function [eeX, eeY, eeZ] = getTableXYZ(hObject,eventdata,handles)
    global tableParam tableImagePoints tableWorldPoints
    global vid

    if (get(hObject,'Value') == 1)
        %add in screenshot function 
        im = getsnapshot(vid);
        axes(handles.TableCamera);
        figure(1);
        imshow(im);
        close(figure(1));
        
        [R, T] = extrinsics(tableImagePoints.tImagePoints, tableWorldPoints.tWorldPoints, tableParam.tableCameraParams);
        [x, y] = getpts(handles.TableCamera); % need to change to respective axes
        x = round(x);
        y = round(y);

        if x < 0 || x >1200
            flag = 0;
        else
            worldPoints = pointsToWorld(tableParam.tableCameraParams, R, T, [x y]);
            flag = 1;
        end

        switch flag
            case 0 %out of bounds
                disp('OUT OF BOUNDS: PLS TAKE PIC WITHIN CONVEYOR CAMERA FRAME');
            case 1 %within bounds
                disp('PRINTING VALUES OF X Y Z');
                xTol=0; yTol=0; zTol=13; %zTol dependednt on what item on table
                X = worldPoints(end,1)+xTol;
                Y = worldPoints(end,2)+yTol;
                Z = 147 + zTol;
                eeX = round(X,2); 
                eeY = round(Y,2);
                eeZ = round(Z,2); 
        end
    end
end