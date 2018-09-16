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
    [angles, position, letter, finalText] = useBlocks(image); 
%edge finding
    image(1:250,:,:)=0;
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
    
 % Constructing Final Array
    for i=1:length(angles)
        block = [position(i,1), position(i,2),... 
            angles(i), letter(i),...
            isReachable(position(i,1), position(i,2))];
        % See if block is reachable or not
        if (block(5)==1)
            text(position(i,1)+30, position(i,2)+30, [finalText(i) ' , ' num2str(angles(i))], 'Color','blue');
        else
            text(position(i,1)+30, position(i,2)+30, [finalText(i) ' , ' num2str(angles(i))], 'Color','red');
        end
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
function [trueAngles, centroids, letter, finalTextBefore] = useBlocks(image)

    images = imsharpen(image);
    imHSV = rgb2hsv(images);
    
    imMask = imHSV(:,:,2)<0.25 & imHSV(:,:,3)>0.68;
    imMask(1:250, :, :) = 1;
    imMask(end-20:end, :, :) = 1;
    imMask(:, end-20:end, :) = 1;
    imMask(:, 1:20, :) = 1;

    % Remove grid from image   
    for i=1:720
        imMask(i,:) = ~bwareaopen(~imMask(i,:),4);
    end
    for i=1:1280
        imMask(:,i) = ~bwareaopen(~imMask(:,i),4);
    end
    
    % Remove the letter inside block
    newMask = bwareaopen(imMask,800);
    % Find characteristics of blocks using regionprops
    [centroids, area] = shapeCentroid(~newMask);
    
    % Find how many blocks are in a centroid
    for i=1:length(area)
        true = 0;
        numberBlocks(i) = round(area(i)/2400);
        if (numberBlocks(i) > 1)
            imMask = imMask - bwareaopen(imMask, 3000);
            colourMask = bwperim(imMask);
            % Find characteristics of blocks using regionprops
            [centroids, area] = shapeCentroid(colourMask);
            true = 1;
        end
        if (true==1)
            break
        end
    end
    
    % Find Corner points using Douglas Peucker
     contour1 = contourc(double(newMask));
     res = DouglasPeucker(contour1,25);  % somewhere above 20
     co = removeZero(res); % Removes zero points 
   
    % this section calculates the angle of the block
    for i=1:length(centroids)
        angles(i) = findAngle(co, centroids(i,:));
        [trueAngles(i), letter(i), finalTextBefore(i)] = findLetter(angles(i), centroids(i,:), imMask);
    end    
    
    
end

%% Finds letter using OCR and change angle if letter is found
function [angles, letter, finalTextBefore] = findLetter(angles, centroids, imMask)
    % Rotation through 4 angles to find letters for each centroid

    % Split imMask into area
    % form [xmin ymin width height].
    translatedAngles = rad2deg(angles);
    degrees = [translatedAngles; translatedAngles+90; translatedAngles-90; translatedAngles-180];
    I2 = imcrop(imMask,[(centroids(1)-25) (centroids(2)-25) 50 50]);
    
    % Resizing makes it more accurate
    I2 = imresize(I2,3/4);
    
    % CASE 1: Angle
    case1 = imrotate(I2,degrees(1));
    case1 = bwareaopen(case1, 100);
%          imshow(case1)
    results1 = ocr(case1, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (isempty(results1.Words) == 1)
        text = [0];
        results = [0];
    else
        text = [results1.Text(1)];
        results = [results1.WordConfidences(1)];
    end

    % CASE 2: Angle + 90
    case2 = imrotate(I2,degrees(2));
    case2 = bwareaopen(case2, 100);
    results2 = ocr(case2, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case2)
    if (isempty(results2.Words) == 1)
        text = [text; 0];
        results = [results; 0];
    else
        text = [text; results2.Text(1)];
        results = [results; results2.WordConfidences(1)];
    end

    % CASE 3: Angle - 90 
    case3 = imrotate(I2,degrees(3));
    case3 = bwareaopen(case3, 100);
    results3 = ocr(case3, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case3)
    if (isempty(results3.Words) == 1)
        text = [text ;0];
        results = [results; 0];
    else
        text = [text; results3.Text(1)];
        results = [results; results3.WordConfidences(1)];
    end

    % CASE 4: Angle - 180  
    case4 = imrotate(I2,degrees(4));
    case4 = bwareaopen(case4, 100);
    results4 = ocr(case4, 'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ');
%          imshow(case4)
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
    

    letter2number = @(c)1+lower(c)-'a'; % Convert letter to digit
    finalTextBefore = text(max_idx);
    finalText = letter2number(finalTextBefore);
    letter = finalText;
    angles = angles+rad(max_idx); % Find correct orientation of the block

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
function [centroids, area] = shapeCentroid(imMask)
    stats = regionprops(imMask, 'Centroid', 'Area');
    
    % Centroids will find position of the block
    centroids = cat(1, stats.Centroid);
    area = cat(1, stats.Area);

    for m=1:length(centroids(:,1))
        for i=1:length(centroids(:,1))
            %associate an angle with colours
            flag = 0;
            for j=1:length(centroids(:,1))
                dist = sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2);
                if(dist<40 && dist>0)
                    centroids(j, : )= [];
                    area(j) = [];
                    flag = 1;
                    break;
                end
            end
            if (flag == 1)
                break
            end
        end
    end
    
end
