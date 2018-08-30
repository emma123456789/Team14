function varargout = DIOGUI(varargin)
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

% Last Modified by GUIDE v2.5 30-Aug-2018 23:15:54

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
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
% hObject    handle to VacuumPump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    VacuumPumpValue = get(hObject,'Value');
    if VacuumPumpValue == 1
        set(handles.VacuumPumpStatus,'string', "Vacuum Pump On")
    else
        set(handles.VacuumPumpStatus,'string', "Vacuum Pump Off")
    end
end


% --- Executes on button press in VacuumSolenoid.
function VacuumSolenoid_Callback(hObject, eventdata, handles)
% hObject    handle to VacuumSolenoid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    VacuumSolenoidValue = get(hObject,'Value');
    if VacuumSolenoidValue == 1
        set(handles.VacuumSolenoidStatus,'string', "Vacuum Solenoid On")
    else
        set(handles.VacuumSolenoidStatus,'string', "Vacuum Solenoid Off")
    end
end

% --- Executes on button press in ConveyorRun.
function ConveyorRun_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    ConveyorRunValue = get(hObject,'Value');
    if ConveyorRunValue == 1
        set(handles.ConveyorRunStatus,'string', "Conveyor Run On")
    else
        set(handles.ConveyorRunStatus,'string', "Conveyor Run Off")
    end
end    


% --- Executes on button press in ConveyorReverse.
function ConveyorReverse_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyorReverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    ConveyorReverseValue = get(hObject,'Value');
    if ConveyorReverseValue == 1
        set(handles.ConveyorReverseStatus,'string', "Conveyor Reverse On")
    else
        set(handles.ConveyorReverseStatus,'string', "Enable Conveyor Off")
    end
end

% --- Executes on button press in EnableConveyor.
function EnableConveyor_Callback(hObject, eventdata, handles)
% hObject    handle to EnableConveyor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% HINT: get(hObject,'Value') returns toggle status of togglebutton1
    EnableConveyorValue = get(hObject,'Value');
    if EnableConveyorValue == 1
        set(handles.EnableConveyorStatus,'string', "Enable Conveyor On")
    else
        set(handles.EnableConveyorStatus,'string', "Enable Conveyor Off")
    end
end


% --- Executes on button press in Resume.
function Resume_Callback(hObject, eventdata, handles)
% hObject    handle to Resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
% hObject    handle to Pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
        set(handles.ControlPanel,'Visible','On');
        set(handles.DIOPanel,'Visible','On');
        set(handles.RobotStatusPanel,'Visible','On');
        set(handles.SafetyPanel,'Visible','Off');

%         % Start Camera feed
%         % Presently will start device camera;
%         % Attempt to automatically detect which system you have/ mac/windows;
%         adaptor = imaqhwinfo;
%         adaptor = adaptor.InstalledAdaptors;
%         adaptor = adaptor{1};
%         try
%             axes(handles.axes1);
%             tablecam = videoinput(adaptor,1);
%             hImage = image(zeros(500,1200,3),'Parent',handles.axes1);
%             preview(tablecam,hImage);
%         end
% 
%         try
%             axes(handles.axes3);
%             conveyorcam = videoinput(adaptor,2);
%             hImage2 = image(zeros(500,1200,3),'Parent',handles.axes3);
%             preview(conveyorcam,hImage2);
%         end
          

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


% --- Executes on button press in SecretButton.
function SecretButton_Callback(hObject, eventdata, handles)
% hObject    handle to SecretButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        set(handles.CameraPanel,'Visible','On');
        set(handles.ControlPanel,'Visible','On');
        set(handles.DIOPanel,'Visible','On');
        set(handles.RobotStatusPanel,'Visible','On');
        set(handles.SafetyPanel,'Visible','Off');
        
end

