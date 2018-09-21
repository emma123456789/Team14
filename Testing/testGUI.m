function varargout = testGUI(varargin)
% TESTGUI MATLAB code for testGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testGUI

% Last Modified by GUIDE v2.5 20-Sep-2018 17:02:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testGUI_OutputFcn, ...
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

% --- Executes just before testGUI is made visible.
function testGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGUI (see VARARGIN)

% Choose default command line output for testGUI
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

global vid1

axes(handles.axes1);
vid1 = videoinput('macvideo', 1);

% sguideet image handle
hImage=image(zeros(720,1280,3),'Parent',handles.axes1);
preview(vid1,hImage);

% picture=imread('IMG_001.jpg');
% imshow(picture,'Parent',handles.axes3);

picture=imread('convIMG.jpg');
imshow(picture,'Parent',handles.axes3);


Intrin = tableParam.mainCameraParams.IntrinsicMatrix;
Rot = tableCameraR.R;
Trans = tableParam.mainCameraParams.TranslationVectors;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = testGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in getCoordinates1.
function getCoordinates1_Callback(hObject, eventdata, handles)
% hObject    handle to getCoordinates1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tableParam
global tableCameraR
global vid1
Intrin = tableParam.mainCameraParams.IntrinsicMatrix;
Rot = tableCameraR.R;
%Trans = tableParam.mainCameraParams.TranslationVectors;
T = [-362.2664002845348	-42.383249883396594	903.6546791412422]
%[-114.9484  337.2691  831.0543]

if (get(hObject,'Value') == 1)
    %screenshot table cam
    im = getsnapshot(vid1);
    axes(handles.axes1);
    imshow(im);
    [x1, y1]=getpts(handles.axes1)
    x1 = round(x1); 
    y1 = round(y1);
    if x1 < 0 | x1 >1200
        flag = 0;
    else
        worldPoints = pointsToWorld(tableParam.mainCameraParams, Rot, T, [x1 y1])
        flag = 1;
    end
end
    
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
end


% --- Executes on button press in getImage.
function getImage_Callback(hObject, eventdata, handles)
% hObject    handle to getImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global tableParam
% global tableCameraR
% global convParam;
% global convCameraR;
% global convCameraT;
% 
% tableParam = load('cameraParams_table.mat');
% convParam = load('cameraParams_conveyor.mat');
% tableCameraR = load('cameraR_table.mat');
% convCameraR = load('cameraR_conveyor');
% convCameraT = load('cameraT_conveyor');
% 
% %global vid1
% Intrin = tableParam.mainCameraParams.IntrinsicMatrix;
% Rot = tableCameraR.R;
% Trans = tableParam.mainCameraParams.TranslationVectors;
% %T = [-362.2664002845348	-42.383249883396594	903.6546791412422]
% T=[-114.9484  337.2691  831.0543]
% 
% if (get(hObject,'Value') == 1)
%     %screenshot table cam
%     %im = getsnapshot(vid1);
%     %axes(handles.axes1);
%     %imshow(im);
%     
%     [x3, y3]=getpts(handles.axes3)
%     x3 = round(x3); 
%     y3 = round(y3);
%     if x3 < 0 | x3 >1200
%         flag = 0;
%     else
%         worldPoints = pointsToWorld(tableParam.mainCameraParams, Rot, T, [x3 y3]);
%         flag = 1;
%     end
%     
%         switch flag
%         case 0 %out of bounds
%             disp('OUT OF BOUNDS: PLS TAKE PIC WITHIN TABLE CAMERA FRAME');
%         case 1 %within bounds
%             disp('PRINTING VALUES OF X Y Z');
%             eeX = worldPoints(end,1)+738;
%             eeY = worldPoints(end,2)-110;
%             eeZ = 150;
%             disp(eeX)
%             disp(eeY)
%             disp(eeZ)
%         end
% end

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
%     im = getsnapshot(vid2);
%     axes(handles.ConveyorCamera);
%     imshow(im);
    [x1, y1]=getpts(handles.axes3)
    x1 = round(x1);
    y1 = round(y1);
    if x1 < 0 | x1 >1200
        flag = 0;
    else
        worldPoints = pointsToWorld(convParam.ConvCameraParams, Rot, Trans, [x1 y1])
        flag = 1;
    end
    
    switch flag
        case 0 %out of bounds
            disp('OUT OF BOUNDS: PLS TAKE PIC WITHIN CONVEYOR CAMERA FRAME');
        case 1 %within bounds on table
            disp('PRINTING VALUES OF X Y & MAYBE Z');
            xTol=-10; yTol=-12; zTol=13; %zTol dependednt on what item on table
            eex = worldPoints(end,1)+xTol;
            eey = worldPoints(end,2)+yTol;
            reachable = isReachableWorld(eex, eey);
            if reachable == true
                if (eey<634 & eey>184 & eex>0)
                    disp('IS REACHABLE BY ROBOT ARM ON CONVEYOR') 
                    eez = 22+zTol;
                    disp(eex)
                    disp(eey)
                    disp(eez)
                else 
                    disp('IS REACHABLE BY ROBOT ARM ON TABLE')
                    eez = 147+zTol;
                    disp(eex)
                    disp(eey)
                    disp(eez)
                end
            else
                disp(eex)
                disp(eey)
                disp('IS NOT REACHABLE');
                msgbox('IS NOT REACHABLE');
            end
    end
end
end

%blocks detection function
% Detects if Blocks are Reachable
function reachable = isReachableWorld(x, y)
    zeroPosition = [0, 0];
    radius = 548; 
    
    % Check if block is within reachable radius of robot
    if(x-zeroPosition(1))^2+(y-zeroPosition(2))^2<radius^2
        reachable = true;
    else
        reachable = false;
    end
end
