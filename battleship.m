clc
clear

% Initialize scene
my_scene = simpleGameEngine('Battleship.png',84,84);

% Set up variables to name the various sprites
blank_sprite = 1;
water_sprite = 2;

left_ship_sprite = 3;
horiz_ship_sprite = 4;
right_ship_sprite = 5;

top_ship_sprite = 6;
vert_ship_sprite = 7;
bot_ship_sprite = 8;

hit_sprite = 9;
miss_sprite = 10;

% Ships
shipNames(1,:) = ["Aircraft Carrier", "BattleShip", "Submarine", "Cruiser", "PT Boat"];
shipLoc(1,:) = {0,0,0,0,5}; % carrier
shipLoc(2,:) = {0,0,0,0,4}; % battleship
shipLoc(3,:) = {0,0,0,0,3}; % submarine
shipLoc(4,:) = {0,0,0,0,3}; % cruiser
shipLoc(5,:) = {0,0,0,0,2}; % PT boat
shipLoc = cell2mat(shipLoc);

player_board = cell2mat({0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0});

% Display empty board   
board_display = water_sprite * ones(10,21);
board_display(:,11) = blank_sprite;
drawScene(my_scene,board_display);


% Get placement of ships
fprintf("Place Ships!\n")

for i = 1:length(shipNames)
    correctCord = false;
    while ~correctCord
        % get user input
        fprintf("Choose starting location of %s...\n",shipNames(i))
        [x1,y1] = getMouseInput(my_scene);
        fprintf("Choose ending location of %s...\n",shipNames(i))
        [x2,y2] = getMouseInput(my_scene);
        % convert cordinates to integers 
        shipLoc(i,1:4)= cell2mat({x1,y1,x2,y2});
        % get correctcordinates and possible error
        [correctCord,error] = checkPlacement(shipLoc(i,1),shipLoc(i,2),shipLoc(i,3),shipLoc(i,4),shipLoc(i,5),board_display,shipNames(i));
        if ~correctCord
            fprintf(error+"\n")
        end
    end
    if shipLoc(i,1) == shipLoc(i,3) % horizontial
        if shipLoc(i,2) > shipLoc(i,4)
            shipEnd1 = right_ship_sprite;
            shipEnd2 = left_ship_sprite;
            startcord = 4;
        else
            shipEnd1 = left_ship_sprite;
            shipEnd2 = right_ship_sprite;
            startcord = 2;
        end
        board_display(shipLoc(i,1),shipLoc(i,2)) = shipEnd1;
        player_board(shipLoc(i,1),shipLoc(i,2)) = i;
        for j = 1:(shipLoc(i,5)-2)
            board_display(shipLoc(i,1),shipLoc(i,startcord)+j) = horiz_ship_sprite;
            player_board(shipLoc(i,1),shipLoc(i,startcord)+j) = i;
        end
        
        board_display(shipLoc(i,3),shipLoc(i,4)) = shipEnd2;
        player_board(shipLoc(i,3),shipLoc(i,4)) = i;
        
    elseif shipLoc(i,2) == shipLoc(i,4) % vertical
        if shipLoc(i,1) > shipLoc(i,3)
            shipEnd1 = bot_ship_sprite;
            shipEnd2 = top_ship_sprite;
            startcord = 3;
        else
            shipEnd1 = top_ship_sprite;
            shipEnd2 = bot_ship_sprite;
            startcord = 1;
        end
        board_display(shipLoc(i,1),shipLoc(i,2)) = shipEnd1;
        player_board(shipLoc(i,1),shipLoc(i,2)) = i;
        for k = 1:(shipLoc(i,5)-2)
            board_display(shipLoc(i,startcord)+k,shipLoc(i,2)) = vert_ship_sprite;
            player_board(shipLoc(i,startcord)+k,shipLoc(i,2)) =i;
        end
        
        board_display(shipLoc(i,3),shipLoc(i,2)) = shipEnd2;
        player_board(shipLoc(i,3),shipLoc(i,2)) = i;
    end
    drawScene(my_scene,board_display)
    %if i == 5
    %    pause(5)
    %end
end

% Play the Game
fprintf("\nLets Play Battle Ship!\n")
cpu_board = Setup();
player_board
%pause
%cpu_board
choice = input("Input 1 for heads or 2 for tails: ");
coinFlipValue = randi(2);
if coinFlipValue == choice
    fprintf("Player goes first\n");
    flip = 1;
else
    fprintf("Computer plays first\n");
    flip = 0;
end

% shoot

% Set up hits and misses layer
hitmiss_display = blank_sprite * ones(10,21);
cpu_ship_sunk = {0,0,0,0,0};

playerShipStats = shipHealth();

cpuShipStats = shipHealth();
cpuAI = cpuAI();

playGame = true;

while playGame
    switch flip
        case 1 % player shoots
            % player shoots
            fprintf("\nPlayer's Turn:\n")
            fprintf("Shoot!\n")

            % get correct coordinates
            correctShotCord = false;
            while ~correctShotCord
                [x1,y1] = getMouseInput(my_scene);
                if ~(y1>11)
                    fprintf("Choose Coordinates on the right side of the board\n")
                    correctShotCord = false;
                elseif hitmiss_display(x1,y1) ~= 1
                    fprintf("Already Shot here choose again\n")
                    correctShotCord = false;
                else
                    correctShotCord = true;
                end
            end
            % check shot 
            if cpu_board(x1,y1-11) > 0 % hit
                % update ship enemy health
                
                tempShipName = shipNames(cpu_board(x1,y1-11));
                isSunk = shipHit(playerShipStats,tempShipName);
                tempHealth = getShipHealth(playerShipStats,tempShipName);
                
                
                if isSunk == 1
                    fprintf("%s has Sunk\n",tempShipName)
                else
                    fprintf("Hit %s\n",tempShipName)
                    hits = getShipLength(playerShipStats, tempShipName)-tempHealth;
                    fprintf("%s has %i hits of %i\n",tempShipName,hits,getShipLength(playerShipStats, tempShipName)) 
                end
                floatingShips = getFloatingShips(playerShipStats);
                if floatingShips == 0 % sunk all ships
                    fprintf("You have sunk all of the computers ships\n")
                    fprintf("Player has won!\n")
                    playGame = false;
                else % keep playing
                    fprintf("%i ships are still floating\n",floatingShips)
                end
                hitmiss_display(x1,y1) = hit_sprite;
            else % miss
                fprintf("Miss\n")
                fprintf("%i ships are still floating\n",getFloatingShips(playerShipStats))
                hitmiss_display(x1,y1) = miss_sprite;
            end
            drawScene(my_scene,board_display,hitmiss_display);
            flip = 0;

        case 0 % cpu shoots
            % get cordinates
            fprintf("\nComputers Turn:\n")

            [xCpu,yCpu]=getNewCord(cpuAI);
            % check shot
            if player_board(xCpu,yCpu)>0
                % hit
                fprintf("Computer Hit\n")
                
                shipIdx = player_board(xCpu,yCpu);
                
                shipName = shipNames(shipIdx);
                
                shipHit(cpuShipStats,shipName)
                
                isSunk = updateMap(cpuAI,xCpu,yCpu,1,shipName);
                
                tempHealth = getShipHealth(cpuShipStats,shipName);
                % cpuShipStats
                
                if isSunk == 1
                    fprintf("%s has Sunk\n",shipName)
                else
                    fprintf("Hit %s\n",shipName)
                    hits = getShipLength(cpuShipStats,shipName)-tempHealth;
                    fprintf("%s has %i hits of %i\n",shipName,hits,getShipLength(cpuShipStats, shipName)) 
                end
                floatingShips = getFloatingShips(cpuShipStats);
                if floatingShips == 0 % sunk all ships
                    fprintf("CPU has sunk all of the players ships\n")
                    fprintf("CPU has won!\n")
                    playGame = false;
                else % keep playing
                    fprintf("%i ships are still floating\n",floatingShips)
                end
                
                
                
                
                hitmiss_display(xCpu,yCpu) = hit_sprite;
            else
                % miss
                fprintf("Computer Miss\n")
                
                updateMap(cpuAI,xCpu,yCpu,0,"none");
                
                hitmiss_display(xCpu,yCpu) = miss_sprite;
            end
            % update display
            drawScene(my_scene,board_display,hitmiss_display)
            flip = 1;
    end
end