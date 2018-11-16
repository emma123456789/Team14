% This function calls the simple move functions and move player 1's 
% deck onto the conveyor.
% Requirements: Discard one player's deck onto the conveyor.

function CM_clearDeck1()

    global BoxX;
    global BoxY;
    global BP2Conveyor_index;
    BP2Conveyor_index = 1;

    blockMatrixX1 = [];
    blockMatrixY1 = [];
    
    for blockCounter1 = 1:6 %first 6 blocks
        [blockMatrixX1(blockCounter1),blockMatrixY1(blockCounter1)] = gameboardConversion(blockCounter1,'P');
        SM_BP2ConveyorModified(blockMatrixX1(blockCounter1), blockMatrixY1(blockCounter1), BoxX, BoxY);
        BP2Conveyor_updateBlocklist(BoxX,BoxY);
     end

end