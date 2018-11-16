% This function calls the simple move functions and move the block from 
% both decks to a list of locations as specified in a 9x9 matrix.
% Requirements: Deploy a set of blocks to the boards as specified in a 
% 9x9 matrix, use blocks stored in both player's decks. The type of
% block doesn't matter. There may be blocks already placed neatly on 
% BPs.

function CM_fillTable()
    global fTableBlockData;
    global tableBlockData;
%     global BP2BP_index;
    global fillTableX;
    global fillTableY;
    global gameboardX;
    global gameboardY;
    global deckNum;
    global gbNum;
    global gameboardLetter;
    global gameboardNumber;
    global BP2BP_indexList;
    fillTableX = [];
    fillTableY = [];
    BP2BP_indexList = [];
    gameboardLetter = strings;
    gameboardNumber = [];
    gameboardX = [];
    gameboardY = [];
    
    len = length(tableBlockData);
    
    for i5 = 1:len
        stringSplit = strsplit(tableBlockData(i5));
		BP = char(stringSplit(5));
		% If the block is on player 1's deck
		if (strcmp(BP,'P1')||strcmp(BP,'P2')||strcmp(BP,'P3')||strcmp(BP,'P4')||strcmp(BP,'P5')||strcmp(BP,'P6')||...
            strcmp(BP,'Q1')||strcmp(BP,'Q2')||strcmp(BP,'Q3')||strcmp(BP,'Q4')||strcmp(BP,'Q5')||strcmp(BP,'Q6'))
%             fillTableIndex(end+1) = i5;
            BP2BP_indexList(end+1) = i5;
            fillTableX(end+1) = str2double(stringSplit(1));
            fillTableY(end+1) = str2double(stringSplit(2));
        end
    end
    deckNum = length(fillTableX);
    gbNum = length(fTableBlockData);
    for i6 = 1:gbNum
        fString = string(fTableBlockData(i6));
        gameboardLetter(i6) = fString{1}(1);
        gameboardNumber(i6) = str2double(fString{1}(2));
        [gameboardX(i6),gameboardY(i6)] = gameboardConversion(gameboardNumber(i6),gameboardLetter(i6));
    end

    
end