% Table Block Index will compare bp with table list to find index of the
% matching BP
function occupied = checkBPOccupied(letter, number)
    % global array of the table block information
    global tableBlockData;
    occupied = false;
    number = num2str(number);
    % this loops through the table block data to find the block that has
    % the same letter and number as the inputs given
    for i=1:length(tableBlockData)
        stringSplit = strsplit(tableBlockData(i));
        bp = join([letter, number], "");
        bpCompare = strcmp(stringSplit(5),bp);
        % comparing to see if the block is the same as what we are looking
        % for 
        if (bpCompare == 1)
            % if so, then break
            occupied = true;
            break;
        end
    end
    
end