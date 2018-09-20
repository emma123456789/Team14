
    MODULE Assignment2
    
    !PERS socketdev client_socket;
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
    PERS bool paused:=TRUE;
    PERS bool cancelled := TRUE;
    PERS string numTotal{7};
    PERS string modeSpeed;
    PERS wobjdata wobjCurrent;

    
   
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC Main()
                
        ! Program Starts
        MoveToCalibPos;
        current_state:="";
        wobjCurrent:=wTable;
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
        
        !VelSet 70, 800;
        
        !IF current_state <> "cancel" THEN
            IF current_state = "moveerc" THEN
                wobjCurrent := wConveyer;
                MoveTargetConveyer numTotal;
                done:= TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "moveert"THEN
                wobjCurrent:=wTable;
                MoveTargetTable numTotal;
                done:=TRUE;
                current_state:="None";
            ENDIF
            IF current_state = "movejas"THEN
                MoveToPose;
                done:=TRUE;
                current_state:="None";
            ENDIF
            IF current_state = "bxPlus" THEN
                wobjCurrent := wBase;
                JogX(jog_inc);
                done:= TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "exPlus" THEN
                wobjCurrent := wEffector;
                JogX(jog_inc);
                done:= TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "byPlus" THEN
                wobjCurrent := wBase;
                JogY(jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "eyPlus" THEN
                wobjCurrent := wEffector;
                JogY(jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "bzPlus" THEN
                wobjCurrent := wBase;
                JogZ(jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "ezPlus" THEN
                wobjCurrent := wEffector;
                JogZ(jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "bxMinus" THEN
                wobjCurrent := wBase;
                JogX(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "exMinus" THEN
                wobjCurrent := wEffector;
                JogX(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "byMinus" THEN
                wobjCurrent := wBase;
                JogY(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "eyMinus" THEN
                wobjCurrent := wEffector;
                JogY(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "bzMinus" THEN
                wobjCurrent := wBase;
                JogZ(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "ezMinus" THEN
                wobjCurrent := wEffector;
                JogZ(-jog_inc);
                done:=TRUE;
                current_state := "None";
            ENDIF
            
            IF current_state = "jog1" THEN
                JogJoint 1, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog1" THEN
                JogJoint 1, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "jog2" THEN
                JogJoint 2, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog2" THEN
                JogJoint 2, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "jog3" THEN
                JogJoint 3, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog3" THEN
                JogJoint 3, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "jog4" THEN
                JogJoint 4, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog4" THEN
                JogJoint 4, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "jog5" THEN
                JogJoint 5, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog5" THEN
                JogJoint 5, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "jog6" THEN
                JogJoint 6, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "-jog6" THEN
                JogJoint 6, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "conOn" THEN
                conRunOn;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "conOff" THEN
                conRunOff;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "conReverseOn" THEN
                conDirHome;
                done:=TRUE;
                current_state := "None";
            ENDIF 
            IF current_state = "conReverseOff" THEN
                conDirRob;
                done:=TRUE;
                current_state := "None";
            ENDIF 
            IF current_state = "vacSolOn" THEN
                vacSolOn;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "vacSolOff" THEN
                vacSolOff;
                done:=TRUE;
                current_state := "None";
            ENDIF 
            IF current_state = "vacPumpOn" THEN
                vacPwrOn;
                done:=TRUE;
                current_state := "None";
            ENDIF 
            IF current_state = "vacPumpOff" THEN
                vacPwrOff;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "paused" THEN
                paused:=TRUE;
                StopMove;
                StorePath;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "resume" THEN
                paused:=FALSE;
                RestoPath;
                StartMove;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "cancel" THEN
                cancelled:=TRUE;
                !RestoPath;
                !StartMove;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "shutdown" THEN
                MoveToCalibPos;
                vacPwrOff;
                vacSolOff;
                conRunOff;
                quit:=TRUE;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "unknown" THEN
                TPWrite "Unknown command";
                done:=TRUE;
                current_state := "None";
            !ENDIF
        ELSE
        !done:= TRUE;
        !current_state := "None";
        ENDIF

        checkCom := FALSE;
    ENDWHILE 
        
    ENDPROC
    
    !WHILE quit = FALSE DO
    
    !ENDWHILE
    
     PROC JogX( num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val:=0;
        VAR speeddata move_speed;
        VAR pos jog:= [0,0,0];
        VAR pose workObjectRot := [[0,0,0], [0,0,0,0]];
        !get current pos
        pos_current:=CRobT(\WObj:=wBase);
        pos_new:=pos_current;
        !invert rotation
        IF wobjCurrent = wEffector THEN
            workObjectRot.rot := pos_current.rot;
            !workObjectRot:=PoseInv(workObjectRot);
        ELSE
            workObjectRot := PoseInv(wobjCurrent.uframe);
            workObjectRot.trans := [0,0,0];
        ENDIF
        jog.x := jog_inc;
        jog := PoseVect(workObjectRot, jog);
        !recalculate new pose untill out of limits
        WHILE err_val = 0 DO
            pos_new.trans:=pos_new.trans + jog;
            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wBase\ErrorNumber:=err_val);
        ENDWHILE
       !move to calculated pos
        move_speed:= getSpeed(modeSpeed);
        pos_new.trans:=pos_new.trans-jog;
        MoveL pos_new,move_speed,fine,tSCup\WObj:=wBase;
        ERROR
    ENDPROC   

      PROC JogY( num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val:=0;
        VAR speeddata move_speed;
        VAR pos jog:= [0,0,0];
        VAR pose workObjectRot := [[0,0,0], [0,0,0,0]];
        !get current pos
        pos_current:=CRobT(\WObj:=wBase);
        pos_new:=pos_current;
        !invert rotation
        IF wobjCurrent = wEffector THEN
            workObjectRot.rot := pos_current.rot;
            !workObjectRot:=PoseInv(workObjectRot);
        ELSE
            workObjectRot := PoseInv(wobjCurrent.uframe);
            workObjectRot.trans := [0,0,0];
        ENDIF
        jog.y := jog_inc;
        jog := PoseVect(workObjectRot, jog);
        !recalculate new pose untill out of limits
        WHILE err_val = 0 DO
            pos_new.trans:=pos_new.trans + jog;
            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wBase\ErrorNumber:=err_val);
        ENDWHILE
       !move to calculated pos
        move_speed:= getSpeed(modeSpeed);
        pos_new.trans:=pos_new.trans-jog;
        MoveL pos_new,move_speed,fine,tSCup\WObj:=wBase;
        ERROR
    ENDPROC   
    
     PROC JogZ( num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val:=0;
        VAR speeddata move_speed;
        VAR pos jog:= [0,0,0];
        VAR pose workObjectRot := [[0,0,0], [0,0,0,0]];
        !get current pos
        pos_current:=CRobT(\WObj:=wBase);
        pos_new:=pos_current;
        !invert rotation
        IF wobjCurrent = wEffector THEN
            workObjectRot.rot := pos_current.rot;
            !workObjectRot:=PoseInv(workObjectRot);
        ELSE
            workObjectRot := PoseInv(wobjCurrent.uframe);
            workObjectRot.trans := [0,0,0];
        ENDIF
        jog.z := jog_inc;
        jog := PoseVect(workObjectRot, jog);
        !recalculate new pose untill out of limits
        WHILE err_val = 0 DO
            pos_new.trans:=pos_new.trans + jog;
            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wBase\ErrorNumber:=err_val);
        ENDWHILE
       !move to calculated pos
        move_speed:= getSpeed(modeSpeed);
        pos_new.trans:=pos_new.trans-jog;
        MoveL pos_new,move_speed,fine,tSCup\WObj:=wBase;
        ERROR
    ENDPROC   
    
!    PROC JogY(num jog_inc)
!        VAR robtarget pos_current;
!        VAR robtarget pos_new;
!        VAR jointtarget jog_target;
!        VAR errnum err_val:=0;
!         VAR speeddata move_speed;
!         move_speed:= getSpeed(modeSpeed);
!        !get current pos
!        pos_current:=CRobT(\WObj:=wobjCurrent);
!        pos_new:=pos_current;
!        !recalculate new pose untill out of limits
!        WHILE err_val = 0 DO
!            pos_new.trans.y:=pos_new.trans.y+jog_inc;
!            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wobjCurrent\ErrorNumber:=err_val);
!        ENDWHILE
!       !move to calculated pos
       
!        pos_new.trans.y:=pos_new.trans.y-jog_inc;
!        MoveL pos_new,move_speed,fine,tSCup\WObj:=wobjCurrent;
!        ERROR
!    ENDPROC   
    
!    PROC JogZ(num jog_inc)
!        VAR robtarget pos_current;
!        VAR robtarget pos_new;
!        VAR jointtarget jog_target;
!        VAR errnum err_val;
!        VAR speeddata move_speed;
!        move_speed:= getSpeed(modeSpeed);
!        !get current pos
!        pos_current:=CRobT(\WObj:=wobjCurrent);
!        pos_new:=pos_current;
!        !recalculate new pose untill out of limits
!        WHILE err_val = 0 DO
!            pos_new.trans.z:=pos_new.trans.z+jog_inc;
!            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wobjCurrent\ErrorNumber:=err_val);
!        ENDWHILE
!       !move to calculated pos
!        pos_new.trans.z:=pos_new.trans.z-jog_inc;
!        MoveL pos_new,move_speed,fine,tSCup\WObj:=wobjCurrent;
!        ERROR
!    ENDPROC   
    
    PROC JogYaw (num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val;
        VAR num roll;
        !get current pos
        pos_current:=CRobT(\WObj:=wobjCurrent);
        pos_new:=pos_current;
        !recalculate new pose untill out of limits
        WHILE err_val = 0 DO
            roll := EulerZYX(\X, pos_current.rot);
            roll:= roll + jog_inc;
            pos_new.trans.z:=pos_new.trans.z+jog_inc;
            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wobjCurrent\ErrorNumber:=err_val);
        ENDWHILE
       !move to calculated pos
        pos_new.trans.x:=pos_new.trans.z-jog_inc;
        MoveL pos_new,jog_speed,fine,tSCup\WObj:=wobjCurrent;
        ERROR
    ENDPROC
    !Jog Joint 
    PROC JogJoint(num jointNumber, num jog_inc_deg)
        VAR jointtarget thetas_current;
        VAR jointtarget thetas_new;
        VAR robtarget pos_new;
        VAR robtarget check_target;
        VAR jointtarget check_joints;
        VAR errnum err_val;
        VAR speeddata move_speed;
        
        move_speed := getSpeed(modeSpeed);
        thetas_current:=CJointT();
        thetas_new:=thetas_current;
        !increment new
        IF jointNumber = 1 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_1:=-165;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_1:=165;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ELSEIF jointNumber = 2 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_2:=-110;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_2:=110;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ELSEIF jointNumber = 3 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_3:=-110;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_3:=70;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ELSEIF jointNumber = 4 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_4:=-160;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_4:=160;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ELSEIF jointNumber = 5 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_5:=-110;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_5:=110;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ELSEIF jointNumber = 6 THEN
            IF jog_inc_deg < 0  THEN
                thetas_new.robax.rax_6:=-160;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ELSEIF jog_inc_deg > 0 THEN
                thetas_new.robax.rax_6:=160;
                MoveAbsJ thetas_new,move_speed,fine,tSCup;
            ENDIF
        ENDIF
!        pos_new:=CalcRobT(thetas_new,tSCup);
!        thetas_current:=CalcJointT(pos_new,tSCup,\ErrorNumber:=err_val);
!        IF err_val<>0 THEN
!            errorNumber := err_val;
!            errorHandling := TRUE;
!        ELSE
!            MoveAbsJ thetas_new,jog_speed,fine,tSCup;
!        ENDIF
        ERROR
    ENDPROC
    
     PROC MoveToPose()
        VAR robjoint pose;!
        VAR speeddata move_speed;
        VAR jointtarget thetas_new_formatted;
        !errror checking
        VAR robtarget check_target;
        VAR jointtarget check_joints;
        VAR errnum err_val;
        pose:=getPose(numTotal);
        move_speed := getSpeed(modeSpeed);
        thetas_new_formatted:= [pose, [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];!the formatted joint angles for moving the robot
        !check if in range
        check_target:=CalcRobT(thetas_new_formatted,tSCup);
        check_joints:=CalcJointT(check_target,tSCup\ErrorNumber:=err_val);
         IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveAbsJ thetas_new_formatted, move_speed, fine, tSCup;
         ENDIF
        ERROR
    ENDPROC


    PROC MoveTargetGlobal(string numTotal{*})
        VAR robtarget target;
        VAR speeddata move_speed;
        VAR jointtarget check_joints;
        VAR errnum err_val;
        
        !get data from strings
        move_speed:=getSpeed(modeSpeed);
        target:= getTarget(numTotal);
        
        !error checking before move
        check_joints:=CalcJointT(target,tSCup \WObj:=wobjCurrent\ErrorNumber:=err_val);
         IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveJ target, move_speed, fine, tSCup\WObj:=wobjCurrent;
         ENDIF
         ERROR
    ENDPROC
    
    PROC MoveTargetTable(string numTotal{*})
        VAR robtarget target;
        VAR speeddata move_speed;
        VAR jointtarget check_joints;
        VAR errnum err_val;
        
        !get data from strings
        move_speed:=getSpeed(modeSpeed);
        target:= getTarget(numTotal);
        
        !error checking before move
        check_joints:=CalcJointT(target,tSCup\WObj:=wobjCurrent \ErrorNumber:=err_val);
        IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveJ target, move_speed, fine, tSCup, \WObj:=wobjCurrent;
        ENDIF
        ERROR
    ENDPROC
    
    PROC MoveTargetConveyer(string numTotal{*})
        VAR robtarget target;
        VAR speeddata move_speed;
        
        VAR jointtarget check_joints;
        VAR errnum err_val;
        
        !get data from strings
        move_speed:=getSpeed(modeSpeed);
        target:= getTarget(numTotal);
        
        !error checking before move
        check_joints:=CalcJointT(target,tSCup\WObj:=wobjCurrent\ErrorNumber:=err_val);
         IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveJ target, move_speed, fine, tSCup, \WObj:=wobjCurrent;
         ENDIF
         ERROR
    ENDPROC
    
    PROC MoveTargetOffset(robtarget target, num x, num y, num z)
        
              MoveL Offs(target, x, y, z), v100, fine, tSCup;
    ENDPROC
    
    !converts the string fragments from the comms server to a robtarget
    FUNC robtarget getTarget(string numTotal{*})
        VAR robtarget newTarget;
        VAR bool conversion_outcome;
        VAR num converted_num;
        VAR num roll;
        VAR num pitch;
        VAR num yaw;
        
        conversion_outcome := StrtoVal(numTotal{1}, newTarget.trans.x);
        conversion_outcome := StrtoVal(numTotal{2}, newTarget.trans.y);
        conversion_outcome := StrtoVal(numTotal{3}, newTarget.trans.z);
!        conversion_outcome := StrtoVal(numTotal{4}, newTarget.rot.q1);
!        conversion_outcome := StrtoVal(numTotal{5}, newTarget.rot.q2);
!        conversion_outcome := StrtoVal(numTotal{6}, newTarget.rot.q3);
!        conversion_outcome := StrtoVal(numTotal{7}, newTarget.rot.q4);
        conversion_outcome := StrtoVal(numTotal{4}, roll);
        conversion_outcome := StrtoVal(numTotal{5}, pitch);
        conversion_outcome := StrtoVal(numTotal{6}, yaw);
        newTarget.rot := OrientZYX(roll, pitch, yaw); 
        
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
      RETURN move_speed;
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