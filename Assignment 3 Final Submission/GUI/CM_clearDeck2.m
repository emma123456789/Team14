% This function calls the simple move functions and move player 2's 
% deck onto the conveyor.
% Requirements: Discard one player's deck onto the conveyor.

function CM_clearDeck2()

    global boxX;
    global boxY;
    global BP2Conveyor_index;
    BP2Conveyor_index = 1;

    blockMatrixX2 = [];
    blockMatrixY2 = [];

 
    for blockCounter2 = 1:6 %first 6 blocks
        [blockMatrixX2(blockCounter2),blockMatrixY2(blockCounter2)] = gameboardConversion(blockCounter2,'Q')
        SM_BP2ConveyorModified(blockMatrixX2(blockCounter2), blockMatrixY2(blockCounter2), boxX, boxY);
        BP2Conveyor_updateBlocklist(boxX,boxY);
    end

end