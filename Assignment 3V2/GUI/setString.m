% setString will update the gui tic tac toe grid
function setString(plrmark, i, j, GuiHandle)
    handles = guidata(GuiHandle);
    if (i == 1)
        if (j == 1)
            set(handles.ttt1, 'String', plrmark);
        elseif (j == 2)
            set(handles.ttt2, 'String', plrmark);
        elseif (j == 3)
            set(handles.ttt3, 'String', plrmark);
        end
    elseif (i == 2)
        if (j == 1)
            set(handles.ttt4, 'String', plrmark);
        elseif (j == 2)
            set(handles.ttt5, 'String', plrmark);
        elseif (j == 3)
            set(handles.ttt6, 'String', plrmark); 
        end
    elseif (i == 3)
        if (j == 1)
            set(handles.ttt7, 'String', plrmark);
        elseif (j == 2)
            set(handles.ttt8, 'String', plrmark);
        elseif (j == 3)
            set(handles.ttt9, 'String', plrmark);
        end
    end
end