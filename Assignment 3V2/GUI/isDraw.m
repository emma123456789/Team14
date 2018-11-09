function [ draw ] = isDraw( board, row, col)
    for i = 1:row
        for j = 1:col
            if board(i, j) == 0
                draw = false;
                return;
            end
        end
    end
    
    draw = true;
end

