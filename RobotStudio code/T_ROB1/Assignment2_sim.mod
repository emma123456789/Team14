MODULE Assignment2_sim
    
    VAR num effectorHeight:= 147;
    VAR robtarget testTarget := [[230, -100, 147],[0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
   
    VAR num jog_inc:=30;
    VAR num jog_inc_deg:= 5;
    VAR speeddata jog_speed:=v100;
    VAR speeddata pose_speed:= v100;
    VAR num errorNo :=0;
    PERS string current_state;
   
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC Main()
        
        MoveToCalibPos;
        !SingArea \Wrist;
        WHILE errorNo = 0 DO
            JogX(50);
            WaitTime 1;
        ENDWHILE
        
        WaitTime 2;
        MoveTarget testTarget;
        WaitTime 2;
        
        OrientTool 0, 0, 90;
        WaitTime 2;
        WaitTime 4;
        
        
        
        !only use this if the position can deviate to avoid singularities
        
        
        !absolute position
        confj  \On;
        
        VelSet 70, 800;
        
        
        
        
        IF current_state = "xPlus" THEN
            JogX(jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "yPlus" THEN
            JogY(jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "zPlus" THEN
            JogZ(jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "xMinus" THEN
            JogX(-jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "yMinus" THEN
            JogY(-jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "zMinus" THEN
            JogZ(-jog_inc);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "jog1" THEN
            Jog1(jog_inc_deg);
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "conOn" THEN
            conRunOn;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "conOff" THEN
            conRunOff;
            current_state := "None";
            WaitTime 2;
        !ELSEIF current_state = "conEnabled" THEN
            !conDirHome;
            !current_state := "None";
            !WaitTime 2;
        !ELSEIF current_state = "conDisabled" THEN
            !conDirRob;
            !current_state := "None";
            !WaitTime 2;
        ELSEIF current_state = "conReverseOn" THEN
            conDirHome;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "conReverseOff" THEN
            conDirRob;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "vacSolOn" THEN
            vacSolOn;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "vacSolOff" THEN
            vacSolOff;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "vacPumpOn" THEN
            vacPwrOn;
            current_state := "None";
            WaitTime 2;
        ELSEIF current_state = "vacPumpOff" THEN
            vacPwrOff;
            current_state := "None";
            WaitTime 2;
        !ELSEIF current_state = "moveToPose" THEN
            !moveToPose(thetas_new);
            !WaitTime 2;
        ELSEIF current_state = "unknown" THEN
            TPWrite "Unknown command";
            WaitTime 2;
        !ELSE 
            !TPWrite "Illegal input";
            !WaitTime 2;
        ENDIF
        
        !JogY(jog_inc);
        !WaitTime 2;
        !JogY(jog_inc);
        !WaitTime 2;
        !JogY(jog_inc);
        !JogZ(jog_inc);
        !WaitTime 2;
        !JogZ(jog_inc);
        !WaitTime 2;
        !Jog1(-jog_inc_deg);
        !Jog1(-jog_inc_deg);
        !Jog1(-jog_inc_deg);
        !Jog1(+jog_inc_deg);
        
    ENDPROC
    
    PROC JogX(num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val;
        !get current pos
        pos_current:=CRobT();
        
        !calculate new pos
        pos_new:=pos_current;
        pos_new.trans.x:=pos_current.trans.x+jog_inc;
        jog_target:=CalcJointT(pos_new,tSCup,\ErrorNumber:=err_val);
        IF err_val>0 OR err_val >0THEN
            !send message to matlab
            errorNo:=1;
            WaitTime 1;
            RETURN;
        ELSE
            SingArea \Wrist;
            !move to calculated pos
            MoveL pos_new,jog_speed,z10,tSCup;
            SingArea \Off;
            
            MoveL pos_new,jog_speed,z10,tSCup;
        ENDIF
    ENDPROC   
    
    PROC JogY(num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val;
        !get current pos
        pos_current:=CRobT();
        !calculate new pos
        pos_new:=pos_current;
        pos_new.trans.y:=pos_current.trans.y+jog_inc;
        !check if reachable
        jog_target:=CalcJointT(pos_new,tSCup,\ErrorNumber:=err_val);
        IF err_val=1135 OR err_val=1074 OR err_val = ERR_ROBLIMIT THEN
            !send message to matlab
            WaitTime 1;
            RETURN;
        ELSE
            SingArea \Wrist;
            !move to calculated pos
            MoveL pos_new,jog_speed,z10,tSCup;
            SingArea \Off;
        ENDIF
    ENDPROC   
    
    PROC JogZ(num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val;
        !get current pos
        pos_current:=CRobT();
        
        !calculate new pos
        pos_new:=pos_current;
        pos_new.trans.z:=pos_current.trans.z+jog_inc;
        
        jog_target:=CalcJointT(pos_new,tSCup,\ErrorNumber:=err_val);
        IF err_val=1135 OR err_val=1074 OR err_val = ERR_ROBLIMIT THEN
            !send message to matlab
            WaitTime 1;
        ELSE
            SingArea \Wrist;
            !move to calculated pos
            MoveL pos_new,jog_speed,z10,tSCup;
            SingArea \Off;
        ENDIF
    ENDPROC   
    
    !Jog Joint 1
    PROC Jog1(num jog_inc_deg)
        VAR jointtarget thetas_current;
        VAR jointtarget thetas_new;
        VAR robtarget pos_new;
        VAR errnum err_val;
        
        !get current
        thetas_current:=CJointT();
        thetas_new:=thetas_current;
        !increment new
        thetas_new.robax.rax_1:=thetas_new.robax.rax_1+jog_inc_deg;
    
        pos_new:=CalcRobT(thetas_new,tSCup);
        thetas_current:=CalcJointT(pos_new,tSCup,\ErrorNumber:=err_val);
        IF err_val=1135 OR err_val=1074 OR err_val = ERR_ROBLIMIT THEN
            !send message to matlab, out of range
            RETURN;
        ELSE
            MoveAbsJ thetas_new,jog_speed,fine,tSCup;
            !send mesage to matlab
        ENDIF
    ENDPROC
    
    
     PROC MoveToPose(robjoint thetas_new)
        VAR jointtarget thetas_new_formatted;
        thetas_new_formatted:= [thetas_new, [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];!the formatted joint angles for moving the robot   
        MoveAbsJ thetas_new_formatted, jog_speed, fine, tSCup;
    ENDPROC
    
    !reposition the orientation of the end effector 
    PROC OrientTool(num roll,num pitch, num yaw)
        VAR robtarget pos_current;
        
        
        pos_current:=CRobT();
        pos_current.rot :=OrientZYX(roll, pitch, yaw);
        MoveTarget pos_current;
        
        !OrientZYX
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
    
    PROC vacPwrOff()
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
    
    
    
    PROC target()
        VAR robtarget pos_current;
        VAR num pos_array{7};
        VAR string pos_string:="";
        pos_current:=CRobT(\Tool:=tsCup);
        
        pos_array{1}:=pos_current.trans.x;
        pos_array{2}:=pos_current.trans.y;
        pos_array{3}:=pos_current.trans.z;
        pos_array{4}:=pos_current.rot.q1;
        pos_array{5}:=pos_current.rot.q2;
        pos_array{6}:=pos_current.rot.q3;
        pos_array{7}:=pos_current.rot.q4;
        FOR index FROM 1 TO 7 DO
            pos_string:=pos_string+" "+ ValtoStr(pos_array{index});
        ENDFOR
        !send message
    ENDPROC
    
    ! 
    PROC angles()
        VAR jointtarget thetas_current;
        VAR num thetas_array{6};
        VAR string thetas_string;
        thetas_current:=CJointT();
        thetas_array{1}:=thetas_current.robax.rax_1;
        thetas_array{2}:=thetas_current.robax.rax_2;
        thetas_array{3}:=thetas_current.robax.rax_3;
        thetas_array{4}:=thetas_current.robax.rax_4;
        thetas_array{5}:=thetas_current.robax.rax_5;
        thetas_array{6}:=thetas_current.robax.rax_6;
        FOR index FROM 1 TO 6 DO
            thetas_string:=thetas_string+ " " + ValtoStr(thetas_array{index});
        ENDFOR
        !send message
    ENDPROC
    
    
    PROC GetIO()
        VAR num io_array{5};
        VAR string io_string;
        io_array{1}:=DOutput(DO10_1); !Vac Power Status
        io_array{2}:=DOutput(DO10_2); !Vac Solenoid Status
        io_array{3}:=DOutput(DO10_3); !ConvPower Status
        io_array{4}:=DOutput(DO10_4); !Conv Direcion Status
        io_array{5}:=DInput(DI10_1);  !Conv Status Value
        FOR index FROM 1 TO 5 DO
            io_string:=io_string+" "+ ValtoStr(io_array{index});
        ENDFOR
        
    ENDPROC
    
    
        
    
    
      
    
ENDMODULE