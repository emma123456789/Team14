MODULE MTRN4230_Server_Sample    

    ! The socket connected to the client.
    VAR socketdev client_socket;
    ! The host and port that we will be listening for a connection on.
    PERS string host := "127.0.0.1";
    PERS string current_state := "None";
    CONST num port := 1025;
    PERS bool quit := FALSE;
    PERS bool checkCom := FALSE;
    PERS bool done := FALSE;
    VAR num stringLength;
    VAR num stringStart;
    VAR num numStart;
    VAR string stringTotal;
    VAR num index := 1;
    VAR bool stringFound;
    VAR num numIndex := 1;
    VAR bool stringDecoded := FALSE;
    PERS bool errorHandling := FALSE;
    PERS num errorNumber;
    PERS string numTotal{7};
    PERS string modeSpeed;
   
    
    
    PROC Main ()
        !this is just for testing        
        !current_state := "";
        IF RobOS() THEN
            host := "192.168.125.1";
        ELSE
            host := "127.0.0.1";
        ENDIF
        
        ListenForAndAcceptConnection;
        MainServer;
        
    ENDPROC

    PROC MainServer()
        
        !VAR bool isJogging;
        
        
        VAR string received_str := "";
        VAR string received_strSeg := "";
        current_state:="";
        
        WHILE quit=FALSE DO
            
            !getStatus
            target;
            angles;
            getIO;
            getError;
            WaitTime 1;
            
            ! Receive a string from the client.            
            SocketReceive client_socket \Str:=received_str \Time:=WAIT_MAX;
            
            !for testing, needed later for string separation
            stringLength := strLen(received_str);
            index := 1;
            numIndex:=1;
            IF stringFound = FALSE THEN
                stringStart :=  strFind(received_str,index,STR_WHITE);
                received_strSeg :=  strPart(received_str,index,stringStart-index);
                index := stringStart+1;
                stringFound := TRUE;
            ENDIF 
            
            stringFound := FALSE;
            
            IF received_strSeg = "moveert" OR received_strSeg = "moveerc" THEN
                WHILE numIndex <= 7 DO
                numStart := strFind(received_str,index,STR_WHITE);
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "moveert";
                checkCom := TRUE;
                
            ENDIF 
            
            IF received_strSeg = "movejas" THEN
                WHILE numIndex <= 6 DO
                numStart := strFind(received_str,index,STR_WHITE);
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "movejas";
                checkCom := TRUE;
            ENDIF 
 
            IF received_strSeg = "moveree" THEN
                WHILE numIndex <= 4 DO
                numStart := strFind(received_str,index,STR_WHITE);
                numTotal{numIndex} := strPart(received_str,index,numStart-index);
                numIndex := numIndex+1;
                index := numStart+1;
                ENDWHILE
                modeSpeed := strPart(received_str,index,stringLength-index+1);
                current_state := "moveree";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "baseFrameXposSTART" THEN
                SocketSend client_socket \Str:=("jogX started" + "\0A");
                current_state := "xPlus"; 
                checkCom := TRUE;
            ENDIF
            IF received_str = "baseFrameYposSTART" THEN 
                SocketSend client_socket \Str:=("jogY started" + "\0A"); 
                current_state := "yPlus";
                checkCom := TRUE;
            ENDIF

            IF received_str = "baseFrameZposSTART" THEN
                SocketSend client_socket \Str:=("jogZ started" + "\0A");
                current_state := "zPlus";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "baseFrameXnegSTART" THEN
                SocketSend client_socket \Str:=("-jogX started" + "\0A");
                current_state := "xMinus";
                checkCom := TRUE;
            ENDIF 
                
            IF received_str = "baseFrameYnegSTART" THEN
                SocketSend client_socket \Str:=("-jogY started" + "\0A");
                current_state := "yMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "baseFrameZnegSTART" THEN
                SocketSend client_socket \Str:=("-jogZ started" + "\0A");
                current_state := "zMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "jogQ1posSTART" THEN
                SocketSend client_socket \Str:=("jog1 started" + "\0A");
                current_state := "jog1";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "moveToPose" THEN
                SocketSend client_socket \Str:=("moveToPose started" + "\0A");
                current_state := "moveToPose";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "moveAngle" THEN
                SocketSend client_socket \Str:=("moveAngle started" + "\0A");
                current_state := "moveAngle";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorRunOn" THEN
                SocketSend client_socket \Str:=("conveyor turned on" + "\0A");
                current_state := "conOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorRunOff" THEN
                SocketSend client_socket \Str:=("conveyor turned off" + "\0A");
                current_state := "conOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorReverseOn" THEN
                SocketSend client_socket \Str:=("conveyor reverse on" + "\0A");
                current_state := "conReverseOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "conveyorReverseOff" THEN
                SocketSend client_socket \Str:=("conveyor reverse off" + "\0A");
                current_state := "conReverseOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "enableConveyorOn" THEN
                SocketSend client_socket \Str:=("conveyor enabled" + "\0A");
                current_state := "conEnabled";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "enableConveyorOff" THEN
                SocketSend client_socket \Str:=("conveyor disabled" + "\0A");
                current_state := "conDisabled";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "vacuumSolenoidOn" THEN
                SocketSend client_socket \Str:=("vaccum solenoid on" + "\0A");
                current_state := "vacSolOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumSolenoidOff" THEN
                SocketSend client_socket \Str:=("vacuum solenoid off" + "\0A");
                current_state := "vacSolOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumPumpOn" THEN
                SocketSend client_socket \Str:=("vacuum pump on" + "\0A");
                current_state := "vacPumpOn";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "vacuumPumpOff" THEN
                SocketSend client_socket \Str:=("vacuum pump off" + "\0A");
                current_state := "vacPumpOff";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str<> "baseFrameXposSTART" AND received_str<> "baseFrameYposSTART" AND
            received_str<>"baseFrameZposSTART" AND received_str<>"baseFrameXnegSTART" AND
            received_str<>"baseFrameYnegSTART" AND received_str<>"baseFrameZnegSTART" AND received_str<>"jogQ1posSTART" AND
            received_str<>"vacuumPumpOn" AND received_str<>"vacuumPumpOff" AND
            received_str<>"vacuumSolenoidOn" AND received_str<>"vacuumSolenoidOff" AND
            received_str<>"conveyorRunOn" AND received_str<>"conveyorRunOff" AND 
            received_str<>"enableConveyorOn" AND received_str<>"enableConveyorOff" AND 
            received_str<>"conveyorReverseOn" AND received_str<>"conveyorReverseOff" AND
            received_str<>"moveToPose" AND received_str<>"moveAngle" AND 
            received_str<>"" AND received_str<>"pause" AND received_str<>"resume" AND 
            received_str<>"cancel" AND received_str<>"quit" THEN
                SocketSend client_socket \Str:=("unknown comand" + "\0A"); 
                current_state := "unknown";
                checkCom := TRUE;
            ENDIF
               
            IF received_str = "pause" THEN
                SocketSend client_socket \Str:=("paused" + "\0A");
                current_state := "paused";
                checkCom := TRUE;
            ENDIF
        
            IF received_str = "resume" THEN
                SocketSend client_socket \Str:=("resume" + "\0A");
                current_state := "resume";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "cancel" THEN
                SocketSend client_socket \Str:=("cancel" + "\0A");
                current_state := "cancel";
                checkCom := TRUE;
            ENDIF
            
            IF received_str = "quit" THEN
                SocketSend client_socket \Str:=("quit" + "\0A");
                current_state := "quit";
                checkCom := TRUE;
            ENDIF
            
            !IF received_str <> "cancel" THEN
            checkCom:=TRUE;
            WaitUntil current_state = "None" and done = TRUE;
            IF errorHandling = TRUE THEN
                SocketSend client_socket \Str:=("Error Number:" + ValtoStr(errorNumber) + "\0A");
            ENDIF 
            errorHandling := FALSE;
            SocketSend client_socket \Str:=("Done" + "\0A");
            done := FALSE;
                      
        ENDWHILE
        CloseConnection;
        ERROR 
            IF ERRNO=ERR_SOCK_CLOSED THEN
                CloseConnection;
                ListenForAndAcceptConnection;
            ELSEIF ERRNO=ERR_SOCK_TIMEOUT THEN
                ResetRetryCount;
                CloseConnection;
                ListenForAndAcceptConnection;
                RETRY;
            ELSEIF ERRNO=ERR_SOCK_ADDR_INUSE THEN
                CloseConnection;
                ListenForAndAcceptConnection;
            ENDIF
            TRYNEXT;
    ENDPROC

    PROC ListenForAndAcceptConnection()
        
        ! Create the socket to listen for a connection on.
        VAR socketdev welcome_socket;
        SocketCreate welcome_socket;
        
        ! Bind the socket to the host and port.
        SocketBind welcome_socket, host, port;
        
        ! Listen on the welcome socket.
        SocketListen welcome_socket;
        
        ! Accept a connection on the host and port.
        SocketAccept welcome_socket, client_socket; !\Time:=WAIT_MAX;
        
        ERROR 
            IF ERRNO=ERR_SOCK_CLOSED THEN
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
            TRYNEXT;
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
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
        pos_string := "endEffector";
        FOR index FROM 1 TO 7 DO
            pos_string:=pos_string+" "+ ValtoStr(pos_array{index});
        ENDFOR
    SocketSend client_socket \Str:=pos_string + "\0A";
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
        thetas_string := "jointAngle";
        FOR index FROM 1 TO 6 DO
            thetas_string:=thetas_string+ " " + ValtoStr(thetas_array{index});
        ENDFOR
        SocketSend client_socket \Str:=thetas_string+ "\0A";
    ENDPROC
    
    
    PROC GetIO()
        VAR num io_array{4};
        VAR string io_string;
        !io_array{1}:=DOutput(DO10_1); !Vac Power Status
        !io_array{2}:=DOutput(DO10_2); !Vac Solenoid Status
        !io_array{3}:=DOutput(DO10_3); !ConvPower Status
        !io_array{4}:=DOutput(DO10_4); !Conv Direcion Status
        !io_array{5}:=DInput(DI10_1);  !Conv Status Value
        !io_array{1}:=DInput(DI10_1); !Enable Conveyor
        io_array{1}:=DOutput(DO10_3); !Conveyor Run
        io_array{2}:=DOutput(DO10_4); !Convyor Reverse
        io_array{3}:=DOutput(DO10_1); !Vacuum Pump
        io_array{4}:=DOutput(DO10_2);  !Vacuum solenoid
        io_string := "DIO";
        FOR index FROM 1 TO 4 DO
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

ENDMODULE