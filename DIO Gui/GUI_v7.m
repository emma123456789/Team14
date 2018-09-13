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

% Last Modified by GUIDE v2.5 14-Sep-2018 05:50:41

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

% axes(handles.TableCamera);
% axes(handles.ConveyorCamera);
% vid = videoinput('winvideo',1); 
% vid2 = videoinput('winvideo',2); 
% 
% % sguideet image handle
% hImage=image(zeros(800,1280,3),'Parent',handles.TableCamera);
% hImage2=image(zeros(800,1280,3),'Parent',handles.ConveyorCamera);
% preview(vid,hImage);
% preview(vid2,hImage2);


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

queue = LinkedList();
status_queue = LinkedList();

s_timer = timer;
s_timer.TimerFcn = @sendTimer;
s_timer.period = 0.5;
s_timer.ExecutionMode = 'fixedSpacing';
start(s_timer);
r_timer = timer;
r_timer.TimerFcn = @receiveTimer;
r_timer.period = 0.5;
r_timer.ExecutionMode = 'fixedSpacing';
start(r_timer);

command_flag = 1;
g_handles = handles;

end


function sendTimer(obj, event)
	global command_flag;
	global status_queue;
	
	if (status_queue.size()>0)
		send_priorityString();
		
	elseif (command_flag == 1)
        send_string();
%         fprintf('c\n');
 		command_flag = 0;
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

	% Stop the timers	
	stop(s_timer);
	stop(r_timer);
	delete(timerfindall);

end

function send_string()
	% Send a command to the robot
	global queue;
	global socket;
	global g_handles;

	if queue.size()>0
		% Obtain the fist command in the linkedlist
		commandStr = queue.pop();
		fwrite(socket,commandStr);
 		%fprintf(char(commandStr));
		
		% Update Sent Message Log
		sentList = [{commandStr}; g_handles.SentMessages.String];
        set(g_handles.SentMessages, 'String', sentList);
	end

end

function send_priorityString()
	% Send pause, resume and cancel immediately after they're pressed
	global status_queue;
	global socket;
	global g_handles;

	criticalCommandStr = status_queue.pop();
	fwrite(socket,criticalCommandStr);
	
	% Update Sent Priority Message Log
	sentList = [{criticalCommandStr}; g_handles.SentMessages.String];
    set(g_handles.SentMessages, 'String', sentList);
	
end

function response=receive_string()
	% Receive a message from the robot
	global socket;
	global g_handles;
	
    response = [];
    if (socket.BytesAvailable)
        response = fgetl(socket);
		
		% Update Received Message Log
		receivedList = [{response}; g_handles.ReceivedMessages.String];
        set(g_handles.ReceivedMessages, 'String', receivedList);
    end
	fprintf(char(response));
	
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
        set(handles.VacuumPumpStatus,'string', 'Vacuum Pump On')
		commandStr = 'vacuumPumpOn';
		queue.add(commandStr);
    else
        set(handles.VacuumPumpStatus,'string', 'Vacuum Pump Off')
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
        set(handles.VacuumSolenoidStatus,'string', 'Vacuum Solenoid On')
		commandStr = 'vacuumSolenoidOn';
		queue.add(commandStr);	
    else
        set(handles.VacuumSolenoidStatus,'string', 'Vacuum Solenoid Off')
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
        set(handles.ConveyorRunStatus,'string', 'Conveyor Run On')
		commandStr = 'conveyorRunOn';
		queue.add(commandStr);	
    else
        set(handles.ConveyorRunStatus,'string', 'Conveyor Run Off')
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
        set(handles.ConveyorReverseStatus,'string', 'Conveyor Reverse On')
		commandStr = 'conveyorReverseOn';
		queue.add(commandStr);
    else
        set(handles.ConveyorReverseStatus,'string', 'Enable Conveyor Off')
		commandStr = 'conveyorReverseOff';
		queue.add(commandStr);
    end
end

% --- Executes on button press in EnableConveyor.
function EnableConveyor_Callback(hObject, eventdata, handles)
global queue;
% hObject    handle to EnableConveyor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    EnableConveyorValue = get(hObject,'Value');
    if EnableConveyorValue == 1
        set(handles.EnableConveyorStatus,'string', 'Enable Conveyor On')
		commandStr = 'enableConveyorOn';
		queue.add(commandStr);
    else
        set(handles.EnableConveyorStatus,'string', 'Enable Conveyor Off')
		commandStr = 'enableConveyorOff';
		queue.add(commandStr);
    end
end


% --- Executes on button press in Resume.
function Resume_Callback(hObject, eventdata, handles)
global status_queue;
% hObject    handle to Resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

commandStr = 'resume';
status_queue.add(commandStr);

end

% --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
global status_queue;
% hObject    handle to Pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

commandStr = 'pause';
status_queue.add(commandStr);

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


    SWP = SWPGET(handles);
    zero = find(SWP ~= 1);
    if (isempty(zero))
        % Effectly changing 'screens'
        set(handles.CameraPanel,'Visible','On');
        set(handles.statusPanel,'Visible','On');
        set(handles.DIOPanel,'Visible','On');
        set(handles.RobotStatusPanel,'Visible','On');
        set(handles.SafetyPanel,'Visible','Off');
		
	% Connect to the robot 	
	global socket;

	% The robot's IP address.
% 	robot_IP_address = '192.168.125.1'; % Real robot ip address
	robot_IP_address = '127.0.0.1'; % Simulation ip address

	% The port that the robot will be listening on. This must be the same as in
	% your RAPID program.
	robot_port = 1025;
% 	Server_port = 10000;

	% Open a TCP connection to the robot.
	socket = tcpip(robot_IP_address, robot_port);
    
	set(socket, 'ReadAsyncMode', 'continuous');
	fopen(socket);

	% Check if the connection is valid.+6

	if(~isequal(get(socket, 'Status'), 'open'))
		warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
		return;
	end
	
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
    msgbox('YOU SUCK');
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
% hObject    handle to SecretButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        set(handles.CameraPanel,'Visible','On');
        set(handles.statusPanel,'Visible','On');
        set(handles.DIOPanel,'Visible','On');
        set(handles.RobotStatusPanel,'Visible','On');
        set(handles.SafetyPanel,'Visible','Off');
		
	global socket;

	% The robot's IP address.
	robot_IP_address = '192.168.125.1'; % Real robot ip address
% 	robot_IP_address = '127.0.0.1'; % Simulation ip address

	% The port that the robot will be listening on. This must be the same as in
	% your RAPID program.
	robot_port = 1025;
% 	Server_port = 10000;

	% Open a TCP connection to the robot.
	socket = tcpip(robot_IP_address, robot_port);
    
	set(socket, 'ReadAsyncMode', 'continuous');
% 	fopen(socket);

	% Check if the connection is valid.+6

	if(~isequal(get(socket, 'Status'), 'open'))
		warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
		return;
	end
        
end



function endEffectorX_Callback(hObject, eventdata, handles)

% hObject    handle to endEffectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorX as text
%        str2double(get(hObject,'String')) returns contents of endEffectorX as a double
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


function endEffectorQ4_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorQ4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorQ4 as text
%        str2double(get(hObject,'String')) returns contents of endEffectorQ4 as a double
end

% --- Executes during object creation, after setting all properties.
function endEffectorQ4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorQ4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function endEffectorQ3_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorQ3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorQ3 as text
%        str2double(get(hObject,'String')) returns contents of endEffectorQ3 as a double
end

% --- Executes during object creation, after setting all properties.
function endEffectorQ3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorQ3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function endEffectorQ2_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorQ2 as text
%        str2double(get(hObject,'String')) returns contents of endEffectorQ2 as a double
end

% --- Executes during object creation, after setting all properties.
function endEffectorQ2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function endEffectorQ1_Callback(hObject, eventdata, handles)
% hObject    handle to endEffectorQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endEffectorQ1 as text
%        str2double(get(hObject,'String')) returns contents of endEffectorQ1 as a double
end

% --- Executes during object creation, after setting all properties.
function endEffectorQ1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endEffectorQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
end

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
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

% --- Executes on button press in jogXpos.
function jogXpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogXpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'xPlus';
queue.add(commandStr);

% Just to test if the linkedlist works fine although I'm pretty sure it
% works fine
% str = queue.pop();
send_string();
% receive_string();
% fprintf(char(str));

end

% --- Executes on button press in jogXneg.
function jogXneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogXneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'xMinus';
queue.add(commandStr);

end

% --- Executes on button press in jogYpos.
function jogYpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogYpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'yPlus';
queue.add(commandStr);

end

% --- Executes on button press in jogZpos.
function jogZpos_Callback(hObject, eventdata, handles)
% hObject    handle to jogZpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'zPlus';
queue.add(commandStr);

end

% --- Executes on button press in jogZneg.
function jogZneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogZneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'zMinus';
queue.add(commandStr);

end

% --- Executes on button press in jogYneg.
function jogYneg_Callback(hObject, eventdata, handles)
% hObject    handle to jogYneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global queue;

commandStr = 'yMinus';
queue.add(commandStr);

end


% --- Executes on selection change in joggingSpeed.
function joggingSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to joggingSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns joggingSpeed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from joggingSpeed
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
% hObject    handle to moveRobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

commandStr = 'move';
queue.add(commandStr);

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

    if (strcmp(joggingModeValue,'End Effector rel Conveyor'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.linearMode,'Visible','On');
    elseif(strcmp(joggingModeValue,'End Effector rel Base'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','Off');
        set(handles.linearMode,'Visible','On');    
    elseif (strcmp(joggingModeValue,'Joint Angles'))
        set(handles.reorientEndEffectorMode,'Visible','Off');
        set(handles.jointMode,'Visible','On');
        set(handles.linearMode,'Visible','Off');
    elseif (strcmp(joggingModeValue,'Reorient End Effector'))
        set(handles.reorientEndEffectorMode,'Visible','On');
        set(handles.jointMode,'Visible','Off');
        set(handles.linearMode,'Visible','Off');
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
end

% --- Executes on button press in jogQ6pos.
function jogQ6pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ6pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ5neg.
function jogQ5neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ5neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ5pos.
function jogQ5pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ5pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ4neg.
function jogQ4neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ4neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ4pos.
function jogQ4pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ4pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ3neg.
function jogQ3neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ3neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ3pos.
function jogQ3pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ3pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ2neg.
function jogQ2neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ2neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ2pos.
function jogQ2pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ2pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ1neg.
function jogQ1neg_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ1neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in jogQ1pos.
function jogQ1pos_Callback(hObject, eventdata, handles)
% hObject    handle to jogQ1pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ4neg.
function REORIENTjogQ4neg_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ4neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ4pos.
function REORIENTjogQ4pos_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ4pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ3neg.
function REORIENTjogQ3neg_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ3neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ3pos.
function REORIENTjogQ3pos_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ3pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ2neg.
function REORIENTjogQ2neg_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ2neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ2pos.
function REORIENTjogQ2pos_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ2pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ1neg.
function REORIENTjogQ1neg_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ1neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in REORIENTjogQ1pos.
function REORIENTjogQ1pos_Callback(hObject, eventdata, handles)
% hObject    handle to REORIENTjogQ1pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in connectToPort.
function connectToPort_Callback(hObject, eventdata, handles)
% hObject    handle to connectToPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

	global socket;

	% The robot's IP address.
	robot_IP_address = '192.168.125.1'; % Real robot ip address
% 	robot_IP_address = '127.0.0.1'; % Simulation ip address

	% The port that the robot will be listening on. This must be the same as in
	% your RAPID program.
	robot_port = 1025;
% 	Server_port = 10000;

	% Open a TCP connection to the robot.
	socket = tcpip(robot_IP_address, robot_port);
    
	set(socket, 'ReadAsyncMode', 'continuous');
	fopen(socket);

	% Check if the connection is valid.+6

	if(~isequal(get(socket, 'Status'), 'open'))
		warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
		return;
	end

end
