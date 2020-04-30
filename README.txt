Files needed to run battleship:

1. battleship.m
2. checkPlacement.m
3. cpuAI.m
4. Setup.m
5. shipHealth.m
6. simpleGameEngine.m
7. Battleship.png

Descriptions of each file:
1. battleship.m
-> Main file. The entire game is run out of this file. It uses all other files mentioned.

2. checkPlacement.m
-> Single function called checkPlacement is the entierty of this file.
-> This function returns true if the given locations meet the ship reqierments
-> This function returns false if the given locations do not meet the ship reqierments
-> the function takes 7 arguments
-> "x1" argument: reqiers a positive integer containting the row number of the beginning of the ship
-> "y1" argument: reqiers a positive integer containting the column number of the beginning of the ship
-> "x2" argument: reqiers a positive integer containting the row number of the ending of the ship
-> "y2" argument: reqiers a positive integer containting the column number of the ending of the ship
-> "shipLength" argument: reqiers and positive integer that corresponds the the ship length
-> "board" argument: requiers a 10 x 21 matrix
-> "ship" arguemnt: requiers a string value of the corresponding ship.

3. cpuAI.m
-> Class file.
-> Only one object is created for this game.

4. Setup.m
-> single function file
-> only function is called "Setup()"
-> no paramaters reqiered
-> returns a 10 x 10 matrix containg the 5 ships and their locations
-> (Given in project from carmen)

5. shipHealth.m
-> Class file
-> two objects are generated for both the player and the cpu to track ship health

6. simpleGameEngine.m
-> Class file.
-> is responsible for GUI display and sprite managment
-> (Given in project from carmen)

7. Battleship.png
-> single sprite image that holds all sprite images for use in game
-> (Given in project from carmen)