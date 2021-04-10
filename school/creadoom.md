---
title: CreaDoom
---

CreaDoom is a very simple 3D First person shooter.

This was a February 2014 school project( during second year at [Creajeux](https://www.creajeux.fr/) ), I had two weeks to do it. The subject was quite simple, we had to create a similar game as [Doom](https://en.wikipedia.org/wiki/Doom_(1993_video_game)).

It is the direct application of different classes we had about DirectX. That was my first project with this library. I tried my best but it was not very easy because that was my first 3D project too. I pretty much like DirectX even if I am not very familiar with all its features. I enjoy this library because it is quite Low Level and I like being at this step of programming. I admit it is not easy without a scene editor but it is very interesting to do all we need in the scene ourselves and not just drag and drop some contents and wish it will do exactly what we want.

So, to do this I used DirectX 9 ( June 2010 SDK ) with Visual Studio 2012 in C++, in which I used Lights, Textures, Matrix, Vectors, Materials, Mesh and some other features.

The point I liked in this project was the physics we had to do ourselves. Even if I am not very good in math, I really enjoy physics. In classes we learnt to do different types of collision and I tried to apply them in this game successfully. It might not be a big deal but I managed to make the grenades bounce against walls by myself.

The principle of the game is simple, progress in the level and kill the final boss.

The player has two types of weapons : the gun or grenades. Munitions are not unlimited so save them for the final boss.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creadoom/Menu.PNG" caption="Main Menu" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creadoom/Start.PNG" caption="Beginning of the level" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creadoom/PowerUp.PNG" caption="Power Ups : Health on the front and ammo in the back" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creadoom/Enemies.PNG" caption="Yellow shots and move to you, blue throws grenades and is still" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creadoom/BossHE.PNG" caption="Final Boss" height=256 width=256 %}
    </div>
</div>
