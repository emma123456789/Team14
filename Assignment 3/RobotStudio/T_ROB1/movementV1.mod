    MODULE ROB_MAIN
    
    VAR num effectorHeight:= 147;! The height of the table
    PERS robtarget target := [[200, 0, 20],[4.37114E-08,0,-1,0],[0,0,0,0],[0,0,0,0,0,0]];! test target initialised to touch the table home
    PERS robjoint joints:= [0, 0, 0, 0, 0, 0]; !test pose initialised to calib position
    PERS jointtarget joints_robot;
   
    VAR num jog_inc:=30;                    !increment for linear jogging
    VAR num jog_inc_deg:= 5;                !increment for axis jogging
    PERS string current_state := "";        !Current state for the main loop conditional statements, set in T_COM1
    PERS bool quit := TRUE;                 !quit flag
    PERS bool done := FALSE;                !command finished flag
    PERS bool checkCom; !:= FALSE;            !COM checked flag
    PERS bool errorHandling := FALSE;       !error flag
    PERS num errorNumber;                   !error number for range calculations
    VAR intnum pauseTrigger;                !trigger for pausing robot path
    VAR intnum cancelTrigger;               !trigger for cancelling robot path
    PERS bool paused:=TRUE;                 !pause flag
    PERS bool cancelled := TRUE;            !cancel flag
    PERS string numTotal{7};                !string arguments array
    PERS string modeSpeed;                  !speed data string
    PERS speeddata move_speed;              !speed data for poses
    PERS speeddata jog_speed;               !speed data for jogging
    PERS wobjdata wobjCurrent;              !current work object (can be used to calculate positions relative to different rotational frames)

    
   
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC Main()
                
        ! Program Starts
        MoveToCalibPos;                     !Start in calib position
        current_state:="";                  !initialise current state
        wobjCurrent:=wTable;                !initialise current frame to table reference
        
        SingArea \Wrist;                    !Allow wrist position to deviate to avoid singularities
        confj  \On;                         !Aim for absolute position, if not possible stop execution
        
!        CONNECT pauseTrigger WITH pauseRoutine;     !connect pause trigger with pause interrupt routine
!        IPers paused, pauseTrigger;                 !change in value of paused will activate the pause trigger
!        CONNECT cancelTrigger WITH cancelRoutine;   !connect cancel trigger with cancel interrupt routine
!        IPers cancelled, cancelTrigger;             !change in value of cancel will avtivate the cancel trigger

        WHILE quit = FALSE DO                       !robot action will run continuously when the shutdown button is not pressed
        
        WaitUntil checkCom = TRUE;              !wait until the server has received message from MATLAB
        !obtain current status
        
        
        !IF current_state <> "cancel" THEN
                                                    !if asked to move to a target relative to conveyer home
            IF current_state = "moveerc" THEN       
                wobjCurrent := wConveyer;             !set current work object to conveyer
                move_speed :=getSpeed(modeSpeed);     !convert speed argument string to speeddata
                target:=getTarget(numTotal);          !convert argument string array to target (uses wobjCurrent)
                MoveTarget target, move_speed;        !Move to target
                done:= TRUE;                          !the flag for action done is set as TRUE
                current_state := "None";              !the current state is reset after the motion is finished
            ENDIF
                                                    !if asked to move to a target relative to table home
            IF current_state = "moveert"THEN
                wobjCurrent:=wTable;                  !set current work object to table
                move_speed :=getSpeed(modeSpeed);     !convert speed argument string to usable move_speed
                target:=getTarget(numTotal);          !convert argument string array to usable target (uses wobjCurrent)
                MoveTarget target, move_speed;        !Move to target
                done:=TRUE;                           !the flag for action done is set as TRUE
                current_state:="None";                !the current state is reset after the motion is finished
            ENDIF
                                                    !if asked to set the joint angles
            IF current_state = "movejas"THEN
                joints:=getPose(numTotal);            !convert argument string array to usable pose
                move_speed := getSpeed(modeSpeed);    !convert speed argument string to move_speed
                MoveToPose joints, move_speed;        !move to the given joint angles
                done:=TRUE;                           !the flag for action done is set as TRUE
                current_state:="None";                !the current state is reset after the motion is finished
            ENDIF
                                                    !if asked to jog x in base frame
            IF current_state = "bxPlus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "x", +jog_inc, jog_speed;
                done:= TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog x in end effector frame
            IF current_state = "exPlus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "x", +jog_inc, jog_speed;
                done:= TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -x in base frame
            IF current_state = "bxMinus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "x", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -x in end effector frame
            IF current_state = "exMinus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "x", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog y in base frame
            IF current_state = "byPlus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "y", jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog y in end effector frame
            IF current_state = "eyPlus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "y", jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
            
                                                    !if asked to jog -y in base frame
            IF current_state = "byMinus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "y", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -y in end effector frame
            IF current_state = "eyMinus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "y", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog z in base frame
            IF current_state = "bzPlus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "z", jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog z in end effector frame
            IF current_state = "ezPlus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "z", jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -z in base frame
            IF current_state = "bzMinus" THEN
                wobjCurrent := wBase;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "z", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -z in end effector frame
            IF current_state = "ezMinus" THEN
                wobjCurrent := wEffector;
                jog_speed:=getSpeed(modeSpeed);
                JogLinear "z", -jog_inc, jog_speed;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint1
            IF current_state = "jog1" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 1, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint1
            IF current_state = "-jog1" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 1, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint2
            IF current_state = "jog2" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 2, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint2
            IF current_state = "-jog2" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 2, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint3
            IF current_state = "jog3" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 3, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint3
            IF current_state = "-jog3" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 3, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint4
            IF current_state = "jog4" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 4, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint4
            IF current_state = "-jog4" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 4, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint5
            IF current_state = "jog5" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 5, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint5
            IF current_state = "-jog5" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 5, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog joint6
            IF current_state = "jog6" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 6, jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to jog -joint6
            IF current_state = "-jog6" THEN
                jog_speed:=getSpeed(modeSpeed);
                JogJoint 6, -jog_inc_deg;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to turn on conveyer
            IF current_state = "conOn" THEN
                conRunOn;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to turn off conveyer
            IF current_state = "conOff" THEN
                conRunOff;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to make conveyer go to home
            IF current_state = "conReverseOn" THEN
                conDirHome;
                done:=TRUE;
                current_state := "None";
            ENDIF 
                                                    !if asked to make conveyer go to robot
            IF current_state = "conReverseOff" THEN
                conDirRob;
                done:=TRUE;
                current_state := "None";
            ENDIF 
                                                    !if asked to turn on vacuum solenoid
            IF current_state = "vacSolOn" THEN
                vacSolOn;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to turn off vacuum solenoid
            IF current_state = "vacSolOff" THEN
                vacSolOff;
                done:=TRUE;
                current_state := "None";
            ENDIF 
                                                    !if asked to turn on vacuum pump
            IF current_state = "vacPumpOn" THEN
                vacPwrOn;
                done:=TRUE;
                current_state := "None";
            ENDIF 
                                                    !if asked to turn off vacuum pump
            IF current_state = "vacPumpOff" THEN
                vacPwrOff;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to pause
            IF current_state = "paused" THEN
                paused:=TRUE;                       !the paused bool is set to TRUE to activate the paused trigger
                StopMove;                           !stopMove stops the robot's current path
                StorePath;                          !stores the robot's current path so that the robot can resume when needed
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to resume
            IF current_state = "resume" THEN
                paused:=FALSE;                      !the paused bool is set to FALSE to activate the paused trigger again
                RestoPath;                          !RestoPath restores the path saved from StorePath
                StartMove;                          !robot starts moving again in the stored path
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to cancel
            IF current_state = "cancel" THEN
                cancelled:=TRUE;                    !the cancelled bool iss et to TRUE to activate the cancel trigger
                !RestoPath;                         
                !StartMove;
                done:=TRUE;
                current_state := "None";
            ENDIF
                                                    !if asked to shutdown
            IF current_state = "shutdown" THEN
                wobjCurrent:=wWorld;
                joints_robot:=CJointT();
                MoveToPose [joints_robot.robax.rax_1, 0, 0, 0, 0, 0], v100;   !First lift to above conveyer to avoid collision with table
                MoveToCalibPos;                         !Move to calib
                vacPwrOff;                              !reset DIOs
                vacSolOff;                          
                conRunOff;
                conDirRob;
                quit:=TRUE;
                done:=TRUE;
                current_state := "None";
            ENDIF
            IF current_state = "unknown" THEN        !if an unknown command is read
                TPWrite "Unknown command";               !write "Unknown command" on the FlexPendant
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
    
    !Jog continuously in an axis (X,Y,or Z) untill paused elsewhere or the limits are reached
    !Will calculate the axis based on the current frame of reference set by wobjCurrent
    !PARAM axis:            the axis to use
    !PARAM jog_inc:         num to continuously increment the axis by to find the robot's limit. Negative increment will jog in negative axis direction
    !PARAM move_speed:      speed data
    PROC JogLinear(string axis, num jog_inc, speeddata move_speed)
        VAR robtarget pos_current;                      !current robot target
        VAR robtarget pos_new;                          !new robot target to be calculated
        VAR jointtarget check_joint;                    !joint variable for range checking
        VAR errnum err_val:=0;                          !error variable for range checking
        VAR pos jog:= [0,0,0];                          !vector to be incremented and rotated before adding to new_pos
        VAR pose workObjectRot := [[0,0,0], [0,0,0,0]];    !rotation to transform the jog vector by based on the current work object
        
        pos_current:=CRobT(\WObj:=wBase);               !get current pos
        pos_new:=pos_current;
        
        IF wobjCurrent = wEffector THEN                 !check if frame is the dynamic end effector frame based off link 6
            workObjectRot.rot := pos_current.rot;           !if so use link 6's frame for axis rotation
        ELSE
            workObjectRot := PoseInv(wobjCurrent.uframe);!else use the current work objects frame.
            workObjectRot.trans := [0,0,0];
        ENDIF
        
        IF axis = "x" OR axis = "X" THEN                 !apply increment to axis indicated in argument
            jog.x := jog_inc;
        ELSEIF axis = "y" or axis = "Y" THEN
            jog.y:= jog_inc;
        ELSEIF axis = "z" or axis = "Z" THEN 
            jog.z:= jog_inc;
        ENDIF
        
        jog := PoseVect(workObjectRot, jog);            !transform vector by the rotation matrix for the work object
        
                                                       
        WHILE err_val = 0 DO                            !recalculate new pose by incrementing untill out of limits
            pos_new.trans:=pos_new.trans + jog;
            check_joint:=CalcJointT(pos_new,tSCup,\WObj:=wBase\ErrorNumber:=err_val);
        ENDWHILE
        pos_new.trans:=pos_new.trans-jog;               !deincrement once to move back in range
                                                         
        MoveL pos_new,move_speed,fine,tSCup\WObj:=wBase;!move to calculated pos by linear pathing 
        ERROR
    ENDPROC   

    !Work in progress (should work but has not been tested because no comms statements for it)
    PROC JogYaw (num jog_inc)
        VAR robtarget pos_current;
        VAR robtarget pos_new;
        VAR jointtarget jog_target;
        VAR errnum err_val;
        VAR num roll;
        VAR num pitch;
        VAR num yaw;
        pos_current:=CRobT(\WObj:=wobjCurrent);          !get current pos 
        pos_new:=pos_current;
        roll := EulerZYX(\Z, pos_current.rot);           !get current roll
        pitch:= EulerZYX(\Y, pos_current.rot);           !get current pitch
        yaw := EulerZYX(\X, pos_current.rot);            !get current yaw
        !recalculate new pose untill out of limits
        WHILE err_val = 0 DO
            yaw  := yaw + jog_inc;                       !increment yaw
            pos_new.rot := OrientZYX(roll, pitch, yaw);  !apply rotations
            jog_target:=CalcJointT(pos_new,tSCup,\WObj:=wobjCurrent\ErrorNumber:=err_val);! check for errors
        ENDWHILE
        pos_new.trans.x:=pos_new.trans.z-jog_inc;        !decrement yaw once to get back in range
        MoveJ pos_new,jog_speed,fine,tSCup\WObj:=wobjCurrent;!move joints.
        ERROR
    ENDPROC
    
    !Jog specified Joint to positive or negative limit
    !PARAM jointNumber: joint number 1 to 6
    !PARAM jog_inc_deg: increment to use to reach robot limit (mainly used to specify direction of joint) 
    PROC JogJoint(num jointNumber, num jog_inc_deg)
        VAR jointtarget thetas_current;                 !current joint angles
        VAR jointtarget thetas_new;                     !new joint angles
        VAR speeddata jog_speed;                        !speed used for joint jogging
        
        jog_speed := getSpeed(modeSpeed);               !get speed from string argument
        thetas_current:=CJointT();                      !get current joint angles
        thetas_new:=thetas_current;                     !new joint angles for incrementing
        
        !IF statement to determine first join number and then joint direction. Each joint limit is hardcoded in to the iff statements. 
        !see first example
        IF jointNumber = 1 THEN                                 !joint  1?
            IF jog_inc_deg < 0  THEN                                !negative increment?
                thetas_new.robax.rax_1:=-165;                           !set joint 1 to negative limit (hardcoded)
                MoveAbsJ thetas_new,move_speed,fine,tSCup;              !move to new angles
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
        ERROR
    ENDPROC
    
     !Move to specified joint angles
     !PARAM pose:               joint angles 1 to 6, e.g [90,0,0,0,0,0]
     !PARAM move_speed:         speed to move at, e.g v100
     PROC MoveToPose(robjoint pose, speeddata move_speed)
        VAR jointtarget thetas_new_formatted;       !We will need the joint angles formatted to a joint target for moving the robot
        VAR robtarget check_target;                 !target for error checking
        VAR jointtarget check_joints;               !joints for error cecking
        VAR errnum err_val;                         !error variable
        
        thetas_new_formatted:= [pose, [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];       !pad the desired robot joint angles to a jointtarget variable
        check_target:=CalcRobT(thetas_new_formatted,tSCup);                         !check if in range step 1
        check_joints:=CalcJointT(check_target,tSCup\ErrorNumber:=err_val);          !check if in range step 2
         IF err_val<>0 THEN                                                             !error found in position?
            errorNumber := err_val; 
            errorHandling := TRUE;                                                      !flag for error handling
        ELSE
            MoveAbsJ thetas_new_formatted, move_speed, fine, tSCup;                 !move joint angles if no errors
         ENDIF
        ERROR
    ENDPROC


    ! Move to a target relative to the current work object
    ! PARAM target: target position and orientation
    ! PARAM move_speed: speed to move at
    PROC MoveTarget(robtarget target, speeddata move_speed)
        VAR jointtarget check_joints;                       !error checking target
        VAR errnum err_val;                                 !error variable
        
        check_joints:=CalcJointT(target,tSCup\WObj:=wobjCurrent\ErrorNumber:=err_val); !error checking before move
         IF err_val<>0 THEN
            errorNumber := err_val;
            errorHandling := TRUE;
        ELSE
            MoveJ target, move_speed, fine, tSCup, \WObj:=wobjCurrent;      !move joint angles
         ENDIF
         ERROR
    ENDPROC
    
    
    !move to a linear offset of the target. no error checking as this is just for testing
    PROC MoveTargetOffset(robtarget target, num x, num y, num z)
        
              MoveL Offs(target, x, y, z), v100, fine, tSCup;
    ENDPROC
    
    !converts the string fragments from the comms server to a robtarget
    !PARAM numTotal: string array with 6 arguments, expected to be [xt,yt,zt,zr,yr,xr] 
    !where t is translational component and r is rotational component
    !RETURN robtarget:
    FUNC robtarget getTarget(string numTotal{*})
        VAR robtarget newTarget;
        VAR bool conversion_outcome;
        VAR num converted_num;
        VAR num roll;
        VAR num pitch;
        VAR num yaw;
        
        !convert strings to numbers
        conversion_outcome := StrtoVal(numTotal{1}, newTarget.trans.x);
        conversion_outcome := StrtoVal(numTotal{2}, newTarget.trans.y);
        conversion_outcome := StrtoVal(numTotal{3}, newTarget.trans.z);
        conversion_outcome := StrtoVal(numTotal{4}, roll);
        conversion_outcome := StrtoVal(numTotal{5}, pitch);
        conversion_outcome := StrtoVal(numTotal{6}, yaw);
        newTarget.rot := OrientZYX(roll, pitch, yaw);                       !convert euler angles to quarternion for the robot
        
        RETURN newTarget;
    ENDFUNC
    
    !converts the string fragments from the comms server to joint angles
    !PARAM numTotal: string array with 6 arguments, expected to be [q1,q2,q3,q4,q5,q6] 
    !where qs are the joint angles
    !RETURN robtarget:
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
    !originally set to v50, v100, and v500 this has been reduced on just the rapid side as the robot cannot move that fast.
    FUNC speeddata getSpeed(string modeSpeed)
      VAR speeddata move_speed;
      IF modeSpeed = "v50" THEN
          move_speed := v10;
      ELSEIF modeSpeed = "v100" THEN
          move_speed := v50;
      ELSEIF modeSpeed = "v500" THEN
          move_speed := v100;
      ENDIF
      RETURN move_speed;
    ENDFUNC
    
    !turn on vacuum pump
    PROC vacPwrOn()
        SetDO DO10_1, 1;
    ENDPROC
    
    !turn off vacuum pump
    PROC vacPwrOff()
        SetDO DO10_1, 0;
    ENDPROC
    
    !turn on vacuum solenoid
    PROC vacSolOn()
        SetDO DO10_2, 1;
    ENDPROC
    
    !turn off vacuum solenoid
    PROC vacSolOff()
        SetDO DO10_2, 0;
    ENDPROC
    
    !turn on conveyer
    PROC conRunOn()
        IF DInput(DI10_1)= 1 THEN          !first check if conveyer is enabled
            SetDO DO10_3, 1;
        ENDIF
    ENDPROC
    
    !turn off conveyer
    PROC conRunOff()
        SetDO DO10_3, 0;
    ENDPROC
    
    !set the conveyer to move towards the robot
    PROC conDirRob()
        SetDO DO10_4, 1;
    ENDPROC
    
    !set the conveyer to move towards the hatch
    PROC conDirHome()
        SetDO DO10_4, 0;
    ENDPROC
    

    TRAP pauseRoutine               !the pause interrupt is called for pausing
        IF paused =TRUE THEN            !if the robot is set to the paused state
            StopMove;                   !robot still first stop moving in the current path
            StorePath;                  !the current path is stored for resuming later
        ELSE                        !the pause interrupt is called for resuming
            RestoPath;                  !robot restores the path stored earlier      
            StartMove;                  !robot will move along the restored path
        ENDIF
    ENDTRAP
    
    TRAP cancelRoutine              !the cancel interrupt is called for cancelling
        IF cancelled =TRUE THEN         !if the robot is set to cancelled state
            StopMove;                   !robot still stop moving in the current path
            ClearPath;                  !robot will delete the current path so that it cannot be restored
        ENDIF
    ENDTRAP

ENDMODULE