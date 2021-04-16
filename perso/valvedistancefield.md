---
title: “Improved Alpha-Tested Magnfication for Vector Textures and Special Effects”
---

## Paper Description

[Improved Alpha-Tested Magnification for Vector Textures and Special Effects](https://dl.acm.org/citation.cfm?id=1281665) was proposed by Chris Green in 2007.​

The idea is to generate a distance field of a high resolution image and store the result into a smaller resolution image. Then, using an alpha-testing rendering, the low resolution image can be drawn. The rendered image will have smooth edges whatever the level of magnification used. All this without the need of an image in vector form.​

## Distance Field

At first I started to look at what is the distance field. It was a new concept for me so I did some researches to understand the idea and how to generate the distance field.​

So I found out that the distance field was the representation of the importance of an “in” pixel (a pixel with a color) over the image. The “out” pixel will be the black ones (no color). The more we go far from an “in” pixel, the less it will have an importance. It results in a shading of the color. The area of effect of one pixel is determined by a value named “spread”.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/SDFNoResize_Spread100.png" caption="Distance field generated from an image of 1024x1024 with a spread of 100" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/ExampleSDFNoResize.png" caption="Distance field generated from an image of 1024x1024 with a spread of 30" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/GreyScale.png" caption="Distance field generated from an image of 256x256 with a spread of 10" height=256 width=256 %}
    </div>
</div>

From the images above, we can see that higher resolution pictures generate better distance fields. Later we will see that a bigger input image can help to keep small details.​

Here are the results of different spread values on the polygon image (1024×1024) :

{% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/SpreadEffect.png" caption="Result of different spread values on a part of the polygon" height=512 width=512 %}

Note that the results above are retrieved from image at the end of the whole process (distance field + resize to 64×64 + shader).​

## Resizing​

The second step of the technique consists in resizing the image holding the distance field.​

I used the library stb to resize pictures (and load them), it implements several resizing algorithms, this allowed me to see if, according to these algorithms, the results can change or not.

{% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/ResizeAlgoEffects.png" caption="Effects of resizing algorithms on bottom left of the original picture" height=400 width=400 %}

We can notice that the influence of resizing algorithms is not very significant. I stick with the Catmull-Rom one because it seems to keep properly some details but I don’t think it is a very important parameter.

Indeed, a more important parameter is the resized size. Very small images (holding the distance field) tend to erase a lot of details, but if we don’t resize, the results are not great (the edges are not very smooth).

{% include image-modal.html id=5 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/ResizeEffects.png" caption="Influence of the size on the distance field" height=256 width=256 %}

## Rendering​

The final step of the technique is the alpha-testing rendering. This method allows to draw only pixels with an alpha channel bigger than a given threshold. Combined with the linear interpolation on texture done by OpenGL and the distance field, it draws smooth edges whatever the level of magnification used on the texture.​

At first, like suggested in the paper, I used OpenGL alpha-test rendering functions :

```cpp
glEnable( GL_ALPHA_TEST );
glAlphaFunc( GL_GEQUAL, ALPHA_THRESHOLD );
```

With the threshold around 0.5.

Then, still following the paper, I used the smooth step function in the fragment shader with a settable parameter that influences on the smoothness of the edges.

{% include image-modal.html id=6 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/SmoothParam.png" caption="Shader smooth parameter" height=512 width=512 %}

## Colors

In the paper, they seem to apply the technique only to binary pictures, but since I had a lot of colored pictures, I wished to know if it was possible to use this technique for them.​

According to the texture type, I selected a specific channel to process the distance field :​

- RGBA and grey-scalalpha textures : Alpha channel

- Grey-scale textures : Grey channel

Then, once the distance computed, I put the distance value in the corresponding channel (alpha for RGBA, … ).

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column" style="background-color:#000000AA">
        {% include image-modal.html id=7 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/GreyScaleAlpha.png" caption="Grey + Alpha" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=8 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/RGBA.png" caption="RGBA" height=256 width=256 %}
    </div>
</div>

Important detail : when I put the distance on the channel, the pixel color depends on its initial value. If the pixel was “in” I took its color, if it was “out” I looked if in the spread area there was a pixel “in” :​

- if there is a pixel “in”, I took its color instead

- otherwise I took the pixel initial color.

This method avoids some bad coloration issues in some areas of the picture, like on the image below.

{% include image-modal.html id=9 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/ColorFix.png" caption="Error on colored distance field" height=700 width=700 %}

## Limitations and Benefits​

A limitation of this technique is the conservation of small details. Indeed, if the picture has very little elements, they are easily erased. To keep a bit of details we must use big input textures.​

Despite this limitation, the technique described in the paper is very powerful for pictures without details.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=10 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/WhySoSeriousDetails.png" caption="Input with a lot of details" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=11 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/CircleNoDetails.png" caption="Input with few details" height=256 width=256 %}
    </div>
</div>

We can see in the images above, that on a complicated picture, the details are quickly lost and it’s getting worse when the distance field gets smaller.

However, the picture with the circle and the square, that has almost no small details, remains great. There are only the square corners that bend a bit but for a downscale of 16 I think the result is pretty stunning.​

This technique can be a great memory optimization for “simple” textures. ​

Despite the loss of some details, this technique allows us to scale however we want the picture, without the blur and pixelization seen when we are scaling “regular” textures.​

So this technique can be very powerful to render rounded shapes and save a lot of memory while keeping super smooth edges at close look.

{% include image-modal.html id=12 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/MagnificationImpact.png" caption="Impact of different scales on IO of Why So Serious from image above ( smooth = 64, spread = 20 )" height=700 width=700 %}

## Tools​

I did the first version of the distance field generation on CPU, but once I understood the concept and done a working version I tried to port it to GPU.​

During my first year at the University, we learnt CUDA, but we didn’t study OpenCL, so I decided to use OpenCL for this project to experiment something new. Thanks to a [NVIDIA introduction](http://developer.download.nvidia.com/CUDA/training/NVIDIA_GPU_Computing_Webinars_Introduction_To_OpenCL.pdf) (slideshow) I quickly got into this new library and managed to successfully generate the distance fields with my GPU.​

To render the images, I used my own little framework I’m developing on my free time. It doesn’t do much but it was enough for this project. It uses OpenGL for rendering.​​

## Work To Do

Even if I got results there is a lot of things to do :​

- Finish to implement the paper (outline, glows, drop shadows)

- Handle sharp corners (the paper suggests using several distance fields and combine them).

- Do a beautiful application for the project, with some UI to set the different parameters.

- Handle big pictures. For the moment it is a bit hard to send a picture bigger than 1024 x 1024 (RGBA) to the OpenCL kernel, but since we look only in an area defined by the spread value, we can determine a maximum amount of pixels sendable to the GPU and divide the picture into “chunks” that we send one after the other to the GPU.

{% include image-modal.html id=13 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/valvedistancefield/OptiKernel.png" caption="Blueprint to handle bigger pictures" height=256 width=256 %}

- Improve colors handling. The grey-scale is not very well handled, only the full white pixels (with a channel value of 255) are considered “in”, I wish to give the possibility to decrease this threshold if the user wants to. And RGB is not working yet, I don’t know if I will give the possibility to the user to choose the channel used for the distance field (Red, Blue or Green) or if I do something else using the three channels at the same time.

- Implement myself the resizing algorithms (it seems super interesting) and make parallel them with OpenCL to maybe earn some compute time.

- Do some benchmarking to study the process time with different parameters and algorithms.

## Personal Conclusion (for the work done)​​

I did this project during the end of summer 2017 (between my first and second year at the University) and while I am writing this conclusion, I am getting back to my studies and I lack time to continue this project and work on the points described in “Work To Do” section, but as soon as I have free time again, I will continue this because it’s a cool technique and I wish to succeed to implement the whole paper.​

I am happy to implement (at least a part of it at the moment) a scientific paper because it’s something a bit new, even if at the university we did several projects using this kind of documents, it’s also still hard for me to understand the techniques described in those. Maybe this paper is an “easy” paper but I am still glad that I got some results.​

I also discovered different resizing algorithms, it can be interesting to study them a bit further.​

Learning how to use OpenCL is great too, the usage of CUDA is a bit different from OpenCL so I am glad to know both of them, and the university classes on parallel computing on GPU helped me a lot to understand the introduction to OpenCL slideshow.

## Update : Little Application​​

After a long time, I finally continued a bit this project​. I decided to switch to the [SFML](https://www.sfml-dev.org/index-fr.php) (with OpenGL behind it) and [ImGUI](https://github.com/ocornut/imgui) for the user interface to make a little application. All the stuff done with OpenCL is now done in a fragment shader.
I finished implementing the glow and the outline but not the preservation of sharp corners. I tried to fix a bit the color handling, the greyscale is now working properly and for the RGB images, I chose to do an average of the three channels.
To handle big textures, I ended up relying on the texture loading of the SFML which checks if the texture size is not over the hardware limit.

You can find the code on my [GitHub](https://github.com/Lilyel/ValveSignedDistanceField).
