%% Arbitrary block coordinates for testing
x1L = [0,5,10,15,20];
y1L = [0,5,10,15,20];
x2L = [60,65,70,75,80];
y2L = [60,65,70,75,80];

%% clear Deck Function
clearDeckFcn(x1L,x2L,y1L,y2L);

function clearDeckFcn(x1List, y1List, x2List, y2List)
    for listCounter = 1:length(x1List)
        % if the desired conveyor location is occupied
            % shift the location by a block's size 
                %repeat until the desired location is not occupied, then DO
        SM_BP2Conveyor(x1List(listCounter),y1List(listCounter),x2List(listCounter),y2List(listCounter));
        BP2Conveyor_updateBlocklist(x2,y2);
    end
end

