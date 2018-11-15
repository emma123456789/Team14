function   [TestImageTable,TestImageCobveyor] = DisplayImage(i)
% DisplayImage  get the prerecorded images 
% [A,B] = DisplayImage(i)  get the image for table svaed into A, for
%
% conveyor saved into B


 TestImageTable=imread([num2str(i),'.jpg']);
 TestImageCobveyor = imread([num2str(i+100),'.jpg']);
 
end

