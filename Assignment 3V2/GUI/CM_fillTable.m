%% from both player's deck to 9*9 matrix

function CM_fillTable()
    global fTableBlockData;
    global tableBlockData;
    global BP2BP_index;
    global fillTableX;
    global fillTableY;
    global gameboardX;
    global gameboardY;
    global deckNum;
    global gbNum;
    global gameboardLetter;
    global gameboardNumber;
    fillTableX = [];
    fillTableY = [];
    len = length(tableBlockData);
    
    for i5 = 1:len
        stringSplit = strsplit(tableBlockData(i5));
		BP = char(stringSplit(5));
		% If the block is on player 1's deck
		if (strcmp(BP,'P1')||strcmp(BP,'P2')||strcmp(BP,'P3')||strcmp(BP,'P4')||strcmp(BP,'P5')||strcmp(BP,'P6')||...
            strcmp(BP,'Q1')||strcmp(BP,'Q2')||strcmp(BP,'Q3')||strcmp(BP,'Q4')||strcmp(BP,'Q5')||strcmp(BP,'Q6'))
%             fillTableIndex(end+1) = i5;
            BP2BP_index = i5;
            fillTableX(end+1) = str2double(stringSplit(1));
            fillTableY(end+1) = str2double(stringSplit(2));
        end
    end
    deckNum = length(fillTableX);
    gbNum = length(fTableBlockData);
    for i6 = 1:gbNum
        fString = string(fTableBlockData(i6));
        gameboardLetter = fString{1}(1);
        gameboardNumber = str2double(fString{1}(2));
        
%         % Check if BP is already in use
%         occupied = checkBPOccupied(gameboardLetter, gameboardNumber);
%         if (occupied == false)
            [gameboardX(i6),gameboardY(i6)] = gameboardConversion(gameboardNumber,gameboardLetter);
%         elseif (occupied == true)
%             f = msgbox('BP is occupied');
%         end
    end

    
end