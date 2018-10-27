% Table Block Index will compare bp with table list to find index of the
% matching BP

function findTableBlockIndex(letter, number)
    global tableBlockData;
    global BP2BP_index;
    
    number = num2str(number);
    for i=1:length(tableBlockData)
        BP2BP_index = i;
        stringSplit = strsplit(tableBlockData(i));
        bp = join([letter, number], "");
        bpCompare = strcmp(stringSplit(5),bp);
        if (bpCompare == 1)
            break;
        end
    end
    
end