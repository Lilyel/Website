---
title: Audiovisual Project
---

## Project Description

This project was a practical work for the University during my second year of my master degree.

The objective of this exercise was to implement the algorithm of Lukas & Kanade to track objects in a short video, attach a sound to them and spatialize these sounds according the objects positions.

There were no restrictions for the language or library, except OpenAL for the audio part. So I chose do to the project in C++ with OpenCV (3.4).

We got one week to do this assignment.

## Images Extraction

The first step was to transform a short video into a set of pictures.

To do that, I first load the video with the OpenCV functionality *VideoCapture*. Then for each frame of the video, I save it to a *jpeg* file. I also save a blurred version of this frame as a *jpeg* file too.

The blurred version will be useful for noisy images. This blurred is applied using the *GaussianBlur* function of OpenCV. The image is blurred using a convolution, so the size of the kernel and the standard deviation can be set by the user. The more the video is noised, the bigger the size of the kernel or higher the standard deviation must be.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Sheep0.jpeg" caption="Image of sheeps without noise" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/SheepNoise0.jpeg" caption="Image of sheeps noised" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/SheepNoise0_blurred.jpeg" caption="Image of sheeps blurred" height=256 width=256 %}
    </div>
</div>

If the video is not noised (or not a lot), the blurred version is not necessary to get a nice final result.

## Optical Flow

To process the optical flow, I used the *Lukas & Kanade* algorithm. I could have use the one proposed by OpenCV, but since it was the first time I work with this algorithm, I preferred to implement it myself. However, the final results could have been better with the OpenCV function.

Here the *Lukas & Kanade* equation for optical flow at a time $$t$$ :

$$\vec{v}=\operatorname{argmin}_{\delta_x, \delta_y}{(\sum_{(x,y) \in W}{(I_x(x,y)*\delta_x + I_y(x,y)*\delta_y + I_t(x,y))^2})}$$

Where $$W$$ is a window around the pixel on the picture. For the few videos I worked on, a window of $$9*9$$ pixels seems to work fine.

$$\vec{v}$$ is the direction of the optical flow on the current pixel. It represents the movement at this pixel and at this time $$t$$ in the video.

We will use this equation for every pixel in every frame of the video.

The objective is to find $$\delta_x$$ and $$\delta_y$$ that fit the best. They will be the components of the vector $$\vec{v}$$ :

$$\vec{v}=\begin{bmatrix}\delta_x \\ \delta_y\end{bmatrix}$$

I begin with the spatial derivative on the $$x$$ axis : $$I_x$$. To achieve that, I use the function *filter2D* of OpenCV with the following kernel :

$$\begin{bmatrix}-1 & 0 & 1\end{bmatrix}$$

{% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Ix.jpeg" caption="Spatial derivative on X axis" height=256 width=256 %}

Then, I do the same for the spatial derivative on the $$y$$ axis : $$I_y$$, using the following kernel :

$$\begin{bmatrix}-1 \\ 0 \\ 1\end{bmatrix}$$

{% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Iy.jpeg" caption="Spatial derivative on Y axis" height=256 width=256 %}

To get the temporal derivative $$I_t$$, I just subtract the frame at time $$t+1$$ with the frame at time $$t$$.

{% include image-modal.html id=5 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/It.jpeg" caption="Temporal derivative" height=256 width=256 %}

To find $$\vec{v}$$, I put the *Lukas & Kanade* equation in matrix form :

$$H*\vec{v}=b$$

with :

$$H=\begin{bmatrix}\sum_{(x,y) \in W}{I_x(x,y)^2} & \sum_{(x,y) \in W}{I_x(x,y) * I_y(x,y)} \\ \sum_{(x,y) \in W}{I_x(x,y)*I_y(x,y)} & \sum_{(x,y) \in W}{I_y(x,y)^2}\end{bmatrix}$$

$$b=\begin{bmatrix}\sum_{(x,y) \in W}{I_x(x,y) * I_t(x,y)} \\ \sum_{(x,y) \in W}{I_y(x,y) * I_t(x,y)}\end{bmatrix}$$

This matrix form is solved with the least square method. To do that, we follow the following equation :

$$\vec{v}=(H^T*H)^{-1}*H^T*b$$

where $$H^T$$ is the $$H$$ matrix transposed.

But before applying the least square method, I check the eigen values of $$H$$ : $$\lambda_1$$ and $$\lambda_2$$. If they are both near 0, we are in an uniform area (there is no movement), so I set $$\vec{v}$$ to a 0 vector. If only one of them is near 0, the movement is orthogonal to the image gradient, in this case too I set $$\vec{v}$$ to 0.

Drawing the optical flow for each pixel using $$\vec{v}$$ coordinates to process a color was a bit difficult to me to see if it was correct or not. To improve the preview of the optical flow, I generate a new image where the original frame is divided in a grid of $$10*10$$ pixels. The optical flow in each cell is averaged. Then I draw a line that shows this average. The color of the line represents the length of the vector averaged : blue means small and red means big.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=6 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/OpticalFlow.jpeg" caption="Optical flow per pixel" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=7 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Shapes25_flow.jpeg" caption="Optical flow averaged" height=256 width=256 %}
    </div>
</div>

## Object Detection

The next step of the project was to detect objects and follow them through the video.To do that I use the previously calculated optical flow. Now that we have a movement vector for every pixel and for every frame, I create an image that will hold the length of each movement vector at the pixel location as grey level.

{% include image-modal.html id=8 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/LengthMap.jpeg" caption="Length Map" height=256 width=256 %}

With the length map, I try to detect object by starting at the pixel holding the biggest value. Then I look up around it if there are interesting other pixels (value bigger than a specified value).

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Detection1.png" height=360 width=360 %}

And with these new interesting pixel, I start again : I look up around them for other interesting pixels, with care to not process already visited pixels.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/Detection2.png" height=360 width=360 %}

Once there is no more interesting pixel, I build an Axis-Aligned Bounding Box (AABB) that include all the interesting visited pixels.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/DetectionAABB.png" height=360 width=360 %}

When a pixel is visited, its value is set to 0. By doing that, I can restart the whole process with the biggest value (which will not be the same as before) in the image and maybe find more objects.

To avoid stopping exploring a shape too soon because we encountered a little gap in the form, I first applied morphological transformations. To do that, I used the *morphologyEx* function of OpenCV, with at first the Opening operation (MORH_OPEN) to remove the noise and then with the Closing operation (MORH_CLOSE) to remove the little holes and gaps.

Unfortunately, if two objects are too close, the exploration consider them as the same objects.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=8 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/CurrentAABB.jpeg" caption="Objects far enough" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=9 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/CurrentAABBTooClose.jpeg" caption="Objects too close" height=256 width=256 %}
    </div>
</div>

## Object Tracking

To follow objects, I wanted to use the optical flow to determine the next object position. From the movement vectors inside the AABB of the object in the previous frame, I process the average movement vector of this object. With this averaged movement, I move the AABB.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/IdeaTracking.png" height=700 width=700 %}

But in practice, the length of the averaged vector is too small.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/RealityTracking.png" height=360 width=360 %}

With the hypothesis that movements in the video are small, this idea still work, but may be not very necessary for the next step. In the new AABB (the one moved by the averaged movement), I start a new detection with the maximum value inside this AABB. The new AABB created at the end of the detection is attached to the object we are tracking. If the averaged vector is 0, that means the object doesn’t move anymore and we stop tracking it. If this area move again later in the video, it will be considered as a brand new object. Once all objects are tracked, I try to detect new objects in the case that previously static objects in the video start moving. Note that I didn’t test it, but the OpenCV version of Lukas & Kanade may produce better movement vectors and make the average vector more useful (the step of rebuilding the AABB may be not necessary anymore).

## Noise Impact

The noise have an important and negative effect for the tracking. It generates movements in the whole image that correspond to no objects. When the video is very noised, only one object is detected and it occupies the entire frames.With the blur step when processing the video and the morphological transformations, the noise can be a bit reduced and several objects are detected. Nonetheless, even if they don’t, they are considered moving during the entire video.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=10 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/SheepNoiseWithoutBlur.jpeg" caption="Tracking without blur" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=11 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/SheepNoiseWithBlur.jpeg" caption="Tracking with blur" height=256 width=256 %}
    </div>
</div>

## Audio Spatialization

For the audio part of the project, it was recommended to use OpenAL. I just did a little abstraction of the OpenAL API. It is a set of small classes :

- *Sound* : load an audio file with the library *libsndfile*, then create an OpenAL buffer.

- *Source* : hold an OpenAL source with the possibility to move it and also play it, pause it or stop it from emitting a sound. It is possible to active the loop mode to play continuously a sound (as long as an object is active for instance).

- *Scene* : initialize the OpenAL environment (device and context) and manage the objects playing the sounds (*Sources*). It also stores the loaded *Sounds*.

No matter the aspect ratio or the size of the video, the audio space will always be a square of $$30 * 30$$ starting at $$(-15,-15)$$ with the listener (the mic) placed at $$(0,0)$$.

The position of the objects will be transformed from the image space to the audio space.

{% include figure.html image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/audiovisualproject/AudioRoom_Black.png" height=750 width=750 %}

Each object can have a sound attached, when the object become active (start moving), the sound is played on a loop as long as the object is moving. When an object stop moving, the sound is stopped.The sound is played through a source with the position of the object (transformed into the audio space) and listened with the listener at $$(0,0)$$. OpenAL will process the stereo spatialization automatically.

## Audio Recording

Once I got the sounds playing well and spatialized, I had to record it into a file. To record sounds that didn't come from a mic, I use *OpenAL Soft*, a set of extension for OpenAL. It provide the possibility to do a kind of "offline rendering" of the sounds.

I play the sounds like usually but after each update of objects position I record the count of samples that correspond to the time of one frame in the video. And then I update again the objects and record the number of samples for one frame, on so on. But I didn't have to wait that the sounds are actually played, since OpenAL Soft extracts directly all data from the OpenAL buffer, it is not necessary to wait.

When the audio is recorded for the whole video, I save all the samples into a *wav* file with the library *libsdnfile*.

## Results

<div style="text-align:center">

<iframe src="https://player.vimeo.com/video/276432662" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>

<iframe src="https://player.vimeo.com/video/276518001" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>

</div>

## References & Useful Links

### Lukas & Kanade:

- [http://www.inf.fu-berlin.de/inst/ag-ki/rojas_home/documents/tutorials/Lucas-Kanade2.pdf](http://www.inf.fu-berlin.de/inst/ag-ki/rojas_home/documents/tutorials/Lucas-Kanade2.pdf)

- [http://www.cs.cornell.edu/courses/cs664/2005fa/Lectures/lecture18.pdf](http://www.cs.cornell.edu/courses/cs664/2005fa/Lectures/lecture18.pdf)

### OpenCV:

- [https://opencv.org/](https://opencv.org/)

- [https://docs.opencv.org/trunk/d9/d61/tutorial_py_morphological_ops.html](https://docs.opencv.org/trunk/d9/d61/tutorial_py_morphological_ops.html)

### OpenAL:

- [https://www.openal.org/](https://www.openal.org/)

- [https://github.com/kcat/openal-soft](https://github.com/kcat/openal-soft)

- [https://gist.github.com/skitaoka/13a0ffa3f6434ca03e87](https://gist.github.com/skitaoka/13a0ffa3f6434ca03e87)
 