


**Introduction/Ideas:**

So after 3 years of abstinence from doing Game Jams I decided to enter this months Godot Wild Jam, since I think Godot is pretty neat and all and I liked the time span of around a week to complete the game​.

The Theme was Expansion! Initially my idea was to make a game, where you are a tumor and your task is to kill the body you're in by expanding in size and spreading over the body. The reason I didn't go with since I thought other people would also have that Idea and I wanted to make something truly unique.
I had some others in between, but as soon as I got the Idea for a game where you're the bad guy spreading misinformation it clinged to my mind and I went with it.
Here's also the first problem: I started with a concept centering on story and  world and not on one where the gameplay was the main focus.

After having this initial Idea, I sort of built a world around it, where you're an AI created for the sole purpose of destroying the planet by spreading misinformation. (Yes, I read a lot of Scifi this year) 
At the start I also watched a Video on how misinformation spreads by the BBC. It mentioned the 5 types of characters/motivations that are essential for spreading misinformation in our society. I saw  this as an invite to have 5 character classes in this game you can kind of control in  every country. The classes were:

 1. The Joker
 2. The Scammer
 3. The  Conspiracy Theorist
 4. The Insider
 5. The Politician
 
I wanted to make this character work off of each other and have this progression in each country, where you could unlock a new type by hitting certain thresholds in conversion rate.

For the world I wanted to have a real world globe map with selectable countries and this very nihilistic/repressing vibe.

**Development**
I started by trying to do the  world map as a globe, which I instantly threw out of the window, after In realized I never did a 3D game and this was a bit too step for me.
I settled on getting freely accessible GeoData from the web in the form of .geojson files. They are a pretty cool thing I never heard of and I went down this rabbit hole of geographical files and structures for 1 day of development.
Getting the data into the Game was pretty straightforward tbh. Just JSON,  and adding the geometries, which are just a bunch of points in lat/lon formatted values to a Polygon. 
The main problem was RUSSIA. I swear the god, if I think about how much ungodly time I spent trying to make the GeoData of this Country show up in Godot I could cry. This single country caused me so much trouble, and in the end the problem simply where a combination of intersections in the points and the sheer size. 

TIP: If you ever have this issue go to this website: https://mapshaper.org/

 - Open the Console 
 - Use the Command **clean** (fixes intersections) & **explode** (split the big polygon into multiple)
 - Optionally also simplify the Geometry for faster loading times
 
 For the Gameplay I decided on this **Clicker-Type-Game**, which was kinda stupid in hindsight, since I never really played them and it turns out balancing them really is a pain in the ass.
So, made the countries selectable, added core tasks and initially only jokers. I actually wanted each class to behave and play completely different. Then I realized that I only had 3 days left and still no gameplay loop, so they act all the same, only that their effectiveness heavily depends on certain country properties.

Joker : Effective in countries with big Population
Scammer: Effective in richer countries, e.g. Norway,...
Conspirator: In poorer and younger countries
Insider: Scraped -> No ideas & no time
Politician: Is the only unique class in the way that you can bribe them continously  and they work for you

On major thing I also decided during development, is to use art by myself. Not because I'm particularly artistic or so, more so that I found all  assets available (for free) didn't fit the theme I was going for at all. So, I dusted off my old Graphics Tablet I bought for playing OSU! and created those sketchy watercolor/pencil drawings in Affinity Photo. Tbh, I'm really happy on how they turned out & how well they fit in the game.

**Conclusion**
In this 3 year pause of doing game jams I seem to have forgotten, that you should keep it simple and not try to start a revolution with your game. I worked way too long on a lot of concepts, scraped many again and couldn't polish most of the gameplay structures.

In the end It's a product I'm actually pretty happy with and learned A LOT from. It's the first thing I actually finished in Godot 4, so even if its a bit clunky on some edges I still am so happy to have pulled through and committed on my initial ideas.

**Things I Learned for Myself**

 - I love working with geodata in game engines. For real that may have been the most fun part for me. Seeing those countries and making them interactable. The best  thing is that there  is so much more of it, so I'll probably use it more in the future
 - Clicker Games aren't my type of Genre to develop
 - Making my own art for games is incredibly satisfying and a good change of pace in the workflow
 
 Hey, If you're reading this first off; Thank you! I'm writing this more for my future self and am well aware that few others may ever read this, so If you are not my future self, I really appreciate it :)
 


