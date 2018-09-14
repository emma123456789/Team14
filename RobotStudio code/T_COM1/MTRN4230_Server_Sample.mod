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
        
        
        VAR string received_str := "";
        WHILE quit=FALSE DO
            ! Receive a string from the client.            
            SocketReceive client_socket \Str:=received_str;
            !PERS matlab_str := received_str;
            
            IF received_str = "xPlus" THEN
                SocketSend client_socket \Str:=("jogX started" + "\0A");
                current_state := "xPlus"; 
                checkCom := TRUE;
            ENDIF
            IF received_str = "yPlus" THEN 
                SocketSend client_socket \Str:=("jogY started" + "\0A"); 
                current_state := "yPlus";
                checkCom := TRUE;
            ENDIF

            IF received_str = "zPlus" THEN
                SocketSend client_socket \Str:=("jogZ started" + "\0A");
                current_state := "zPlus";
                checkCom := TRUE;
            ENDIF
            
            !IF current_state = "None" THEN
            !    IF done = TRUE THEN
            !        SocketSend client_socket \Str:=("Done" + "\0A");
            !    ENDIF
            !ENDIF
            
            IF received_str = "xMinus" THEN
                SocketSend client_socket \Str:=("-jogX started" + "\0A");
                current_state := "xMinus";
                checkCom := TRUE;
            ENDIF 
                
            IF received_str = "yMinus" THEN
                SocketSend client_socket \Str:=("-jogY started" + "\0A");
                current_state := "yMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "zMinus" THEN
                SocketSend client_socket \Str:=("-jogZ started" + "\0A");
                current_state := "zMinus";
                checkCom := TRUE;
            ENDIF 
            
            IF received_str = "jog1" THEN
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
            
            IF received_str<> "xPlus" AND received_str<> "yPlus" AND
            received_str<>"zPlus" AND received_str<>"xMinus" AND
            received_str<>"yMinus" AND received_str<>"zMinus" AND received_str<>"jog1" AND
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
            
            IF received_str <> "cancel" THEN
            WaitUntil current_state = "None" and done = TRUE;
            SocketSend client_socket \Str:=("Done" + "\0A");
            done := FALSE;
            ENDIF
          
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

    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
    ENDPROC
    

ENDMODULE