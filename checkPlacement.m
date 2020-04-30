function [correctCord,error] = checkPlacement(x1,y1,x2,y2,shipLength,board,ship)
    error = "";
    correctCord = true;
    if ~(x1<11 && y1<11)
        error = "Starting cordinates are outside game board.";
        correctCord = false;
    elseif ~(x2<11 && y2<11)
        error = "Ending cordinates are outside game board.";
        correctCord = false;
    elseif x1 ~= x2 && y1 ~= y2 % straight check
            error = "Ships must be placed Vertically or Hortizontially.";
            correctCord = false;
    elseif abs(x1 - x2)+1 ~= shipLength && abs(y1 - y2)+1 ~= shipLength % size check
            error = "Incorrect ship length. The "+ship+" must be "+shipLength+" long.";
            correctCord = false;
    else % blank check
        isBlank = true;
        if x1 == x2 % horizontial
            if y2 > y1
                for i = 1:shipLength
                    array(1,i) = board(x1,y1+i-1);
                end
            elseif y1 > y2
                for i = 1:shipLength
                    array(1,i) = board(x1,y2+i-1);
                end
            end
        elseif y1 == y2 % vertical
            if x2 > x1
                for i = 1:shipLength
                    array(1,i) = board(x1+i-1,y1);
                end
            elseif x1 > x2
                for i = 1:shipLength
                    array(1,i) = board(x2+i-1,y1);
                end
            end
        end
        for i = 1:shipLength % check to makesure they are blank
            if array(1,i) ~= 2
                error = "Cannot place ships ontop of each other.";
                correctCord = false;
            end
        end
    end
    
    
end

