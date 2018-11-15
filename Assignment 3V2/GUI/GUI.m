% Main GUI interface for Assignment 2

function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
    % See also: GUIDE, GUIDATA, GUIHANDLES
     % Edit the above text to modify the response to help GUI
     % Last Modified by GUIDE v2.5 16-Nov-2018 01:18:05
     % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
     if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT
end

 % --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to GUI (see VARARGIN)
    % Choose default command line output for GUI
     
    % Stop and delete all existing timers
    try
        stop(timerfind());
        delete(timerfind());
    catch
    end
    
    handles.output = hObject;
    
    %declaring global variables 
    global tableParam tableImagePoints tableWorldPoints
    global convParam convImagePoints convWorldPoints

    %load respective table and conveyor structs
    tableParam = load('cameraParams_table.mat');
    tableImagePoints = load('tableImagePoints.mat');
    tableWorldPoints = load('tableWorldPoints.mat');

    convParam = load('cameraParams_conveyor.mat');
    convImagePoints = load('convImagePoints.mat');
    convWorldPoints = load('convWorldPoints.mat');

    global vid;
    global vid2;
    global OG;
    global testflag;
    testflag =1;
    global MODE;% simulation or real? make sure anything that requires hardware to be connected checks if the mode is imulation first.
    MODE = 'r';

     OG = zeros(9,11);
    % Choose default command line output for tictactoe
    handles.plr=1;
    handles.box=[0 0 0;0 0 0;0 0 0];
    set(handles.currentPlayer, 'String','Next: Player 1');
    handles.counter=1;
    global record;
    record = cell.empty();
    
     % Update handles structure
    guidata(hObject, handles);
    
     % Create the linked list for the queues
    import java.util.LinkedList;
    
    % Setup global variables
    global queue;
    global status_queue;
    global s_timer;
    global r_timer;
    global command_flag;
    global done_flag
    global g_handles;
    global real_robot_IP_address;
    global sim_robot_IP_address;
    global robot_port; 
    global poseMode;
    global poseSpeed;
    global joggingSpeed;
    global eeX eeY eeZ eeROLL eePITCH eeYAW;
    global jaQ1 jaQ2 jaQ3 jaQ4 jaQ5 jaQ6;
	global boxX boxY;
	global condition;
   
    % Initialise the global variables
    poseMode = 1;
    poseSpeed = 'Slow'; joggingSpeed = 'Slow';
    eeX = 0; eeY = 0; eeZ = 0; eeROLL = 0; eePITCH = 0; eeYAW = 0;
    jaQ1 = 0; jaQ2 = 0; jaQ3 = 0; jaQ4 = 0; jaQ5 = 0; jaQ6 = 0;
    queue = LinkedList();
    status_queue = LinkedList();
	boxX = 0; boxY = 409;
	condition = 0;
    
    % Initialise timers
    s_timer = timer;
    s_timer.TimerFcn = @sendTimer;
    s_timer.period = 0.1;
    s_timer.ExecutionMode = 'fixedSpacing';
    r_timer = timer;
    r_timer.TimerFcn = @receiveTimer;
    r_timer.period = 0.1;
    r_timer.ExecutionMode = 'fixedSpacing';
    
    % Set the command flag to 1 when opening gui
    command_flag = 1;
    done_flag = 1;
    
    % Get a copy of handles
    g_handles = handles;
    
    % Define the robot's address
    real_robot_IP_address = '192.168.125.1'; % Real robot ip address
    sim_robot_IP_address = '127.0.0.1'; % Simulation ip address
    
    % Define the port that the robot will be listening on
    robot_port = 1025;
    
    % Define table and conveyor data of blocks
    global tableBlockData
    global conveyorBlockData
    global fTableBlockData
    % initially create an empty string array
    tableBlockData = strings(0);
    conveyorBlockData = strings(0);
    fTableBlockData = strings(0);
    
    
    
%         axes(g_handles.TableCamera);
%         axes(g_handles.ConveyorCamera);
%         vid = videoinput('winvideo',1, 'MJPG_1600x1200'); 
%         video_resolution1 = vid.VideoResolution;
%         nbands1 = vid.NumberOfBands;
%         vid2 = videoinput('winvideo',2,'MJPG_1600x1200'); 
%         video_resolution2 = vid2.VideoResolution;
%         nbands2 = vid2.NumberOfBands;
% 
%         % sguideet image handle
%         hImage=image(zeros([video_resolution1(2), video_resolution1(1), nbands1]),'Parent',g_handles.TableCamera);
%         hImage2=image(zeros([video_resolution2(2), video_resolution2(1), nbands2]),'Parent',g_handles.ConveyorCamera);
%         preview(vid,hImage);
% 
%         preview(vid2,hImage2);
    
end
 
 % --- Executes when send timer is called
 function sendTimer(obj, event)
    % Setup global variables
	global command_flag;
    global done_flag;
	global status_queue;
    global queue;
    
    % Send pause/resume/cancel/shutdown instantly when they are pressed
	if (status_queue.size()>0)
		send_priorityString();
	% Otherwise send the command string when the flag is on	
	elseif (command_flag == 1 && done_flag == 1 && queue.size()>0)
        send_string();
        done_flag = 0;
 	end
    
 end

 % --- Executes when receive timer is called
 function receiveTimer(obj, event)
%   % Setup global variables
	global command_flag;
    
    % Call the receive function and return the message for future use
	response = receive_string();
    
 end
 
 % --- Executes when we need to stop the timers and clear the queue
 function error_handling()
	global s_timer;
	global r_timer;
	global queue;
	
	% Clear the command queue
	queue.clear();
    
%    Try stopping timers and if they have been stopped, delete them
 	try
		% Stop the timers	
		stop(s_timer);
		stop(r_timer);
        % Delete the timers
		delete(timerfindall);
        clear r_timer;
        clear s_timer;
	catch
		delete(timerfindall);
        clear r_timer;
        clear s_timer;
	end
 end
 
 % --- Executes when we need to send a command to the robot
 function send_string()
	% Setup global variables
	global queue;
	global socket;
	global g_handles;
    global command_flag;
    global done_flag;
    
    % Check if there is anything in the command queue
    if queue.size()>0
		% Obtain the fist command in the linkedlist
		commandStr = queue.pop();
        
        % Try to write to the socket
        try
            
			fwrite(socket,commandStr);
			% Update Sent Message Log
			sentList = [{commandStr}; g_handles.SentMessages.String];
			set(g_handles.SentMessages, 'String', sentList);
		% If it fails, show connection error	
		catch
			set(g_handles.portNumber, 'String', 'Connection Error');
			set(g_handles.portNumber, 'BackgroundColor', [1 0 0]);
            % Stop sending messages
            command_flag = 0;
        end	
    end
    
 end
 
  % --- Executes when we need to send a pause/resume/cancel/shutdown to the robot
 function send_priorityString()
	% Setup global variables
	global status_queue;
	global socket;
	global g_handles;
    
    % Obtain the command in the queue
	criticalCommandStr = status_queue.pop();
    
    % Try to write to the socket.
	try
		fwrite(socket,criticalCommandStr);
        
		% Update Sent Priority Message Log
		sentList = [{criticalCommandStr}; g_handles.SentMessages.String];
		set(g_handles.SentMessages, 'String', sentList);
        
    % If it fails, show connection error    
	catch
		set(g_handles.portNumber, 'String', 'Connection Error');
		set(g_handles.portNumber, 'BackgroundColor', [1 0 0]);
	end
 end
 
 % --- Executes when we need to receive a message from the robot
 function response=receive_string()
	% Setup global variables
	global socket;
	global g_handles;
    global emergencyStop;
    global lightCurtain;
    global motorOn;
    global holdToEnable;
    global ExecutionError;
    global motorSupTriggered;
    global conveyorEnable;
    global command_flag;
    global done_flag;
	% Read from the socket if there's a message
    response = [];
    if (socket.BytesAvailable)
        response = fgetl(socket);
		
        % Get a copy of the message and split the message
		copy = response;
		copy_split = string(strsplit(copy));
        
        % Update Status
        if (strcmp(copy,'Done'))
            done_flag = 1;
            
        elseif (strcmp(copy_split(1),'jointAngle'))
            % Update joint angle status
            set(g_handles.Joint1Status,'string',copy_split(2));
            set(g_handles.Joint2Status,'string',copy_split(3));
            set(g_handles.Joint3Status,'string',copy_split(4));
            set(g_handles.Joint4Status,'string',copy_split(5));
            set(g_handles.Joint5Status,'string',copy_split(6));
            set(g_handles.Joint6Status,'string',copy_split(7));
            
        elseif (strcmp(copy_split(1),'endEffector'))   
            % Update end effector status
            set(g_handles.XStatus,'string',copy_split(2));
            set(g_handles.YStatus,'string',copy_split(3));
            set(g_handles.ZStatus,'string',copy_split(4));
            set(g_handles.rollStatus,'string',copy_split(5));
            set(g_handles.pitchStatus,'string',copy_split(6));
            set(g_handles.yawStatus,'string',copy_split(7));
            
        elseif (strcmp(copy_split(1),'DIO'))
            % Update DIO status
            if (strcmp(copy_split(2),'1'))
                set(g_handles.EnableConveyorStatus,'string','Enable Conveyor On');
            elseif(strcmp(copy_split(2),'0'))
                set(g_handles.EnableConveyorStatus,'string','Enable Conveyor Off');
            else
                set(g_handles.EnableConveyorStatus,'string','Unknown');
            end
            
            if (strcmp(copy_split(3),'1'))
                set(g_handles.ConveyorRunStatus,'string','Conveyor Run On');
            elseif(strcmp(copy_split(3),'0'))
                set(g_handles.ConveyorRunStatus,'string','Conveyor Run Off');
            else
                set(g_handles.ConveyorRunStatus,'string','Unknown');
            end
            
            if (strcmp(copy_split(4),'1'))
                set(g_handles.ConveyorReverseStatus,'string','Conveyor Reverse On');
            elseif(strcmp(copy_split(4),'0'))
                set(g_handles.ConveyorReverseStatus,'string','Conveyor Reverse Off');
            else
                set(g_handles.ConveyorReverseStatus,'string','Unknown');
            end
            
            if (strcmp(copy_split(5),'1'))
                set(g_handles.VacuumPumpStatus,'string','Vacuum Pump On');
            elseif(strcmp(copy_split(5),'0'))
                set(g_handles.VacuumPumpStatus,'string','Vacuum Pump Off');
            else
                set(g_handles.VacuumPumpStatus,'string','Unknown');
            end
            
            if (strcmp(copy_split(6),'1'))
                set(g_handles.VacuumSolenoidStatus,'string','Vacuum Solenoid On');
            elseif(strcmp(copy_split(6),'0'))
                set(g_handles.VacuumSolenoidStatus,'string','Vacuum Solenoid Off');
            else
                set(g_handles.VacuumSolenoidStatus,'string','Unknown');
            end
            
        elseif (strcmp(copy_split(1),'Error'))
            % Get error flags
            emergencyStop = copy_split(2);
            lightCurtain = copy_split(3);
            motorOn = copy_split(4);
            holdToEnable = copy_split(5);
            ExecutionError = copy_split(6);
            motorSupTriggered = copy_split(7);
            conveyorEnable = copy_split(8);
            
            % If any of the errors occur, turn on the error panel
            if (emergencyStop == '1' || lightCurtain == '0' || motorOn == '0' || holdToEnable == '0' || ExecutionError == '1' || motorSupTriggered == '1')
                set(g_handles.errorPanel,'Visible','On');
                command_flag = 0;
                
                % depending on the error, change the text colors
                if (emergencyStop == '1')
					set(g_handles.emergencyStop, 'BackgroundColor', [1 0 0]);
                elseif (lightCurtain=='0')
                    set(g_handles.lightCurtain, 'BackgroundColor', [1 0 0]);
                elseif (motorOn=='0')
                    set(g_handles.motorsAreOff, 'BackgroundColor', [1 0 0]);
                elseif (holdToEnable=='0')
                    set(g_handles.holdToEnableNotPressed, 'BackgroundColor', [1 0 0]);
                elseif (ExecutionError=='1')
                    set(g_handles.executionError, 'BackgroundColor', [1 0 0]);
                elseif (motorSupTriggered=='1')
                    set(g_handles.motionSupervisionTriggered, 'BackgroundColor', [1 0 0]);
                elseif(conveyorEnable=='0')
                    set(g_handles.conveyorNotEnabled, 'BackgroundColor', [1 0 0]);
                end
            end
            
        else

        end
            % Update Received Message Log
            receivedList = [{response}; g_handles.ReceivedMessages.String];
            set(g_handles.ReceivedMessages, 'String', receivedList);
    end
	
 end

 % --- Executes when we need to connect to robot
 function connectToRobot(buttonNo)
    % Setup global variables
	global socket;
	global real_robot_IP_address;
	global sim_robot_IP_address;
	global robot_port;
	global s_timer;
	global r_timer;
	global vid;
    global vid2;
    global g_handles;
    global MODE;
    if  MODE == 's'
        IP = sim_robot_IP_address;
    else
        IP = real_robot_IP_address;
    end
    
 	% Connect to the robot 	
	try
		% Open a TCP connection to the robot.
		socket = tcpip(IP, robot_port);
		set(socket, 'ReadAsyncMode', 'continuous');
		fopen(socket);
		
        % Print the IP address and port number on the screen
		str = sprintf(' IP: %s \n Port: %d',IP,robot_port);
		set(g_handles.portNumber, 'String', str);
		set(g_handles.portNumber, 'BackgroundColor', [0.94 0.94 0.94]);
		
        % If we try to connect in safety panel, start the timers
        %if (buttonNo == 1)
            start(s_timer);
            start(r_timer);
        %end
        
         % Start Cameras
	 %location the display of video feed'
     if MODE ~= 's' %Only start if we are not in simulation mode. change 's' to anything else if we have the robot
        axes(g_handles.TableCamera);
        axes(g_handles.ConveyorCamera);
        vid = videoinput('winvideo',1, 'MJPG_1600x1200'); 
        video_resolution1 = vid.VideoResolution;
        nbands1 = vid.NumberOfBands;
        vid2 = videoinput('winvideo',2,'MJPG_1600x1200'); 
        video_resolution2 = vid2.VideoResolution;
        nbands2 = vid2.NumberOfBands;

        % sguideet image handle
        hImage=image(zeros([video_resolution1(2), video_resolution1(1), nbands1]),'Parent',g_handles.TableCamera);
        hImage2=image(zeros([video_resolution2(2), video_resolution2(1), nbands2]),'Parent',g_handles.ConveyorCamera);
        preview(vid,hImage);
        src1 = getselectedsource(vid);
        src1.ExposureMode = 'manual';
        src1.Exposure = -4;
        preview(vid2,hImage2);
     end
     
     % Check if the connection is valid.+6
     if(~isequal(get(socket, 'Status'), 'open'))
        warning(['Could not open TCP connection to ', IP, ' on port ', robot_port]);
        return;
     end
    
    % Effectly changing 'screens'
    %set(g_handles.CameraPanel,'Visible','On');
    %set(g_handles.statusPanel,'Visible','On');
    %set(g_handles.DIOPanel,'Visible','On');
    %set(g_handles.RobotStatusPanel,'Visible','On');
    %set(g_handles.SafetyPanel,'Visible','Off');
    %set(g_handles.errorPanel,'Visible','Off');
    
    % If it fails to connect, return to the safety page and notify users
    catch error
         % Print out error messages on the command window
        fprintf(error.message);
        
        % Call error handling function
        error_handling();
        msgbox('Invalid Connection. Please reconnect.');
		
        % If we try to connect in the main gui window, and connection
        % fails, turn off the current windows and show the safety window
		if (buttonNo==2)

%             set(g_handles.CameraPanel,'Visible','Off');
% 			set(g_handles.statusPanel,'Visible','Off');
% 			set(g_handles.DIOPanel,'Visible','Off');
% 			set(g_handles.RobotStatusPanel,'Visible','Off');
% 			set(g_handles.SafetyPanel,'Visible','On');
%             set(g_handles.errorPanel,'Visible','Off');
		end
		
	end
 end

 % --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
    varargout{1} = handles.output;
end

 % --- Executes on button press in VacuumPump.
function VacuumPump_Callback(hObject, eventdata, handles)
    global queue;
% hObject    handle to VacuumPump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% HINT: get(hObject,'Value') returns toggle status of togglebutton1
 
    VacuumPumpValue = get(hObject,'Value');
    if VacuumPumpValue == 1 % check if vacuum pump button is pressed on
		commandStr = 'vacuumPumpOn'; % send string to indicate vacuum pump on
		queue.add(commandStr); % and add to queue
    else
		commandStr = 'vacuumPumpOff'; % send string to indicate vacuum pump off
		queue.add(commandStr); % and add to queue
    end
end

 % --- Executes on button press in VacuumSolenoid.
function VacuumSolenoid_Callback(hObject, eventdata, handles)
    global queue;
% hObject    handle to VacuumSolenoid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% HINT: get(hObject,'Value') returns toggle status of togglebutton1

    VacuumSolenoidValue = get(hObject,'Value');
    if VacuumSolenoidValue == 1 % check if vacuum solenoid button is pressed on
		commandStr = 'vacuumSolenoidOn'; % send string to indicate vacuum solenoid on
		queue.add(commandStr); % and add to queue
    else
		commandStr = 'vacuumSolenoidOff'; % send string to indicate vacuum solenoid off
		queue.add(commandStr); % and add to queue
    end
end

 % --- Executes on button press in ConveyorRun.
function ConveyorRun_Callback(hObject, eventdata, handles)
    global queue;
% hObject    handle to ConveyorRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % HINT: get(hObject,'Value') returns toggle status of togglebutton1
    ConveyorRunValue = get(hObject,'Value');
    if ConveyorRunValue == 1 % check if conveyor run button is pressed on
		commandStr = 'conveyorRunOn'; % send string to indicate conveyor run on
		queue.add(commandStr); % and add to queue
    else
		commandStr = 'conveyorRunOff'; % send string to indicate conveyor run off
		queue.add(commandStr); % and add to queue
    end
end    

 % --- Executes on button press in ConveyorReverse.
function ConveyorReverse_Callback(hObject, eventdata, handles)
    global queue;
% hObject    handle to ConveyorReverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % HINT: get(hObject,'Value') returns toggle status of togglebutton1
    ConveyorReverseValue = get(hObject,'Value');
    if ConveyorReverseValue == 1 % check if conveyor reverse button is pressed on
		commandStr = 'conveyorReverseOn'; % send string to indicate conveyor reverse on
		queue.add(commandStr); % and add to queue
    else
		commandStr = 'conveyorReverseOff'; % send string to indicate conveyor reverse off
		queue.add(commandStr); % and add to queue
    end
end

 % --- Executes on button press in Resume.
function Resume_Callback(hObject, eventdata, handles)
    global status_queue;
    global command_flag;
    % hObject    handle to Resume (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    commandStr = 'resume';
    status_queue.add(commandStr); % add resume message to the queue
    % Resume sending commands to the robot by changing the flag
    command_flag = 1;
end
 
 % --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
    global status_queue;
    global command_flag;
    % hObject    handle to Pause (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    commandStr = 'pause';
    status_queue.add(commandStr); % add pause message to the status queue
     % Stop sending commands to the robot by changing the flag
    command_flag = 0;
end
 
% Sent Messages contains all messages sent from GUI and MATLAB to
% RobotStudio
 % --- Executes on selection change in SentMessages.
function SentMessages_Callback(hObject, eventdata, handles)
% hObject    handle to SentMessages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns SentMessages contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SentMessages
end
 
 % --- Executes during object creation, after setting all properties.
function SentMessages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SentMessages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Sent Messages contains all messages received on MATLAB from RobotStudio
 % --- Executes on selection change in ReceivedMessages.
function ReceivedMessages_Callback(hObject, eventdata, handles)
% hObject    handle to ReceivedMessages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns ReceivedMessages contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ReceivedMessages
end

 % --- Executes during object creation, after setting all properties.
function ReceivedMessages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReceivedMessages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 % --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
    global status_queue;
    % hObject    handle to Cancel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    commandStr = 'cancel'; % Send string to indicate cancel command
    status_queue.add(commandStr); % and add to queue
end
 
 % --- Executes on button press in SafetyConfimation.
function SafetyConfimation_Callback(hObject, eventdata, handles)
% hObject    handle to SafetyConfimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Define the button number
	buttonNo = 1;
    
    % Obtain the SWP status through handles
    SWP = SWPGET(handles);
    zero = find(SWP ~= 1);
    if (isempty(zero))		
		% If all check boxes are clicked, try to connect to the robot
		connectToRobot(buttonNo);
	
    else
        % Otherwise, ask users to check all boxes
        msgbox('PLEASE READ AND CHECK ALL BOXES');
    end
end    

 % --- Executes on button press in Decline.
function Decline_Callback(hObject, eventdata, handles)
% hObject    handle to Decline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close all; % If decline button is pressed, then close GUI
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP1.
function SWP1_Callback(hObject, eventdata, handles)
% hObject    handle to SWP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP1
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP2.
function SWP2_Callback(hObject, eventdata, handles)
% hObject    handle to SWP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP2
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP3.
function SWP3_Callback(hObject, eventdata, handles)
% hObject    handle to SWP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP3
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP4.
function SWP4_Callback(hObject, eventdata, handles)
% hObject    handle to SWP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP4
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP5.
function SWP5_Callback(hObject, eventdata, handles)
% hObject    handle to SWP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP5
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP6.
function SWP6_Callback(hObject, eventdata, handles)
% hObject    handle to SWP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP6
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP7.
function SWP7_Callback(hObject, eventdata, handles)
% hObject    handle to SWP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP7
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP8.
function SWP8_Callback(hObject, eventdata, handles)
% hObject    handle to SWP8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP8
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP9.
function SWP9_Callback(hObject, eventdata, handles)
% hObject    handle to SWP9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP9
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP10.
function SWP10_Callback(hObject, eventdata, handles)
% hObject    handle to SWP10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP10
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP11.
function SWP11_Callback(hObject, eventdata, handles)
% hObject    handle to SWP11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP11
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP12.
function SWP12_Callback(hObject, eventdata, handles)
% hObject    handle to SWP12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP12
end

% Safe Work Procedure checklist
 % --- Executes on button press in SWP13.
function SWP13_Callback(hObject, eventdata, handles)
% hObject    handle to SWP13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of SWP13
end

% Function to check if all Safety Work Procedures are checked 
function value = SWPGET(handles)
    value(1) = get(handles.SWP1,'Value'); % Find value of each SWP checkbox
    value(2) = get(handles.SWP2,'Value');
    value(3) = get(handles.SWP3,'Value');
    value(4) = get(handles.SWP4,'Value');
    value(5) = get(handles.SWP5,'Value');
    value(6) = get(handles.SWP6,'Value');
    value(7) = get(handles.SWP7,'Value');
    value(8) = get(handles.SWP8,'Value');
    value(9) = get(handles.SWP9,'Value');
    value(10) = get(handles.SWP10,'Value');
    value(11) = get(handles.SWP11,'Value');
    value(12) = get(handles.SWP12,'Value');
    value(13) = get(handles.SWP13,'Value');
end  

 % --- Executes on button press in SecretButton. (For testing)
function SecretButton_Callback(hObject, eventdata, handles)
    global socket;
    global real_robot_IP_address;
    global sim_robot_IP_address;
    global robot_port;
    global s_timer;
    global r_timer;
    global vid;
    global vid2;
% hObject    handle to SecretButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)	
 	
	% Go to the main panel but don't connect to the robot
    % Open a TCP connection to the robot.
    socket = tcpip(real_robot_IP_address, robot_port);
    set(socket, 'ReadAsyncMode', 'continuous');
% 	fopen(socket);
    start(s_timer);
    start(r_timer);

    % Effectly changing 'screens'
    set(handles.CameraPanel,'Visible','On');
    set(handles.statusPanel,'Visible','On');
    set(handles.ComplexMovePanel,'Visible','On');
    set(handles.RobotStatusPanel,'Visible','On');
    set(handles.SafetyPanel,'Visible','Off');
    set(handles.errorPanel,'Visible','Off');
end


function endEffectorX_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of endEffectorX as text
% str2double(get(hObject,'String')) returns contents of endEffectorX as a double
    global eeX;
    eeX = str2double(get(hObject, 'String'));
end

 % --- Executes during object creation, after setting all properties.
function endEffectorX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 % --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

 % --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 function endEffectorY_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of endEffectorY as text
%        str2double(get(hObject,'String')) returns contents of endEffectorY as a double
    global eeY;
    eeY = str2double(get(hObject, 'String'));
end

 % --- Executes during object creation, after setting all properties.
function endEffectorY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 function endEffectorZ_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of endEffectorZ as text
%        str2double(get(hObject,'String')) returns contents of endEffectorZ as a double
    global eeZ;
    eeZ = str2double(get(hObject, 'String'));
end

 % --- Executes during object creation, after setting all properties.
function endEffectorZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 function endEffectorYaw_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorYaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of endEffectorYaw as text
%        str2double(get(hObject,'String')) returns contents of endEffectorYaw as a double
    global eeYAW;
    eeYAW = str2double(get(hObject, 'String'));
end

 % --- Executes during object creation, after setting all properties.
function endEffectorYaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorYaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 function endEffectorPitch_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of endEffectorPitch as text
%        str2double(get(hObject,'String')) returns contents of endEffectorPitch as a double
    global eePITCH;
    eePITCH = str2double(get(hObject, 'String'));
end

 % --- Executes during object creation, after setting all properties.
function endEffectorPitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function endEffectorRoll_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorRoll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of endEffectorRoll as text
%        str2double(get(hObject,'String')) returns contents of endEffectorRoll as a double
    global eeROLL;
    eeROLL = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function endEffectorRoll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorRoll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ6_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ3 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ3 as a double
    global jaQ6;
    jaQ6 = str2double(get(hObject, 'String'));
end

function jointAngleQ6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ5_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ5 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ5 as a double
    global jaQ5;
    jaQ5 = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function jointAngleQ5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ4_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ4 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ4 as a double
    global jaQ4;
    jaQ4 = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function jointAngleQ4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ3_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ3 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ3 as a double
    global jaQ3;
    jaQ3 = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function jointAngleQ3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ2_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ2 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ2 as a double
    global jaQ2;
    jaQ2 = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function jointAngleQ2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function jointAngleQ1_Callback(hObject, eventdata, handles)
% hObject    handle to jointAngleQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of jointAngleQ1 as text
%        str2double(get(hObject,'String')) returns contents of jointAngleQ1 as a double
    global jaQ1;
    jaQ1 = str2double(get(hObject, 'String'));
end

% --- Executes during object creation, after setting all properties.
function jointAngleQ1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointAngleQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
end

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in poseMode.
function poseMode_Callback(hObject, eventdata, handles)
% hObject    handle to poseMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns poseMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poseMode
	str = get(hObject, 'String');
	val = get(hObject, 'Value');
	global poseMode;
 	switch string(str(val)) % decide which pose mode is chosen
		case 'End Effector rel Conveyor'
			poseMode = 1;
		case 'End Effector rel Table'
			poseMode = 2;
		case 'Joint Angles'
			poseMode = 3;
		case 'Reorient End Effector'
			poseMode = 4;
	end
end

% --- Executes during object creation, after setting all properties.
function poseMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poseMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in poseSpeed.
function poseSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to poseSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns poseSpeed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poseSpeed
	global poseSpeed;
	str = get(hObject, 'String');
	val = get(hObject, 'Value');
	poseSpeed = string(str(val));
end

% --- Executes during object creation, after setting all properties.
function poseSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poseSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in endEffectorXpos.
function endEffectorXpos_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorXpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    % Initialise the speed
    j_Speed = 'v50';
    switch joggingSpeed % Define the speed according to the speed chosen
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
    
    % Check the button reading
    endEffectorXposValue = get(hObject,'Value');
    
    % If the value is 1, start jogging. Otherwise, stop jogging
    if endEffectorXposValue == 1
		commandStr = sprintf('endEffectorXposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorXposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

% --- Executes on button press in endEffectorXneg.
function endEffectorXneg_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorXneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed % decide which speed is chosen
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
     endEffectorXnegValue = get(hObject,'Value');
    if endEffectorXnegValue == 1
		commandStr = sprintf('endEffectorXnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorXnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

% --- Executes on button press in endEffectorYpos.
function endEffectorYpos_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorYpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed % Decide which speed is chosen by user
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
     endEffectorYposValue = get(hObject,'Value');
    if endEffectorYposValue == 1
		commandStr = sprintf('endEffectorYposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorYposEND %s',j_Speed);
		queue.add(commandStr);
    end
end
 
 % --- Executes on button press in endEffectorZpos.
function endEffectorZpos_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorZpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed % Decide which speed is chosen
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
     endEffectorZposValue = get(hObject,'Value');
    if endEffectorZposValue == 1
		commandStr = sprintf('endEffectorZposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorZposEND %s',j_Speed);
		queue.add(commandStr);
    end
end
 
 % --- Executes on button press in endEffectorZneg.
function endEffectorZneg_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorZneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
     endEffectorZnegValue = get(hObject,'Value');
    if endEffectorZnegValue == 1
		commandStr = sprintf('endEffectorZnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorZnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end
 
 % --- Executes on button press in endEffectorYneg.
function endEffectorYneg_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorYneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end    
     endEffectorYnegValue = get(hObject,'Value');
    if endEffectorYnegValue == 1
		commandStr = sprintf('endEffectorYnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('endEffectorYnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end
 
 % --- Executes on selection change in joggingSpeed.
function joggingSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to joggingSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns joggingSpeed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from joggingSpeed
	global joggingSpeed;
	str = get(hObject, 'String');
	val = get(hObject, 'Value');
	joggingSpeed = string(str(val));
    
end

 % --- Executes during object creation, after setting all properties.
function joggingSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joggingSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 % --- Executes on button press in moveRobot.
function moveRobot_Callback(hObject, eventdata, handles)
    global queue;
    global poseMode;
    global poseSpeed;
    global eeX eeY eeZ eeROLL eePITCH eeYAW;
    global jaQ1 jaQ2 jaQ3 jaQ4 jaQ5 jaQ6;

% hObject    handle to moveRobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 	speed = 'v50';
	
    % Obtain the speed seleted and define the speed
	switch poseSpeed
		case 'Slow'
			speed = 'v50';
		case 'Regular'
			speed = 'v100';
		case 'Fast'
			speed = 'v500';
	end
	
	% Check which mode is seleted
	switch poseMode
		case 1
			eex = eeX;
			eey = eeY;
			eez = eeZ;
            roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
			
	        commandStr = sprintf('moveerc %.3f %.3f %.3f %.3f %.3f %.3f %s', eex,eey,eez,roll,pitch,yaw,speed);
	        queue.add(commandStr);
		case 2
			eex = eeX;
			eey = eeY;
			eez = eeZ;
			roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
            commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', eex,eey,eez,roll,pitch,yaw,speed);
            queue.add(commandStr);
		case 3
			q1 = jaQ1;
			q2 = jaQ2;
			q3 = jaQ3;
			q4 = jaQ4;
			q5 = jaQ5;
			q6 = jaQ6;
            commandStr = sprintf('movejas %.3f %.3f %.3f %.3f %.3f %.3f %s', q1,q2,q3,q4,q5,q6,speed);
            queue.add(commandStr);
		case 4
			roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
            commandStr = sprintf('moveree %.3f %.3f %.3f %s', roll,pitch,yaw,speed);
            queue.add(commandStr);
	end
end
 
 % --- Executes on selection change in joggingMode.
function joggingMode_Callback(hObject, eventdata, handles)
% hObject    handle to joggingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hints: contents = cellstr(get(hObject,'String')) returns joggingMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from joggingMode
    contents = cellstr(get(hObject,'String')); % find which jogging Mode is selected in popup menu
    joggingModeValue = contents{get(hObject,'Value')};
    % Change visibility of panels according to which jogging Mode is
    % selected
    if (strcmp(joggingModeValue,'End Effector rel Base Frame'))
        set(handles.SimpleMovePanel,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.endEffectorFrameMode,'Visible','Off');
        set(handles.baseFrameMode,'Visible','On');
    elseif(strcmp(joggingModeValue,'End Effector rel End Effector Frame'))
        set(handles.SimpleMovePanel,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.endEffectorFrameMode,'Visible','On');
        set(handles.baseFrameMode,'Visible','Off');
    elseif (strcmp(joggingModeValue,'Joint Angles'))
        set(handles.SimpleMovePanel,'Visible','Off');
        set(handles.jointMode,'Visible','On');
        set(handles.endEffectorFrameMode,'Visible','Off');
        set(handles.baseFrameMode,'Visible','Off');
    elseif (strcmp(joggingModeValue,'Reorient End Effector'))
        set(handles.SimpleMovePanel,'Visible','On');
        set(handles.jointMode,'Visible','Off');
        set(handles.endEffectorFrameMode,'Visible','Off');
        set(handles.baseFrameMode,'Visible','Off');
    end 
end
 
 % --- Executes during object creation, after setting all properties.
function joggingMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joggingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 % --- Executes on button press in jogQ6neg.
function jogQ6neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ6neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed % Decide on which jogging speed is chosen
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
    
    jogQ6negValue = get(hObject,'Value');
    if jogQ6negValue == 1
		commandStr = sprintf('jogQ6negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ6negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ6pos.
function jogQ6pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ6pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
    
    
    jogQ6posValue = get(hObject,'Value');
    if jogQ6posValue == 1
		commandStr = sprintf('jogQ6posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ6posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ5neg.
function jogQ5neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ5neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
    
    jogQ5negValue = get(hObject,'Value');
    if jogQ5negValue == 1
		commandStr = sprintf('jogQ5negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ5negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ5pos.
function jogQ5pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ5pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed % Decide on which jogging speed is chosen
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end
     jogQ5posValue = get(hObject,'Value');
    if jogQ5posValue == 1
		commandStr = sprintf('jogQ5posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ5posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ4neg.
function jogQ4neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ4neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end    
    
    jogQ4negValue = get(hObject,'Value');
    if jogQ4negValue == 1
		commandStr = sprintf('jogQ4negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ4negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ4pos.
function jogQ4pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ4pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end     
    
    jogQ4posValue = get(hObject,'Value');
    if jogQ4posValue == 1
		commandStr = sprintf('jogQ4posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ4posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ3neg.
function jogQ3neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ3neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end     
    
    jogQ3negValue = get(hObject,'Value');
    if jogQ3negValue == 1
		commandStr = sprintf('jogQ3negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ3negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ3pos.
function jogQ3pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ3pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end     
    
    jogQ3posValue = get(hObject,'Value');
    if jogQ3posValue == 1
		commandStr = sprintf('jogQ3posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ3posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ2neg.
function jogQ2neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ2neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end       
    
    jogQ2negValue = get(hObject,'Value');
    if jogQ2negValue == 1
		commandStr = sprintf('jogQ2negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ2negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ2pos.
function jogQ2pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ2pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogQ2posValue = get(hObject,'Value');
    if jogQ2posValue == 1
		commandStr = sprintf('jogQ2posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ2posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ1neg.
function jogQ1neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ1neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogQ1negValue = get(hObject,'Value');
    if jogQ1negValue == 1
		commandStr = sprintf('jogQ1negSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ1negEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogQ1pos.
function jogQ1pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ1pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogQ1posValue = get(hObject,'Value');
    if jogQ1posValue == 1
		commandStr = sprintf('jogQ1posSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogQ1posEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogYAWneg.
function jogYAWneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogYAWneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogYAWnegValue = get(hObject,'Value');
    if jogYAWnegValue == 1
		commandStr = sprintf('jogYAWnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogYAWnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogYAWpos.
function jogYAWpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogYAWpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogYAWposValue = get(hObject,'Value');
    if jogYAWposValue == 1
		commandStr = sprintf('jogYAWposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogYAWposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogPITCHneg.
function jogPITCHneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogPITCHneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogPITCHnegValue = get(hObject,'Value');
    if jogPITCHnegValue == 1
		commandStr = sprintf('jogPITCHnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogPITCHnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogPITCHpos.
function jogPITCHpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogPITCHpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogPITCHposValue = get(hObject,'Value');
    if jogPITCHposValue == 1
		commandStr = sprintf('jogPITCHposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogPITCHposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogROLLneg.
function jogROLLneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogROLLneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogROLLnegValue = get(hObject,'Value');
    if jogROLLnegValue == 1
		commandStr = sprintf('jogROLLnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogROLLnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in jogROLLpos.
function jogROLLpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogROLLpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end   
    
    jogROLLposValue = get(hObject,'Value');
    if jogROLLposValue == 1
		commandStr = sprintf('jogROLLposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('jogROLLposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in connectToPort.
function connectToPort_Callback(hObject, eventdata, handles)
% hObject    handle to connectToPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Define the button number
    buttonNo = 2;
    % Call connect to robot function and pass in the button number
    connectToRobot(buttonNo);
end
 
 % --- Executes on button press in Shutdown.
function Shutdown_Callback(hObject, eventdata, handles)
    global status_queue;
    % hObject    handle to Shutdown (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    commandStr = 'shutdown'; % Send command to shutdown robot
    status_queue.add(commandStr);
    pause(5); % pause to send messages before timers are stopped
    error_handling(); % Handle all errors when shutting down
    close all; % Close down all GUI
end
 
 % --- Executes on button press in baseFrameXpos.
function baseFrameXpos_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameXpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end     
    
    baseFrameXposValue = get(hObject,'Value');
    if baseFrameXposValue == 1
		commandStr = sprintf('baseFrameXposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameXposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in baseFrameYpos.
function baseFrameYpos_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameYpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end     
     baseFrameYposValue = get(hObject,'Value');
    if baseFrameYposValue == 1
		commandStr = sprintf('baseFrameYposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameYposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in baseFrameZpos.
function baseFrameZpos_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameZpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end 
    
    baseFrameZposValue = get(hObject,'Value');
    if baseFrameZposValue == 1
		commandStr = sprintf('baseFrameZposSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameZposEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in baseFrameXneg.
function baseFrameXneg_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameXneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end 
    
    baseFrameXnegValue = get(hObject,'Value');
    if baseFrameXnegValue == 1
		commandStr = sprintf('baseFrameXnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameXnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in baseFrameYneg.
function baseFrameYneg_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameYneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end 
     baseFrameYnegValue = get(hObject,'Value');
    if baseFrameYnegValue == 1
		commandStr = sprintf('baseFrameYnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameYnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in baseFrameZneg.
function baseFrameZneg_Callback(hObject, eventdata, handles)
% hObject    handle to baseFrameZneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    global joggingSpeed;
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end 
    
    baseFrameZnegValue = get(hObject,'Value');
    if baseFrameZnegValue == 1
		commandStr = sprintf('baseFrameZnegSTART %s',j_Speed);
		queue.add(commandStr);
    else
		commandStr = sprintf('baseFrameZnegEND %s',j_Speed);
		queue.add(commandStr);
    end
end

 % --- Executes on button press in TableCamSS.
 % --- Clicking on this sets the curser into a clicker for the user to
 % click within the specified camera frame
function TableCamSS_Callback(hObject, eventdata, handles)
% hObject    handle to TableCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of TableCamSS
    global eeX eeY eeZ
    
    [eeX, eeY, eeZ] = getTableXYZ(hObject,eventdata,handles);
    disp(eeX); disp(eeY); disp(eeZ);
end

 % --- Executes on button press in ConveyorCamSS.
 % --- Clicking on this sets the curser into a clicker for the user to
 % click within the specified camera frame
function ConveyorCamSS_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global eeX eeY eeZ
    
    [eeX, eeY, eeZ] = getConveyorXYZ(hObject,eventdata,handles);
    disp(eeX); disp(eeY); disp(eeZ);
end

% Hint: get(hObject,'Value') returns toggle state of ConveyorCamSS
function getBlocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReceivedMessages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

 % --- Executes on button press in getBox.
function getBox_Callback(hObject, eventdata, handles)
% hObject    handle to getBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global convParam convImagePoints convWorldPoints
    global vid2
    global Boxcentrod 
    global blockInfo 
    global conveyorBlockData
    global BoxX;
    global BoxY;
    %check the if button is pressed
    if get(hObject,'Value') == 1
       %get one frame from conveyor video feed and apply the edge and oritation detection of box
          snapshot = getsnapshot(vid2);
          box = snapshot;
%box = imread('4.jpg');
    figure(2);
 imshow(box); hold on;
    box1 = box;
    box1(:,1:600,:)=0;     %1:580
    box1(:,1180:1600,:)=0;  %1180:1600
    box1(710:1200,:,:)=0;   %710:1200
       
    greybox1 = rgb2gray(box1);
    bw = imbinarize(greybox1,0.4);   %0.5
  
    bw1 = ~bwareaopen(~bw,1000); 
    bw2 = ~bwareaopen(~bw,152000);
    bw3 = medfilt2(bw2,[10 10]);
    blackIndex = find(bw3==0);
    box2=rgb2gray(box);
    
    box2(blackIndex) =255;
    bw4 = imbinarize(box2,0.4); 
    bw4 =~bwareaopen(~bw4,1000); 
    
    bw5 = bwareaopen(bw4,800);
  
    
    Size1 = length(find(bw1));
    Size2 = length(find(bw2));
    
    if (Size1 <Size2)
        disp('Blocks detected');
    % detection of box
    bOrientation = regionprops('table',bw2,'Centroid','Image','Orientation');
    N= length(bOrientation.Orientation);
     for i= 1:N 
      if   (length(bOrientation.Image{i})>200)
     index=i;
      end
     end
    plot(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),'*');
    text(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),num2str(bOrientation.Orientation(index)),'Color','red','FontSize',20);
    contour(bw2,'r');
    
    %get centroid for box
    x=bOrientation.Centroid(index,1);
    y=bOrientation.Centroid(index,2);
    
    x = round(x);
    y = round(y);
    
    [R, T] = extrinsics(convImagePoints.imagePoints, convWorldPoints.worldPoints, convParam.ConvCameraParams);
    worldPoints = pointsToWorld(convParam.ConvCameraParams, R, T, [x y]);
    xTol=0; yTol=0;
    X = worldPoints(end,1)+xTol;
    Y = worldPoints(end,2)+yTol;
    x = round(X); 
    y = round(Y);
    BoxX = x;
    BoxY = y;
    a = sprintf('%.0f %.0f',x,y);
    Boxcentrod = a;
    
    %detect blocks in box
     
     [angles, position, letter, finalText] = useBlocks_conveyor(bw4,bw5);  
     
      % Constructing Final Array
    for i=1:length(angles)
        block = [position(i,1), position(i,2),... 
            angles(i), letter(i),...
            1];
        
        hold on 

        % Show the central and orientation of the block
        plot(position(i,1),position(i,2),'*');
        hold on
         if (block(5)==1)
             text(position(i,1)+30, position(i,2)+30, num2str(angles(i)*180/pi), 'Color','blue');
         else
             text(position(i,1)+30, position(i,2)+30, num2str(angles(i)*180/pi), 'Color','red');
         end   
        % change x y 
        x=position(i,1);
        y=position(i,2);
        [R, T] = extrinsics(convImagePoints.imagePoints, convWorldPoints.worldPoints, convParam.ConvCameraParams);
        worldPoints = pointsToWorld(convParam.ConvCameraParams, R, T, [x y]);
        xTol=0; yTol=0;
        X = worldPoints(end,1)+xTol;
        Y = worldPoints(end,2)+yTol;

      
        X = round(X);
        Y = round(Y);
     
         blockInfo = sprintf('%.0f %.0f %.0f %.0f',X,Y,(block(1,3)*180/pi),block(1,4));
         tableList = string(blockInfo);
         
         if isempty(conveyorBlockData)
                conveyorBlockData = tableList;
            else
                conveyorBlockData = [conveyorBlockData; tableList];
            end 
            set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
            set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    
         
        
    end
    
    else
        disp('No Blocks');
	
	% detection of box
    bOrientation = regionprops('table',bw2,'Centroid','Image','Orientation');
    N= length(bOrientation.Orientation);
     for i= 1:N 
      if   (length(bOrientation.Image{i})>200)
     index=i;
      end
     end
    plot(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),'*');
    text(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),num2str(bOrientation.Orientation(index)),'Color','red','FontSize',20);
    contour(bw2,'r');
    
    %get centroid for box
    x=bOrientation.Centroid(index,1);
    y=bOrientation.Centroid(index,2);
    
    x = round(x);
    y = round(y);
    
    [R, T] = extrinsics(convImagePoints.imagePoints, convWorldPoints.worldPoints, convParam.ConvCameraParams);
    worldPoints = pointsToWorld(convParam.ConvCameraParams, R, T, [x y]);
    xTol=0; yTol=0;
    X = worldPoints(end,1)+xTol;
    Y = worldPoints(end,2)+yTol;
    x = round(X); 
    y = round(Y);
    BoxX = x;
    BoxY = y;
    a = sprintf('%.0f %.0f',x,y);
    Boxcentrod = a;
    end
      
       
    end
end

 function getBlocks_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Hint: get(hObject,'Value') returns toggle state of ConveyorCamSS
    global vid;
    global tableParam tableImagePoints tableWorldPoints
    global blockInfo 
    global tableBlockData
    global OG
    if get(hObject,'Value') == 1
%         %get one frame from table video feed and apply the edge,orientation,OCR and reachable detection of blocks
         snapshot = getsnapshot(vid);
         image = snapshot;
%          image = imread('1.jpg');
    
    [angles, position, letter, finalText] = useBlocks(image);
    figure(1);
    imshow(image);
    Blocksdata_table = zeros(length(angles),6);
    % Constructing Final Array
    for i=1:length(angles)
        block = [position(i,1), position(i,2),... 
            angles(i), letter(i),...
            isReachable(position(i,1), position(i,2))];
        
        hold on 

        % Show the central and orientation of the block
        
        plot(position(i,1),position(i,2),'*');
        hold on
         if (block(5)==1)
             text(position(i,1)+30, position(i,2)+30, num2str(angles(i)*180/pi), 'Color','blue');
         else
             text(position(i,1)+30, position(i,2)+30, num2str(angles(i)*180/pi), 'Color','red');
         end
        
        % write blocks information to a array
        % [num2str(angles(i)*180/pi]//type of block: 1=letter/2=pattern
        
        x=round(block(1,1));
        y=round(block(1,2));
        Blocksdata_table(i,3) =block(1,3);
        Blocksdata_table(i,4) =block(1,4); %check if it is a letter or not
        Blocksdata_table(i,5) =1;  %call function coordinates to bp
        Blocksdata_table(i,6) =block(1,5);
  
        
        % change x y 
        [R, T] = extrinsics(tableImagePoints.tImagePoints, tableWorldPoints.tWorldPoints, tableParam.tableCameraParams);
        worldPoints = pointsToWorld(tableParam.tableCameraParams, R, T, [x y]);
        xTol=0; yTol=0;
        X = worldPoints(end,1)+xTol;
        Y = worldPoints(end,2)+yTol;

        [BPletter,BPnumber]= Coordinates2BP(X,Y);
        X = round(X);
        Y = round(Y);
         BP=strcat(BPletter,BPnumber);
%         [newOG] = UpdateOG(BP);
         blockInfo = sprintf('%.0f %.0f %.0f %.0f %s %.0f',X,Y,round(block(1,3)),block(1,4),BP,block(1,5));
         tableList = string(blockInfo);
         if isempty(tableBlockData)
                tableBlockData = tableList;
            else
                tableBlockData = [tableBlockData; tableList];
         end
            set(handles.TableBlocksListbox, 'String', tableBlockData);
            set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
            set(handles.BPtoBPBlockList, 'String', tableBlockData);
            set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
         
        
    end
  end
 end

 %blocks detection function in pixel coordinates
% Detects if Blocks are Reachable
function reachable = isReachable(x, y)
    zeroPosition = [805, 25.5943];
    radius = 832.405697; 
    
    % Check if block is within reachable radius of robot
    if(x-zeroPosition(1))^2+(y-zeroPosition(2))^2<radius^2
        reachable = true;
    else
        reachable = false;
    end
end

% blocks detection function in Robot Base Frame coordinates
function [trueAngles, centroids, letter, finalTextBefore] = useBlocks_conveyor(image1,image2)

    
    % Remove the letter inside block
    imMask=image1;
    newMask = image2;
    % Find characteristics of blocks using regionprops
    [centroids, area] = shapeCentroid(~newMask);
    
    % Find how many blocks are in a centroid
    for i=1:length(area)
        true = 0;
        numberBlocks(i) = round(area(i)/2400);
        if (numberBlocks(i) > 1)
            imMask = imMask - bwareaopen(imMask, 3000);
            colourMask = bwperim(imMask);
            % Find characteristics of blocks using regionprops
            [centroids, area] = shapeCentroid(colourMask);
            true = 1;
        end
        if (true==1)
            break
        end
    end
    
    % Find Corner points using Douglas Peucker
     contour1 = contourc(double(newMask));
     res = DouglasPeucker(contour1,25);  % somewhere above 20
     co = removeZero(res); % Removes zero points 
 
    % this section calculates the angle of the block
    for i=1:length(centroids(:,1))
        angles(i) = findAngle(co, centroids(i,:));
        [trueAngles(i), letter(i), finalTextBefore(i)] = findLetter(angles(i), centroids(i,:), imMask);
%         imshow(~imMask);
    end    
    
    
end

 % Identifying Blocks
function [trueAngles, centroids, letter, finalTextBefore] = useBlocks(image)

    images = imsharpen(image);
    imHSV = rgb2hsv(images);
    
    imMask = imHSV(:,:,2)<0.25 & imHSV(:,:,3)>0.68;
    imMask(1:250, :, :) = 1;
    imMask(end-20:end, :, :) = 1;
    imMask(:, end-20:end, :) = 1;
    imMask(:, 1:20, :) = 1;

    % Remove grid from image   
    for i=1:1200
        imMask(i,:) = ~bwareaopen(~imMask(i,:),6);
    end
    for i=1:1600
        imMask(:,i) = ~bwareaopen(~imMask(:,i),6);
    end
    
    % Remove the letter inside block
    newMask = bwareaopen(imMask,800);
%     imshow(newMask);
    % Find characteristics of blocks using regionprops
    [centroids, area] = shapeCentroid(~newMask);
    
    % Find how many blocks are in a centroid
    for i=1:length(area)
        true = 0;
        numberBlocks(i) = round(area(i)/2400);
        if (numberBlocks(i) > 1)
            imMask = imMask - bwareaopen(imMask, 3000);
            colourMask = bwperim(imMask);
            % Find characteristics of blocks using regionprops
            [centroids, area] = shapeCentroid(colourMask);
            true = 1;
        end
        if (true==1)
            break
        end
    end
    
    % Find Corner points using Douglas Peucker
     contour1 = contourc(double(newMask));
     res = DouglasPeucker(contour1,25);  % somewhere above 20
     co = removeZero(res); % Removes zero points 
  
    % this section calculates the angle of the block
    for i=1:length(centroids)
        angles(i) = findAngle(co, centroids(i,:));
        [trueAngles(i), letter(i), finalTextBefore(i)] = findLetter(angles(i), centroids(i,:), imMask);
%         imshow(~imMask);
    end    
    
    
end

 % Finds letter using OCR and change angle if letter is found
function [angles, letter, finalTextBefore] = findLetter(angles, centroids, imMask)
    % Rotation through 4 angles to find letters for each centroid

 
    
    
    % Split imMask into area
    % form [xmin ymin width height].
    translatedAngles = rad2deg(angles);
    degrees = [translatedAngles; translatedAngles+90; translatedAngles-90; translatedAngles-180];
    I2 = imcrop(imMask,[(centroids(1)-25) (centroids(2)-25) 50 50]);
    
    % Resizing makes it more accurate
    I2 = imresize(I2,3/4);
    
    % CASE 1: Angle
    case1 = imrotate(I2,degrees(1));
    case1 = bwareaopen(case1, 100);
%           imshow(case1)
    results1 = ocr(case1, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (isempty(results1.Words) == 1)
        text = [0];
        results = [0];
    else
        text = [results1.Text(1)];
        results = [results1.WordConfidences(1)];
    end 

    % See which case has the highest confidence value
    max_num=max(results); 
    [max_num,max_idx] = max(results);
    rad = [0; (pi/2); (-pi/2); (-pi)];

    letter2number = @(c)1+lower(c)-'a'; % Convert letter to digit
    finalTextBefore = text(max_idx);
    finalText = letter2number(finalTextBefore);
    
    if finalText<1
    letter = 2;
    else
        letter = 1;
    end
    angles = angles+rad(max_idx); % Find correct orientation of the block

    
    
    
end  

 % Removes zero values from RDP
function co = removeZero(res)
    j = 1;
    for i=1:length(res)
        if res(i,1) > 5
            corners = res(i,:);
            % make it into a matrix
            if(j == 1)
                co = corners;
            else
                co = [co; corners];
            end
            j = j+1;
        end
    end
end
    
% Calculates angle of block
function finalAngles = findAngle(co, centroids)
    % maybe what I could do is find blocks points within a range, and if
    % they are length 30-35 find angle, then average all angles 0-90
    % degrees
    p=1;
    associatedAngles = 0;
    associatedCorners = [];
    % Find all associated corners for that centroid
    for j=1:length(co)
        distPoint = sqrt((centroids(1)-co(j,1))^2 + (centroids(2)-co(j,2))^2);
        if (distPoint<50)
            % Make matrix of associated corners to each centroid
            if(p == 1)
                associatedCorners = co(j,:);
            else
                associatedCorners = [associatedCorners; co(j,:)];
            end
            p = p+1;
        end
    end
    % After you find all corners, find angles
    q=1;
    if (isempty(associatedCorners) == 0)
        for k=1:length(associatedCorners(:,1))
            for l=1:length(associatedCorners(:,1))
                distCorner = sqrt((associatedCorners(k,1)-associatedCorners(l,1))^2 + (associatedCorners(k,2)-associatedCorners(l,2))^2);
                if (30<distCorner && distCorner<60)
                    %find angle
                    angleCorner = atan2(associatedCorners(k,2)-associatedCorners(l,2),associatedCorners(k,1)-associatedCorners(l,1));
                    if ((pi/2)<angleCorner && angleCorner<=(pi))
                        angleCorner = angleCorner - (pi/2);
                    elseif ((-pi)<=angleCorner && angleCorner<(-pi/2))
                        angleCorner = angleCorner + (pi);
                    elseif ((-pi/2)<angleCorner && angleCorner<(0)) 
                        angleCorner = angleCorner + (pi/2);
                    end
                    if(q==1)
                        associatedAngles = angleCorner;
                    else 
                        associatedAngles = [associatedAngles; angleCorner];
                    end
                    q=q+1;
                end
            end
        end
    end
    % now average all associatedAngles and then that is centroids(i)
    % angle
    stdA = std(associatedAngles);
    if (stdA > 0.3)
        finalAngles = 0;
    else
        finalAngles = mean(associatedAngles);
    end

end
 
 % Takes in a black and white mask of shapes and gets the stats on each
function [centroids, area] = shapeCentroid(imMask)
    stats = regionprops(imMask, 'Centroid', 'Area');
    
    % Centroids will find position of the block
    centroids = cat(1, stats.Centroid);
    area = cat(1, stats.Area);
     for m=1:length(centroids(:,1))
        for i=1:length(centroids(:,1))
            %associate an angle with colours
            flag = 0;
            for j=1:length(centroids(:,1))
                dist = sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2);
                if(dist<40 && dist>0)
                    centroids(j, : )= [];
                    area(j) = [];
                    flag = 1;
                    break;
                end
            end
            if (flag == 1)
                break
            end
        end
     end
end

 % --- Executes on button press in errorContinue.
function errorContinue_Callback(hObject, eventdata, handles)
% hObject    handle to errorContinue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global g_handles;
    global emergencyStop;
    global lightCurtain;
    global motorOn;
    global holdToEnable;
    global ExecutionError;
    global motorSupTriggered;
    global conveyorEnable;
    global command_flag;
    
    if (emergencyStop == 0 && lightCurtain == 1 && motorOn ==1 && holdToEnable == 1 && ExecutionError ==0 && motorSupTriggered == 0 && conveyorEnable == 1)
        set(g_handles.CameraPanel,'Visible','On');
        set(g_handles.statusPanel,'Visible','On');
        set(g_handles.DIOPanel,'Visible','On');
        set(g_handles.RobotStatusPanel,'Visible','On');
        set(g_handles.SafetyPanel,'Visible','Off');
        set(g_handles.errorPanel,'Visible','Off');
        command_flag = 1;
        set(g_handles.emergencyStop, 'BackgroundColor', [0 0 0]);
        set(g_handles.lightCurtain, 'BackgroundColor', [0 0 0]);
        set(g_handles.motorsAreOff, 'BackgroundColor', [0 0 0]);
        set(g_handles.holdToEnableNotPressed, 'BackgroundColor', [0 0 0]);
        set(g_handles.executionError, 'BackgroundColor', [0 0 0]);
        set(g_handles.motionSupervisionTriggered, 'BackgroundColor', [0 0 0]);
        set(g_handles.conveyorNotEnabled, 'BackgroundColor', [0 0 0]);
    else
        msg('Please fix error');
    end
end


% --- Executes on button press in fillDeck1Button.
function fillDeck1Button_Callback(hObject, eventdata, handles)
% hObject    handle to fillDeck1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global letterBlocks;
    global tableBlockData;
    global conveyorBlockData;
    global Conveyor2BP_index;
    global letterIndex;
    
    CM_fillDeck1();
    if(~isempty(letterBlocks))
        for i3 = 1:length(letterBlocks(1,:))
            l1_x1(i3) = letterBlocks(1,i3);
            l1_y1(i3) = letterBlocks(2,i3);
            l1_rot(i3) = letterBlocks(3,i3);
            
            % Check if BP is already in use
            occupied = checkBPOccupied('P', i3);
            if (occupied == false)
                [l1_x2(i3),l1_y2(i3)] = gameboardConversion(i3,'P');
                Conveyor2BP_index = letterIndex(i3)-(i3-1);
                SM_FillDeckConveyor2BP(l1_x1(i3), l1_y1(i3), l1_x2(i3), l1_y2(i3), l1_rot(i3));
                Conveyor2BP_updateBlocklist(i3, 'P', l1_x2(i3), l1_y2(i3));
                set(handles.TableBlocksListbox, 'String', tableBlockData);
                set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
                set(handles.BPtoBPBlockList, 'String', tableBlockData);
                set(handles.RotateBlockBlockList, 'String', tableBlockData);
                set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
                set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
            elseif (occupied == true)
                f = msgbox('BP is occupied');
            end
        end
    end
    
end

% --- Executes on button press in clearDeck1Button.
function clearDeck1Button_Callback(hObject, eventdata, handles)
% hObject    handle to clearDeck1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tableBlockData;
    global conveyorBlockData;
    CM_clearDeck1; 
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
end

% --- Executes on button press in sortDeckButton.
function sortDeckButton_Callback(hObject, eventdata, handles)
% hObject    handle to sortDeckButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % GuiHandle allows us to change gui in external function
    GuiHandle = ancestor(hObject, 'figure');
	
	CM_SortDeck(GuiHandle);
end

% --- Executes on button press in clearTableButton.
function clearTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tableBlockData;
    global conveyorBlockData;
    CM_ClearTable();
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
end

% --- Executes on button press in fillTableButton.
function fillTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to fillTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tableBlockData;
    global fillTableX;
    global fillTableY;
    global gameboardX;
    global gameboardY;
    global deckNum;
    global gbNum;
    global gameboardNumber;
    global gameboardLetter;
    global BP2BP_index;
    global BP2BP_indexList;
%     global ftBlockInfo;
    global fTableBlockData;
    
    CM_fillTable;

    if(deckNum ~= 0)
        for i7 = 1:min(deckNum,gbNum)
            % Check if BP is already in use
            occupied = checkBPOccupied(gameboardLetter(i7), gameboardNumber(i7));
            if (occupied == false)
                SM_BP2BP(fillTableX(i7),fillTableY(i7),gameboardX(i7),gameboardY(i7));
                BP2BP_index = BP2BP_indexList(i7)-(i7-1);
                BP2BP_updateBlocklist(gameboardNumber(i7), gameboardLetter(i7), gameboardX(i7), gameboardY(i7));
                % updating info to all lists  
                set(handles.TableBlocksListbox, 'String', tableBlockData);    
                set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
                set(handles.BPtoBPBlockList, 'String', tableBlockData);
                set(handles.RotateBlockBlockList, 'String', tableBlockData);
                fTableBlockData(1) = [];
                set(handles.fillTableListbox,'String',fTableBlockData);
            elseif (occupied == true)
                f = msgbox('BP is occupied');
            end
        end
    else
        disp('No more blocks on both decks!');
    end
end


% --- Executes on button press in reloadBoxButton.
function reloadBoxButton_Callback(hObject, eventdata, handles)
% hObject    handle to reloadBoxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    
    commandStr = sprintf('reload_box');
    queue.add(commandStr);
end

% --- Executes on button press in insertBoxButton.
function insertBoxButton_Callback(hObject, eventdata, handles)
% hObject    handle to insertBoxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global queue;
    
    commandStr = sprintf('insert_box');
    queue.add(commandStr);
end


% --- Executes on button press in ConveyortoBPButton1.
function ConveyortoBPButton1_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global conveyor2BP_blocklist;
    global conveyor2BP_letter;
    global conveyor2BP_number;
    global tableBlockData;
    global conveyorBlockData;
    
	x1 = conveyor2BP_blocklist(1);
    y1 = conveyor2BP_blocklist(2);
    
    % Check if BP is already in use
    occupied = checkBPOccupied(conveyor2BP_letter, conveyor2BP_number);
    if (occupied == false)
        [x2,y2] = gameboardConversion(conveyor2BP_number,conveyor2BP_letter);
        SM_Conveyor2BP(x1,y1,x2,y2);
        Conveyor2BP_updateBlocklist(conveyor2BP_number,conveyor2BP_letter, x2, y2);

        % updating info to all lists  
        set(handles.TableBlocksListbox, 'String', tableBlockData);
        set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
        set(handles.BPtoBPBlockList, 'String', tableBlockData);
        set(handles.RotateBlockBlockList, 'String', tableBlockData);
        set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
        set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
    elseif (occupied == true)
        f = msgbox('BP is occupied');
    end
    
end


% --- Executes on button press in RotateBlockButton1.
function RotateBlockButton1_Callback(hObject, eventdata, handles)
% hObject    handle to RotateBlockButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Rotate_blocklist;
    global tableBlockData;
    x1 = Rotate_blocklist(1);
    y1 = Rotate_blocklist(2);
    rot = Rotate_blocklist(3);
    
    SM_RotateBlock(x1,y1,rot);
    rotateBlock_updateBlocklist(x1,y1);
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
end

% --- Executes on button press in BPtoConveyorButton1.
function BPtoConveyorButton1_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoConveyorButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

	global BP2Conveyor_blocklist;
    global tableBlockData;
    global conveyorBlockData;
	x1 = BP2Conveyor_blocklist(1);
    y1 = BP2Conveyor_blocklist(2);
	% Need to know conveyor coordinates
    global boxX;
    global boxY;
	SM_BP2Conveyor(x1,y1,boxX,boxY);
    BP2Conveyor_updateBlocklist(boxX, boxY);
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
    
end

% --- Executes on selection change in RotateBlockBlockList.
function RotateBlockBlockList_Callback(hObject, eventdata, handles)
% hObject    handle to RotateBlockBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RotateBlockBlockList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RotateBlockBlockList
	global Rotate_blocklist;
    global Rotate_index;
    % This will choose out of a list of the block list data
    contents = cellstr(get(hObject,'String'));
	block_list = contents{get(hObject, 'Value')};
    Rotate_index = get(hObject, 'Value');
	list_split = string(strsplit(block_list));
	x1 = str2double(list_split(1));
	y1 = str2double(list_split(2));
    rot = str2double(list_split(3));
	Rotate_blocklist = [x1,y1,rot];
end

% --- Executes during object creation, after setting all properties.
function RotateBlockBlockList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RotateBlockBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in BPtoBPBlockList.
function BPtoBPBlockList_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoBPBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BPtoBPBlockList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BPtoBPBlockList
	global BP2BP_blocklist;
    global BP2BP_index;
    % This will choose out of a list of the block list data
    contents = cellstr(get(hObject,'String'));
	block_list = contents{get(hObject, 'Value')};
    BP2BP_index = get(hObject, 'Value');
	list_split = string(strsplit(block_list));
	x1 = str2double(list_split(1));
	y1 = str2double(list_split(2));
	BP2BP_blocklist = [x1,y1];

end

% --- Executes during object creation, after setting all properties.
function BPtoBPBlockList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPtoBPBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in ConveyortoBPBlockList.
function ConveyortoBPBlockList_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConveyortoBPBlockList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConveyortoBPBlockList
	global conveyor2BP_blocklist;
    global Conveyor2BP_index;
    contents = cellstr(get(hObject,'String'));
	block_list = contents{get(hObject, 'Value')};
    Conveyor2BP_index = get(hObject, 'Value');
	list_split = string(strsplit(block_list));
	x1 = str2double(list_split(1));
	y1 = str2double(list_split(2));
	conveyor2BP_blocklist = [x1,y1];
end

% --- Executes during object creation, after setting all properties.
function ConveyortoBPBlockList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in BPtoBPAlphabet.
function BPtoBPAlphabet_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoBPAlphabet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BPtoBPAlphabet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BPtoBPAlphabet
	global BP2BP_letter;
    contents = cellstr(get(hObject,'String'));
	BP2BP_letter = contents{get(hObject, 'Value')};

end

% --- Executes during object creation, after setting all properties.
function BPtoBPAlphabet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPtoBPAlphabet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in BPtoBPNumber.
function BPtoBPNumber_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoBPNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BPtoBPNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BPtoBPNumber
	global BP2BP_number;
    contents = cellstr(get(hObject,'String'));
	BP2BP_number = contents{get(hObject, 'Value')};
    BP2BP_number = str2double(BP2BP_number);
end

% --- Executes during object creation, after setting all properties.
function BPtoBPNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPtoBPNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in BPtoConveyorBlockList.
function BPtoConveyorBlockList_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoConveyorBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BPtoConveyorBlockList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BPtoConveyorBlockList
   % global tableBlockData

    %set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
	global BP2Conveyor_blocklist;
    global BP2Conveyor_index;
    contents = cellstr(get(hObject,'String'));
	block_list = contents{get(hObject, 'Value')};
    BP2Conveyor_index = get(hObject, 'Value');
	list_split = string(strsplit(block_list));
	x1 = str2double(list_split(1));
	y1 = str2double(list_split(2));
	BP2Conveyor_blocklist = [x1,y1];
end

% --- Executes during object creation, after setting all properties.
function BPtoConveyorBlockList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPtoConveyorBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in ConveyortoBPAlphabet.
function ConveyortoBPAlphabet_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPAlphabet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConveyortoBPAlphabet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConveyortoBPAlphabet
	global conveyor2BP_letter;
    contents = cellstr(get(hObject,'String'));
	conveyor2BP_letter = contents{get(hObject, 'Value')};
end

% --- Executes during object creation, after setting all properties.
function ConveyortoBPAlphabet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPAlphabet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in ConveyortoBPNumber.
function ConveyortoBPNumber_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConveyortoBPNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConveyortoBPNumber
	global conveyor2BP_number;
    contents = cellstr(get(hObject,'String'));
	BP2BP_number = contents{get(hObject, 'Value')};
    conveyor2BP_number = str2double(BP2BP_number);
end

% --- Executes during object creation, after setting all properties.
function ConveyortoBPNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in ConveyorBlocksListbox.
function ConveyorBlocksListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorBlocksListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConveyorBlocksListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConveyorBlocksListbox
    global conveyorIndexSelected
    conveyorIndexSelected = get(hObject,'Value');
end

% --- Executes during object creation, after setting all properties.
function ConveyorBlocksListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConveyorBlocksListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in TableBlocksListbox.
function TableBlocksListbox_Callback(hObject, eventdata, handles)
% hObject    handle to TableBlocksListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TableBlocksListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TableBlocksListbox
    global tableIndexSelected
    tableIndexSelected = get(hObject,'Value');
end

% --- Executes during object creation, after setting all properties.
function TableBlocksListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TableBlocksListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in CameraPopupmenu.
function CameraPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to CameraPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CameraPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CameraPopupmenu
    global cameraType
    
   contents = cellstr(get(hObject,'String'));
   cameraType = contents{get(hObject,'Value')};
    
end

% --- Executes during object creation, after setting all properties.
function CameraPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    global cameraType
    cameraType = 'Table';
end


% --- Executes on selection change in BlockListPopupmenu.
function BlockListPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to BlockListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BlockListPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BlockListPopupmenu
end

% --- Executes during object creation, after setting all properties.
function BlockListPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function CorrectBlockStatusHereEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CorrectBlockStatusHereEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CorrectBlockStatusHereEdit as text
%        str2double(get(hObject,'String')) returns contents of CorrectBlockStatusHereEdit as a double
    global blockInfo 
    
    blockInfo = get(hObject,'String');

end

% --- Executes during object creation, after setting all properties.
function CorrectBlockStatusHereEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CorrectBlockStatusHereEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in CorrectButton.
function CorrectButton_Callback(hObject, eventdata, handles)
% hObject    handle to CorrectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %sentList = [{commandStr}; g_handles.SentMessages.String];
    global blockInfo 
    global tableBlockData
    global conveyorBlockData
    global cameraType
    
    tableList = string(blockInfo);
    
    % The correct button will check which block data the user wants to addbutton
    % to and then adds whatever they inputed on the gui
    switch cameraType
		case 'Table'
            if isempty(tableBlockData)
                tableBlockData = tableList;
            else
                tableBlockData = [tableBlockData; tableList];
            end
            set(handles.TableBlocksListbox, 'String', tableBlockData);
            set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
            set(handles.BPtoBPBlockList, 'String', tableBlockData);
            set(handles.RotateBlockBlockList, 'String', tableBlockData);

        case 'Conveyor'
            if isempty(conveyorBlockData)
                conveyorBlockData = tableList;
            else
                conveyorBlockData = [conveyorBlockData; tableList];
            end 
            set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
            set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
           
    end

end


% --- Executes on button press in DeleteSelectedTableBlock.
function DeleteSelectedTableBlock_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSelectedTableBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global tableIndexSelected
    global tableBlockData
    
    % this will find which block data has been selected on the list and
    % will delete it
    tableBlockData(tableIndexSelected) = [];
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
end

% --- Executes on button press in DeleteSelectedConveyorBlock.
function DeleteSelectedConveyorBlock_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSelectedConveyorBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global conveyorIndexSelected
    global conveyorBlockData
    
    % this will find which block data has been selected on the list and
    % will delete it
    conveyorBlockData(conveyorIndexSelected) = [];
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double
end

% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double
end

% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double
end

% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double
end

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double
end

% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double
end

% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double
end

% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double
end

% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit47 as text
%        str2double(get(hObject,'String')) returns contents of edit47 as a double
end

% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double
end

% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double
end

% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double
end

% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu31.
function popupmenu31_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu31 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu31
end

% --- Executes during object creation, after setting all properties.
function popupmenu31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu32.
function popupmenu32_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu32 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu32
end

% --- Executes during object creation, after setting all properties.
function popupmenu32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton107.
function pushbutton107_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton107 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton102.
function pushbutton102_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton103.
function pushbutton103_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton103 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton104.
function pushbutton104_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton104 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton105.
function pushbutton105_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton105 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton106.
function pushbutton106_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton106 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton100.
function pushbutton100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton101.
function pushbutton101_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton96.
function pushbutton96_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton97.
function pushbutton97_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton97 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton98.
function pushbutton98_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton99.
function pushbutton99_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in popupmenu23.
function popupmenu23_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu23 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu23
end

% --- Executes during object creation, after setting all properties.
function popupmenu23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu24.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu24 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu24
end

% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu25.
function popupmenu25_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu25 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu25
end

% --- Executes during object creation, after setting all properties.
function popupmenu25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu26.
function popupmenu26_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu26 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu26
end

% --- Executes during object creation, after setting all properties.
function popupmenu26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu27.
function popupmenu27_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu27 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu27
end

% --- Executes during object creation, after setting all properties.
function popupmenu27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu28.
function popupmenu28_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu28 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu28
end

% --- Executes during object creation, after setting all properties.
function popupmenu28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu29.
function popupmenu29_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu29 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu29
end

% --- Executes during object creation, after setting all properties.
function popupmenu29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu30.
function popupmenu30_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu30 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu30
end

% --- Executes during object creation, after setting all properties.
function popupmenu30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7
end

% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8
end

% --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton94.
function pushbutton94_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton95.
function pushbutton95_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in popupmenu33.
function popupmenu33_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu33 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu33
end

% --- Executes during object creation, after setting all properties.
function popupmenu33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double
end

% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton108.
function pushbutton108_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton108 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in ttt1.
function ttt1_Callback(hObject, eventdata, handles)
% hObject    handle to ttt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end

    %if not already marked
    if handles.box(1,1)==0
       set(hObject,'String',plrmark);
       handles.box(1,1)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(4,'D');
       
       rec = sprintf('%.0f %.0f 4 D %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};   
        
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(4,'D', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt4.
function ttt4_Callback(hObject, eventdata, handles)
% hObject    handle to ttt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(2,1)==0
       set(hObject,'String',plrmark);
       handles.box(2,1)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(5,'D');
        
       rec = sprintf('%.0f %.0f 5 D %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};
        
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(5,'D', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt7.
function ttt7_Callback(hObject, eventdata, handles)
% hObject    handle to ttt7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(3,1)==0
       set(hObject,'String',plrmark)
       handles.box(3,1)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(6,'D');
      
       rec = sprintf('%.0f %.0f 6 D %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};      
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(6,'D', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt8.
function ttt8_Callback(hObject, eventdata, handles)
% hObject    handle to ttt8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(3,2)==0
       set(hObject,'String',plrmark)
       handles.box(3,2)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(6,'E');
       
       rec = sprintf('%.0f %.0f 6 E %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};       
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(6,'E', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt5.
function ttt5_Callback(hObject, eventdata, handles)
% hObject    handle to ttt5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(2,2)==0
       set(hObject,'String',plrmark)
       handles.box(2,2)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(5,'E');
       
       rec = sprintf('%.0f %.0f 5 E %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};      
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(5,'E', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt2.
function ttt2_Callback(hObject, eventdata, handles)
% hObject    handle to ttt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(1,2)==0
       set(hObject,'String',plrmark)
       handles.box(1,2)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(4,'E');
       
       rec = sprintf('%.0f %.0f 4 E %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};         
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(4,'E', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt9.
function ttt9_Callback(hObject, eventdata, handles)
% hObject    handle to ttt9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(3,3)==0
       set(hObject,'String',plrmark)
       handles.box(3,3)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(6,'F');
       
       rec = sprintf('%.0f %.0f 6 F %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};       
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(6,'F', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt6.
function ttt6_Callback(hObject, eventdata, handles)
% hObject    handle to ttt6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(2,3)==0
       set(hObject,'String',plrmark)
       handles.box(2,3)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(5,'F');
       
       rec = sprintf('%.0f %.0f 5 F %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};        
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(5,'F', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;        
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in ttt3.
function ttt3_Callback(hObject, eventdata, handles)
% hObject    handle to ttt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    global condition;
    %update currentplayer mark depending on whose turn
    if handles.plr==1
        plrmark='X';
        number = (handles.counter+1)/2;
        letter = 'P';
    elseif handles.plr==2
        plrmark='O';
        number = handles.counter/2;
        letter = 'Q';
    end
    
    %if not already marked
    if handles.box(1,3)==0
       set(hObject,'String',plrmark)
       handles.box(1,3)=handles.plr;
       [x1,y1] = gameboardConversion(number,letter);
       [x2,y2] = gameboardConversion(4,'F');
       
       rec = sprintf('%.0f %.0f 4 F %.0f %.0f %.0f %c',x2,y2,x1,y1,number,letter);
       record{handles.counter} = {rec};   
       
       SM_BP2BP(x1,y1,x2,y2);
       findTableBlockIndex(letter,number);
       BP2BP_updateBlocklist(4,'F', x2, y2);
       
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        condition = 1;
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in TicTacToeEndGame.
function TicTacToeEndGame_Callback(hObject, eventdata, handles)
% hObject    handle to TicTacToeEndGame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Global variable
    global queue;
    global record;
    global tableBlockData;
	global condition;

	if (condition ~= 1)
		% Cancel the movement
		Cancel_Callback(hObject, eventdata, handles);
		% Clear the queue
		queue.clear();
		condition = 0;
	end
    
    % Reset the game
    handles.box=[0 0 0;0 0 0;0 0 0];
    handles.plr=1;
    
    plrmark=' ';
    set(handles.ttt1,'String',plrmark);
    set(handles.ttt2,'String',plrmark);
    set(handles.ttt3,'String',plrmark);
    set(handles.ttt4,'String',plrmark);
    set(handles.ttt5,'String',plrmark);
    set(handles.ttt6,'String',plrmark);
    set(handles.ttt7,'String',plrmark);
    set(handles.ttt8,'String',plrmark);
    set(handles.ttt9,'String',plrmark);
    
    % Move all the blocks back
    len = length(record);
    for i = 1:len
        j = len - i + 1; % to put everything back backwards
        if(~isempty(record{1,j}))
            stringSplit = strsplit(record{1,j}{1,1});
            x1 = str2double(stringSplit(1));
            y1 = str2double(stringSplit(2));
            number1 = str2double(stringSplit(3));
            letter1 = char(stringSplit(4));
            x2 = str2double(stringSplit(5));
            y2 = str2double(stringSplit(6));
            number2 = str2double(stringSplit(7));
            letter2 = char(stringSplit(8));

            SM_BP2BP(x1,y1,x2,y2);
            findTableBlockIndex(letter1,number1);
            BP2BP_updateBlocklist(number2,letter2, x2, y2);

            % updating info to all lists  
            set(handles.TableBlocksListbox, 'String', tableBlockData);
            set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
            set(handles.BPtoBPBlockList, 'String', tableBlockData);
            set(handles.RotateBlockBlockList, 'String', tableBlockData);
        end
    end
    
    handles.counter = 1;
    record = cell.empty();
    guidata(hObject,handles);
end

% --- Executes on button press in TicTacToeResume.
function TicTacToeResume_Callback(hObject, eventdata, handles)
% hObject    handle to TicTacToeResume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Resume_Callback(hObject, eventdata, handles);
    
    set(handles.nomove,'Visible','off');
    
    set(handles.tttdoNotMove,'BackgroundColor','white');
    set(handles.tttdoNotMove,'Visible','on');
    set(handles.ttt1,'Visible','on');
    set(handles.ttt2,'Visible','on');
    set(handles.ttt3,'Visible','on');
    set(handles.ttt4,'Visible','on');
    set(handles.ttt5,'Visible','on');
    set(handles.ttt6,'Visible','on');
    set(handles.ttt7,'Visible','on');
    set(handles.ttt8,'Visible','on');
    set(handles.ttt9,'Visible','on');
end

% --- Executes on button press in TicTacToePause.
function TicTacToePause_Callback(hObject, eventdata, handles)
% hObject    handle to TicTacToePause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Pause_Callback(hObject, eventdata, handles);
    
    filename = 'i-will-not-move.jpg';
    theImage = imread(filename);
    axes(handles.nomove); % Use actual variable names from your program!
    imshow(theImage);
    
    
    set(handles.tttdoNotMove,'BackgroundColor','red');
    set(handles.tttdoNotMove,'Visible','off');
    set(handles.ttt1,'Visible','off');
    set(handles.ttt2,'Visible','off');
    set(handles.ttt3,'Visible','off');
    set(handles.ttt4,'Visible','off');
    set(handles.ttt5,'Visible','off');
    set(handles.ttt6,'Visible','off');
    set(handles.ttt7,'Visible','off');
    set(handles.ttt8,'Visible','off');
    set(handles.ttt9,'Visible','off');
end

% --- Executes on button press in Player1AIMove.
function Player1AIMove_Callback(hObject, eventdata, handles)
% hObject    handle to Player1AIMove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Initialisation
    winner=0;
    global tableBlockData;
    global record;
    GuiHandle = ancestor(hObject, 'figure');
    % check which players turn it is
    if handles.plr==1
        % do AI
        board = handles.box;
        turn = handles.plr;
        agent_turn = 1;
        % This function will find the optimal place the AI should be placed
        [ board, value] = searchTreeTemp(board, turn, agent_turn);
        
        plrmark='X';
        % this loop just goes through the new board matrix and sees which
        % place the new player chose and then moves to that place and also
        % updates the gui
        for i = 1:3
            for j=1:3
                if (handles.box(i,j)~=board(i,j))
                   % setString will update the gui tic tac toe grid
                   setString(plrmark, i, j, GuiHandle);
                   number = (handles.counter+1)/2;
                   letter = 'P';
                   
                   [x1,y1] = gameboardConversion(number,letter);
                   if(i==1)
                       number2 = 4;
                   elseif(i==2)
                       number2 = 5;
                   elseif(i==3)
                       number2 = 6;
                   end
                   
                   if(j==1)
                       letter2 = 'D';
                   elseif(j==2)
                       letter2 = 'E';
                   elseif(j==3)
                       letter2 = 'F';
                   end
                   
                   [x2,y2] = gameboardConversion(number2,letter2);

                   rec = sprintf('%.0f %.0f %.0f %c %.0f %.0f %.0f %c',x2,y2,number2,letter2,x1,y1,number,letter);
                   record{handles.counter} = {rec};   

                   SM_BP2BP(x1,y1,x2,y2);
                   findTableBlockIndex(letter,number);
                   BP2BP_updateBlocklist(number2,letter2, x2, y2);
                   break;
                end

            end
        end
        handles.box = board;
        
       %update currentplayer value
       winner=whowins(handles.plr,handles.box);
       if handles.plr==1
           set(handles.currentPlayer, 'String','Next: Player 2');
           handles.plr=2;
       else
           set(handles.currentPlayer, 'String','Next: Player 1');
           handles.plr=1;
       end
    end
    %when nobody wins winner=0 other wise close program with results
    if winner~=0
        if winner==1
            msgbox('Player 1 Wins');
        elseif winner==2
            msgbox('Player 2 Wins');
        elseif winner==-1
            msgbox('Its a Draw');
        end
        handles.box=[0 0 0;0 0 0;0 0 0];
        handles.plr=1;
        TicTacToeEndGame_Callback(hObject, eventdata, handles);
    end
    handles.counter = handles.counter+1;
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
    guidata(hObject,handles);
end

% --- Executes on button press in Player2Move.
function Player2Move_Callback(hObject, eventdata, handles)
% hObject    handle to Player2Move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in Player1Move.
function Player1Move_Callback(hObject, eventdata, handles)
% hObject    handle to Player1Move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in PPEndAlpha.
function PPEndAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to PPEndAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPEndAlpha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPEndAlpha
    global ppGoalLetter

    contents = cellstr(get(hObject, 'String'));
    ppGoalLetter = contents{get(hObject, 'Value')};
end

% --- Executes during object creation, after setting all properties.
function PPEndAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPEndAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in PPStartAlpha.
function PPStartAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to PPStartAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPStartAlpha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPStartAlpha
    global ppStartLetter
    contents = cellstr(get(hObject, 'String'));
    ppStartLetter = contents{get(hObject, 'Value')};

end

% --- Executes during object creation, after setting all properties.
function PPStartAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPStartAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in PPStartNumber.
function PPStartNumber_Callback(hObject, eventdata, handles)
% hObject    handle to PPStartNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPStartNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPStartNumber
    global ppStartNumber
    contents = cellstr(get(hObject, 'String'));
    ppStartNumber = contents{get(hObject, 'Value')};
end

% --- Executes during object creation, after setting all properties.
function PPStartNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPStartNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in PPEndNumber.
function PPEndNumber_Callback(hObject, eventdata, handles)
% hObject    handle to PPEndNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPEndNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPEndNumber
    global ppGoalNumber
    contents = cellstr(get(hObject, 'String'));
    ppGoalNumber = contents{get(hObject, 'Value')};

end

% --- Executes during object creation, after setting all properties.
function PPEndNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPEndNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in StartMaze.
function StartMaze_Callback(hObject, eventdata, handles)
% hObject    handle to StartMaze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ppStartLetter ppStartNumber 
    global ppGoalLetter ppGoalNumber

    %code to combine letter with number 
    ppStart = strcat(ppStartLetter, ppStartNumber);
    ppGoal = strcat(ppGoalLetter,ppGoalNumber);

    %display the start and end BPs
    disp(ppStart);
    disp(ppGoal);

    %gets path & flag for gui input start and goal
    [ppBpPath, ppFlag]= pathPlanning(ppStart, ppGoal);
    
    %moveFlag: 0=no path, 1=yes path, 2=start/goal on obstacle, no path 
    switch ppFlag
        case 0
            %prints on gui there is no path
            noPath = 'Path not available!';
            set(handles.PathPlanningText, 'String', noPath);
        case 1
            %prints on gui there is a path available
            yesPath = 'Path available - moving now!';
            set(handles.PathPlanningText, 'String', yesPath);
            %moves robot along path
            movePathPlanning(ppBpPath);
        case 2
            %prints on gui start/goal on obstacle
            isObstacle = 'Start/Goal is an obstacle!';
            set(handles.PathPlanningText, 'String', isObstacle);
    end
        
%     %checks if there is a path available or not
%     if isempty(ppBpPath)
%         %prints on gui there is no path
%         set(handles.PathPlanningText, 'String', noPath);
%     else
%         %prints on gui there is a path available
%         set(handles.PathPlanningText, 'String', yesPath);
%         %moves robot along path
%         movePathPlanning(ppBpPath);
%     end
end


% --- Executes on button press in BPtoBPButton1.
function BPtoBPButton1_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoBPButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global BP2BP_letter;
	global BP2BP_number;
	global BP2BP_blocklist;
    global tableBlockData;
	x1 = BP2BP_blocklist(1);
    y1 = BP2BP_blocklist(2);
    
    % Check if BP is already in use
    occupied = checkBPOccupied(BP2BP_letter, BP2BP_number);
    if (occupied == false)
        % if occupied is false, then move to desired BP
        [x2,y2] = gameboardConversion(BP2BP_number,BP2BP_letter);
        SM_BP2BP(x1,y1,x2,y2);
        BP2BP_updateBlocklist(BP2BP_number,BP2BP_letter, x2, y2);
        
        % updating info to all lists  
        set(handles.TableBlocksListbox, 'String', tableBlockData);
        set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
        set(handles.BPtoBPBlockList, 'String', tableBlockData);
        set(handles.RotateBlockBlockList, 'String', tableBlockData);
    elseif (occupied == true)
        % if occupied is true, then do not move to the BP
        f = msgbox('BP is occupied');
    end
    
end


% --- Executes on selection change in ControlOrActivitiesPopup.
function ControlOrActivitiesPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ControlOrActivitiesPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ControlOrActivitiesPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ControlOrActivitiesPopup

    contents = cellstr(get(hObject,'String'));
    PopupValue = contents{get(hObject,'Value')};

    if (strcmp(PopupValue,'Simple Moves and Conveyor Control'))
        set(handles.SMandConveyorPanel,'Visible','On');
        set(handles.ComplexMovePanel,'Visible','Off');
        set(handles.TicTacToePanel,'Visible','Off');
        set(handles.PathPlanningPanel,'Visible','Off');
        set(handles.TestingPanel,'Visible','Off');        
    elseif(strcmp(PopupValue,'Complex Moves'))
        set(handles.SMandConveyorPanel,'Visible','Off');
        set(handles.ComplexMovePanel,'Visible','On');
        set(handles.TicTacToePanel,'Visible','Off');
        set(handles.PathPlanningPanel,'Visible','Off');
        set(handles.TestingPanel,'Visible','Off');  
    elseif(strcmp(PopupValue,'Tic Tac Toe'))
        set(handles.SMandConveyorPanel,'Visible','Off');
        set(handles.ComplexMovePanel,'Visible','Off');
        set(handles.TicTacToePanel,'Visible','On');
        set(handles.PathPlanningPanel,'Visible','Off');
        set(handles.TestingPanel,'Visible','Off');  
    elseif(strcmp(PopupValue,'Path Planning'))
        set(handles.SMandConveyorPanel,'Visible','Off');
        set(handles.ComplexMovePanel,'Visible','Off');
        set(handles.TicTacToePanel,'Visible','Off');
        set(handles.PathPlanningPanel,'Visible','On');
        set(handles.TestingPanel,'Visible','Off');  
    elseif(strcmp(PopupValue,'Testing'))
        set(handles.SMandConveyorPanel,'Visible','Off');
        set(handles.ComplexMovePanel,'Visible','Off');
        set(handles.TicTacToePanel,'Visible','Off');
        set(handles.PathPlanningPanel,'Visible','Off');
        set(handles.TestingPanel,'Visible','On');  
    end
    
end

% --- Executes during object creation, after setting all properties.
function ControlOrActivitiesPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ControlOrActivitiesPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in TicOrPosePopup.
function TicOrPosePopup_Callback(hObject, eventdata, handles)
% hObject    handle to TicOrPosePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TicOrPosePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TicOrPosePopup

    contents = cellstr(get(hObject,'String'));
    PopupValue = contents{get(hObject,'Value')};

    if (strcmp(PopupValue,'Tic Tac Toe'))
        set(handles.TicTacToePanel,'Visible','On');
        set(handles.PosePanel,'Visible','Off');
    elseif(strcmp(PopupValue,'Pose Control'))
        set(handles.TicTacToePanel,'Visible','Off');
        set(handles.PosePanel,'Visible','On');
    end
end

% --- Executes during object creation, after setting all properties.
function TicOrPosePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TicOrPosePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in fillDeck2Button.
function fillDeck2Button_Callback(hObject, eventdata, handles)
% hObject    handle to fillDeck2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global shapeBlocks;
    global tableBlockData;
    global conveyorBlockData;
    global Conveyor2BP_index;
    global shapeIndex;
    
    CM_fillDeck2;
    if(~isempty(shapeBlocks))
        for i2 = 1:length(shapeBlocks(1,:)) 
            s1_x1(i2) = shapeBlocks(1,i2);
            s1_y1(i2) = shapeBlocks(2,i2);
            s1_rot(i2) = shapeBlocks(3,i2);
            
            % Check if BP is already in use
            occupied = checkBPOccupied('P', i3);
            if (occupied == false)
                [s1_x2(i2),s1_y2(i2)] = gameboardConversion(i2,'Q');
                Conveyor2BP_index = shapeIndex(i2)-(i2-1);
                SM_FillDeckConveyor2BP(s1_x1(i2), s1_y1(i2), s1_x2(i2), s1_y2(i2), s1_rot(i2));
                Conveyor2BP_updateBlocklist(i2, 'Q', s1_x2(i2), s1_y2(i2));
                set(handles.TableBlocksListbox, 'String', tableBlockData);
                set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
                set(handles.BPtoBPBlockList, 'String', tableBlockData);
                set(handles.RotateBlockBlockList, 'String', tableBlockData);
                set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
                set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
            elseif (occupied == true)
                f = msgbox('BP is occupied');
            end
        end
    end
end

% --- Executes on button press in clearDeck2Button.
function clearDeck2Button_Callback(hObject, eventdata, handles)
% hObject    handle to clearDeck2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global tableBlockData;
    global conveyorBlockData;
    CM_clearDeck2; 
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
end

% --- Executes on button press in BP2BPTest.
function BP2BPTest_Callback(hObject, eventdata, handles)
% hObject    handle to BP2BPTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in BP2ConveyorTest.
function BP2ConveyorTest_Callback(hObject, eventdata, handles)
% hObject    handle to BP2ConveyorTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in Conveyor2BPTest.
function Conveyor2BPTest_Callback(hObject, eventdata, handles)
% hObject    handle to Conveyor2BPTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in RotateBlockTest.
function RotateBlockTest_Callback(hObject, eventdata, handles)
% hObject    handle to RotateBlockTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in TestingButton.
function TestingButton_Callback(hObject, eventdata, handles)
% hObject    handle to TestingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 

    % GuiHandle allows us to change gui in external function
    GuiHandle = ancestor(hObject, 'figure');
	
    % Goes through and tests each simple move
    Testing_BP2BP(GuiHandle);
    pause; % press enter to continue
	
    Testing_BP2Conveyor(GuiHandle);
    pause; % press enter to continue
	
    Testing_Conveyor2BP(GuiHandle);
    pause; % press enter to continue
	
    Testing_RotateBlock(GuiHandle);
end



function fillTableInput_Callback(hObject, eventdata, handles)
% hObject    handle to  (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of  as text
%        str2double(get(hObject,'String')) returns contents of  as a double

    global ftBlockInfo;
    global fTableBlockData;
    
    ftBlockInfo = get(hObject,'String');
end

% --- Executes during object creation, after setting all properties.
function fillTableInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to  (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end 


% --- Executes on selection change in fillTableListbox.
function fillTableListbox_Callback(hObject, eventdata, handles)
% hObject    handle to fillTableListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fillTableListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fillTableListbox
    global fTableIndexSelected;
    fTableIndexSelected = get(hObject,'Value');
end

% --- Executes during object creation, after setting all properties.
function fillTableListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fillTableListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in deleteSelectedBP.
function deleteSelectedBP_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSelectedBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global fTableIndexSelected
    global fTableBlockData
    
    fTableBlockData(fTableIndexSelected) = [];
    set(handles.fillTableListbox, 'String', fTableBlockData);
end


% --- Executes on button press in MoveToHomeButton.
function MoveToHomeButton_Callback(hObject, eventdata, handles)
% hObject    handle to MoveToHomeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Move2Home();
end


% --- Executes on button press in cameraFeedButton.
function cameraFeedButton_Callback(hObject, eventdata, handles)
% hObject    handle to cameraFeedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testflag;
global g_handles;
[image1,image2 ]= DisplayImage(testflag); 
axes(g_handles.TableCamera);
imshow(image1); hold on; 
axes(g_handles.ConveyorCamera);
imshow(image2); hold on;
if testflag <17
testflag =testflag +1;
else
    testflag=1;
end
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    global ftBlockInfo;
    global fTableBlockData;
    
    fTableList = string(ftBlockInfo);
    if isempty(fTableBlockData)
        fTableBlockData = fTableList;
    else
        fTableBlockData = [fTableBlockData; fTableList];
    end
    set(handles.fillTableListbox, 'String', fTableBlockData);

end


