MODULE MTRN4230_Server_Sample    

    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    PERS string host := "127.0.0.1";
    PERS string current_state;
    CONST num port := 1025;
    
    PROC Main ()
        IF RobOS() THEN
            host := "192.168.125.1";
        ELSE
            host := "127.0.0.1";
        ENDIF
        MainServer;
        
    ENDPROC

    PROC MainServer()
        
        VAR string received_str;
        !VAR bool isJogging;
        
        ListenForAndAcceptConnection;
            
        ! Receive a string from the client.
        SocketReceive client_socket \Str:=received_str;
        !PERS matlab_str := received_str;
        IF received_str = "jogX" THEN
            SocketSend client_socket \Str:=("jogX started" + "\0A");
            current_state := "jogX";
        ELSEIF received_str = "jogY" THEN 
            SocketSend client_socket \Str:=("jogY started" + "\0A"); 
            current_state := "jogY";
        ELSEIF received_str = "jogZ" THEN
            SocketSend client_socket \Str:=("jogZ started" + "\0A");
            current_state := "jogZ";
        ELSEIF received_str = "jog1" THEN
            SocketSend client_socket \Str:=("jog1 started" + "\0A");
            current_state := "jog1";
        ELSEIF received_str = "moveToPose" THEN
            SocketSend client_socket \Str:=("moveToPose started" + "\0A");
            current_state := "moveToPose";
        ELSEIF received_str = "moveAngle" THEN
            SocketSend client_socket \Str:=("moveAngle started" + "\0A");
            current_state := "moveAngle";
        ELSE
            SocketSend client_socket \Str:=("unknown comand" + "\0A"); 
            current_state := "unknown";
        ENDIF
        ! Send the string back to the client, adding a line feed character.
        !SocketSend client_socket \Str:=(received_str + "\0A");

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