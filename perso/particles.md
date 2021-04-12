---
title: Particle Sample
---

Particle Sample is a little program which presents some math functions.

I did this sample with [SFML](https://www.sfml-dev.org/) ( Simple and Fast Multimedia Library ), C++ and Visual Studio 2012. It was during my second year at [Creajeux](https://www.creajeux.fr/), I worked on it on my free time.
At the beginning, I just wanted to try to do a [SFML tutorial](http://sfml-dev.org/tutorials/2.0/graphics-vertex-array.php) about particles.

After that, I thought it will be nice to see the emitter make beautiful moves. So I searched some math functions describing interesting curves.

For the line mode, it was only a debug mode for me to see curves clearly but I chose to keep it because I found interesting to see the curves without having many particles around it so I let the user choose the mode between particles and line.

There is some *Fourier Series* applications but I don’t have any skills in *Signal Processing*, I just pick up definitions on Wikipedia pages of the different waveforms. ( [Triangle](http://en.wikipedia.org/wiki/Triangle_wave), [Square](http://en.wikipedia.org/wiki/Square_wave) and [Saw-tooth](http://en.wikipedia.org/wiki/Square_wave) ).

Also, I made a “Draw” mode, with mouse path and line mode, you can click with the left button of the mouse to make some lines. I made this mode because when I implemented line mode with the mouse there was just a moving point so I have chosen to make a little funnier mode.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/particles/ParticleMouse.PNG" caption="Mouse pattern with particle mode" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/particles/ParticleRosace.PNG" caption="Rosace pattern with particle mode" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/particles/LineInterference.PNG" caption="Interference pattern with line mode" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/particles/LineMouse.PNG" caption="Mouse pattern with line mode" height=256 width=256 %}
    </div>
</div>

 {% include image-button.html link="https://www.dropbox.com/s/s7x4m0bzeb2e5jm/ParticleSample.zip?dl=0" image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/particles/DonwloadSelect.gif" height=164 width=164 %}
