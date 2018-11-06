%% Player2's deck = Shapes

function CM_fillDeck2()
    global conveyorBlockData;
    global tableBlockData;
    global shapeBlocks;
    global shapeIndex;
    shapeCounter = 0;
%     letterCounter = 0;
    shapeBlocks = [];
%     letterBlocks = [];
    %while ~isempty(conveyorBlockData)
        len = length(conveyorBlockData);
        for i = 1:len
            stringSplit = strsplit(conveyorBlockData(i));
            xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
            yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
            rotConveyor(i) = str2double(stringSplit(3));
            pattern = char(stringSplit(4));
            if strcmp(pattern,'1')
                if(shapeCounter <= 6)%shape
                    shapeCounter = shapeCounter+1;
                    shapeIndex(shapeCounter) = i;
                    shapeBlocks(1,shapeCounter) = xConveyor(i); %first column is x
                    shapeBlocks(2,shapeCounter) = yConveyor(i); %second column is y
                    shapeBlocks(3,shapeCounter) = rotConveyor(i); % third column is rotation
                else
                    disp('Player2 deck is full!')
                end
            end
%             elseif strcmp(pattern,'2')
%                 if(letterCounter <= 6) %letter
%                     letterCounter = letterCounter+1;
%                     letterBlocks(1,letterCounter) = xConveyor(i);
%                     letterBlocks(2,letterCounter) = yConveyor(i);
%                     letterBlocks(3,letterCounter) = rotConveyor(i);
%                 else
%                     disp('letter matrix is full!')
%                 end
        end
%         end
        % we get 6 shapes and letters
        % move 6 shapes
        % then move 6 letters
%        if(~isempty(letterBlocks))
%            for i3 = 1:length(letterBlocks(1,:))
%                 l1_x1(i3) = letterBlocks(1,i3);
%                 l1_y1(i3) = letterBlocks(2,i3);
%                 l1_rot(i3) = letterBlocks(3,i3);
%                 [l1_x2(i3),l1_y2(i3)] = gameboardConversion(i3,'P');
% %                 SM_RotateBlock(l1_x1(i3), l1_y1(i3), l1_rot(i3));
%                 SM_FillDeckConveyor2BP(l1_x1(i3), l1_y1(i3), l1_x2(i3), l1_y2(i3), l1_rot(i3));
%                 sprintf('Letter %d is moved onto Deck!',i3)
%            end
       end
       % it would still work if there is less than 6 shapes/letters
    %end
%     disp('no blocks on conveyor!')
% end