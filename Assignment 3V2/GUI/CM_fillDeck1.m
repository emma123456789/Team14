% This function finds the x, y and rotation of the blocks to be filled 
% onto player 1's deck. Then, the simple move functions will be called 
% on the GUI to move the blocks.
% Requirements: Fill one player's deck using blocks contained in a box on 
% the conveyor.

function CM_fillDeck1()
    global conveyorBlockData;
    global tableBlockData;
    global letterBlocks;
    global letterIndex;
    letterCounter = 0;
    letterBlocks = [];
        len = length(conveyorBlockData);
        for i = 1:len
            stringSplit = strsplit(conveyorBlockData(i));
            xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
            yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
            rotConveyor(i) = str2double(stringSplit(3));
            pattern = char(stringSplit(4));

%             if strcmp(pattern,'2')
                if(letterCounter <= 6) %letter
                    letterCounter = letterCounter+1;
                    letterIndex(letterCounter) = i;
                    letterBlocks(1,letterCounter) = xConveyor(i);
                    letterBlocks(2,letterCounter) = yConveyor(i);
                    letterBlocks(3,letterCounter) = rotConveyor(i);
                else
                    disp('Player1 deck is full!')
                end
%             end
        end

end