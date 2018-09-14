MODULE MTRN4230_Server_Sample    

    ! The socket connected to the client.
    VAR socketdev client_socket;
    ! The host and port that we will be listening for a connection on.
    PERS string host := "192.168.125.1";
    PERS string current_state := "";
    CONST num port := 1025;
    PERS bool isCancelled := FALSE;
    PERS bool checkCom := FALSE;
    PERS bool done := TRUE;
    
    
    PROC Main ()
        current_state := "";
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
        
        
        VAR string received_str;
        WHILE isCancelled=FALSE DO
            ! Receive a string from the client.
            SocketReceive client_socket \Str:=received_str;
            !PERS matlab_str := received_str;
            IF received_str = "xPlus" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("jogX started" + "\0A");
                current_state := "xPlus";              
            !ENDIF
            ELSEIF received_str = "yPlus" THEN 
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("jogY started" + "\0A"); 
                current_state := "yPlus";
            !ENDIF

            ELSEIF received_str = "zPlus" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("jogZ started" + "\0A");
                current_state := "zPlus";
            ENDIF
            
            IF done = TRUE THEN
                SocketSend client_socket \Str:=("Done" + "\0A");
            ENDIF 
            
            IF received_str = "xMinus" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("-jogX started" + "\0A");
                current_state := "xMinus";
            ENDIF 
                
            IF received_str = "yMinus" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("-jogY started" + "\0A");
                current_state := "yMinus";
            ENDIF 
            
            IF received_str = "zMinus" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("-jogZ started" + "\0A");
                current_state := "zMinus";
            ENDIF 
            
            IF received_str = "jog1" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("jog1 started" + "\0A");
                current_state := "jog1";
            ENDIF 
            
            IF received_str = "moveToPose" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("moveToPose started" + "\0A");
                current_state := "moveToPose";
            ENDIF
            
            IF received_str = "moveAngle" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("moveAngle started" + "\0A");
                current_state := "moveAngle";
            ENDIF 
            
            IF received_str = "conveyorRunOn" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor turned on" + "\0A");
                current_state := "conOn";
            ENDIF 
            
            IF received_str = "conveyorRunOff" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor turned off" + "\0A");
                current_state := "conOff";
            ENDIF 
            
            IF received_str = "conveyorReverseOn" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor reverse on" + "\0A");
                current_state := "conReverseOn";
            ENDIF 
            
            IF received_str = "conveyorReverseOff" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor reverse off" + "\0A");
                current_state := "conReverseOff";
            ENDIF 
            
            IF received_str = "enableConveyorOn" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor enabled" + "\0A");
                current_state := "conEnabled";
            ENDIF
            
            IF received_str = "enableConveyorOff" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("conveyor disabled" + "\0A");
                current_state := "conDisabled";
            ENDIF
            
            IF received_str = "vacuumSolenoidOn" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("vaccum solenoid on" + "\0A");
                current_state := "vacSolOn";
            ENDIF 
            
            IF received_str = "vacuumSolenoidOff" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("vacuum solenoid off" + "\0A");
                current_state := "vacSolOff";
            ENDIF 
            
            IF received_str = "vacuumPumpOn" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("vacuum pump on" + "\0A");
                current_state := "vacPumpOn";
            ENDIF 
            
            IF received_str = "vacuumPumpOff" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("vacuum pump off" + "\0A");
                current_state := "vacPumpOff";
            ENDIF 
            
            !IF received_str<> "xPlus" AND received_str<> "yPlus" AND
            !received_str<>"zPlus" AND received_str<>"xMinus" AND
            !received_str<>"yMinus" AND received_str<>"zMinus" AND received_str<>"jog1" AND
            !received_str<>"vacuumPumpOn" AND received_str<>"vacuumPumpOff" AND
            !received_str<>"vacuumSolenoidOn" AND received_str<>"vacuumSolenoidOff" AND
            !received_str<>"conveyorRunOn" AND received_str<>"conveyorRunOff" AND 
            !received_str<>"enableConveyorOn" AND received_str<>"enableConveyorOff" AND 
            !received_str<>"conveyorReverseOn" AND received_str<>"conveyorReverseOff" AND
            !received_str<>"moveToPose" AND received_str<>"moveAngle" THEN
            !    !checkCom := TRUE;
            !    SocketSend client_socket \Str:=("unknown comand" + "\0A"); 
            !    current_state := "unknown";
            !ENDIF
            
            !IF current_state = "None" THEN
                !checkCom := TRUE;
            !    SocketSend client_socket \Str:=("Done" + "\0A"); 
            !ENDIF    
            
            IF received_str = "pause" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("paused" + "\0A");
                current_state := "paused";
            ENDIF
        
            IF received_str = "resume" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("resume" + "\0A");
                current_state := "resume";
            ENDIF
            
            IF received_str = "cancel" THEN
                !checkCom := TRUE;
                SocketSend client_socket \Str:=("cancel" + "\0A");
                current_state := "cancel";
            ENDIF
            
            
            !IF received_str = 
            !IF current_state = "xPlusDone" THEN
            !    SocketSend client_socket \Str:=("jogX finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "yPlusDone" THEN
            !    SocketSend client_socket \Str:=("jogY finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "zPlusDone" THEN
            !    SocketSend client_socket \Str:=("jogZ finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "xMinusDone" THEN
            !    SocketSend client_socket \Str:=("-jogX finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "yMinusDone" THEN
            !    SocketSend client_socket \Str:=("-jogY finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "zMinusDone" THEN
            !    SocketSend client_socket \Str:=("-jogZ finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "jog1Done" THEN
            !    SocketSend client_socket \Str:=("jog1 finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "conOnDone" THEN
            !    SocketSend client_socket \Str:=("conveyor turned on finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "conOffDone" THEN
            !    SocketSend client_socket \Str:=("conveyor turned off finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "conReverseOnDone" THEN
            !    SocketSend client_socket \Str:=("conveyor reverse on finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "conReverseOffDone" THEN
            !    SocketSend client_socket \Str:=("conveyor reverse off finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "vacSolOnDone" THEN
            !    SocketSend client_socket \Str:=("vaccum solenoid on finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "vacSolOffDone" THEN
            !    SocketSend client_socket \Str:=("vacuum solenoid off finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "vacPumpOnDone" THEN
            !    SocketSend client_socket \Str:=("vacuum pump on finished" + "\0A"); 
            !    current_state := "None";
            !ELSEIF current_state = "vacPumpOffDone" THEN
            !    SocketSend client_socket \Str:=("vacuum pump off finished" + "\0A"); 
            !    current_state := "None";
            !ENDIF
            ! Send the string back to the client, adding a line feed character.
            !SocketSend client_socket \Str:=(received_str + "\0A");
        ENDWHILE
        CloseConnection;
		
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
        SocketAccept welcome_socket, client_socket \Time:=WAIT_MAX;
        
        ! Close the welcome socket, as it is no longer needed.
        SocketClose welcome_socket;
        
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
    ENDPROC
    

ENDMODULE