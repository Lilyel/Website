---
title: JanKen Battle Arena
---

JanKen Battle Arena is a fighting game mixed with “Rock Paper Scissors”, that is available on [Android](https://play.google.com/store/apps/details?id=com.bakcorpstudio.jba&hl=en) and [iOS](https://apps.apple.com/us/app/jan-ken-battle-arena/id1160328096).

It is developed by Bakcorp Studio, a small video game studio based in Montpellier (France). When I joined the studio, there were the boss a developer, another gameplay developer, an illustrator and two 2D animators, then finally, a community manager who also helped the boss to create sounds and musics.

I joined them on early November 2015 within the context of my internship. Then I was hired for two months to help to ship the game and then I have chosen to continue my studies in an university.​

The game is developed using Unity3D (C#) and Visual Studio 2012. We used PlasticSCM as source control.

## Game Summary

In the game, the player can possess several spirits, he can equip them with a weapon and a shield, improve their spells or unlock new ones. Then, the player can fight another player or an artificial intelligence.

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/SpiritDetail.png "Example of spirit with its items and spells.")

During the fight, there are, at first, three symbols : rock, paper and scissors. The player has to choose one, then the opponent’s symbol is revealed. If the player wins, the spirit attacks the enemy, if he loses his spirit is attacked by the adversary’s one. Spells can be chosen just after the symbol if the spirit has enough Doki (energy).

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/SymbolButtons.png "Symbol selection. The colored outline of the buttons represents the remaining time to choose.")

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/AttackDefenseButtons.png "Opponent's symbol revelation.")

In case of a draw, the winner will be determined thanks to a mini game. In those games, players have to trace circles, tap the screen or slice a symbol as fast as possible. The fastest player will win the round.

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/RockDraw.png "Symbol to circle.")

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/ScissorsDraw.png "Symbol to tap.")

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/PaperDraw.png "Symbol to slice.")

At the end of the fight, the players win some gold (more for the winner). Gold is used in the gift machine to get new stuff or some components to improve spells or purchase new spirits.

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/P4Minou.PNG "Rewards show up, then the gift machine appears.")

![alt text](https://raw.githubusercontent.com/Lilyel/Website/main/assets/jankenbattlearena/GiftMachine.png "For some gold, the player can try his luck to get some gifts.")

## My Tasks


###### *User Interface* :

- Upgrade all existing menus with new artworks and update functionalities. These menus were the one where the player sets up the spirits and the one where the player can equip a weapon and a shield on a spirit. I also worked on the spirits selection menu and a bit on the rewards screen after the fight.

- Implementation of new menus : Settings, shop, player profile screen and the menus just before starting the search of an opponent.

- Redesign of menus architecture to keep them in a single scene to reduce loading times between each menus.

- Integration of the artworks of tutorials bubbles and dialogues.

- Implementation of the HUD for the draw mini games.

- Improvement of symbols and spells buttons animations and appearance.

- Implementation of the languages module to translate every texts of the menus.


###### *Gameplay* :

- Implementation of tutorials and dialogues architectures.

- Implementation of the draw mini games.

- Integration of the Google Play Services for real time multiplayer. Migrate the game from the old multiplayer system to Google Play.

- In-App purchases integration.

- iOS porting.​


###### *Tools* (Windows Presentation Foundation, C#) :

- Development of an application for designers to easily add, remove or modify translations in languages supported by Unity. The tool writes translations in an XML, which will be loaded in the game.

- Creation of an application for the developers to parse an Unity folder and change the images compression settings in Unity meta files.

- Creation of an application for developers and artists to parse a folder and resize pictures. Possibility to round up or down or to the nearest power of 2 the picture resolution or even set to a custom size. Ability to choose the origin of the resizing and if the resize will crop or scale the picture.

<iframe width="560" height="315" src="https://www.youtube.com/embed/btadhEyXHpA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
