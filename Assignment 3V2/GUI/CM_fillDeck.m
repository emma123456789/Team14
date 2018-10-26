%% Arbitrary block coordinates for testing
% x1L = [0,5,10,15,20];
% y1L = [0,5,10,15,20];
% x2L = [60,65,70,75,80];
% y2L = [60,65,70,75,80];

%% fill Deck Function
% fillDeckFcn(x1L,x2L,y1L,y2L);

function CM_fillDeck()
    global conveyorBlockData;
    shapeCounter = 0;
    letterCounter = 0;
    shapeBlocks = [];
    letterBlocks = [];
    %while ~isempty(conveyorBlockData)
        len = length(conveyorBlockData);
        for i = 1:len
            stringSplit = strsplit(conveyorBlockData(i));
            xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
            yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
            pattern = char(stringSplit(4));
            if strcmp(pattern,'1')
                if(shapeCounter <= 6)%shape
                    shapeCounter = shapeCounter+1;
                    shapeBlocks(1,shapeCounter) = xConveyor(i); %first column is x
                    shapeBlocks(2,shapeCounter) = yConveyor(i); %second column is y
                else
                    disp('shape matrix is full!')
                end
            elseif strcmp(pattern,'2')
                if(letterCounter <= 6) %letter
                    letterCounter = letterCounter+1;
                    letterBlocks(1,letterCounter) = xConveyor(i);
                    letterBlocks(2,letterCounter) = yConveyor(i);
                else
                    disp('letter matrix is full!')
                end
            end
        end
        % we get 6 shapes and letters
        % move 6 shapes
        if(~isempty(shapeBlocks))
            for i2 = 1:length(shapeBlocks(1,:)) 
                s1_x1(i2) = shapeBlocks(1,i2);
                s1_y1(i2) = shapeBlocks(2,i2);
                [s1_x2(i2),s1_y2(i2)] = gameboardConversion(i2,'Q');
                SM_Conveyor2BP(s1_x1(i2), s1_y1(i2), s1_x2(i2), s1_y2(i2));
                sprintf('Shape %d is moved onto Deck!',i2)
            end
        end
        % then move 6 letters
       if(~isempty(letterBlocks))
           for i3 = 1:length(letterBlocks(1,:))
                l1_x1(i3) = letterBlocks(1,i3);
                l1_y1(i3) = letterBlocks(2,i3);
                [l1_x2(i3),l1_y2(i3)] = gameboardConversion(i3,'P');
                SM_Conveyor2BP(l1_x1(i3), l1_y1(i3), l1_x2(i3), l1_y2(i3));
                sprintf('Letter %d is moved onto Deck!',i3)
           end
       end
       % it would still work if there is less than 6 shapes/letters
    %end
%     disp('no blocks on conveyor!')
end