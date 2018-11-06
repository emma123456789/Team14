%% Player1's deck = Letters

function CM_fillDeck1()
    global conveyorBlockData;
    global tableBlockData;
    global letterBlocks;
    global letterIndex;
%     shapeCounter = 0;
    letterCounter = 0;
%     shapeBlocks = [];
    letterBlocks = [];
    %while ~isempty(conveyorBlockData)
        len = length(conveyorBlockData);
        for i = 1:len
            stringSplit = strsplit(conveyorBlockData(i));
            xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
            yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
            rotConveyor(i) = str2double(stringSplit(3));
            pattern = char(stringSplit(4));
%             if strcmp(pattern,'1')
%                 if(shapeCounter <= 6)%shape
%                     shapeCounter = shapeCounter+1;
%                     shapeBlocks(1,shapeCounter) = xConveyor(i); %first column is x
%                     shapeBlocks(2,shapeCounter) = yConveyor(i); %second column is y
%                     shapeBlocks(3,shapeCounter) = rotConveyor(i); % third column is rotation
%                 else
%                     disp('shape matrix is full!')
%                 end
            if strcmp(pattern,'2')
                if(letterCounter <= 6) %letter
                    letterCounter = letterCounter+1;
                    letterIndex(letterCounter) = i;
                    letterBlocks(1,letterCounter) = xConveyor(i);
                    letterBlocks(2,letterCounter) = yConveyor(i);
                    letterBlocks(3,letterCounter) = rotConveyor(i);
                else
                    disp('Player1 deck is full!')
                end
            end
        end
        % we get 6 shapes and letters
        % move 6 shapes
%         if(~isempty(shapeBlocks))
%             for i2 = 1:length(shapeBlocks(1,:)) 
%                 s1_x1(i2) = shapeBlocks(1,i2);
%                 s1_y1(i2) = shapeBlocks(2,i2);
%                 s1_rot(i2) = shapeBlocks(3,i2)
%                 [s1_x2(i2),s1_y2(i2)] = gameboardConversion(i2,'Q');
%                 SM_RotateBlock(s1_x1(i2), s1_y1(i2), s1_rot(i2));
%                 SM_FillDeckConveyor2BP(s1_x1(i2), s1_y1(i2), s1_x2(i2), s1_y2(i2), s1_rot(i2));
%                 sprintf('Shape %d is moved onto Deck!',i2)
%             end
%         end
        % then move 6 letters

       % it would still work if there is less than 6 shapes/letters
    %end
%     disp('no blocks on conveyor!')
end