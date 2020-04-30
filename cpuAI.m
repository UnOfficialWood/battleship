classdef cpuAI < handle
    %SHIPHEALTH Summary of this class could go here
    %   Detailed explanation could go here
    properties
        % 0 = do not shoot
        % 1 = shoot blankly
        % 2 = miss
        % 3 = possible ship
        % 4 = ship hit
        % 5 = ship sunk
        shootMap = [
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0]
            
        shootMapOrg=[
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0;
                0,1,0,1,0,1,0,1,0,1;
                1,0,1,0,1,0,1,0,1,0];
            
        %Stats [not hit = 0 first hit == 1 2nd hit = 2, ship health, ship
        %smallest x, smallest y, largest x, largest y]
        carrierStats = [0,5,0,0];
        battleStats = [0,4,0,0];
        subStats = [0,3,0,0];
        cruiserStats =  [0,3,0,0];
        ptStats = [0,2,0,0];
        
        
        shipNames = ["Aircraft Carrier", "BattleShip", "Submarine", "Cruiser", "PT Boat"];
    end
    methods
        
        % checks to see if three is on the shootMap
        function threeOnGameBoard = isThree(obj)
            threeOnGameBoard = 0;
            for i = 1:10
                for j = 1:10
                    if obj.shootMap(i,j) == 3
                        threeOnGameBoard = 1;
                    end
                end
            end
        end
        
        % return coordinates for cpu to shoot
        function [x,y] = getNewCord(obj)
            % 3 on shootmap?
            if isThree(obj) == 1
                cpuCorectCord = false;
                while ~cpuCorectCord % shoot where posible ship is
                    x = randi(10);
                    y = randi(10);
                    if obj.shootMap(x,y) == 3
                        cpuCorectCord = true;
                        obj.shootMap(x,y)=0;
                    end
                end
            else % shoot randomly
                cpuCorectCord = false;
                while ~cpuCorectCord
                    x = randi(10);
                    y = randi(10);
                    if obj.shootMap(x,y) == 1
                        cpuCorectCord = true;
                        obj.shootMap(x,y)=0;
                    end
                end 
            end
        end
        
        function isSunk = updateMap(obj,x,y,hitType,ship)
            isSunk = false;
            % hitType will come in 1 or 0
            % 1 is a hit
            % 0 is a miss
            if hitType == 0 % miss
                obj.shootMap(x,y) = 2;
            elseif hitType == 1 % hit 
                if ship == obj.shipNames(1)% carrier
                    
                    % update carrier health
                    tempHealth = obj.carrierStats(1,2);
                    obj.carrierStats(1,2) = tempHealth - 1;
                    
                    % set shootMap to Hit
                    obj.shootMap(x,y) = 4;
                    
                    if obj.carrierStats(1,2) > 0 % ship still floating
                        
                        if obj.carrierStats(1,1) == 0 % first hit
                            
                            % update that it has been hit
                            obj.carrierStats(1,1) = 1;
                            % set inital hit coordinates
                            obj.carrierStats(1,3:4) = cell2mat({x,y});
                            
                            % update surrounding area
                            % fill +/- size of ship from loctaion
                            xUp = x+1;
                            xDown =x-1;
                            yLeft = y-1;
                            yRight = y+1;
                            if xUp<11
                                if obj.shootMap(xUp,y) < 2
                                    obj.shootMap(xUp,y) = 3;
                                end
                            end
                            if xDown >0
                                if obj.shootMap(xDown,y) < 2
                                    obj.shootMap(xDown,y) = 3;
                                end
                            end
                            if yLeft >0
                                if obj.shootMap(x,yLeft) < 2
                                    obj.shootMap(x,yLeft) = 3;
                                end
                            end
                            if yRight <11
                                if obj.shootMap(x,yRight) < 2
                                    obj.shootMap(x,yRight) = 3;
                                end
                            end
                            
                        elseif obj.carrierStats(1,1) == 1 % second hit
                            % update ship has been hit a 2nd time
                            obj.carrierStats(1,1) = 2;
                            
                            % remove previous possible areas
                            xOrg = obj.carrierStats(1,3);
                            yOrg = obj.carrierStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               % reset surrounding area to original value
                               if (xOrg +1) <11
                                   if obj.shootMap(xOrg+1,yOrg) < 2
                                       obj.shootMap(xOrg+1,yOrg) = obj.shootMapOrg(xOrg+1,yOrg);
                                   end
                               end
                               if (xOrg-1)>0
                                   if obj.shootMap(xOrg-1,yOrg) < 2
                                       obj.shootMap(xOrg-1,yOrg) = obj.shootMapOrg(xOrg-1,yOrg);
                                   end
                               end
                               % set next shot
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.carrierStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                           
                            elseif y == yOrg 
                                % ship is vertical
                                if (yOrg+1)<11
                                    if obj.shootMap(xOrg,yOrg+1) < 2
                                       obj.shootMap(xOrg,yOrg+1) = obj.shootMapOrg(xOrg,yOrg+1);
                                    end
                                end
                                if (yOrg-1)>0
                                    if obj.shootMap(xOrg,yOrg-1) < 2
                                       obj.shootMap(xOrg,yOrg-1) = obj.shootMapOrg(xOrg,yOrg-1);
                                    end
                                end
                                % set next possible shot
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.carrierStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                                
                            end
                        elseif obj.carrierStats(1,1) >= 2
                            % update surrounding area
                            xOrg = obj.carrierStats(1,3);
                            yOrg = obj.carrierStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.carrierStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                            elseif y == yOrg
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.carrierStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                            end
                        end
                    else
                        isSunk = true;
                    end
                elseif ship == obj.shipNames(2) % battle ship
                    % update battle ship health
                    tempHealth = obj.battleStats(1,2);
                    obj.battleStats(1,2) = tempHealth - 1;
                    
                    % set shootMap to Hit
                    obj.shootMap(x,y) = 4;
                    
                    if obj.battleStats(1,2) > 0 % ship still floating
                        
                        if obj.battleStats(1,1) == 0 % first hit
                            
                            % update that it has been hit
                            obj.battleStats(1,1) = 1;
                            % set inital hit coordinates
                            obj.battleStats(1,3:4) = [x,y];
                            
                            % update surrounding area
                            % fill +/- size of ship from loctaion
                            xUp = x+1;
                            xDown =x-1;
                            yLeft = y-1;
                            yRight = y+1;
                            if xUp<11
                                if obj.shootMap(xUp,y) < 2
                                    obj.shootMap(xUp,y) = 3;
                                end
                            end
                            if xDown >0
                                if obj.shootMap(xDown,y) < 2
                                    obj.shootMap(xDown,y) = 3;
                                end
                            end
                            if yLeft >0
                                if obj.shootMap(x,yLeft) < 2
                                    obj.shootMap(x,yLeft) = 3;
                                end
                            end
                            if yRight <11
                                if obj.shootMap(x,yRight) < 2
                                    obj.shootMap(x,yRight) = 3;
                                end
                            end
                            
                        elseif obj.battleStats(1,1) == 1 % second hit
                            % update ship has been hit a 2nd time
                            obj.battleStats(1,1) = 2;
                            
                            % remove previous possible areas
                            xOrg = obj.battleStats(1,3);
                            yOrg = obj.battleStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               % reset surrounding area to original value
                               if (xOrg +1) <11
                                   if obj.shootMap(xOrg+1,yOrg) < 2
                                       obj.shootMap(xOrg+1,yOrg) = obj.shootMapOrg(xOrg+1,yOrg);
                                   end
                               end
                               if (xOrg-1)>0
                                   if obj.shootMap(xOrg-1,yOrg) < 2
                                       obj.shootMap(xOrg-1,yOrg) = obj.shootMapOrg(xOrg-1,yOrg);
                                   end
                               end
                               % set next shot
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.battleStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                           
                            elseif y == yOrg 
                                % ship is vertical
                                if (yOrg+1)<11
                                    if obj.shootMap(xOrg,yOrg+1) < 2
                                       obj.shootMap(xOrg,yOrg+1) = obj.shootMapOrg(xOrg,yOrg+1);
                                    end
                                end
                                if (yOrg-1)>0
                                    if obj.shootMap(xOrg,yOrg-1) < 2
                                       obj.shootMap(xOrg,yOrg-1) = obj.shootMapOrg(xOrg,yOrg-1);
                                    end
                                end
                                % set next possible shot
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.battleStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                                
                            end
                        elseif obj.battleStats(1,1) >= 2
                            % update surrounding area
                            xOrg = obj.battleStats(1,3);
                            yOrg = obj.battleStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.battleStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                            elseif y == yOrg
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.battleStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                            end
                        end
                    else
                        % ship sunk
                        isSunk = true;
                    end
                elseif ship == obj.shipNames(3) % sub
                    % update carrier health
                    tempHealth = obj.subStats(1,2);
                    obj.subStats(1,2) = tempHealth - 1;
                    
                    % set shootMap to Hit
                    obj.shootMap(x,y) = 4;
                    
                    if obj.subStats(1,2) > 0 % ship still floating
                        
                        if obj.subStats(1,1) == 0 % first hit
                            
                            % update that it has been hit
                            obj.subStats(1,1) = 1;
                            % set inital hit coordinates
                            obj.subStats(1,3:4) = cell2mat({x,y});
                            
                            % update surrounding area
                            % fill +/- size of ship from loctaion
                            xUp = x+1;
                            xDown =x-1;
                            yLeft = y-1;
                            yRight = y+1;
                            if xUp<11
                                if obj.shootMap(xUp,y) < 2
                                    obj.shootMap(xUp,y) = 3;
                                end
                            end
                            if xDown >0
                                if obj.shootMap(xDown,y) < 2
                                    obj.shootMap(xDown,y) = 3;
                                end
                            end
                            if yLeft >0
                                if obj.shootMap(x,yLeft) < 2
                                    obj.shootMap(x,yLeft) = 3;
                                end
                            end
                            if yRight <11
                                if obj.shootMap(x,yRight) < 2
                                    obj.shootMap(x,yRight) = 3;
                                end
                            end
                            
                        elseif obj.subStats(1,1) == 1 % second hit
                            % update ship has been hit a 2nd time
                            obj.subStats(1,1) = 2;
                            
                            % remove previous possible areas
                            xOrg = obj.subStats(1,3);
                            yOrg = obj.subStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               % reset surrounding area to original value
                               if (xOrg +1) <11
                                   if obj.shootMap(xOrg+1,yOrg) < 2
                                       obj.shootMap(xOrg+1,yOrg) = obj.shootMapOrg(xOrg+1,yOrg);
                                   end
                               end
                               if (xOrg-1)>0
                                   if obj.shootMap(xOrg-1,yOrg) < 2
                                       obj.shootMap(xOrg-1,yOrg) = obj.shootMapOrg(xOrg-1,yOrg);
                                   end
                               end
                               % set next shot
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.subStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                           
                            elseif y == yOrg 
                                % ship is vertical
                                if (yOrg+1)<11
                                    if obj.shootMap(xOrg,yOrg+1) < 2
                                       obj.shootMap(xOrg,yOrg+1) = obj.shootMapOrg(xOrg,yOrg+1);
                                    end
                                end
                                if (yOrg-1)>0
                                    if obj.shootMap(xOrg,yOrg-1) < 2
                                       obj.shootMap(xOrg,yOrg-1) = obj.shootMapOrg(xOrg,yOrg-1);
                                    end
                                end
                                % set next possible shot
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.subStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                                
                            end
                        elseif obj.subStats(1,1) >= 2
                            % update surrounding area
                            xOrg = obj.subStats(1,3);
                            yOrg = obj.subStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.subStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                            elseif y == yOrg
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.subStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                            end
                        end
                    else
                        % ship sunk
                        isSunk = true;
                    end
                elseif ship == obj.shipNames(4) % cruiser
                    % update cruiser health
                    tempHealth = obj.cruiserStats(1,2);
                    obj.cruiserStats(1,2) = tempHealth - 1;
                    
                    % set shootMap to Hit
                    obj.shootMap(x,y) = 4;
                    
                    if obj.cruiserStats(1,2) > 0 % ship still floating
                        
                        if obj.cruiserStats(1,1) == 0 % first hit
                            
                            % update that it has been hit
                            obj.cruiserStats(1,1) = 1;
                            % set inital hit coordinates
                            obj.cruiserStats(1,3:4) = cell2mat({x,y});
                            
                            % update surrounding area
                            % fill +/- size of ship from loctaion
                            xUp = x+1;
                            xDown =x-1;
                            yLeft = y-1;
                            yRight = y+1;
                            if xUp<11
                                if obj.shootMap(xUp,y) < 2
                                    obj.shootMap(xUp,y) = 3;
                                end
                            end
                            if xDown >0
                                if obj.shootMap(xDown,y) < 2
                                    obj.shootMap(xDown,y) = 3;
                                end
                            end
                            if yLeft >0
                                if obj.shootMap(x,yLeft) < 2
                                    obj.shootMap(x,yLeft) = 3;
                                end
                            end
                            if yRight <11
                                if obj.shootMap(x,yRight) < 2
                                    obj.shootMap(x,yRight) = 3;
                                end
                            end
                            
                        elseif obj.cruiserStats(1,1) == 1 % second hit
                            % update ship has been hit a 2nd time
                            obj.cruiserStats(1,1) = 2;
                            
                            % remove previous possible areas
                            xOrg = obj.cruiserStats(1,3);
                            yOrg = obj.cruiserStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               % reset surrounding area to original value
                               if (xOrg +1) <11
                                   if obj.shootMap(xOrg+1,yOrg) < 2
                                       obj.shootMap(xOrg+1,yOrg) = obj.shootMapOrg(xOrg+1,yOrg);
                                   end
                               end
                               if (xOrg-1)>0
                                   if obj.shootMap(xOrg-1,yOrg) < 2
                                       obj.shootMap(xOrg-1,yOrg) = obj.shootMapOrg(xOrg-1,yOrg);
                                   end
                               end
                               % set next shot
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.cruiserStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                           
                            elseif y == yOrg 
                                % ship is vertical
                                if (yOrg+1)<11
                                    if obj.shootMap(xOrg,yOrg+1) < 2
                                       obj.shootMap(xOrg,yOrg+1) = obj.shootMapOrg(xOrg,yOrg+1);
                                    end
                                end
                                if (yOrg-1)>0
                                    if obj.shootMap(xOrg,yOrg-1) < 2
                                       obj.shootMap(xOrg,yOrg-1) = obj.shootMapOrg(xOrg,yOrg-1);
                                    end
                                end
                                % set next possible shot
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.cruiserStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                                
                            end
                        elseif obj.cruiserStats(1,1) >= 2
                            % update surrounding area
                            xOrg = obj.cruiserStats(1,3);
                            yOrg = obj.cruiserStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.cruiserStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                            elseif y == yOrg
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.cruiserStats(1,3) = xOrg -1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                            end
                        end
                    else
                        % ship sunk
                        isSunk = true;
                    end
                elseif ship == obj.shipNames(5)% PT boat
                    % update PT Boat health
                    tempHealth = obj.ptStats(1,2);
                    obj.ptStats(1,2) = tempHealth - 1;
                    
                    % set shootMap to Hit
                    obj.shootMap(x,y) = 4;
                    
                    if obj.ptStats(1,2) > 0 % ship still floating
                        
                        if obj.ptStats(1,1) == 0 % first hit
                            
                            % update that it has been hit
                            obj.ptStats(1,1) = 1;
                            % set inital hit coordinates
                            obj.ptStats(1,3:4) = cell2mat({x,y});
                            
                            % update surrounding area
                            % fill +/- size of ship from loctaion
                            xUp = x+1;
                            xDown =x-1;
                            yLeft = y-1;
                            yRight = y+1;
                            if xUp<11
                                if obj.shootMap(xUp,y) < 2
                                    obj.shootMap(xUp,y) = 3;
                                end
                            end
                            if xDown >0
                                if obj.shootMap(xDown,y) < 2
                                    obj.shootMap(xDown,y) = 3;
                                end
                            end
                            if yLeft >0
                                if obj.shootMap(x,yLeft) < 2
                                    obj.shootMap(x,yLeft) = 3;
                                end
                            end
                            if yRight <11
                                if obj.shootMap(x,yRight) < 2
                                    obj.shootMap(x,yRight) = 3;
                                end
                            end
                            
                        elseif obj.ptStats(1,1) == 1 % second hit
                            % update ship has been hit a 2nd time
                            obj.ptStats(1,1) = 2;
                            
                            % remove previous possible areas
                            xOrg = obj.ptStats(1,3);
                            yOrg = obj.ptStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               % reset surrounding area to original value
                               if (xOrg +1) <11
                                   if obj.shootMap(xOrg+1,yOrg) < 2
                                       obj.shootMap(xOrg+1,yOrg) = obj.shootMapOrg(xOrg+1,yOrg);
                                   end
                               end
                               if (xOrg-1)>0
                                   if obj.shootMap(xOrg-1,yOrg) < 2
                                       obj.shootMap(xOrg-1,yOrg) = obj.shootMapOrg(xOrg-1,yOrg);
                                   end
                               end
                               % set next shot
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.ptStats(1,4) = yOrg -1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                           
                            elseif y == yOrg 
                                % ship is vertical
                                if (yOrg+1)<11
                                    if obj.shootMap(xOrg,yOrg+1) < 2
                                       obj.shootMap(xOrg,yOrg+1) = obj.shootMapOrg(xOrg,yOrg+1);
                                    end
                                end
                                if (yOrg-1)>0
                                    if obj.shootMap(xOrg,yOrg-1) < 2
                                       obj.shootMap(xOrg,yOrg-1) = obj.shootMapOrg(xOrg,yOrg-1);
                                    end
                                end
                                % set next possible shot
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.ptStats(1,3) = xOrg - 1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                                
                            end
                        elseif obj.ptStats(1,1) >= 2
                            % update surrounding area
                            xOrg = obj.ptStats(1,3);
                            yOrg = obj.ptStats(1,4);
                            if x == xOrg
                               % ship is horizontial
                               if (y+1) < 11 && obj.shootMap(x,y+1) < 2
                                   obj.shootMap(x,y+1) = 3;
                               elseif (yOrg-1)>0 && obj.shootMap(x,yOrg-1) < 2
                                   obj.ptStats(1,4) = yOrg - 1;
                                   obj.shootMap(x,yOrg-1) = 3;
                               end
                            elseif y == yOrg
                                % ship is vertical
                                if (x+1) < 11 && obj.shootMap(x+1,y) < 2
                                   obj.shootMap(x+1,y) = 3;
                                elseif xOrg-1>0 && obj.shootMap(xOrg-1,y) < 2
                                   obj.ptStats(1,3) = xOrg - 1;
                                   obj.shootMap(xOrg-1,y) = 3;
                                end
                            end
                        end
                    else
                        % ship sunk
                        isSunk = true;
                    end
                else
                    % error in ship name
                    isSunk = false;
                end
                obj.shootMap()
                
            end
        end
        
    end
end

