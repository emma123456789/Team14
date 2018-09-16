% imaqhwinfo
% webcamlist

clc; clear; objects = imaqfind; delete(objects);

vidobj = videoinput('macvideo',1);

% Configure the object for manual trigger mode.
triggerconfig(vidobj, 'manual');

% Now that the device is configured for manual triggering, call START.
% This will cause the device to send data back to MATLAB, but will not log
% frames to memory at this point.
start(vidobj)

% Measure the time to acquire 20 frames.
tic
while (1)
    snapshot = getsnapshot(vidobj);
    
    image = ycbcr2rgb(snapshot);
    imshow(image); hold on;
    gs = rgb2gray(image);
    level = graythresh(gs);
    bw = im2bw(gs, level);
%         [angles, position, letter] = useBlocks(snapshot); 
%         L1 = char(letter+64);
%          N1 = length(angles);
%     Reachable1 = ones(N1);
%     for j=1:N1
%     if ((angles(j)>pi/2 && angles(j)<pi)| ((angles(j)>-pi && (angles(j)<0))))
%     d1 = 25/sin(abs(angles(j))-pi/2);
%     else
%         d1 = 25/sin(abs(angles(j)));
%     end
%     x1 = [position(j,1)-d1, position(j,1),position(j,1)+d1,position(j,1),position(j,1)-d1]
%     y1 = [position(j,2), position(j,2)-d1, position(j,2), position(j,2)+d1, position(j,2)]
%     if Reachable1(j)==1
%     plot(x1,y1,'g');
%     else
%         plot(x1,y1,'r');
%     end
%     
%     text(position(j,1)+20,position(j,2)+20,L1(j),'Color','red','FontSize',14);
    
    image(1:250,:,:)=0;
    % Associates position with the colour centroids
    % Get rid of bad letters that are not 0-26 make them 0 
%     adjustedColours = zeros(size(angles));
%     adjustedShapes = zeros(size(angles));
%     for i=1:size(colours)
%         for j=1:length(position)
%             dist = sqrt((position(j,1)-centroids(i,1))^2 + (position(j,2)-centroids(i,2))^2);
%             if(dist<40)
%                     adjustedColours(j) = colours(i);
%                     adjustedShapes(j) = shapes(i);
%                     if (adjustedColours(j) == 0)
%                         adjustedShapes(j) = 0;
%                     end
%             end
% 
%             if( 1<=letter(j) && letter(j)<= 26)
%                 adjustedColours(j) = 0;
%                 adjustedShapes(j) = 0;
%             else
%                 letter(j) = 0; 
%             end
% 
%         end
%     end
%     
%     N1 = length(angles);
%     Reachable1 = ones(N1);
%edge finding
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
    imshow(image); hold on;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
    
    
    pause(0.1);
end

elapsedTime = toc

% Compute the time per frame and effective frame rate.
timePerFrame = elapsedTime/20
effectiveFrameRate = 1/timePerFrame

% Call the STOP function to stop the device.
stop(vidobj)

delete(vidobj);

%% Detects if Blocks are Reachable
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

%% Identifying Blocks
function [trueAngles, centroids, letter] = useBlocks(image)

    images = imsharpen(image);
    imHSV = rgb2hsv(images);
    
    imMask = imHSV(:,:,2)<0.25 & imHSV(:,:,3)>0.68;
    imMask(1:250, :, :) = 1;
    imMask(end-20:end, :, :) = 1;
    imMask(:, end-20:end, :) = 1;
    imMask(:, 1:20, :) = 1;

    % Remove grid from image
%     SE1 = strel('line',3.3,0);
%     imMask = imclose(imMask,SE1);
%     SE2 = strel('line',3.3,90);
%     imMask = imclose(imMask,SE2);
%     SE3 = strel('disk',3);
%     imMask = imclose(imMask,SE3);    
    for i=1:1200
        imMask(i,:) = ~bwareaopen(~imMask(i,:),4);
    end
    
    for i=1:1600
        imMask(:,i) = ~bwareaopen(~imMask(:,i),4);
    end
    
    % Remove the letter inside block
    newMask = bwareaopen(imMask,800);
    % Find characteristics of blocks using regionprops
    [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeCentroid(~newMask);
    
    % Find how many blocks are in a centroid
    for i=1:length(area)
        true = 0;
        numberBlocks(i) = round(area(i)/2400);
        if (numberBlocks(i) > 1)
            [r_imMask, o_imMask, y_imMask, g_imMask, b_imMask, p_imMask] = imColours(image);
    
            idx = find(o_imMask==0);    
            o_imMask(idx) = r_imMask(idx);
            idx = find(y_imMask==0);  
            y_imMask(idx) = o_imMask(idx);
            idx = find(g_imMask==0);    
            g_imMask(idx) = y_imMask(idx);
            idx = find(b_imMask==0);  
            b_imMask(idx) = g_imMask(idx);
            idx = find(p_imMask==0);    
            p_imMask(idx) = b_imMask(idx);
            idx = find(imMask==0);  
            imMask(idx) = p_imMask(idx);
            imMask = imMask - bwareaopen(imMask, 3000);
            
            colourMask = bwperim(imMask);
            % Find characteristics of blocks using regionprops
            [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeCentroid(colourMask);
            true = 1;
        end
        if (true==1)
            break
        end
    end
    
    % Find Corner points
     contour1 = contourc(double(newMask));
     res = DouglasPeucker(contour1,25); %,length(centroids));%:0.1:1.5); % some where above 20
     co = removeZero(res); % Removes zero points 
%      figure(2);
%      plot(co(:,1),co(:,2),'*r');
%      hold on 
%      contour(imMask,5, 'k');
%     
    % this section calculates the angle of the block
    for i=1:length(centroids)
        angles(i) = findAngle(co, centroids(i,:));
        [trueAngles(i), letter(i)] = findLetter(angles(i), centroids(i,:), imMask);
    end    
    
    
end

%% Finds letter using OCR and change angle if letter is found
function [angles, letter] = findLetter(angles, centroids, imMask)
    % Rotation through 4 angles to find letters for each centroid

    % Split imMask into area
    % form [xmin ymin width height].
    translatedAngles = rad2deg(angles);
    degrees = [translatedAngles; translatedAngles+90; translatedAngles-90; translatedAngles-180];
    I2 = imcrop(imMask,[(centroids(1)-25) (centroids(2)-25) 50 50]);
    
    % CASE 1: Angle
    case1 = imrotate(I2,degrees(1));
    case1 = bwareaopen(case1, 150);
%       imshow(case1)
    results1 = ocr(case1, 'TextLayout', 'Block');
    if (isempty(results1.Words) == 1)
        text = [0];
        results = [0];
    else
        text = [results1.Text(1)];
        results = [results1.WordConfidences(1)];
    end

    % CASE 2: Angle + 90
    case2 = imrotate(I2,degrees(2));
    case2 = bwareaopen(case2, 150);
    results2 = ocr(case2, 'TextLayout', 'Block');
%       imshow(case2)
    if (isempty(results2.Words) == 1)
        text = [text; 0];
        results = [results; 0];
    else
        text = [text; results2.Text(1)];
        results = [results; results2.WordConfidences(1)];
    end

    % CASE 3: Angle - 90 
    case3 = imrotate(I2,degrees(3));
    case3 = bwareaopen(case3, 150);
    results3 = ocr(case3, 'TextLayout', 'Block');
%       imshow(case3)
    if (isempty(results3.Words) == 1)
        text = [text ;0];
        results = [results; 0];
    else
        text = [text; results3.Text(1)];
        results = [results; results3.WordConfidences(1)];
    end

    % CASE 4: Angle - 180  
    case4 = imrotate(I2,degrees(4));
    case4 = bwareaopen(case4, 150);
    results4 = ocr(case4, 'TextLayout', 'Block');
%       imshow(case4)
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
    
    % Make sure highest confidence value is at least 70%
    if (max_num>0.7 && isempty(max_idx) == 0)
        letter2number = @(c)1+lower(c)-'a'; % Convert letter to digit
        finalText = text(max_idx);
        finalText = letter2number(finalText);
        letter = finalText;
        angles = angles+rad(max_idx); % Find correct orientation of the block
    else
        letter = 0;
    end

end 


%% Removes zero values from RDP
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
    
%% Calculates angle of block
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

%% Takes in a black and white mask of shapes and gets the stats on each
function [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeCentroid(imMask)
    %imMask = bwperim(imMask);
    stats = regionprops(imMask, 'Centroid', 'Area', 'Orientation', 'Perimeter', 'ConvexArea', 'Solidity', 'EquivDiameter', ...
        'Orientation', 'MajorAxisLength', 'MinorAxisLength');
    
    % Centroids will find position of the block
    centroids = cat(1, stats.Centroid);
%     imshow(imMask)
%     hold on
%       plot(centroids(:,1),centroids(:,2), 'r*')

    % Random extra stats shiz
    area = cat(1, stats.Area);
    perim = cat(1, stats.Perimeter);
    solid = cat(1, stats.Solidity);
    conv = cat(1, stats.ConvexArea);
    orientation = cat(1, stats.Orientation);
    majorAxis = cat(1, stats.MajorAxisLength);
    minorAxis = cat(1, stats.MinorAxisLength);


    for m=1:length(centroids(:,1))
        for i=1:length(centroids(:,1))
            %associate an angle with colours
            flag = 0;
            for j=1:length(centroids(:,1))
                dist = sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2);
                if(dist<40 && dist>0)
                    centroids(j, : )= [];
                    area(j) = [];
                    perim(j) = [];
                    solid(j) = [];
                    conv(j) = [];
                    orientation(j) = [];
                    majorAxis(j) = [];
                    minorAxis(j) = [];
                    flag = 1;
                    break;
                end
            end
            if (flag == 1)
                break
            end
        end
    end
    
%     imshow(imMask)
%          hold on
%      plot(centroids(:,1),centroids(:,2),'*r');

end

%% Takes in a black and white mask of shapes and gets the stats on each
function [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeStats(imMask)
    stats = regionprops(imMask, 'Centroid', 'Area', 'Orientation', 'Perimeter', 'ConvexArea', 'Solidity', 'EquivDiameter', ...
        'Orientation', 'MajorAxisLength', 'MinorAxisLength');
    
       
    % Centroids will find position of the block
    centroids = cat(1, stats.Centroid);
    %hold on
%      plot(centroids(:,1),centroids(:,2), 'r*')
    
    % Random extra stats shiz
    area = cat(1, stats.Area);
    perim = cat(1, stats.Perimeter);
    solid = cat(1, stats.Solidity);
    conv = cat(1, stats.ConvexArea);
    orientation = cat(1, stats.Orientation);
    majorAxis = cat(1, stats.MajorAxisLength);
    minorAxis = cat(1, stats.MinorAxisLength);
    hold on 

end

 
%%
function [r_imMask, o_imMask, y_imMask, g_imMask, b_imMask, p_imMask] = imColours(image)
    imHSV = rgb2hsv(image);

% http://www.workwithcolor.com/magenta-pink-color-hue-range-01.htm         
    r_imMask = imHSV(:,:,2)>0.272 & imHSV(:,:,3)>0.299 & imHSV(:,:,1)>(321/360) | imHSV(:,:,1) < (0.009);
    r_imMask = bwareaopen(r_imMask, 350);

    o_imMask = imHSV(:,:,2)>0.28 & imHSV(:,:,3)>0.3 & imHSV(:,:,1) > (0) & imHSV(:,:,1)<(40/360);
    o_imMask = bwareaopen(o_imMask, 350);

    y_imMask = imHSV(:,:,2)>0.2 & imHSV(:,:,3)>0.2 & imHSV(:,:,1) > (41/360) & imHSV(:,:,1)<(60/360);
    y_imMask = bwareaopen(y_imMask, 350);

    g_imMask = imHSV(:,:,2)>0.112 & imHSV(:,:,3)>0.181 & imHSV(:,:,1) > (61/360) & imHSV(:,:,1)< (169/360);
    g_imMask = bwareaopen(g_imMask, 350);

    b_imMask = imHSV(:,:,2)>0.2 & imHSV(:,:,3)>0.2 & imHSV(:,:,1) > (170/360) & imHSV(:,:,1)<(240/360);
    b_imMask = bwareaopen(b_imMask, 350);

    p_imMask = imHSV(:,:,2)>0.2 & imHSV(:,:,3)>0.2 & imHSV(:,:,1) > (241/360) & imHSV(:,:,1)< (320/360);
    p_imMask = bwareaopen(p_imMask, 350);
end

%%
function [colours, centroids, shapes] = useColours(image)

    [r_imMask, o_imMask, y_imMask, g_imMask, b_imMask, p_imMask] = imColours(image);
    
    [r_centroids, r_area, r_perim, r_solid, r_conv, r_orientation, r_majorAxis, r_minorAxis] = shapeStats(r_imMask);
    [o_centroids, o_area, o_perim, o_solid, o_conv, o_orientation, o_majorAxis, o_minorAxis] = shapeStats(o_imMask);
    [y_centroids, y_area, y_perim, y_solid, y_conv, y_orientation, y_majorAxis, y_minorAxis] = shapeStats(y_imMask);
    [g_centroids, g_area, g_perim, g_solid, g_conv, g_orientation, g_majorAxis, g_minorAxis] = shapeStats(g_imMask);
    [b_centroids, b_area, b_perim, b_solid, b_conv, b_orientation, b_majorAxis, b_minorAxis] = shapeStats(b_imMask);
    [p_centroids, p_area, p_perim, p_solid, p_conv, p_orientation, p_majorAxis, p_minorAxis] = shapeStats(p_imMask);

    colours = [ones(size(r_area)); ...
               2*ones(size(o_area)); ...
               3*ones(size(y_area)); ...
               4*ones(size(g_area)); ...
               5*ones(size(b_area)); ...
               6*ones(size(p_area))];

    centroids = [r_centroids; o_centroids; y_centroids; g_centroids; b_centroids; p_centroids];
    area = [r_area; o_area; y_area; g_area; b_area; p_area];
    perim = [r_perim; o_perim; y_perim; g_perim; b_perim; p_perim];
    conv = [r_conv; o_conv; y_conv; g_conv; b_conv; p_conv];
    solid = [r_solid; o_solid; y_solid; g_solid; b_solid; p_solid];
    orientation = [r_orientation; o_orientation; y_orientation; g_orientation; b_orientation; p_orientation];
    majorAxis = [r_majorAxis; o_majorAxis; y_majorAxis; g_majorAxis; b_majorAxis; p_majorAxis];

    % Find shapes of colours
    shapes = zeros(size(area));    
     for i = 1:length(area)
         shapes(i) = processShape(area(i), perim(i), solid(i), conv(i), i); 
     end
end

%% Determine the shape
function shape = processShape(area, perim, solidity, conv, i)
   shape = 0;

   % CASE 1: Square
   if(area > 900 && area < 1300 && solidity > 0.8)
%        if(area > 900 && area < 1020 && solidity > 0.9)
       shape = 1;

   % CASE 2: Diamond
   elseif(area>900 && area<1200 && solidity > 0.8)
% elseif(area/perim>6.5 && area/perim<8   && solidity > 0.9)
       shape = 2;

   % CASE 3: Circle
   elseif(solidity > 0.95 && area > 1030)
% elseif(solidity > 0.8 && area/perim > 8.5)
       shape = 3;

   % CASE 4: Club
   elseif(conv > 1000 && solidity > 0.75 < solidity < 0.9)
% elseif(conv > 1000 && conv < 1290  && solidity > 0.75 && solidity < 0.85)
       shape = 4;

   % CASE 5: Cross
   elseif(solidity > 0.45 && solidity < 0.7  && conv > 1200)
% elseif(solidity > 0.45 && solidity < 0.62  && conv/perim > 6.5)
       shape = 5;

   % CASE 6: Star
   else
       %(solidity > 0.56 && solidity < 0.8 && area < 900)
% elseif(solidity > 0.56 && solidity < 0.7  && conv/perim < 6.5)
       shape = 6;
   end
end
