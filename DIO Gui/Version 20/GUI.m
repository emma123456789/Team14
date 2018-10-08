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

% Last Modified by GUIDE v2.5 20-Sep-2018 21:21:35

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
handles.output = hObject;

global tableParam;
global tableCameraR;
global convParam;
global convCameraR;
global convCameraT;

tableParam = load('cameraParams_table.mat');
convParam = load('cameraParams_conveyor.mat');
tableCameraR = load('cameraR_table.mat');
convCameraR = load('cameraR_conveyor');
convCameraT = load('cameraT_conveyor');

global vid;
global vid2;
% 
%  			% Start Cameras
%  			axes(handles.TableCamera);
%  			axes(handles.ConveyorCamera);
%   			vid = videoinput('macvideo',1, 'MJPG_1600x1200'); 
%             video_resolution1 = vid.VideoResolution;
%             nbands1 = vid.NumberOfBands;
% 			vid2 = videoinput('macvideo',2,'MJPG_1600x1200'); 
%             video_resolution2 = vid2.VideoResolution;
%             nbands2 = vid2.NumberOfBands;
%  
%  			% sguideet image handle
%  			hImage=image(zeros([video_resolution1(2), video_resolution1(1), nbands1]),'Parent',handles.TableCamera);
% 			hImage2=image(zeros([video_resolution2(2), video_resolution2(1), nbands2]),'Parent',handles.ConveyorCamera);
%  			preview(vid,hImage);
%  			preview(vid2,hImage2);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1)

% Create the linked list for multitasks
import java.util.LinkedList;
global queue;
global status_queue;
global s_timer;
global r_timer;
global command_flag;
global g_handles;
global real_robot_IP_address;
global sim_robot_IP_address;
global robot_port;

global poseMode;
global poseSpeed;
global joggingSpeed;
global eeX eeY eeZ eeROLL eePITCH eeYAW;
global jaQ1 jaQ2 jaQ3 jaQ4 jaQ5 jaQ6;

poseMode = 1;
poseSpeed = 'Slow'; joggingSpeed = 'Slow';
eeX = 0; eeY = 0; eeZ = 0; eeROLL = 0; eePITCH = 0; eeYAW = 0;
jaQ1 = 0; jaQ2 = 0; jaQ3 = 0; jaQ4 = 0; jaQ5 = 0; jaQ6 = 0;


queue = LinkedList();
status_queue = LinkedList();

s_timer = timer;
s_timer.TimerFcn = @sendTimer;
s_timer.period = 0.5;
s_timer.ExecutionMode = 'fixedSpacing';

r_timer = timer;
r_timer.TimerFcn = @receiveTimer;
r_timer.period = 0.5;
r_timer.ExecutionMode = 'fixedSpacing';


command_flag = 1;
g_handles = handles;

% The robot's IP address.
real_robot_IP_address = '192.168.125.1'; % Real robot ip address
sim_robot_IP_address = '127.0.0.1'; % Simulation ip address

% The port that the robot will be listening on. This must be the same as in
% your RAPID program.
robot_port = 1025;
% 	Server_port = 10000;

end


function sendTimer(obj, event)
	global command_flag;
	global status_queue;
	
	if (status_queue.size()>0)
		send_priorityString();
		
	elseif (command_flag == 1)
        send_string();
%         fprintf('c\n');

	end
    
end

function receiveTimer(obj, event)
% fprintf('b\n');
	global command_flag;
	response = receive_string();
	tf = strcmp(response,'Done');
	if (tf)
		command_flag = 1;
	end

end


function error_handling()
	global s_timer;
	global r_timer;
	global queue;
	
	% Clear the command queue if there is an error
	queue.clear();

	try
		% Stop the timers	
		stop(s_timer);
		stop(r_timer);
		delete(timerfindall);
	catch
		delete(timerfindall);
	end

end

function send_string()
	% Send a command to the robot
	global queue;
	global socket;
	global g_handles;
    global command_flag;

	if queue.size()>0
		% Obtain the fist command in the linkedlist
		commandStr = queue.pop();	
		try
			fwrite(socket,commandStr);
			
			% Update Sent Message Log
			sentList = [{commandStr}; g_handles.SentMessages.String];
			set(g_handles.SentMessages, 'String', sentList);
			
		catch
			set(g_handles.portNumber, 'String', 'Connection Error');
			set(g_handles.portNumber, 'BackgroundColor', [1 0 0]);
		end
%         command_flag = 0;
 		%fprintf(char(commandStr));
		
	end

end

function send_priorityString()
	% Send pause, resume and cancel immediately after they're pressed
	global status_queue;
	global socket;
	global g_handles;
    
	criticalCommandStr = status_queue.pop();
	try
		fwrite(socket,criticalCommandStr);
		
		% Update Sent Priority Message Log
		sentList = [{criticalCommandStr}; g_handles.SentMessages.String];
		set(g_handles.SentMessages, 'String', sentList);
	catch
		set(g_handles.portNumber, 'String', 'Connection Error');
		set(g_handles.portNumber, 'BackgroundColor', [1 0 0]);
	end

end

function response=receive_string()
	% Receive a message from the robot
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
    
	
    response = [];
    if (socket.BytesAvailable)
        response = fgetl(socket);
		
		copy = response;
		copy_split = string(strsplit(copy));
        
        % Update Status
        if (strcmp(copy_split(1),'jointAngle'))
            set(g_handles.Joint1Status,'string',copy_split(2));
            set(g_handles.Joint2Status,'string',copy_split(3));
            set(g_handles.Joint3Status,'string',copy_split(4));
            set(g_handles.Joint4Status,'string',copy_split(5));
            set(g_handles.Joint5Status,'string',copy_split(6));
            set(g_handles.Joint6Status,'string',copy_split(7));
            
        elseif (strcmp(copy_split(1),'endEffector'))     
            set(g_handles.XStatus,'string',copy_split(2));
            set(g_handles.YStatus,'string',copy_split(3));
            set(g_handles.ZStatus,'string',copy_split(4));
            set(g_handles.q1Status,'string',copy_split(5));
            set(g_handles.q2Status,'string',copy_split(6));
            set(g_handles.q3Status,'string',copy_split(7));
            set(g_handles.q4Status,'string',copy_split(8));
            
        elseif (strcmp(copy_split(1),'DIO'))            
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
            emergencyStop = copy_split(2);
            lightCurtain = copy_split(3);
            motorOn = copy_split(4);
            holdToEnable = copy_split(5);
            ExecutionError = copy_split(6);
            motorSupTriggered = copy_split(7);
            conveyorEnable = copy_split(8);
            
            if (emergencyStop == 1 || lightCurtain == 0 || motorOn == 0 || holdToEnable == 0 || ExecutionError == 1 || motorSupTriggered == 1 || conveyorEnable == 0)
                set(g_handles.errorPanel,'Visible','On');
                command_flag = 0;
                
                % depending on the error, change the text colors
                if (emergencyStop == 1)
					set(g_handles.emergencyStop, 'BackgroundColor', [1 0 0]);
                end
            end
            
        else
            % Update Received Message Log
            receivedList = [{response}; g_handles.ReceivedMessages.String];
            set(g_handles.ReceivedMessages, 'String', receivedList);
		end

    end
% 	fprintf(char(response));
	
end

function connectToRobot(buttonNo)
	global socket;
	global real_robot_IP_address;
	global sim_robot_IP_address;
	global robot_port;
	global s_timer;
	global r_timer;
	global vid;
    global g_handles;

	% Connect to the robot 	
	try
		% Open a TCP connection to the robot.
		socket = tcpip(sim_robot_IP_address, robot_port);
		set(socket, 'ReadAsyncMode', 'continuous');
		fopen(socket);
		
		str = sprintf(' IP: %s \n Port: %d',sim_robot_IP_address,robot_port);
		set(g_handles.portNumber, 'String', str);
		set(g_handles.portNumber, 'BackgroundColor', [0 0 0]);
		
		if (buttonNo==1)
			start(s_timer);
			start(r_timer);
		end

%     % Start Cameras
%     axes(handles.TableCamera);
%     axes(handles.ConveyorCamera);
%     vid = videoinput('winvideo',1, 'MJPG_1600x1200'); 
%     video_resolution1 = vid.VideoResolution;
%     nbands1 = vid.NumberOfBands;
%     vid2 = videoinput('winvideo',2,'MJPG_1600x1200'); 
%     video_resolution2 = vid2.VideoResolution;
%     nbands2 = vid2.NumberOfBands;
% 
%     % sguideet image handle
%     hImage=image(zeros([video_resolution1(2), video_resolution1(1), nbands1]),'Parent',handles.TableCamera);
%     hImage2=image(zeros([video_resolution2(2), video_resolution2(1), nbands2]),'Parent',handles.ConveyorCamera);
%     preview(vid,hImage);
%     preview(vid2,hImage2);


    % Check if the connection is valid.+6

    if(~isequal(get(socket, 'Status'), 'open'))
        warning(['Could not open TCP connection to ', sim_robot_IP_address, ' on port ', robot_port]);
        return;
    end

    % Effectly changing 'screens'
    set(g_handles.CameraPanel,'Visible','On');
    set(g_handles.statusPanel,'Visible','On');
    set(g_handles.DIOPanel,'Visible','On');
    set(g_handles.RobotStatusPanel,'Visible','On');
    set(g_handles.SafetyPanel,'Visible','Off');
    set(g_handles.errorPanel,'Visible','Off');

    catch error
        fprintf(error.message);
        
        error_handling();
        msgbox('Invalid Connection. Please reconnect.');
		
		if (buttonNo==2)
			set(g_handles.CameraPanel,'Visible','Off');
			set(g_handles.statusPanel,'Visible','Off');
			set(g_handles.DIOPanel,'Visible','Off');
			set(g_handles.RobotStatusPanel,'Visible','Off');
			set(g_handles.SafetyPanel,'Visible','On');
            set(g_handles.errorPanel,'Visible','Off');
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
    if VacuumPumpValue == 1
		commandStr = 'vacuumPumpOn';
		queue.add(commandStr);
    else
		commandStr = 'vacuumPumpOff';
		queue.add(commandStr);
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
    if VacuumSolenoidValue == 1
		commandStr = 'vacuumSolenoidOn';
		queue.add(commandStr);	
    else
		commandStr = 'vacuumSolenoidOff';
		queue.add(commandStr);
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
    if ConveyorRunValue == 1
		commandStr = 'conveyorRunOn';
		queue.add(commandStr);	
    else
		commandStr = 'conveyorRunOff';
		queue.add(commandStr);
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
    if ConveyorReverseValue == 1
		commandStr = 'conveyorReverseOn';
		queue.add(commandStr);
    else
		commandStr = 'conveyorReverseOff';
		queue.add(commandStr);
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
status_queue.add(commandStr);

% Resume sending commands to the robot
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
status_queue.add(commandStr);

% Stop sending commands to the robot
command_flag = 0;

end

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

commandStr = 'cancel';
status_queue.add(commandStr);

end

% --- Executes on button press in SafetyConfimation.
function SafetyConfimation_Callback(hObject, eventdata, handles)
% hObject    handle to SafetyConfimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	buttonNo = 1;

    SWP = SWPGET(handles);
    zero = find(SWP ~= 1);
    if (isempty(zero))		
		
		connectToRobot(buttonNo);
	
    else
        msgbox('PLEASE READ AND CHECK ALL BOXES');
    end
end    
    
function value = SWPGET(handles)
    value(1) = get(handles.SWP1,'Value');
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


% --- Executes on button press in Decline.
function Decline_Callback(hObject, eventdata, handles)
% hObject    handle to Decline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close all;
end

% --- Executes on button press in SWP1.
function SWP1_Callback(hObject, eventdata, handles)
% hObject    handle to SWP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP1
end


% --- Executes on button press in SWP2.
function SWP2_Callback(hObject, eventdata, handles)
% hObject    handle to SWP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP2
end

% --- Executes on button press in SWP3.
function SWP3_Callback(hObject, eventdata, handles)
% hObject    handle to SWP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP3
end

% --- Executes on button press in SWP4.
function SWP4_Callback(hObject, eventdata, handles)
% hObject    handle to SWP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP4
end

% --- Executes on button press in SWP5.
function SWP5_Callback(hObject, eventdata, handles)
% hObject    handle to SWP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP5
end

% --- Executes on button press in SWP6.
function SWP6_Callback(hObject, eventdata, handles)
% hObject    handle to SWP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP6
end

% --- Executes on button press in SWP7.
function SWP7_Callback(hObject, eventdata, handles)
% hObject    handle to SWP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP7
end


% --- Executes on button press in SWP8.
function SWP8_Callback(hObject, eventdata, handles)
% hObject    handle to SWP8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP8
end

% --- Executes on button press in SWP9.
function SWP9_Callback(hObject, eventdata, handles)
% hObject    handle to SWP9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP9
end

% --- Executes on button press in SWP10.
function SWP10_Callback(hObject, eventdata, handles)
% hObject    handle to SWP10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP10
end

% --- Executes on button press in SWP11.
function SWP11_Callback(hObject, eventdata, handles)
% hObject    handle to SWP11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP11
end

% --- Executes on button press in SWP12.
function SWP12_Callback(hObject, eventdata, handles)
% hObject    handle to SWP12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP12
end

% --- Executes on button press in SWP13.
function SWP13_Callback(hObject, eventdata, handles)
% hObject    handle to SWP13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SWP13
end




% --- Executes on button press in SecretButton.
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

	
	% Connect to the robot 	
% 		try		
			% Open a TCP connection to the robot.
% 			socket = tcpip(real_robot_IP_address, robot_port,'ConnectTimeout',5);
			socket = tcpip(real_robot_IP_address, robot_port);
			set(socket, 'ReadAsyncMode', 'continuous');
% 			fopen(socket);

			start(s_timer);
			start(r_timer);
			
% % 			% Start Cameras
% 			axes(handles.TableCamera);
% 			axes(handles.ConveyorCamera);
%   			vid = videoinput('winvideo',1, 'MJPG_1600x1200'); 
%             video_resolution1 = vid.VideoResolution;
%             nbands1 = vid.NumberOfBands;
% 			vid2 = videoinput('winvideo',2,'MJPG_1600x1200'); 
%             video_resolution2 = vid2.VideoResolution;
%             nbands2 = vid2.NumberOfBands;
% 
% 			% sguideet image handle
%  			hImage=image(zeros([video_resolution1(2), video_resolution1(1), nbands1]),'Parent',handles.TableCamera);
% 			hImage2=image(zeros([video_resolution2(2), video_resolution2(1), nbands2]),'Parent',handles.ConveyorCamera);
%  			
%             preview(vid,hImage);
%  			preview(vid2,hImage2);
% 			src1 = getselectedsource(vid);
%             src1.ExposureMode='manual';
%             src1.Exposure = -5;
			% Check if the connection is valid.+6

% 			if(~isequal(get(socket, 'Status'), 'open'))
% 				warning(['Could not open TCP connection to ', real_robot_IP_address, ' on port ', robot_port]);
% 				return;
% 			end
			
			% Effectly changing 'screens'
			set(handles.CameraPanel,'Visible','On');
			set(handles.statusPanel,'Visible','On');
			set(handles.DIOPanel,'Visible','On');
			set(handles.RobotStatusPanel,'Visible','On');
			set(handles.SafetyPanel,'Visible','Off');
            set(handles.errorPanel,'Visible','Off');
		
% 		catch
% 			try 
% 				socket = tcpip(sim_robot_IP_address, robot_port,'ConnectTimeout',5);
% 				set(socket, 'ReadAsyncMode', 'continuous');
% 				fopen(socket);
% 
% 				if(~isequal(get(socket, 'Status'), 'open'))
% 				warning(['Could not open TCP connection to ', sim_robot_IP_address, ' on port ', robot_port]);
% 				return;		
% 				end
% 				
% 				% Effectly changing 'screens'
% 				set(handles.CameraPanel,'Visible','On');
% 				set(handles.statusPanel,'Visible','On');
% 				set(handles.DIOPanel,'Visible','On');
% 				set(handles.RobotStatusPanel,'Visible','On');
% 				set(handles.SafetyPanel,'Visible','Off');
% 				
% 			catch
% 				error_handling();
% 				msgbox('I CANNOT CONNECT TO EITHER REAL ROBOT OR SIMULATION');			
% 				return;
% 			end
% 		end

        
end



function endEffectorX_Callback(hObject, eventdata, handles)

% hObject    handle to endEffectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorX as text
%        str2double(get(hObject,'String')) returns contents of endEffectorX as a double
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

	switch string(str(val))
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
    
    j_Speed = 'v50';
    switch joggingSpeed
		case 'Slow'
			j_Speed = 'v50';
		case 'Regular'
			j_Speed = 'v100';
		case 'Fast'
			j_Speed = 'v500';
    end

    endEffectorXposValue = get(hObject,'Value');
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
    switch joggingSpeed
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
    switch joggingSpeed
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
    switch joggingSpeed
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
	
	switch poseSpeed
		case 'Slow'
			speed = 'v50';
		case 'Regular'
			speed = 'v100';
		case 'Fast'
			speed = 'v500';
	end
	
	
	switch poseMode
		case 1
			eex = eeX;
			eey = eeY;
			eez = eeZ;
            roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
			
	        commandStr = sprintf('moveerc %d %d %d %d %d %d %s', eex,eey,eez,roll,pitch,yaw,speed);
	        queue.add(commandStr);
		case 2
			eex = eeX;
			eey = eeY;
			eez = eeZ;
			roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
            commandStr = sprintf('moveert %d %d %d %d %d %d %s', eex,eey,eez,roll,pitch,yaw,speed);
            queue.add(commandStr);
		case 3
			q1 = jaQ1;
			q2 = jaQ2;
			q3 = jaQ3;
			q4 = jaQ4;
			q5 = jaQ5;
			q6 = jaQ6;
            commandStr = sprintf('movejas %d %d %d %d %d %d %s', q1,q2,q3,q4,q5,q6,speed);
            queue.add(commandStr);
		case 4
			roll = eeROLL;
			pitch = eePITCH;
			yaw = eeYAW;
            commandStr = sprintf('moveree %d %d %d %s', roll,pitch,yaw,speed);
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

    contents = cellstr(get(hObject,'String'));
    joggingModeValue = contents{get(hObject,'Value')};

    if (strcmp(joggingModeValue,'End Effector rel Base Frame'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.endEffectorFrameMode,'Visible','Off');
        set(handles.baseFrameMode,'Visible','On');
    elseif(strcmp(joggingModeValue,'End Effector rel End Effector Frame'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.endEffectorFrameMode,'Visible','On');
        set(handles.baseFrameMode,'Visible','Off');
    elseif (strcmp(joggingModeValue,'Joint Angles'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','On');
        set(handles.endEffectorFrameMode,'Visible','Off');
        set(handles.baseFrameMode,'Visible','Off');
    elseif (strcmp(joggingModeValue,'Reorient End Effector'))
        set(handles.reorientEndEffectorMode,'Visible','On');
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
    switch joggingSpeed
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
    switch joggingSpeed
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
buttonNo = 2;

connectToRobot(buttonNo);

end



% --- Executes on button press in Shutdown.
function Shutdown_Callback(hObject, eventdata, handles)
global status_queue;
% hObject    handle to Shutdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
commandStr = 'shutdown';
status_queue.add(commandStr);
pause(5);
error_handling();
close all;


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
function TableCamSS_Callback(hObject, eventdata, handles)
% hObject    handle to TableCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TableCamSS
    global vid
    global tableParam
    global tableCameraR

    Rot = tableCameraR.R;
    Trans = [-114.9484  337.2691  831.0543] %initial more accurate
    %Trans = [-362.2664002845348	-42.383249883396594	903.6546791412422]%later 

    if (get(hObject,'Value') == 1)
        %screenshot table cam
        im = getsnapshot(vid);
        axes(handles.TableCamera);
        figure(1);
        imshow(im);
        close(figure(1));
        [x1, y1]=getpts(handles.TableCamera)
        x1 = round(x1);
        y1 = round(y1);

        if x1 < 0 | x1 >1200
            flag = 0;
        else
            worldPoints = pointsToWorld(tableParam.mainCameraParams, Rot, Trans, [x1 y1])
            flag = 1;
        end

        xTol=738;
        yTol=-110;
        zTol=13;
        
        switch flag
            case 0 %out of bounds
                disp('OUT OF BOUNDS: PLS TAKE PIC WITHIN TABLE CAMERA FRAME');
            case 1 %within bounds
                disp('PRINTING VALUES OF X Y Z');
                eex = worldPoints(end,1)+xTol;
                eey = worldPoints(end,2)+yTol;
                eez = 147+zTol;
                disp(eex)
                disp(eey)
                disp(eez)
        end
    end
end

% --- Executes on button press in ConveyorCamSS.
function ConveyorCamSS_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global vid2
    global convParam 
    global convCameraR
    global convCameraT

    Rot = convCameraR.R;
    Trans = convCameraT.t;
    %Trans = [-114.9484  337.2691  831.0543] %initial more accurate
    %Trans = [-362.2664002845348	-42.383249883396594	903.6546791412422]%later 

    if (get(hObject,'Value') == 1)
        %screenshot table cam
        im = getsnapshot(vid2);
        axes(handles.ConveyorCamera);
        figure(1);
        imshow(im);
        close(figure(1));
        [x1, y1]=getpts(handles.ConveyorCamera)
        x1 = round(x1);
        y1 = round(y1);
        if x1 < 0 | x1 >1200
            flag = 0;
        else
            worldPoints = pointsToWorld(convParam.mainCameraParams, Rot, Trans, [x1 y1])
            flag = 1;
        end
    
        xTol=738;
        yTol=-110;
        zTol=13;
    
        switch flag
            case 0 %out of bounds
                disp('OUT OF BOUNDS: PLS TAKE PIC WITHIN TABLE CAMERA FRAME');
            case 1 %within bounds
                disp('PRINTING VALUES OF X Y Z');
                eex = worldPoints(end,1)+xTol;
                eey = worldPoints(end,2)+yTol;
                eez = 22+zTol;
                disp(eex)
                disp(eey)
                disp(eez)        
        end
    end
% Hint: get(hObject,'Value') returns toggle state of ConveyorCamSS
end

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
global vid2;
if get(hObject,'Value') == 1
   box = getsnapshot(vid2);
    figure(1);
    imshow(box); hold on;
   box1 = box;
   box1(:,1:580,:)=0;
   box1(:,1180:1600,:)=0;
   box1(710:1200,:,:)=0;
   
   greybox1 = rgb2gray(box1);
   bw = imbinarize(greybox1,0.5);
   bw= ~bwareaopen(~bw,152200);
   bOrientation = regionprops('table',bw,'Centroid','Image','Orientation');
   text(bOrientation.Centroid(1,1),bOrientation.Centroid(1,2),num2str(bOrientation.Orientation(1)),'Color','red','FontSize',20);
   contour(bw,'r');
end
end


function getBlocks_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorCamSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ConveyorCamSS
global vid;
if get(hObject,'Value') == 1
   
    snapshot = getsnapshot(vid);
    image = ycbcr2rgb(snapshot);
     figure(1);
    imshow(image); hold on;
    [angles, position, letter, finalText] = useBlocks(image); 
    
    %centroids, reachable
    images = image;
    imHSV = rgb2hsv(images);
    
    imMask = imHSV(:,:,2)<0.25 & imHSV(:,:,3)>0.68;
    imMask(1:250, :, :) = 1;
    imMask(end-20:end, :, :) = 1;
    imMask(:, end-20:end, :) = 1;
    imMask(:, 1:20, :) = 1;
    SE1 = strel('line',3.3,0);
    imMask = imclose(imMask,SE1);
    SE2 = strel('line',3.3,90);
    imMask = imclose(imMask,SE2);
    SE3 = strel('disk',3);
    imMask = imclose(imMask,SE3);
    bCentroid = regionprops('table',imMask,'Centroid');
    centroids = bCentroid.Centroid(:,:);
    N = length(centroids(:,1));
    %reachable define
    reachableTag = ones(1,N);
    Cx =805;
    Cy = 25.5943;
    radius = 832.405697;
    for j=1:N
    d = sqrt((centroids(j,1)-Cx)^2+(centroids(j,2)-Cy)^2);
    if (d>radius)
        reachableTag(1,j) = 0;
    end
    end

%edge finding with reachable
    image(1:250,:,:)=0;  %resolution change here
    greyBlocks = rgb2gray(image);
    bwBlocks = imbinarize(greyBlocks);
    seH = strel('line',3.9,0);
    closeH = imclose(bwBlocks,seH);
    seV = strel('line',3.9,90);
    closeV = imclose(closeH,seV);
    Blocks_final = medfilt2(closeV);
    Blocks_final(1:250,:,:)=255;
    Blocks_final = bwareaopen(Blocks_final,900);
    Blocks_final = ~bwareaopen(~Blocks_final,100);
    Blocks_final =~Blocks_final;
    [B,L] = bwboundaries(Blocks_final,'noholes');
    
   for k = 1:length(B)
   boundary = B{k};
   if (reachableTag(1,k) ==1)
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
   else 
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)    
   end
   end
    
    % Constructing Final Array
    for i=1:length(angles)
        block = [position(i,1), position(i,2),... 
            angles(i), letter(i),...
            isReachable(position(i,1), position(i,2))];
        % See if block is reachable or not
        if (block(5)==1)
            text(position(i,1)+30, position(i,2)+30, [finalText(i) ' , ' num2str(angles(i))], 'Color','blue');
        else
            text(position(i,1)+30, position(i,2)+30, [finalText(i) ' , ' num2str(angles(i))], 'Color','red');
        end
    end
end
end

%blocks detection function
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

% Identifying Blocks
function [trueAngles, centroids, letter, finalTextBefore] = useBlocks(image)

%     images = imsharpen(image);
    images = image;
    imHSV = rgb2hsv(images);
    
    imMask = imHSV(:,:,2)<0.25 & imHSV(:,:,3)>0.68;
    imMask(1:250, :, :) = 1;
    imMask(end-20:end, :, :) = 1;
    imMask(:, end-20:end, :) = 1;
    imMask(:, 1:20, :) = 1;

    % Remove grid from image   
%     for i=1:1200
%         imMask(i,:) = ~bwareaopen(~imMask(i,:),4);
%     end
%     for i=1:1600
%         imMask(:,i) = ~bwareaopen(~imMask(:,i),4);
%     end
    SE1 = strel('line',3.3,0);
    imMask = imclose(imMask,SE1);
    SE2 = strel('line',3.3,90);
    imMask = imclose(imMask,SE2);
    SE3 = strel('disk',3);
    imMask = imclose(imMask,SE3);  
     bCentroid = regionprops('table',imMask,'Centroid');
     centroids = bCentroid.Centroid(2:end,:);
    % Remove the letter inside block
    newMask = bwareaopen(imMask,800);

    % Find characteristics of blocks using regionprops
%      [centroids, area] = shapeCentroid(~newMask);
    
    % Find how many blocks are in a centroid
%     for i=1:length(area)
%         true = 0;
%         numberBlocks(i) = round(area(i)/2400);
%         if (numberBlocks(i) > 1)
%             imMask = imMask - bwareaopen(imMask, 3000);
%             colourMask = bwperim(imMask);
% %             Find characteristics of blocks using regionprops
%             [centroids, area] = shapeCentroid(colourMask);
%             true = 1;
%         end
%         if (true==1)
%             break
%         end
%     end
    
    % Find Corner points using Douglas Peucker
     contour1 = contourc(double(newMask));
     res = DouglasPeucker(contour1,25);  % somewhere above 20
     co = removeZero(res); % Removes zero points 
   
    % this section calculates the angle of the block
    for i=1:length(centroids(:,1))
        angles(i) = findAngle(co, centroids(i,:));
        [trueAngles(i), letter(i), finalTextBefore(i)] = findLetter(angles(i), centroids(i,:), imMask);
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
%          imshow(case1)
    results1 = ocr(case1, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (isempty(results1.Words) == 1)
        text = [0];
        results = [0];
    else
        text = [results1.Text(1)];
        results = [results1.WordConfidences(1)];
    end

    % CASE 2: Angle + 90
    case2 = imrotate(I2,degrees(2));
    case2 = bwareaopen(case2, 100);
    results2 = ocr(case2, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case2)
    if (isempty(results2.Words) == 1)
        text = [text; 0];
        results = [results; 0];
    else
        text = [text; results2.Text(1)];
        results = [results; results2.WordConfidences(1)];
    end

    % CASE 3: Angle - 90 
    case3 = imrotate(I2,degrees(3));
    case3 = bwareaopen(case3, 100);
    results3 = ocr(case3, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case3)
    if (isempty(results3.Words) == 1)
        text = [text ;0];
        results = [results; 0];
    else
        text = [text; results3.Text(1)];
        results = [results; results3.WordConfidences(1)];
    end

    % CASE 4: Angle - 180  
    case4 = imrotate(I2,degrees(4));
    case4 = bwareaopen(case4, 100);
    results4 = ocr(case4, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case4)
    if (isempty(results4.Words) == 1)
        text = [text; 0];
        results = [results; 0];
    else
        text = [text; results4.Text(1)];
        results = [results; results4.WordConfidences(1)];
    end

    % See which case has the highest confidence value
    max_num=max(results); 
    [max_num,max_idx] = max(results);
    rad = [0; (pi/2); (-pi/2); (-pi)];
    

    letter2number = @(c)1+lower(c)-'a'; % Convert letter to digit
    finalTextBefore = text(max_idx);
    finalText = letter2number(finalTextBefore);
    letter = finalText;
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
    
 else
    msg('Please fix error');
 end

end
