---
title: Warcreaft
---

Warcreaft is a Real-Time Strategic game.

This was an annual school project during the third year at [Creajeux](http://www.creajeux.fr/). It is an application of almost all Artificial Intelligence lessons that we had.

We had to do a [Warcraft](http://fr.wikipedia.org/wiki/Warcraft)-like game. That was not an obligation to do a real game, but at least an “AI application”. This was a group project, from two to three people.  I was with a friend, but due to his behavior, I almost achieved everything alone, and even when he worked, I had to double check his job. That was pretty exhausting but during the final presentation with our teacher, this one was very happy with our work and asked me to do again the demonstration a bit later for an external person ( a former student of the school who was here for the day ), so even if I would have wanted to do more, I am still glad it pleased him.

One of the rules was to do a “little engine” if we did not use one already. So we used [SFML](http://www.sfml-dev.org/), and did a little framework in dynamical libraries. We worked with Visual Studio 2013 and used C++ language.

Another rule was to do a debug tool with multitask.  So we added a window to the game one and put it in another thread. We did a “tab” system with a toggle button to activate or not the tool. Each tab represents a “category”. For example, unit tab shows all statistics of a selected unit and behavior tab shows the last task done by the enemy player.

For the AI part, we used [Astar](http://en.wikipedia.org/wiki/A*_search_algorithm) algorithm for the pathfinding. We succeeded to integrate HPA (Hierarchical Pathfinding Astar) algorithm but with our big grid the final result was not very beautiful, the path we ended up with was not accurate or convincing enough and we did not have time to improve so we kept our previous use of Astar.

We used HFSM (Hierarchical Finite State Machine) to manage application, units and building states.

We integrated some [steering](http://en.wikipedia.org/wiki/Reactive_planning#Steering) behaviors. Like Separation, path following (with Astar generated path), wandering, obstacle avoidance and arrival. These behaviors were directly in the game, but other behaviors are callable from the debug window (seek, flee, cohesion, lead following, pursuit, evasion, alignment).

We also implemented a little [Behavior](http://en.wikipedia.org/wiki/Behavior_Trees) Tree for the enemy player with very simple tasks, he builds a building when he has not got one, products units when he got less peasants or soldiers than the player. He sends a scout when he has a soldier and not already a scout sent. When the scout sees the player, he sends all free soldiers at this position.

The game over condition is simple: kill every enemy and building.

The graphics are Warcraft sprites, some Age of Empire II sprites and miscellaneous sprites on google, I did the map with [Tiled](https://www.mapeditor.org/), and the menus with Photoshop.

<div class="image-modal-grid-row"> 
    <div class="image-modal-grid-column">
        {% include image-modal.html id=0 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/MainMenu.png" caption="Main Menu" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=1 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/BuildProd.png" caption="Peon is building a barrack. The other barrack is producing Grunts" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=2 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/SteeringPathfinding.png" caption="A*, steering (green), velocity (blue)" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=3 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/Battle.png" caption="Battle between the players' armies" height=256 width=256 %}
    </div>

    <div class="image-modal-grid-column">
        {% include image-modal.html id=4 image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/GameOver.png" caption="Statistics of the game" height=256 width=256 %}
    </div>
</div>

 {% include image-button.html link="https://www.dropbox.com/s/tkxdqn03jifm1p6/Warcreaft.zip?dl=0" image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/warcreaft/Download.png" height=256 width=256 %}
