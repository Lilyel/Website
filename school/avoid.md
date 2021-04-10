---
title: A-Void
---

A-Void was our final project of our third and last year at [Créajeux](http://www.creajeux.fr/).

It is a local multiplayer 3D arcade game in space.  The story behind it is simple, it is inspired from Death Race (2008). There is an arena and some participants fight against each others in a TV show to become famous.

There are three ships, a blue, a green and a red one. This is only aesthetic.

The basic weapon is the laser blaster. It is the only weapon which does not have any ammunition, it has a heat system, when player is firing for too long, the blaster overheats and the player can not fire anymore during awhile.

There are three other weapons to pick up in the arena. The gatling gun, which fires rapidly with a little spray effect which implies low accuracy at long range.

The tesla gun, with a loading system, the more the player loads, the more the weapon will be deadly, it is very accurate but does not have a long range.

Finally there is the plasma canon, it has a homing system linked to a locking system on the player’s HUD.

The player has also to keep an eye on his oxygen level. It decreases over time and can be refilled with tanks in the map.

The only available mode is Free For All, each player must kill as many opponent as possible.

The player can switch from the first person view to the third person view at any moment.

That was the first real project on [Unreal Engine 4](www.unrealengine.com). We used 4.7.3 update. I was very happy to use Unreal because even if there are instabilities and lack of functionalities, I adore this engine.

I am quite happy with this project, not very much on the finality of the game but more on what I did and learnt during its development.

At first I did a lot of blueprint, but gradually I succeeded to convert some of my blueprint functions in C++.

Due to the incompatibility of our Tortoise SVN version and the one required by Unreal, we could not link them together. So to work with the CCC group ( Character, Controller, Camera ) and deal with this little setback, we had to make modules like Player Module, HUD and Sound Module.

So, I worked with the player module group. At the beginning I created the module and helped to do the picking up system of objects.

After that, I had to do the projectiles. I worked in close collaboration with the network group to make them work in multiplayer.

I managed all the projectiles, their aiming system and their interaction with the world, like impacts or the collision with other players. I collaborated with the FX graph group for impact and projectiles effects.

Also I helped on the global debugging of the game and assisted people who needed it when I could.


<div style="text-align:center">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/2KdxVD7R8Ws" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

 {% include image-button.html link="https://www.creajeux.fr/project/a-void/" image="https://raw.githubusercontent.com/Lilyel/Website/main/assets/avoid/ProjectPage.png" height=256 width=256 %}
