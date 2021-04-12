---
title: Battleship
---

Battleship is a very simple game, based on the eponymous [board game](http://en.wikipedia.org/wiki/Battleship_%28game%29).

It was a school project during October 2012 ( first year at [Creajeux](https://www.creajeux.fr/) ), I had two weeks to do it. I did a very bad project, so during the summer holidays of 2014, I remade this game in one week. Even if I lacked time to do what I really wanted, particularly on the Artificial Intelligence, I am pretty happy about the upgrade of this project.

The original project had to be made in C, so I did the upgrade in C too. For this I used the C binding of [SFML](https://www.sfml-dev.org/) ( [CSFML](http://www.sfml-dev.org/download/csfml/) ). I worked with Visual Studio 2012.

The principle of the game is simple, place your own ships, launch the game and try to sink the enemies’ ship.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/battleship/MainMenu.png" caption="Main Menu with controls description" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/battleship/Begin.png" caption="Beginning, ships have been placed, click on GO to start the game" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/battleship/InGame.png" caption="In Game, navy blue areas are empty spots, red ones indicates a boat hit" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/battleship/GameOver.png" caption="Game Over, statistics of the game" height=256 width=256 %}
    </div>
</div>

<div style="text-align:center; font-size: 29px; font-weight: 400!important;">
    <a href="https://www.dropbox.com/s/d3hixv80e01gp72/Battleship.zip?dl=0">Download</a>
</div>
