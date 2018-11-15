% This function finds the x, y and rotation of the blocks to be filled 
% onto player 2's deck. Then, the simple move functions will be called 
% on the GUI to move the blocks.
% Requirements: Fill one player's deck using blocks contained in a box on 
% the conveyor.

function CM_fillDeck2()
    global conveyorBlockData;
    global tableBlockData;
    global shapeBlocks;
    global shapeIndex;
    shapeCounter = 0;
    shapeBlocks = [];
        len = length(conveyorBlockData);
        for i = 1:len
            stringSplit = strsplit(conveyorBlockData(i));
            xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
            yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
            rotConveyor(i) = str2double(stringSplit(3));
            pattern = char(stringSplit(4));
%             if strcmp(pattern,'1')
                if(shapeCounter <= 6)%shape
                    shapeCounter = shapeCounter+1;
                    shapeIndex(shapeCounter) = i;
                    shapeBlocks(1,shapeCounter) = xConveyor(i); %first column is x
                    shapeBlocks(2,shapeCounter) = yConveyor(i); %second column is y
                    shapeBlocks(3,shapeCounter) = rotConveyor(i); % third column is rotation
                else
                    disp('Player2 deck is full!')
                end
%             end
        end
end