MODULE Assignment2
    
    VAR num effectorHeight:= 147;
    
    VAR robtarget testTarget := [[175, -100, effectorHeight],[0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
   

   
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC MainAss2()
      
        
        MoveToCalibPos;
        vacPwrOn;
       
        add effectorHeight, abs(tileHeight);
        ! Call my func
        testTarget := [[175, 0, effectorHeight], [0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        MoveTarget(testTarget);
        vacSolOn;
        
        AccSet 50, 50;
        
        ! Call another procedure that we have defined.
       ! MoveLSample;
        
        MoveL Offs(testTarget, 0, 100, 50), v100, fine, tSCup;
        
        MoveL Offs(testTarget, 0, 100, 5), v100, fine, tSCup;
        
        vacSolOff;
        vacPwerOff;
        AccSet 100, 100;
        MoveToCalibPos;
        
        
        ! Call another procedure, but provide some input arguments.
        VariableSample pTableHome, 100, 100, 0, v100, fine;
  
    ENDPROC

    PROC MoveTarget(robtarget target)
        
            ! 'MoveJ' executes a joint motion towards a robtarget. This is used to move the robot quickly from one point to another when that 
            !   movement does not need to be in a straight line.
            ! 'pTableHome' is a robtarget defined in system module. The exact location of this on the table has been provided to you.
            ! 'v100' is a speeddata variable, and defines how fast the robot should move. The numbers is the speed in mm/sec, in this case 100mm/sec.
            ! 'fine' is a zonedata variable, and defines how close the robot should move to a point before executing its next command. 
            !   'fine' means very close, other values such as 'z10' or 'z50', will move within 10mm and 50mm respectively before executing the next command.
            ! 'tSCup' is a tooldata variable. This has been defined in a system module, and represents the tip of the suction cup, telling the robot that we
            !   want to move this point to the specified robtarget. Please be careful about what tool you use, as using the incorrect tool will result in
            !   the robot not moving where you would expect it to. Generally you should be using
            MoveJ target, v100, fine, tSCup;
            
    ENDPROC
    
    PROC MoveTargetOffset(robtarget target, num x, num y, num z)
        
              MoveL Offs(target, x, y, z), v100, fine, tSCup;
    ENDPROC
    
    PROC vacPwrOn()
        SetDO DO10_1, 1;
    ENDPROC
    
    PROC vacPwerOff()
        SetDO DO10_1, 0;
    ENDPROC
    
    PROC vacSolOn()
        SetDO DO10_2, 1;
    ENDPROC
    
    PROC vacSolOff()
        SetDO DO10_2, 0;
    ENDPROC
    
    PROC conRunOn()
        SetDO DO10_3, 1;
    ENDPROC
    
    PROC conRunOff()
        SetDO DO10_3, 0;
    ENDPROC
    
    PROC conDirRob()
        SetDO DO10_4, 1;
    ENDPROC
    
    PROC conDirHome()
        SetDO DO10_4, 0;
    ENDPROC
    
    
    
    
        
    
    
      
    
ENDMODULE