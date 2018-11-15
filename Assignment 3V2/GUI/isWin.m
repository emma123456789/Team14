% This function returns win: true or false
% Determines if the player of input turn has won or not in tic tac toe
function [ win ] = isWin( board, row, col, turn )
    sequence = 0;
    for i=1:row
        for j=1:col
            if board(i, j) == turn
                sequence = sequence + 1;
            end
        end
        
        if(sequence == row)
            win = true;
            return;
        else
            sequence = 0;
        end
    end
    
    sequence = 0;
    for i=1:col
        for j=1:row
            if board(j, i) == turn
                sequence = sequence + 1;
            end
        end
        
        if(sequence == row)
            win = true;
            return;
        else
            sequence = 0;
        end
    end
    
    sequence = 0;
    j = 1;
    for i=1:row
        if board(i, j) == turn
            sequence = sequence + 1;
        end
        j = j + 1;
    end
    
    if(sequence == row)
        win = true;
        return;
    else
        sequence = 0;
    end
    
    sequence = 0;
    j = row;
    for i=1:row
      if board(i, j) == turn
         sequence = sequence + 1;
      end
      j = j - 1;
    end
    
    if(sequence == row)
        win = true;
        return;
    else
        sequence = 0;
    end
    
    win = false;
end

