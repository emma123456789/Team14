function [eeX, eeY, eeZ] = getConveyorXYZ(hObject,eventdata,handles)
    global convParam convImagePoints convWorldPoints
    global vid2

    if (get(hObject,'Value') == 1)
        %add in screenshot function
        im = getsnapshot(vid2);
        axes(handles.ConveyorCamera);
        figure(1);
        imshow(im);
        close(figure(1));
        [R, T] = extrinsics(convImagePoints.imagePoints, convWorldPoints.worldPoints, convParam.ConvCameraParams);
        [x, y] = getpts(handles.ConveyorCamera); %change to respective axes
        x = round(x);
        y = round(y);

        if x < 0 || x >1200
            flag = 0;
        else
            worldPoints = pointsToWorld(convParam.ConvCameraParams, R, T, [x y]);
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
                Z = 22 + zTol;
                eeX = round(X); 
                eeY = round(Y);
                eeZ = round(Z); 
        end
    end
end