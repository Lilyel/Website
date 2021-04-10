---
title: Tower Defense
---

Tower Defense is my project for the practical part of the final exam at [Créajeux](http://www.creajeux.fr/).

The subject was quite simple : Do a multiplayer, cooperative, tower defense.

I never did a tower defense before, and the only one I really played is Orc Must Die, which I love. So I decided to draw my inspiration from it but transposed in 2D, with 2 players and infinite enemy waves.

We had one week to create it, but Monday and Tuesday morning were lock by theoretical exams. I also worked on it each evening for around 3 hours, I spent a roughly total 45 hours on it.

That was my first project with network, I was not very self confident. So I thought that if I hadn’t successfully understand and integrate the online features basics in the project Tuesday evening, I would only have done one player. Because I thought it would be better to do a correct solo game instead of a bad online one.

So Monday, I did some researches on the [SFML](http://www.sfml-dev.org/)‘s network module. I did the main menu, composed by a play and quit button, the game level and player controls.

Tuesday, I put the network part. I succeeded to make the players move. I also did the tower placement in local.

Wednesday, I did the online tower placement and the two types of monsters. For their AI, I simply did a path-following with some way-points, collision avoidance for environmental collision and separation between them to avoid superposition. After that I handled the online aspect of player bullets.

Thursday, I did the towers’ bullets’ networking, one tower has slow homing projectiles, with seek steering behavior and rapid straight shots for the other one. I also optimized my network, with less packet sending and proper disconnection. I managed to synchronize the joining player, so he wouldn’t have an empty map when he arrived. I also did some functionality and graphical upgrades like tower rotation, fade out on bullets to avoid a brutal disappearance. I made a new attack for the player, the bomb.

The evening, I tried my game with internet with a friend and it worked great ! I was happy because all the network I developed was only in LAN, so when I succeeded to make it work in WAN, it was pretty satisfying.

Friday, it was the last day, we had to hand in our work. So I decided if I had to change the project code that would be only for critical matters. With that in mind, I just resolved a crash which occurred on the client end when the host was leaving the game. Otherwise I just did graphical upgrades for the menus and in game to make the application a bit more beautiful.

And the project was finished !

To sum up the game, there are two players and they have to survive to a maximum number of waves. They can place homing or rapid fire towers with a cost of 150 each.

Players can fire freely as long as they want and they can place a bomb for 300 which will explode one second after it has been fused. When the players kill a monster they earn 10, when it is a tower which kills an enemy, they earn 5. The money is joint, so they have to be cooperative to correctly use it.

The two types of monsters are not very different, the first has less health but moves faster, the second has more health but moves slower.

On the technical part, I used only TCP with SFML network module and did the game in C++. The player who creates the game hosts it and the other player just has to click on play to join him, the bullets are not continuously updated via the network, there is just their creation that is replicated, the monsters are synchronized each 0.5 second, and the player and game infos are sent through the network only when there is a modification on them. There are some details which I didn’t think about right away, like the simultaneous tower placement with network, or what happens if a third player joins. Anyway, for a first experience with online gameplay, I am really happy and I also had a really good mark and great feedbacks, so that’s awesome !

I choose to give you the exact same project as the one I gave to my professors, with its qualities and defects, to show what I really did during one week.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/MainMenu.PNG" caption="Main Menu" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/Towers.PNG" caption="Single Player" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/TwoPlayer.PNG" caption="Two Players" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/BothShooting.PNG" caption="Both Players Shooting" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/BombExplosion.PNG" caption="Bomb Explosion" height=256 width=256 %}
    </div>
</div>

 {% include image-button.html link="https://www.dropbox.com/s/k7dus54ckhf8xqq/Tower%20Defense.zip?dl=0" image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/towerdefense/Download_Black.png" height=164 width=164 %}
