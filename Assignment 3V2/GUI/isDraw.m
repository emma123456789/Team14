% Functions checks if tic tac toe game is a draw by checking if all the
% spaces on the board is filled up.
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

