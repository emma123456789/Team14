%% from both player's deck to 9*9 matrix

function CM_fillDeck1()
    global conveyorBlockData;
    global tableBlockData;
    global letterBlocks;
    global letterIndex;
    letterCounter = 0;
    letterBlocks = [];
    len = length(tableBlockData);
    
    for i = 1:len
        stringSplit = strsplit(tableBlockData(i));
        xConveyor(i) = str2double(stringSplit(1)); %x-coordinate of blocks on conveyor
        yConveyor(i) = str2double(stringSplit(2)); %y-coordinate of blocks on conveyor
        rotConveyor(i) = str2double(stringSplit(3));
    end

end