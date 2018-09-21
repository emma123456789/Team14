
% real_robot_IP_address = '192.168.125.1'; % Real robot ip address
sim_robot_IP_address = '127.0.0.1'; % Simulation ip address

robot_port = 1025;

% DIO (Hint: Test DIO)
fprint('Turning Vaccum Pump On');
fwrite(socket,'vacuumPumpOn');
pause(2);
fprint('Turning Vaccum Solenoid On');
fwrite(socket,'vacuumSolenoidOn');
pause(2);
fprint('Turning Vaccum Solenoid Off');
fwrite(socket,'vacuumSolenoidOff');
pause(2);
fprint('Turning Vaccum Pump Off');
fwrite(socket,'vacuumPumpOff');
pause(2);
fprint('Turning Conveyor Run On');
fwrite(socket,'conveyorRunOn');
pause(2);
fprint('Reversing Conveyor');
fwrite(socket,'conveyorReverseOn');
pause(2);
fprint('Reversing Conveyor again');
fwrite(socket,'conveyorReverseOff');
pause(2);
fprint('Turning Conveyor Off');
fwrite(socket,'conveyorRunOff');
pause(2);
