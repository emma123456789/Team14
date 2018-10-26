    MODULE SERVER_MAIN    

    ! The socket connected to the client.
    VAR socketdev client_socket;
    ! The host and port that we will be listening for a connection on.
    PERS string current_state := "moveert";   !current state of the robot which is initialised as an empty string
    CONST num port := 1025;            !the port used for connection between RobotStudio and MATLAB
    PERS string host := "127.0.0.1";
    PERS bool quit;                    !the quit flag                 
    PERS bool checkCom := TRUE;       !flag to jump to the movement file to decide its next move
    PERS bool done := FALSE;           !flag that indicates action is done
    VAR num stringLength;              !number that returns the total length of the message received from MATLAB
    VAR num stringStart;               !number that stores the index of the first character
    VAR num numStart;                  !number that stores the index of the first digit
    VAR num index := 1;                !number that stores the current index for string segmentation
    VAR bool stringFound;              !flag that indicates the characters have been segmented 
    VAR num numIndex := 1;             !number of values that should be segmented
    VAR bool stringDecoded := FALSE;   !flag that indicates the whole message has been segmented
    PERS bool errorHandling := FALSE;  !flag that indicates there are errors received from jog functions
    PERS num errorNumber;              !number that stores the error value received
    PERS string numTotal{7};           !array that stores the numeric section of the message received from MATLAB
    PERS string modeSpeed;             !string that stores the speed needed for jog functions
    VAR intnum pauseTrigger;
    VAR intnum cancelTrigger;
    PERS num paused:= 0;                 !pause flag
    PERS num cancelled := 0; 
    
    
    PROC Main ()
        !this is just for testing        
        !current_state := "";
        IF RobOS() THEN
            host := "192.168.125.1";   !IP of the real robot
        ELSE
            host := "127.0.0.1";       !IP for simulation
        ENDIF
        
        ListenForAndAcceptConnection;  !waiting to establish connection between MATLAB and RobotStudio
        MainServer;                    !jumps to server operations
        ERROR
    ENDPROC

    PROC MainServer()
        
        !VAR bool isJogging;
        
        
        VAR string received_str := "";      !initialises the received string from MATLAB
        VAR string received_strSeg := "";   !initialises the segmented string from MATLAB
        current_state:="";                  !initialises current state
        
        WHILE quit=FALSE DO                 !while the shutdown button is not pressed, server will read messages from MATLAB
            received_str := "";             !reset the string to ensure it is empty.
            !getStatus
            target;                         !get the current XYZ coordinates and Euler angles from the robot
            angles;                         !get the 6 joint angles from the robot
            getIO;                          !get the IO status of conveyor, vacuum pump and vacuum solenoid
            getError;                       !get the status returned from the error IO signals
            !WaitTime 1;
            deletePauseTrap;
            deleteCancelTrap;
            addPauseTrap;
            addCancelTrap;
            
!            ! Receive a string from the client.           
!                WHILE received_str = "" DO
!                    SocketReceive client_socket \Str:=received_str \Time:=0.1;     !server will remain connected while waiting for messages
!                    IF done = TRUE THEN
!                        SocketSend client_socket, \Str:= "done\0A";
!                        done := FALSE;
!                    ENDIF
!                ENDWHILE

            SocketReceive client_socket \Str:=received_str \Time:=WAIT_MAX;

            IF cancelled = 1 THEN
                StartMove;
                cancelled:= 0;
            ENDIF
            
            !for testing, needed later for string separation
            stringLength := strLen(received_str);               !the length of the message received is stored in stringLength
            index := 1;                                         !current index is initialized as 1
            numIndex:=1;                                        !the number of values to store is initialised as 1
            received_strSeg:="";                                !segmented string is initialised
            WHILE stringFound = FALSE DO                        !if the characters has not been segmented from the message received
                stringStart :=  strFind(received_str,index,STR_WHITE);                  !the index before the first blank character (space) is found
                received_strSeg :=  strPart(received_str,index,stringStart-index);      !the string is the section between the first character and the index before space
                index := stringStart+1;                                                 !updates current index
                stringFound := TRUE;                                                    !flag updates to TRUE since characters have been segmented  
            ENDWHILE 
            
            stringFound := FALSE;  
            
            IF received_strSeg = "insert_box" THEN         !if asked to move to a target relative to table home
                current_state := "insert_box";
                checkCom := TRUE;  
            ENDIF 
            
            IF received_strSeg = "reload_box" THEN         !if asked to move conveyer back to home
                current_state := "reload_box";
                checkCom := TRUE;  
                
            ENDIF 
            IF received_strSeg = "moveert" THEN         !if asked to move to a target relative to table home
                WHILE numIndex <= 6 DO                      !stores the 6 values (xyz+euler angles) for move function
                numStart := strFind(received_str,index,STR_WHITE);      
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);  !stores the speed of moving
                current_state := "moveert";
                checkCom := TRUE;  
            ENDIF 
            
            IF received_strSeg = "moveerb" THEN         !if asked to move to a target relative to base home
                WHILE numIndex <= 6 DO                      !stores the 6 values (xyz+euler angles) for move function
                numStart := strFind(received_str,index,STR_WHITE);      
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);  !stores the speed of moving
                current_state := "moveerb";
                checkCom := TRUE;  
            ENDIF 
            
            IF received_strSeg = "moveerc" THEN         !if asked to move to a target relative to coveyer home
                WHILE numIndex <= 6 DO
                numStart := strFind(received_str,index,STR_WHITE);
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "moveerc";
                checkCom := TRUE;  
            ENDIF 
              
            IF received_strSeg = "movejas" THEN         !if asked to set the joint angles
                WHILE numIndex <= 6 DO                      !stores the 6 joint angles for move function
                numStart := strFind(received_str,index,STR_WHITE);
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "movejas";
                checkCom := TRUE;
            ENDIF 
            
            IF received_strSeg = "baseFrameXposSTART" THEN  !if asked to move in the positive X direction relative to base frame
                SocketSend client_socket \Str:=("base frame jogX started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "bxPlus"; 
                checkCom := TRUE;
            ENDIF
            
            IF received_strSeg = "endEffectorXposSTART" THEN    !if asked to move in the positive X direction relative to end effector frame
                SocketSend client_socket \Str:=("effector frame jogX started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "exPlus"; 
                checkCom := TRUE;
            ENDIF
            IF received_strSeg = "endEffectorXnegSTART" THEN    !if asked to move in the negative X direction relative to base frame
                SocketSend client_socket \Str:=("effector frame -jogX started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "exMinus"; 
                checkCom := TRUE;
            ENDIF
            
            IF received_strSeg = "baseFrameYposSTART" THEN      !if asked to move in the positive Y direction relative to base frame
                SocketSend client_socket \Str:=("base frame jogY started" + "\0A"); 
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "byPlus";
                checkCom := TRUE;
            ENDIF
            
            IF received_strSeg = "endEffectorYposSTART" THEN    !if asked to jog in the positive Y direction relative to end effector frame
                SocketSend client_socket \Str:=("coneffectorveyer frame jogY started" + "\0A"); 
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "eyPlus";
                checkCom := TRUE;
            ENDIF
            IF received_strSeg = "endEffectorYnegSTART" THEN    !if asked to move in the negative Y direction relative to base frame
                SocketSend client_socket \Str:=("effector frame -jogY started" + "\0A"); 
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "eyMinus";
                checkCom := TRUE;
            ENDIF

            IF received_strSeg = "baseFrameZposSTART" THEN   !if asked to move in the negative Y direction relative to end effector frame
                SocketSend client_socket \Str:=("base frame jogZ started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "bzPlus";
                checkCom := TRUE;
            ENDIF
                
            IF received_strSeg = "endEffectorZposSTART" THEN    !if asked to move in the positive Z direction relative to base frame
                SocketSend client_socket \Str:=("effector frame jogZ started" + "\0A"); 
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "ezPlus";
                checkCom := TRUE;
            ENDIF
            
            IF received_strSeg = "endEffectorZnegSTART" THEN    !if asked to move in the negative Z direction relative to base frame
                SocketSend client_socket \Str:=("effector frame -jogZ started" + "\0A"); 
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "ezMinus";
                checkCom := TRUE;
            ENDIF
            
            IF received_strSeg = "baseFrameXnegSTART" THEN  !jog -veX in base frame
                SocketSend client_socket \Str:=("base frame -jogX started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "bxMinus";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "conveyerFrameXnegSTART" THEN  !jog -veX in conveyer frame
                SocketSend client_socket \Str:=("conveyer frame -jogX started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "exMinus";
                checkCom := TRUE;
            ENDIF 
                
            IF received_strSeg = "baseFrameYnegSTART" THEN  !jog -veY in base frame
                SocketSend client_socket \Str:=("base frame -jogY started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "byMinus";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "conveyerFrameYnegSTART" THEN  !jog -veY in conveyer frame
                SocketSend client_socket \Str:=("conveyer frame -jogY started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "eyMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_strSeg = "baseFrameZnegSTART" THEN  !jog -veZ in base frame
                SocketSend client_socket \Str:=("base frame -jogZ started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "bzMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_strSeg = "conveyerFrameZnegSTART" THEN  !jog -veZ in conveyer frame
                SocketSend client_socket \Str:=("conveyer frame -jogZ started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "ezMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_strSeg = "jogQ1posSTART" THEN   !jog joint 1 in the +ve direction
                SocketSend client_socket \Str:=("jog1 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog1";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ1negSTART" THEN   !jog joint 1 in the -ve direction
                SocketSend client_socket \Str:=("-jog1 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog1";
                checkCom := TRUE;
            ENDIF   
            IF received_strSeg = "jogQ2posSTART" THEN   !jog joint 2 in the +ve direction
                SocketSend client_socket \Str:=("jog2 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog2";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ2negSTART" THEN   !jog joint 2 in the -ve direction
                SocketSend client_socket \Str:=("-jog2 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog2";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ3posSTART" THEN   !jog joint 3 in the +ve direction
                SocketSend client_socket \Str:=("jog3 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog3";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ3negSTART" THEN   !jog jonint 3 in the -ve direction
                SocketSend client_socket \Str:=("-jog3 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog3";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ4posSTART" THEN   !jog joint 4 in the +ve direction
                SocketSend client_socket \Str:=("jog4 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog4";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ4negSTART" THEN   !jog joint 4 in the -ve direction
                SocketSend client_socket \Str:=("-jog4 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog4";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ5posSTART" THEN   !jog joint 5 in the +ve direction
                SocketSend client_socket \Str:=("jog5 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog5";
                checkCom := TRUE;
            ENDIF   
            IF received_strSeg = "jogQ5negSTART" THEN   !jog joint 5 in the -ve direction
                SocketSend client_socket \Str:=("-jog5 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog5";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ6posSTART" THEN   !jog joint 6 in the +ve direction
                SocketSend client_socket \Str:=("jog6 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "jog6";
                checkCom := TRUE;
            ENDIF 
            IF received_strSeg = "jogQ6negSTART" THEN   !jog joint 6 in the -ve direction
                SocketSend client_socket \Str:=("-jog6 started" + "\0A");
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "-jog6";
                checkCom := TRUE;
            ENDIF 
            IF received_str = "moveToPose" THEN     !move to a certain pose
                SocketSend client_socket \Str:=("moveToPose started" + "\0A");
                current_state := "moveToPose";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "moveAngle" THEN      !move as the specified 6 joint angles
                SocketSend client_socket \Str:=("moveAngle started" + "\0A");
                current_state := "moveAngle";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorRunOn" THEN   !turn conveyer on
                SocketSend client_socket \Str:=("conveyor turned on" + "\0A");
                current_state := "conOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorRunOff" THEN     !turn conveyer off
                SocketSend client_socket \Str:=("conveyor turned off" + "\0A");
                current_state := "conOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorReverseOn" THEN   !reverse conveyer direction
                SocketSend client_socket \Str:=("conveyor reverse on" + "\0A");
                current_state := "conReverseOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorReverseOff" THEN  !conveyer usual direction
                SocketSend client_socket \Str:=("conveyor reverse off" + "\0A");
                current_state := "conReverseOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "enableConveyorOn" THEN   !enable conveyer
                SocketSend client_socket \Str:=("conveyor enabled" + "\0A");
                current_state := "conEnabled";
                checkCom := TRUE;
            ENDIF
                
            IF received_str = "enableConveyorOff" THEN  !disable conveyer
                SocketSend client_socket \Str:=("conveyor disabled" + "\0A");
                current_state := "conDisabled";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "vacuumSolenoidOn" THEN   !turn on vacuum solenoid
                SocketSend client_socket \Str:=("vaccum solenoid on" + "\0A");
                current_state := "vacSolOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumSolenoidOff" THEN  !turn of vacuum solenoid
                SocketSend client_socket \Str:=("vacuum solenoid off" + "\0A");
                current_state := "vacSolOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumPumpOn" THEN   !turn on vacuum pump
                SocketSend client_socket \Str:=("vacuum pump on" + "\0A");
                current_state := "vacPumpOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumPumpOff" THEN  !turn off vacuum pump
                SocketSend client_socket \Str:=("vacuum pump off" + "\0A");
                current_state := "vacPumpOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_strSeg<> "baseFrameXposSTART" AND received_strSeg<> "baseFrameYposSTART" AND
            received_strSeg<>"baseFrameZposSTART" AND received_strSeg<>"baseFrameXnegSTART" AND
            received_strSeg<>"baseFrameYnegSTART" AND received_strSeg<>"baseFrameZnegSTART" AND
            received_strSeg<>"endEffectorXposSTART" AND received_strSeg<>"endEffectorXnegSTART" AND
            received_strSeg<>"endEffectorYposSTART" AND received_strSeg<>"endEffectorYnegSTART" AND
            received_strSeg<>"endEffectorZposSTART" AND received_strSeg<>"endEffectorZnegSTART" AND
            received_strSeg<>"jogQ1posSTART" AND received_strSeg<>"jogQ1negSTART" AND
            received_strSeg<>"jogQ2posSTART" AND received_strSeg<>"jogQ2negSTART" AND
            received_strSeg<>"jogQ3posSTART" AND received_strSeg<>"jogQ3negSTART" AND
            received_strSeg<>"jogQ4posSTART" AND received_strSeg<>"jogQ4negSTART" AND
            received_strSeg<>"jogQ5posSTART" AND received_strSeg<>"jogQ5negSTART" AND
            received_strSeg<>"jogQ6posSTART" AND received_strSeg<>"jogQ6negSTART" AND
            received_strSeg<>"reload_box" AND received_strSeg<>"insert_box" AND
            received_str<>"vacuumPumpOn" AND received_str<>"vacuumPumpOff" AND
            received_str<>"vacuumSolenoidOn" AND received_str<>"vacuumSolenoidOff" AND
            received_str<>"conveyorRunOn" AND received_str<>"conveyorRunOff" AND 
            received_str<>"enableConveyorOn" AND received_str<>"enableConveyorOff" AND 
            received_str<>"conveyorReverseOn" AND received_str<>"conveyorReverseOff" AND
            received_str<>"moveToPose" AND received_str<>"moveAngle" AND 
            received_strSeg<>"movejas" AND received_strSeg <> "moveert" AND received_strSeg <> "moveerc" AND received_strSeg <> "moveeerb" AND
            received_str<>"" AND received_str<>"pause" AND received_str<>"resume" AND 
            received_str<>"cancel" AND received_str<>"quit" THEN    !if mesage received is none of the above
                SocketSend client_socket \Str:=("unknown comand" + "\0A"); 
                current_state := "unknown";
                checkCom := TRUE;
            ENDIF
               
            IF received_str = "pause" THEN     !if asked to pause
                SocketSend client_socket \Str:=("paused" + "\0A");
                paused := 1;
                current_state := "paused";
                !StopMove;
                !StorePath;
                checkCom := TRUE;
            ENDIF
        
            IF received_str = "resume" THEN     !if asked to resume
                SocketSend client_socket \Str:=("resume" + "\0A");
                paused := 0;
                current_state := "resume";
                !RestoPath;
                StartMove;
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "cancel" THEN     !if asked to cancel
                SocketSend client_socket \Str:=("cancel" + "\0A");
                cancelled := 1;
                current_state := "cancel";
                StopMove;
                ClearPath;
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "shutdown" THEN   !if asked to shutdown
                SocketSend client_socket \Str:=("quit" + "\0A");
                current_state := "shutdown";
                checkCom := TRUE;
            ENDIF
            
            !IF received_str <> "cancel" THEN
            !checkCom:=TRUE;
            !WaitUntil current_state = "None" and done = TRUE;   !wait until the current_state is reset and the done flag is set to the true from movementV1
            IF errorHandling = TRUE THEN       !if error is returned from movementV1 the error value is sent to MATLAB
                SocketSend client_socket \Str:=("Error Number:" + ValtoStr(errorNumber) + "\0A");
            ENDIF 
            errorHandling := FALSE;   !reset the errorHandling flag
            
            !WaitUntil done = TRUE;
            !SocketSend client_socket \Str:=("Done" + "\0A");    !display done after movementV1 finished processing
            !done := FALSE;  !reset done flag
                      
        ENDWHILE
        !CloseConnection;        !if shutdown is pressed, close the connection
        ERROR
        TRYNEXT;
!            IF ERRNO=ERR_SOCK_CLOSED THEN       !if socket is accidentally closed, try and reconnect to the server
!                CloseConnection;
!                ListenForAndAcceptConnection;
!            ELSEIF ERRNO=ERR_SOCK_TIMEOUT THEN
!                ResetRetryCount;
!                CloseConnection;
!                ListenForAndAcceptConnection;
!                RETRY;
!            ELSEIF ERRNO=ERR_SOCK_ADDR_INUSE THEN
!                CloseConnection;
!                ListenForAndAcceptConnection;
!            ENDIF
!            TRYNEXT;
    ENDPROC

    PROC ListenForAndAcceptConnection()
        
        ! Create the socket to listen for a connection on.
        VAR socketdev welcome_socket;
        SocketCreate welcome_socket;
        
        ! Bind the socket to the host and port.
        SocketBind welcome_socket, host, port;
        
        ! Listen on the welcome socket.
        SocketListen welcome_socket;
        
        ! Accept a connection on the host and port. infinite wait
        SocketAccept welcome_socket, client_socket \Time:=WAIT_MAX;
        
        ERROR 
            IF ERRNO=ERR_SOCK_CLOSED THEN       !if socket is accidentally closed, try and reconnect to the server
                SocketClose welcome_socket;
                ListenForAndAcceptConnection;
            ELSEIF ERRNO=ERR_SOCK_TIMEOUT THEN
                ResetRetryCount;
                SocketClose welcome_socket;
                ListenForAndAcceptConnection;
            ELSEIF ERRNO=ERR_SOCK_ADDR_INUSE THEN
                SocketClose welcome_socket;
                ListenForAndAcceptConnection;
            ENDIF
            !TRYNEXT;
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
    ENDPROC
    
    !sends the current end effector target to the client
    !format: [tx, ty, tz, roll, pitch, yaw]
    PROC target()
        VAR robtarget pos_current;              !current position
        VAR num pos_array{6};                   !array of components
        VAR string pos_string:="";              !string to send
        
        pos_current:=CRobT(\Tool:=tsCup);       !get position from robot
        
        pos_array{1}:=pos_current.trans.x;
        pos_array{2}:=pos_current.trans.y;
        pos_array{3}:=pos_current.trans.z;
        pos_array{4}:=EulerZYX(\Z, pos_current.rot);!convert from quarternion to euler rotations (order roll pitch yaw i.e. zyx)
        pos_array{5}:=EulerZYX(\Y, pos_current.rot);
        pos_array{6}:=EulerZYX(\X, pos_current.rot);
        pos_string := "endEffector";            !string opener
        FOR index FROM 1 TO 6 DO                !append each value seperated by whitespace and rounded to 3 decimal places
            pos_string:=pos_string+" "+ ValtoStr(Round(pos_array{index}\Dec:=3));
        ENDFOR
    SocketSend client_socket \Str:=pos_string + "\0A";  !send to client
    ENDPROC

    ! Send the current joint angles to matlab
    !format: [q1, q2, q3, q4, q5, q6]
    PROC angles()
        VAR jointtarget thetas_current;                 !for storing the current joint angles
        VAR num thetas_array{6};                        !joint angle aray
        VAR string thetas_string;                       !string for sending joint angles
        
        thetas_current:=CJointT();                      !get current joint angles from robot
        thetas_array{1}:=thetas_current.robax.rax_1;
        thetas_array{2}:=thetas_current.robax.rax_2;
        thetas_array{3}:=thetas_current.robax.rax_3;
        thetas_array{4}:=thetas_current.robax.rax_4;
        thetas_array{5}:=thetas_current.robax.rax_5;
        thetas_array{6}:=thetas_current.robax.rax_6;
        thetas_string := "jointAngle";                  !string opener
        FOR index FROM 1 TO 6 DO                        !append each value seperated by whitespace and rounded to 3 decimal places
            thetas_string:=thetas_string+ " " + ValtoStr(Round(thetas_array{index}\Dec:=3));
        ENDFOR
        SocketSend client_socket \Str:=thetas_string+ "\0A";!send the string to the client
    ENDPROC
    
    
    PROC GetIO()
        VAR num io_array{5};
        VAR string io_string;
        io_array{1}:=DOutput(DO10_3); !Conveyor Run
        io_array{2}:=DOutput(DO10_4); !Convyor Reverse
        io_array{3}:=DOutput(DO10_1); !Vacuum Pump
        io_array{4}:=DOutput(DO10_2);  !Vacuum solenoid
        io_array{5}:=DInput(DI10_1);   !Enable Conveyor
        io_string := "DIO";
        FOR index FROM 1 TO 5 DO
            io_string:=io_string+" "+ ValtoStr(io_array{index});
        ENDFOR
        SocketSend client_socket \Str:=io_string + "\0A";
    ENDPROC
    
    PROC GetError()
        VAR num error_array{7};
        VAR string error_string;
        error_array{1}:=DOutput(DO_ESTOP2); !normal condition = 0
        error_array{2}:=DOutput(DO_LIGHT_CURTAIN); !normal condition = 1
        error_array{3}:=DOutput(DO_MOTOR_ON_STATE); !normal condition = 1
        error_array{4}:=DOutput(DO_HOLD_TO_ENABLE); !normal condition = 1
        error_array{5}:=DOutput(DO_EXEC_ERR);  !normal condition = 0
        error_array{6}:=DOutput(DO_MOTION_SUP_TRIG);  !normal condition = 0
        error_array{7}:=DInput(DI10_1); !normal condition = 1
        error_string:="Error";
        FOR index FROM 1 TO 7 DO
            error_string:= error_string+" "+ ValtoStr(error_array{index});
        ENDFOR
        SocketSend client_socket \Str:=error_string+ "\0A";
    ENDPROC
    
    PROC deletePauseTrap()
        IDelete pauseTrigger;
    ENDPROC
    
    PROC deleteCancelTrap()
        IDelete cancelTrigger;
    ENDPROC
    
    PROC addPauseTrap()
        CONNECT pauseTrigger WITH pauseRoutine;
        IPers paused, pauseTrigger;
    ENDPROC
    
    PROC addCancelTrap()
        CONNECT cancelTrigger WITH cancelRoutine;
        IPers cancelled, cancelTrigger;
    ENDPROC
    
    TRAP pauseRoutine               !the pause interrupt is called for pausing
        IF paused =1 THEN            !if the robot is set to the paused state
            StopMove;                   !robot still first stop moving in the current path
            !StorePath;                  !the current path is stored for resuming later
        ELSE                        !the pause interrupt is called for resuming
            !RestoPath;                  !robot restores the path stored earlier      
            StartMove;                  !robot will move along the restored path
        ENDIF
        !current_state := "None";
        !checkCom := FALSE;
    ENDTRAP
   
    TRAP cancelRoutine              !the cancel interrupt is called for cancelling
        IF cancelled = 1 THEN         !if the robot is set to cancelled state
            StopMove;                   !robot still stop moving in the current path
            !ClearPath;                  !robot will delete the current path so that it cannot be restored
        ENDIF
        !current_state := "None";
        !checkCom := FALSE;
        !cancelled := 0;
    ENDTRAP

ENDMODULE