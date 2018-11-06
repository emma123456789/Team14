function CM_fillDeck()

    global boxX;
    global boxY;
    global BP2Conveyor_index;
    boxX = 0;
    boxY = 409;
    BP2Conveyor_index = 1;

    blockMatrixX1 = [];
    blockMatrixY1 = [];
    
    for blockCounter1 = 1:6 %first 6 blocks
        [blockMatrixX1(blockCounter1),blockMatrixY1(blockCounter1)] = gameboardConversion(blockCounter1,'P');
        SM_BP2ConveyorModified(blockMatrixX1(blockCounter1), blockMatrixY1(blockCounter1), boxX, boxY);
        BP2Conveyor_updateBlocklist(boxX,boxY);
     end

end