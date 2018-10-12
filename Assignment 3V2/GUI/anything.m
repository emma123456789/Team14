
% --- Executes on button press in sortDeckButton.
function sortDeckButton_Callback(hObject, eventdata, handles)
% hObject    handle to sortDeckButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in clearTableButton.
function clearTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in fillTableButton.
function fillTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to fillTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in reloadBoxButton.
function reloadBoxButton_Callback(hObject, eventdata, handles)
% hObject    handle to reloadBoxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in insertBoxButton.
function insertBoxButton_Callback(hObject, eventdata, handles)
% hObject    handle to insertBoxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in ConveyortoBPButton.
function ConveyortoBPButton_Callback(hObject, eventdata, handles)
% hObject    handle to ConveyortoBPButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in hi.
function hi_Callback(hObject, eventdata, handles)
% hObject    handle to hi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global BP2BP_letter;
	global BP2BP_number;
	global BP2BP_blocklist;
	x1 = BP2BP_blocklist(1);
    y1 = BP2BP_blocklist(2);
	[x2,y2] = gameboardConversion(BP2BP_number,BP2BP_letter);

	SM_BP2BP(x1,y1,x2,y2);
end

% --- Executes on button press in RotateBlockButton.
function RotateBlockButton_Callback(hObject, eventdata, handles)
% hObject    handle to RotateBlockButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in BPtoConveyorButton.
function BPtoConveyorButton_Callback(hObject, eventdata, handles)
% hObject    handle to BPtoConveyorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('hi');
	global BP2Conveyor_blocklist;
	x1 = BP2Conveyor_blocklist(1);
    y1 = BP2Conveyor_blocklist(2);
	% Need to know conveyor coordinates
    x2 = 0;
    y2 = 409;
	SM_BP2BP(x1,y1,x2,y2);
end
