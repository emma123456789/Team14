% This function will find the optimal place the AI should be placed through
% looking at the next gamestates and seeing which place will return the
% highest value
function [nextBoard, value] = searchTreeTemp(board, turn, agentTurn)
    
    [ gameState ] = isAgentWin(board, 3, 3, agentTurn);
    if ( gameState == 10 || gameState == 0 || gameState == -10 )
        nextBoard = board;
        value = gameState;
        return;
    end
    
    children = generateChildren(board, turn);
    [ r c l ] = size(children);
    valuesList = zeros(1, l);
    for i=1:l
        if turn == 2
            nextTurn = 1;
        else
            nextTurn = 2;
        end
        
        [ bestBoard, resultValue ] = searchTreeTemp( children(:, :, i), nextTurn, agentTurn );
        %bestBoard = children(:, :, i);
        valuesList(1, i) = resultValue;
    end

    if( turn == agentTurn )
        [ min_max index ] = max(valuesList);
    else
        [ min_max index ] = min(valuesList);
    end
    nextBoard = children(:, :, index);
    value = min_max;  
end