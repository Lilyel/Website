---
title: CreaSkweek
---

CreaSkweek is a 2D little puzzle game.

This was a school project during October 2013 ( second year at [Creajeux](https://www.creajeux.fr/) ), I had two weeks to achieve it. The subject was quite simple, we had to do a game with the same rules as [Tiny Skweeks](https://www.youtube.com/watch?v=M2wzS3_wDQk), a DOS game.

We were free on the graphical aspect of the project so because I am not that good with tools like Photoshop, Illustrator or even paint I did simple things like cute teddy bears ( picked up from a coloring exercise ).

We had to do this project in C so I used the C binding of SFML ( [CSFML](https://www.sfml-dev.org/download/csfml/) ), I worked with Visual Studio 2012. It was very interesting because that was my first project with CSFML and I did an acceptable work.

The principle of the game is simple, bring the little teddies to their respective color exits. There are different items like teleporter, which transports the matching color teddy to its exit ( same color of the entry ). The levels are timed so hurry to finish each board. There are some more objects to discover, like time bonuses, jokers, lives …

There is also a map creator, to make your own puzzles and compete against yourself. Add as many level as you want with custom passwords and limits time. You are completly free !

Finally, there is a score board too, you can see the 9th first best scores. It is computed from the number of accomplished levels.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Menu.PNG" caption="Main Menu" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Score.PNG" caption="Scoreboard" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Level1.PNG" caption="Exemple of a level (here, the level 1)" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Level4.PNG" caption="Exemple of a level (here, the level 4)" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Editor.PNG" caption="Exemple of an edited map" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=5 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/MapEditPlayed.PNG" caption="The level created in the previous picture, in-game" height=256 width=256 %}
    </div>
</div>

 {% include image-button.html link="https://www.dropbox.com/s/5taiy1wi7mj0rse/CreaSkweek.zip?dl=0" image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/creaskweek/Download.png" height=128 width=128 %}
