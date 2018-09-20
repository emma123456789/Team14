MODULE Assignment2
    
    VAR socketdev client_socket;
    ! The host and port that we will be listening for a connection on.
    !PERS string host := "127.0.0.1";
    
    VAR num effectorHeight:= 147;
    PERS robtarget testTarget := [[175, -100, 147],[0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
   
    VAR num jog_inc:=30;
    VAR num jog_inc_deg:= 5;
    VAR speeddata jog_speed:=v100;
    VAR speeddata pose_speed:= v100;
    PERS string current_state := "None";
    PERS bool quit := FALSE;
    PERS bool done := FALSE;
    PERS bool checkCom := FALSE;
    PERS bool errorHandling := FALSE;
    PERS num errorNumber;
    VAR intnum pauseTrigger;
    VAR intnum cancelTrigger;
    PERS bool paused:=FALSE;
    PERS bool cancelled := TRUE;
    PERS string numTotal{7};
    PERS string modeSpeed;
    

    
   
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC Main()
                
        ! Program Starts
        MoveToCalibPos;
        current_state:="";
        
    CONNECT pauseTrigger WITH pauseRoutine;
    IPers paused, pauseTrigger;
    CONNECT cancelTrigger WITH cancelRoutine;
    IPers cancelled, cancelTrigger;
    WHILE quit = FALSE DO
        
        WaitUntil checkCom = TRUE;

        !obtain current status
        
        !only use this if the position can deviate to avoid singularities
        SingArea \Wrist;
        
        !absolute position
        confj  \On;
        
        VelSet 70, 800;
        
        !IF current_state <> "cancel" THEN
            IF current_state = "moveerc" THEN
                MoveTargetConveyer numTotal;
                done:= TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "movejas"THEN
                MoveToPose;
                WaitTime 2;
            ENDIF
            IF current_state = "xPlus" THEN
                JogX(jog_inc);
                done:= TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "yPlus" THEN
                JogY(jog_inc);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "zPlus" THEN
                JogZ(jog_inc);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "xMinus" THEN
                JogX(-jog_inc);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "yMinus" THEN
                JogY(-jog_inc);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "zMinus" THEN
                JogZ(-jog_inc);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "jog1" THEN
                Jog1(jog_inc_deg);
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "conOn" THEN
                conRunOn;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "conOff" THEN
                conRunOff;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "conReverseOn" THEN
                conDirHome;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF 
            IF current_state = "conReverseOff" THEN
                conDirRob;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF 
            IF current_state = "vacSolOn" THEN
                vacSolOn;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "vacSolOff" THEN
                vacSolOff;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF 
            IF current_state = "vacPumpOn" THEN
                vacPwrOn;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF 
            IF current_state = "vacPumpOff" THEN
                vacPwrOff;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "paused" THEN
                paused:=TRUE;
                !StopMove;
                !StorePath;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "resume" THEN
                paused:=FALSE;
                !RestoPath;
                !StartMove;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "cancel" THEN
                cancelled:=TRUE;
                !RestoPath;
                !StartMove;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            IF current_state = "quit" THEN
                quit:=TRUE;
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            ENDIF
            !ELSEIF current_state = "moveToPose" THEN
                !moveToPose(thetas_new);
                !WaitTime 2;
            !ELSEIF current_state = "moveAngle" THEN
                !moveAngle(robot_ang,robot_speed);
                !WaitTIme 2;
            IF current_state = "unknown" THEN
                TPWrite "Unknown command";
                done:=TRUE;
                current_state := "None";
                WaitTime 2;
            !ENDIF
        ELSE
        done:= TRUE;
        current_state := "None";
        WaitTime 2;
        ENDIF

        checkCom := FALSE;
    ENDWHILE 
        
    ENDPROC
    
    !WHILE quit = FALSE DO
    
    !ENDWHILE
    
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
        IF err_val<>0THEN
            errorNumber := err_val;
            errorHandling := TRUE;
            WaitTime 1;
        ELSE
            !move to calculated pos
            MoveL pos_new,jog_speed,fine,tSCup;
        ENDIF
        ERROR
            done:=TRUE;
            current_state:="None";
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
        IF err_val <> 0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
            WaitTime 1;
        ELSE
            !move to calculated pos
            MoveL pos_new,jog_speed,fine,tSCup;
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
        IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
            WaitTime 1;
        ELSE
            !move to calculated pos
            MoveL pos_new,jog_speed,fine,tSCup;
        ENDIF
        ERROR
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
        IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveAbsJ thetas_new,jog_speed,fine,tSCup;
        ENDIF
        ERROR
    ENDPROC
    
     PROC MoveToPose()
        VAR robjoint pose;
        VAR jointtarget thetas_new_formatted;
        pose:=getPose(numTotal);
        thetas_new_formatted:= [pose, [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];!the formatted joint angles for moving the robot
        MoveAbsJ thetas_new_formatted, jog_speed, fine, tSCup;
        ERROR
    ENDPROC
    
    
    PROC MoveAngle(robjoint robot_ang,speeddata robot_speed)
        VAR jointtarget lin_joint;
        VAR jointtarget jointpos;
        VAR robtarget ang_rob;
        VAR errnum myerrnum;
        jointpos:=[robot_ang,[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        ang_rob:=CalcRobT(jointpos,tSCup);
        lin_joint:=CalcJointT(ang_rob,tSCup\ErrorNumber:=myerrnum);
    ERROR
    ENDPROC
   

    PROC MoveTargetGlobal(robtarget target)
        
           MoveJ target, v100, fine, tSCup;
    ENDPROC
    
    PROC MoveTargetTable(robtarget target)            
           MoveJ target, v100, fine, tSCup, \WObj:=wTable;           
    ENDPROC
    
    PROC MoveTargetConveyer(string numTotal{*})
        VAR robtarget target;
        VAR speeddata move_speed;
        move_speed:=getSpeed(modeSpeed);
        target:= getTarget(numTotal);
        MoveJ target, move_speed, fine, tSCup, \WObj:=wConv;
    ENDPROC
    
    PROC MoveTargetOffset(robtarget target, num x, num y, num z)
        
              MoveL Offs(target, x, y, z), v100, fine, tSCup;
    ENDPROC
    
    !converts the string fragments from the comms server to a robtarget
    FUNC robtarget getTarget(string numTotal{*})
        VAR robtarget newTarget;
        VAR bool conversion_outcome;
        VAR num converted_num;
        
        conversion_outcome := StrtoVal(numTotal{1}, newTarget.trans.x);
        conversion_outcome := StrtoVal(numTotal{2}, newTarget.trans.y);
        conversion_outcome := StrtoVal(numTotal{3}, newTarget.trans.z);
        conversion_outcome := StrtoVal(numTotal{4}, newTarget.rot.q1);
        conversion_outcome := StrtoVal(numTotal{5}, newTarget.rot.q2);
        conversion_outcome := StrtoVal(numTotal{6}, newTarget.rot.q3);
        conversion_outcome := StrtoVal(numTotal{7}, newTarget.rot.q4);
        
        RETURN newTarget;
    ENDFUNC
    
    !converts the string fragments from the comms server to a robtarget
    FUNC robjoint getPose(string numTotal{*})
        VAR robjoint pose;
        VAR bool conversion_outcome;
        VAR num converted_num;
        
        conversion_outcome := StrtoVal(numTotal{1}, pose.rax_1);
        conversion_outcome := StrtoVal(numTotal{2}, pose.rax_2);
        conversion_outcome := StrtoVal(numTotal{3}, pose.rax_3);
        conversion_outcome := StrtoVal(numTotal{4}, pose.rax_4);
        conversion_outcome := StrtoVal(numTotal{5}, pose.rax_5);
        conversion_outcome := StrtoVal(numTotal{6}, pose.rax_6);
        RETURN pose;
    ENDFUNC
    
    !switch statement for the speed string from matlab
    FUNC speeddata getSpeed(string modeSpeed)
      VAR speeddata move_speed;
      IF modeSpeed = "v50" THEN
          move_speed := v50;
      ELSEIF modeSpeed = "v100" THEN
          move_speed := v100;
      ELSEIF modeSpeed = "v500" THEN
          move_speed := v500;
      ENDIF
    ENDFUNC
    
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
    

    TRAP pauseRoutine
        IF paused =TRUE THEN
            StopMove;
            StorePath;
        ELSE
            RestoPath;
            StartMove;
        ENDIF
    ENDTRAP
    
    TRAP cancelRoutine
        IF cancelled =TRUE THEN
            StopMove;
            ClearPath;
        ENDIF
    ENDTRAP

ENDMODULE