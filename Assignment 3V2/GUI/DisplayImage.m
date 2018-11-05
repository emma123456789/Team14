


function   TestImages = DisplayImage(i)

 TestImages=imread([num2str(i),'.jpg']);
 
end

% 
% global testflag;
% 
% TestImages = DisplayImage(testflag); 
% axes(handles.axes1);  
% imshow(TestImages); hold on; 
% if testflag <=16
% testflag =testflag +1;
% else
%     testflag=1;
% end