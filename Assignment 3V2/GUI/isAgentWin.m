function [ gameState ] = isAgentWin( board, row, col, agentTurn )
    win = isWin(board, row, col , agentTurn);
    if win == true
        gameState = 10;
        return;
    end
    if agentTurn == 1
        win = isWin(board, row, col , 2);
    else
        win = isWin(board, row, col , 1);
    end
    
    if win == true
        gameState = -10;
        return;
    end
    draw = isDraw(board, row, col);
    if draw == true
        gameState = 0;
        return;
    end
   gameState = 5;
end

