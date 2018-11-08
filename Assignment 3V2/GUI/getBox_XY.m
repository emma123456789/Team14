    function [x,y]= getBox_XY(hObject)
    % box = imread('no_blocks.jpg');
    global convParam convImagePoints convWorldPoints
    global vid2
<<<<<<< HEAD
     global BoxX;
    global BoxY;
   
=======
    global Boxcentrod
    

    if (get(hObject,'Value') == 1)
>>>>>>> d6eb43ac60170294966c0d41ce9286a8809c7f41
    snapshot = getsnapshot(vid2);
    box = snapshot;


    imshow(box); hold on;
    box1 = box;
    box1(:,1:600,:)=0;     %1:580
    box1(:,1180:1600,:)=0;  %1180:1600
    box1(710:1200,:,:)=0;   %710:1200
    greybox1 = rgb2gray(box1);
    bw = imbinarize(greybox1,0.4);   %0.5

    bw1 = ~bwareaopen(~bw,1000);
    bw2 = ~bwareaopen(~bw,152000);

    Size1 = length(find(bw1));
    Size2 = length(find(bw2));

    if (Size1 <Size2)
        disp('Blocks detected');
    % detection of box
    bOrientation = regionprops('table',bw2,'Centroid','Image','Orientation');
    N= length(bOrientation.Orientation);
     for i= 1:N 
      if   (length(bOrientation.Image{i})>200)
     index=i;
      end
     end
    plot(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),'*');
    text(bOrientation.Centroid(index,1),bOrientation.Centroid(index,2),num2str(bOrientation.Orientation(index)),'Color','red','FontSize',20);
    contour(bw2,'r');
    else
        disp('No Blocks');
    end
    x=bOrientation.Centroid(index,1);
    y=bOrientation.Centroid(index,2);
    
    x = round(x);
    y = round(y);
    
    [R, T] = extrinsics(convImagePoints.imagePoints, convWorldPoints.worldPoints, convParam.ConvCameraParams);
    worldPoints = pointsToWorld(convParam.ConvCameraParams, R, T, [x y]);
    xTol=0; yTol=0;
    X = worldPoints(end,1)+xTol;
    Y = worldPoints(end,2)+yTol;
    x = round(X); 
    y = round(Y);
<<<<<<< HEAD
    BoxX=x;
    BoxY=y;
    disp(x);
    disp(y);
=======
    
    a = sprintf('%.0f %.0f',x,y);
    Boxcentrod = a;
>>>>>>> d6eb43ac60170294966c0d41ce9286a8809c7f41
    
    end
   
