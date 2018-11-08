function CM_fillDeck()
    global BoxX;
    global BoxY;
%     global conveyorBlockData;
%     shapeCounter = 0;
%     letterCounter = 0;
%     shapeBlocks = [];
%     letterBlocks = [];
    %while ~isempty(conveyorBlockData)
%         len = length(conveyorBlockData);
%         for i = 1:len
%             stringSplit = strsplit(conveyorBlockData(i));
%             xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
%             yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
%             pattern = char(stringSplit(4));
%             if strcmp(pattern,'1')
%                 if(shapeCounter <= 6)%shape
%                     shapeCounter = shapeCounter+1;
%                     shapeBlocks(1,shapeCounter) = xConveyor(i); %first column is x
%                     shapeBlocks(2,shapeCounter) = yConveyor(i); %second column is y
%                 else
%                     disp('shape matrix is full!')
%                 end
%             elseif strcmp(pattern,'2')
%                 if(letterCounter <= 6) %letter
%                     letterCounter = letterCounter+1;
%                     letterBlocks(1,letterCounter) = xConveyor(i);
%                     letterBlocks(2,letterCounter) = yConveyor(i);
%                 else
%                     disp('letter matrix is full!')
%                 end
%             end
%         end
        % we get 6 shapes and letters
        % move 6 shapes
%         if(~isempty(shapeBlocks))

        blockMatrixX = [];
        blockMatrixY = [];
%         moveCounter = 0;
        for blockCounter = 1:6 %first 6 blocks
            [blockMatrixX(blockCounter),blockMatrixY(blockCounter)] = gameboardConversion(blockCounter,'Q');
        end
        
        for blockCounter = 1:6 %next 6 blocks
            [blockMatrixX(blockCounter+6),blockMatrixY(blockCounter+6)] = gameboardConversion(blockCounter,'P');
        end
        
        blockCounter = 1;
        for rowCounter = 1:3
            for columnCounter = 1:4
                s1_x1(blockCounter) = blockMatrixX(columnCounter+(rowCounter-1)*4);
                s1_y1(blockCounter) = blockMatrixY(columnCounter+(rowCounter-1)*4);
                s1_x2(blockCounter) = BoxX;
                s1_y2(blockCounter) = BoxY;
                SM_BP2ConveyorModified(s1_x1(blockCounter), s1_y1(blockCounter), s1_x2(blockCounter), s1_y2(blockCounter));
                sprintf('Block %d is moved onto Conveyor!',blockCounter)
                blockCounter = blockCounter+1;
            end
        end
%         end
%         end
        % then move 6 letters
%        if(~isempty(letterBlocks))
%            for i3 = 1:length(letterBlocks(1,:))
%                [l1_x2(i3),l1_y2(i3)] = gameboardConversion(i3,'P');
% %                 l1_x1(i3) = letterBlocks(1,i3);
% %                 l1_y1(i3) = letterBlocks(2,i3);
%                 SM_Conveyor2BP(l1_x1(i3), l1_y1(i3), l1_x2(i3), l1_y2(i3));
%                 sprintf('Letter %d is moved onto Deck!',i3)
%            end
%        end
       % it would still work if there is less than 6 shapes/letters
    %end
%     disp('no blocks on conveyor!')
end