classdef shipHealth < handle
    %SHIPHEALTH Summary of this class could go here
    %   Detailed explanation could go here
    
    properties
        shipHealthList = [5,5; 4,4; 3,3; 3,3; 2,2];
        shipNames = ["Aircraft Carrier", "BattleShip", "Submarine", "Cruiser", "PT Boat"];
    end
    
    methods
        function idx = getShipIdx(obj, ship)
            for i = 1:5
                if ship == obj.shipNames(i)
                    idx = i;
                end
            end
        end
        
        function len = getShipLength(obj, ship)
            len = obj.shipHealthList(getShipIdx(obj, ship),2);
        end
        
        function health = getShipHealth(obj, ship)
            % get index
            index = getShipIdx(obj, ship);
            %return health
            health = obj.shipHealthList(index,1);
        end
        
        function health = setShipHealth(obj, ship, health)
            % get index
            index = getShipIdx(obj, ship);
            %return health
            obj.shipHealthList(index,1) = health;
        end
        
        function isSunk = shipHit(obj, ship)
            isSunk = false;
            index = getShipIdx(obj, ship);
            currentHealth = getShipHealth(obj, ship);
            setShipHealth(obj, ship, currentHealth-1);
            if obj.shipHealthList(index,1)== 0
                isSunk = true;
            end
        end
        
        function num = getFloatingShips(obj)
            num = 5;
            for i = 1:5
                if obj.shipHealthList(i,1) == 0
                    num = num - 1;
                end
            end
        end
    end
end

