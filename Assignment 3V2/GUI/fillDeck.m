%% Arbitrary block coordinates for testing
x1L = [0,5,10,15,20];
y1L = [0,5,10,15,20];
x2L = [60,65,70,75,80];
y2L = [60,65,70,75,80];

%% fill Deck Function
fillDeckFcn(x1L,x2L,y1L,y2L);

function fillDeckFcn(x1List, y1List, x2List, y2List)
    for listCounter = 1:length(x1List)
        % find index of blocks that have the same type and store them into
        % a new array (may be done multiple times)
        
        % update x1 and x2 of blocks that are selected
        
        % if the desired BP location is occupied
            % call BP2Conveyor
            % update occupied flag

        % after all occupied BPs are cleared, DO
        SM_Conveyor2BP(x1List(listCounter),y1List(listCounter),x2List(listCounter),y2List(listCounter));
    end
end