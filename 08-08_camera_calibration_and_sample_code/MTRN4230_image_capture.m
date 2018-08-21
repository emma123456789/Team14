%% MTRN4230 Webcam image display and capture function
%
% Display image stream from webcam in the robot cell. Click on the figure
% or press any key to caputre the image.
% MTRN4230_image_capture () display both camera.
% MTRN4230_image_capture ([]) only display table camera.
% MTRN4230_image_capture ([],[]) only display conveyor camera.
% Zhihao Zhang 2017.

function MTRN4230_image_capture (varargin)
    close all;
    warning('off', 'images:initSize:adjustingMag');

%% Table Camera
% {
    if nargin == 0 || nargin == 1
        fig1 =figure(1);
        axe1 = axes ();
        axe1.Parent = fig1;
        vid1 = videoinput('winvideo', 1, 'MJPG_1600x1200');
        video_resolution1 = vid1.VideoResolution;
        nbands1 = vid1.NumberOfBands;
        img1 = imshow(zeros([video_resolution1(2), video_resolution1(1), nbands1]), 'Parent', axe1);
        prev1 = preview(vid1,img1);
        src1 = getselectedsource(vid1);
        src1.ExposureMode = 'manual';
        src1.Exposure = -5;
%         src1.Contrast = 57;%57,32
%         src1.Saturation = 78;
        cam1_capture_func = @(~,~)capture_image(vid1,'table_img');
        prev1.ButtonDownFcn = cam1_capture_func;
        fig1.KeyPressFcn = cam1_capture_func;
    end
%}
%% Conveyor Camera
% {
    if nargin == 0 || nargin == 2
        fig2 =figure(2);
        axe2 = axes ();
        axe2.Parent = fig2;
        vid2 = videoinput('winvideo', 2, 'MJPG_1600x1200');
        video_resolution2 = vid2.VideoResolution;
        nbands2 = vid2.NumberOfBands;
        img2 = imshow(zeros([video_resolution2(2), video_resolution2(1), nbands2]), 'Parent', axe2);
        prev2 = preview(vid2,img2);
        src2 = getselectedsource(vid2);
        src2.ExposureMode = 'manual';    
        src2.Exposure = -4;
        cam2_capture_func = @(~,~)capture_image(vid2,'conveyor_img');
        fig2.KeyPressFcn = cam2_capture_func;
        prev2.ButtonDownFcn = cam2_capture_func;
    end
%}

%% Image capture function  
    function capture_image (vid,name)
    	snapshot = getsnapshot(vid);
        imwrite(snapshot, [name, datestr(datetime('now'),'_mm_dd_HH_MM_SS'), '.jpg']);
        disp([name 'captured']);
    end
end




