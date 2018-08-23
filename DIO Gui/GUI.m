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

% Last Modified by GUIDE v2.5 18-Aug-2018 12:09:56

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


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
