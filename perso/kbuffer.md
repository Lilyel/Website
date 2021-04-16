---
title: K-Buffer And Translucency
---

In this post, I will describe a translucency technique using the K-Buffer described by Andreas A. Vasilakis and Ioannis Fudos in their paper “[K<sup>+</sup>-buffer : Fragment Synchronized k-buffer](https://abasilak.github.io/papers/conferences/i3d2014/paper.pdf)” to perform depth peeling.

I implemented it with my personal little engine in C++ using OpenGL.

Please be aware that the purpose of this implementation is to learn and discover the algorithms. It may be very verbose and not optimized but the objective was to understand the idea and have the possibility to come back and still be able to easily read the code.

## Why Depth Peeling ?
To process the translucency of an object, we need to know its thickness, the thicker it is the more it absorbs light. Since an object can be thick at some place and thin at some other, a constant value will not achieve a nice result.

A way to get the thickness of an object is to use a depth buffer (“Z-Buffer”) that will store the depth of the fragments. For a simple object, we can proceed with only two steps :

- Draw the object back faces using only a depth buffer.
- Draw the object front faces and compute the distance between the front fragment and the back fragment stored in the depth buffer.

For a more complex object that have concavities or separate layers we will need more than two fragments to compute a nice result because more than one surface may absorb light.

To achieve this, we need to do a depth peeling using a K-Buffer to retrieve several fragments in a back to front order. Having these ordered fragments and knowing which ones are entry points (green on the image below) and exit points (yellow on the image bellow) of the object, we can process the thickness of every layer crossed.

![Depth Peeling](https://raw.githubusercontent.com/Lilyel/Website/main/assets/kbuffer/DepthPeeling.png)

## K-Buffer

A K-Buffer allows to store the *K* nearest fragments when rendering objects and then in a second pass we can sort and blend these fragments.

I tried to implement the solution proposed in the paper “K<sup>+</sup>-buffer : Fragment Synchronized k-buffer” that relies on a spin-lock strategy. There are a lot of other solutions, some of them are presented in these nice [slides](http://on-demand.gputechconf.com/gtc/2014/presentations/S4385-order-independent-transparency-opengl.pdf) made by NVIDIA. According to this document, the spin-lock solution is kind of the worst but I wanted to give it a try to experiment a critical section behavior on GPU.

###  Spin-Lock
To perform a spin-lock we need to use the *image variables* of OpenGL and their *atomic operations*.

I found this [presentation](https://cs.brown.edu/courses/csci1950-v/lecture/week6.pdf) that helped me to learn to use and understand the image variables. The [Khronos wiki](https://www.khronos.org/opengl/wiki/Image_Load_Store) was also very helpful.

The spin-lock will help us to be sure that only one thread at a time is currently modifying the fragment list of the pixel that we are storing. Like CPU multi-threading, concurrent modification of the same pixel by several shader invocations can lead to unexpected result (like flickering).

Each thread will have a fragment to put in the pixel list. The pixel location of a fragment is retrieved using the *gl_FragCoord* built-in variable. We round down the $$x$$ and $$y$$ component of the *gl_FragCoord* variable to find the pixel 2D coordinates.

The idea is to use an image of value $$0$$, when a thread wants to change the fragments list of a pixel it changes the value to $$1$$ using the atomic operation [imageAtomicExchange](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/imageAtomicExchange.xhtml).

The exchange function returns the previous value of the image, if the value was $$0$$ the thread can start modifying the list. But if the value was $$1$$, that means the list at this pixel is not available (another thread is currently modifying it) and the thread can’t enter the critical section and process its fragment.

The threads will loop on the atomic operation until they can enter the critical section.

Once a thread has finished processing its fragment, it puts back the value $$0$$ into the image to free the critical section.

```cpp
bool LockSemaphore( ivec2 _Pixel )
{
    // Quick check to see if the pixel is available.
    if( imageLoad( Semaphores, _Pixel ).r == 1 )
        return false;

    return imageAtomicExchange( Semaphores, _Pixel, 1 ) == 0;
}

void FreeSemaphore( ivec2 _Pixel )
{
    imageStore( Semaphores, _Pixel, uvec4( 0 ) );
}

void main()
{
    ivec2 Pixel = ivec2( gl_FragCoord.xy );

    bool StayInLoop = true;
    while( StayInLoop )
    {
        // Wait until the fragment is available.
        // Once the semaphore passed, we are sure that we can read and write the textures on the pixel location safely.
        if( LockSemaphore( Pixel ) )
        {
            // Do stuff on fragment list here ...

            // Free the access to the pixel to let the other threads store their fragment too.
            FreeSemaphore( Pixel );
            StayInLoop = false;
        }
    }

    discard;
}
```

For the image of value $$0$$ or $$1$$, I use a *GL_TEXTURE_2D* of format *GL_R32UI* and pixel format *GL_RED_INTEGER*. The 32-bit integer format is a restriction of the atomic operations.

```cpp
layout(binding = 0, r32ui) coherent uniform uimage2D Semaphores;
```

The [discard](https://www.khronos.org/opengl/wiki/Fragment#Fragment_discard) instruction allows not to write anything on the render target and quit the shader.

### Clear Pass

To clear the different textures that we are going to use, I call the [glClearTexSubImage](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glClearTexSubImage.xhtml) function.

Note that the paper proposes to do a full-screen pass and uses the imageStore function to set the value of the images instead.

The depths texture is reset to $$1$$ and all other textures are reset to $$0$$.

### Store pass

Now that we can secure the access to a pixel, we can safely store the K nearest fragments in a list.

To store the fragments the paper proposes two solutions :

- An array
- A heap

The heap is advised for a *K* superior to $$16$$ to keep good performances. The complexity of insertion and sort of the heap ($$O(logN)$$) scales better than the array complexity ($$O(N)$$ for the insertion and $$O(N2)$$ for the sort).

I have a simple scene so I only did the array solution. It is also the easiest solution to implement but the heap can be a nice extension to do.

Note that the furthest fragment is always the first element of the array.

We must keep track of the actual number of fragments stored for each pixel. For that, we are going to use another image that we increment each time a new fragment is stored in the array. Once the array is full, we leave the value at its maximum value : *K*.

The texture used for keeping track of the number of stored fragments is a *GL_TEXTURE_2D* of format *GL_R8UI* and pixel format *GL_RED*. The image variable is :

```cpp
layout(binding = 1, r8ui) coherent uniform uimage2D Counts;
```

For now, we are only going to store the depth of the fragments (I will show later how I handle colors and other parameters).

To store the fragments depth, I use a *GL_TEXTURE_2D_ARRAY* of format *GL_R32F* and pixel format *GL_RED*. The number of slices of the array is the number *K*. For each pixel, up to *K* depth values will be stored. The image variable is :

```cpp
layout(binding = 3, r32f) coherent uniform image2DArray Depths;
```

During the store pass, keeping track of the number of fragments in the array will allow us to choose between two methods of insertion : when the array is not full and when the array is full.

#### When the array is not full

If this is the first fragment, we put it in the first element of the array.

If the fragment is closer than the first element, we put it at the next free position. Otherwise we replace the first element with the new fragment and place the previous first element at the next free position.

The next free element index is simply the count value before incrementing it.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/kbuffer/InsertEmptyVeryLow.gif" %}

#### When the array is full

We must find the furthest fragment in the array (ignoring the first element) and place it at the first position. Then, we put the new fragment in place of the furthest fragment found before (that is now the first element).

If the new fragment is the new furthest element of the array, we just put it at the first position.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/kbuffer/InsertFull.gif" %}

#### Early culling

A possible little optimization is to check, before the spin-lock loop, if it is worth to process the fragment.

When the array is full, we can check if the incoming fragment is further than the first element. If it is, we can discard it since it is further than the *K* closer stored fragments, it is not useful to process it.

### Resolve Pass

Now that we have, for each pixel, a list of the *K* nearest fragments, we are going to do a full-screen pass to sort and blend them.

We use the images *Counts* and *Depths* filled in the store pass and we sort the depths from the furthest to the closest. As proposed in the paper, I used an [insertion sort](https://en.wikipedia.org/wiki/Insertion_sort).

```cpp
// Sort the fragment according to their depth.
void InsertionSort( uint _Count, inout float _Depths[MAX_SIZE] )
{
    int i = 1;
    while( i < _Count )
    {
        int j = i;

        while( j > 0 && _Depths[j - 1] < _Depths[j])
        {
            // Swap the values.
            float DepthJ = _Depths[j]
            _Depths[j] = _Depths[j - 1];
            _Depths[j - 1] = DepthJ;

            j--;
        }

        i++;
    }
}
```

The next step is the blending of the fragments.

## Translucency

### Material

The necessary datas to process the translucency is :

- The 3D world position of the rendered point that has generated the fragment.
- The fragment color and its opacity.
- A boolean to know if we apply translucency or transparency.
- The translucent color and the distance after which the object absorbs all the light.
- A boolean to know if the fragment is coming from a front or back face.

I separated these parameters in two categories :

- The ones that are common to all fragments coming from the same object.
- The ones that change for every fragments.

#### Common datas

In the common datas I put :

- The color.
- The translucent color.
- The distance at which the object absorb all light.
- The boolean to switch between translucency and transparency.

To store all these datas I use a *GL_TEXTURE_1D_ARRAY* of format *GL_RGBA16F* and pixel format *GL_RGBA*. This image variable is :

```cpp
layout(binding = 4, rgba16f) coherent uniform image1DArray Materials;
```

Each pixel of this 1D texture is a RGBA color and there are 3 slices. A pixel can be seen as a 4×3 matrix.

The first row is the color and the opacity. The second row is the translucent color. And the last row contains a boolean to know if the material has been written to the image, the boolean to determine if the object is translucent or transparent and the maximum distance at which translucent object absorbs all light.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/kbuffer/MaterialsTexture.png" width=512 height=512 %}

The “Material Set ?” parameter allows us to write the material only once to the image thus saving us from some writing operations.

#### Per fragment datas

In the per fragment datas I put :

- The 3D world position.
- The material index.
- The fragment depth.
- The boolean to know if the fragment is coming from a front or a back face.

The material index links to a pixel in the 1D texture array containing the common datas. I use a *GL_TEXTURE_2D_ARRAY* of format *GL_R8UI* and pixel format *GL_RED*. The image variable is :

```cpp
layout(binding = 2, r8ui) coherent uniform uimage2DArray MaterialIndices;
```

For the world position I use a *GL_TEXTURE_2D_ARRAY* of format *GL_RGBA16F* and pixel format *GL_RGBA*. The image variable is :

```cpp
layout(binding = 5, rgba16f) coherent uniform image2DArray Positions;
```

The alpha component of the *Positions* image will store the boolean telling if the fragment came from a front or back face. The value of this boolean is retrieved from the *gl_FrontFacing* built-in variable.

The number of slices of the array is the *K* number and we need to move these datas like we did with the depths by inserting or sorting elements.

The three images (depths, positions and material indices) will hold the datas for each pixel *K* nearest fragments.

Note that it is possible to do the same with the colors and other parameters put in common. It is also possible to use another texture to store the normals then do a deferred shading in the resolve pass.

### Blend

To compute the translucency, I followed the book [Real-Time Rendering Fourth Edition](https://www.realtimerendering.com/), the translucency is explained at the chapter 14.5 “Translucent Surfaces”.

The idea is to find how much the light is absorbed by the object. The more the light is absorbed the more we will see the object color, otherwise we will see more of the background stained by the translucent color.

To find the light absorption, we use the [Beer-Lambert](https://en.wikipedia.org/wiki/Beer%E2%80%93Lambert_law)‘s law only considering one attenuation species.

$$\vec{T_r} =  \rm e^{ -\vec{\sigma} * d }$$

$$\vec{T_r}$$ is the transmitted light, it will be the tint of the background. $$\vec{\sigma}$$  is the physical extinction, it represents how much the light is absorbed according to the distance traveled inside the object $$d$$.

The physical extinction can be computed with this formula :

$$\vec{\sigma} = \frac{-\log( \vec{t_c} )}{d_{max}}$$

$$\vec{t_c}$$ is the translucent color and $$d_{max}$$ is the distance at which the object absorbs all light.

Here is a little graph to see the behavior of the formulas (with a one channel translucent color) :

<iframe src="https://www.desmos.com/calculator/zzarsryw08" width="100%" height="500px" style="border: 1px solid #ccc" frameborder="0"></iframe>

The curve represents the amount of the background color we will see according to the distance traveled inside the object. 

By tweaking the $$d_{max}$$ parameter we can see that the bigger its value is, the less light will be absorbed for a given thickness value. Changing this $$d_{max}$$ parameter will allow us to make the object more or less translucent.

Using a RGB color for the $$\vec{t_c}$$ parameter will allow us to stain the background.

To apply this tint to the background and combine it with the object color we use this formula :

$$\vec{c_o} = \vec{c_s} + \vec{T_r} * \vec{c_b}$$

$$\vec{c_s}$$ is the object color and $$\vec{c_b}$$ is the background color. 

Since we are processing the fragments from back to front, the background color can be the result of the blend of further fragments.

Due to the addition between the two colors, the final color can go above $$1.0$$ and be clamped, using a tone mapping can be useful to get the blended color value between $$0.0$$ and $$1.0$$.

We can also apply an alpha blending with this result :

$$\vec{c_o} =\alpha * ( \vec{c_s} + \vec{T_r} * \vec{c_b} ) + ( 1 - \alpha ) *   \vec{c_b}$$

Note that for fragments from back faces, their final color is just the background color, they are considered "exit points" of the object and are not supposed to be leading to the inside of an object thus don't have thickness.

Here is an example of result with the Stanford dragon :

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/kbuffer/Dragon.png" %}

# Demo

You can find a demo of this implementation on my [GitHub](https://github.com/Lilyel/KBufferTranslucency).

A downloadable executable can be found in the [releases](https://github.com/Lilyel/KBufferTranslucency/releases) of the repository.

# References and useful links

- K+-buffer: Fragment Synchronized k-buffer. Andreas A. Vasilakis, Ioannis Fudos : [PDF](https://abasilak.github.io/papers/conferences/i3d2014/paper.pdf), [Slides](https://abasilak.github.io/papers/conferences/i3d2014/presentation.pdf), [Website](https://abasilak.github.io/).
- [NVIDIA slides about order independent transparency techniques](http://on-demand.gputechconf.com/gtc/2014/presentations/S4385-order-independent-transparency-opengl.pdf).
- [Lecture about OpenGL image variables and operations](https://cs.brown.edu/courses/csci1950-v/lecture/week6.pdf).
- [Khronos Wiki about image variables and operations](https://www.khronos.org/opengl/wiki/Image_Load_Store).
- [Multi-Fragment Effects on the GPU using the K-Buffer](http://www.sci.utah.edu/~csilva/papers/i3d2007.pdf). Louis Bavoil, Steven P. Callahan, Aaron Lefohn, Joao L. D. Comba, Claudio T. Silva.
- [Real-Time Rendering Fourth Edition website](https://www.realtimerendering.com/).
- [Morgan McGuire’s Computer Graphics Archive](https://casual-effects.com/data).
- [LearnOpenGL tone mapping tutorial](https://learnopengl.com/Advanced-Lighting/HDR).
