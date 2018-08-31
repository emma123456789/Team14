% Script to communicate with IRB120 robot system
% Mark Whitty, Zhihao Zhang
% 140324
function MTRN4230_Client_Sample

jogVelocity = 60;
velStr = num2str(jogVelocity);
jogXVel = strcat('jogX',velStr);

% The robot's IP address.
%robot_IP_address = '192.168.125.1'; % Real robot ip address
robot_IP_address = '127.0.0.1'; % Simulation ip address

% The port that the robot will be listening on. This must be the same as in
% your RAPID program.
robot_port = 1025;

% Open a TCP connection to the robot.
socket = tcpip(robot_IP_address, robot_port);
set(socket, 'ReadAsyncMode', 'continuous');
fopen(socket);

% Check if the connection is valid.+6

if(~isequal(get(socket, 'Status'), 'open'))
    warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
    return;
end


% Send a sample string to the server on the robot.
fwrite(socket, jogXVel);
% fwrite(socket, 'jogX \n');


% Read a line from the socket. Note the line feed appended to the message in the RADID sample code.
data = fgetl(socket);

% Print the data that we got.
fprintf(char(data));

% Close the socket.
fclose(socket);