MODULE MTRN4230_Server_Sample    

    ! The socket connected to the client.
    VAR socketdev client_socket;
    ! The host and port that we will be listening for a connection on.
    PERS string host := "192.168.125.1";
    PERS string current_state;
    CONST num port := 1025;
    
    
    PROC Main ()
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
        WHILE TRUE DO
            ! Receive a string from the client.
            SocketReceive client_socket \Str:=received_str;
            !PERS matlab_str := received_str;
            IF received_str = "xPlus" THEN
                SocketSend client_socket \Str:=("jogX started" + "\0A");
                current_state := "xPlus";
            ELSEIF received_str = "yPlus" THEN 
                SocketSend client_socket \Str:=("jogY started" + "\0A"); 
                current_state := "yPlus";
            ELSEIF received_str = "zPlus" THEN
                SocketSend client_socket \Str:=("jogZ started" + "\0A");
                current_state := "zPlus";
            ELSEIF received_str = "xMinus" THEN
                SocketSend client_socket \Str:=("-jogX started" + "\0A");
                current_state := "xMinus";
            ELSEIF received_str = "yMinus" THEN
                SocketSend client_socket \Str:=("-jogY started" + "\0A");
                current_state := "yMinus";
            ELSEIF received_str = "zMinus" THEN
                SocketSend client_socket \Str:=("-jogZ started" + "\0A");
                current_state := "zMinus";
            ELSEIF received_str = "jog1" THEN
                SocketSend client_socket \Str:=("jog1 started" + "\0A");
                current_state := "jog1";
            ELSEIF received_str = "moveToPose" THEN
                SocketSend client_socket \Str:=("moveToPose started" + "\0A");
                current_state := "moveToPose";
            ELSEIF received_str = "moveAngle" THEN
                SocketSend client_socket \Str:=("moveAngle started" + "\0A");
                current_state := "moveAngle";
            ELSEIF received_str = "conveyorRunOn" THEN
                SocketSend client_socket \Str:=("conveyor turned on" + "\0A");
                current_state := "conOn";
            ELSEIF received_str = "conveyorRunOff" THEN
                SocketSend client_socket \Str:=("conveyor turned off" + "\0A");
                current_state := "conOff";
            ELSEIF received_str = "conveyorReverseOn" THEN
                SocketSend client_socket \Str:=("conveyor reverse on" + "\0A");
                current_state := "conReverseOn";
            ELSEIF received_str = "conveyorReverseOff" THEN
                SocketSend client_socket \Str:=("conveyor reverse off" + "\0A");
                current_state := "conReverseOff";
            ELSEIF received_str = "enableConveyorOn" THEN
                SocketSend client_socket \Str:=("conveyor enabled" + "\0A");
                current_state := "conEnabled";
            ELSEIF received_str = "enableConveyorOff" THEN
                SocketSend client_socket \Str:=("conveyor disabled" + "\0A");
                current_state := "conDisabled";
            ELSEIF received_str = "vacuumSolenoidOn" THEN
                SocketSend client_socket \Str:=("vaccum solenoid on" + "\0A");
                current_state := "vacSolOn";
            ELSEIF received_str = "vacuumSolenoidOff" THEN
                SocketSend client_socket \Str:=("vacuum solenoid off" + "\0A");
                current_state := "vacSolOff";
            ELSEIF received_str = "vacuumPumpOn" THEN
                SocketSend client_socket \Str:=("vacuum pump on" + "\0A");
                current_state := "vacPumpOn";
            ELSEIF received_str = "vacuumPumpOff" THEN
                SocketSend client_socket \Str:=("vacuum pump off" + "\0A");
                current_state := "vacPumpOff";
            ELSE
                SocketSend client_socket \Str:=("unknown comand" + "\0A"); 
                current_state := "unknown";
            ENDIF
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