clc
clear 
close all
%%
%MRI Image

%Reading image individually to know about the image
x = dicomread('MRI/MRI06.dcm');
x_info = dicominfo('MRI/MRI06.dcm');
%Number of fields involved in dicom header
length(fieldnames(x_info))
%Command to know about the pixel spacing from an image.
pixel_spacing = x_info.PixelSpacing;
%Image Modality
x_info.Modality

%ULTRASOUND IMAGE
y = dicominfo('ultrasound/ultrasound.dcm');
fprintf('dimension of Ultasound image:')
[y.Rows, y.Columns]
%Number of fields involved in dicom header
length(fieldnames(y))
%Modality:
y.Modality

%XRAY
xray  = dicominfo('X-Ray/MAMMOGRAPHY_RAW/MAMMOGRAPHY_RAW.dcm');
%Modality
xray.Modality
%Size
[xray.Rows, xray.Columns]
%Pixel Spacing
xray.PixelSpacing
%%
%Reading all the image at once from a given directory
DatabasePath = './MRI/';
imagefiles = dir(strcat(DatabasePath,'*.dcm'));
%counting number of files 
nfiles = length(imagefiles);

%There are two options to read the image file, either create the variable
%of the type uint16 or else read it directly and while
%representing/displaying the image use this explicitely.
%stackimage = uint16(zeros());
stackimage = [];

for i = 1:nfiles
    name = imagefiles(i).name;
    filename = strcat(DatabasePath,name);
    stackimage1(:,:,1,i) = dicomread(filename);
    stackimage(:,:,i) = dicomread(filename);
end
%%
%Histogram of the set of MRI image
imhist(uint16(stackimage(:)))
imwrite(imhist(uint16(stackimage(:))), 'JoinedHistogram.jpg')

%Displaying the stack of image together in a single pic.
figure, montage(uint16(stackimage1))
%%
%Representing different view of an image 
%Axial  view:
figure, imshow(uint16([stackimage(:,:,11) stackimage(:,:,12)]));title('Axial View');

%Coronal view
coronal1=imresize(squeeze(stackimage(:,200,:)),[512 194]);
coronal2=imresize(squeeze(stackimage(:,300,:)),[512 194]);
imshow(uint16([coronal1 coronal2]));title('Coronal View');

%Sagital View
sagital1=imresize(squeeze(stackimage(200,:,:))',[200 512]);
sagital2=imresize(squeeze(stackimage(300,:,:))',[200 512]);
figure, imshow(uint16([sagital1; sagital2]));
title('Sagital View');

%%
%Visualize raw image in matlab
raw_x = uint8(dicomread('X-Ray/MAMMOGRAPHY_RAW/MAMMOGRAPHY_RAW.dcm'));
%by default MATLab assume it to be 8 bits but it comes out to be in 16 bits
%hence the whole image becomes black.
raw_gray = 255-raw_x;
figure, imshow(raw_gray), title('Gray Raw');

%trying different types of processing of the raw image
raw_x_imadjust = imadjust(raw_gray,stretchlim(raw_gray),[]); figure, imshow(raw_x_imadjust), title('Image adjustment')
raw_x_histeq = histeq(raw_gray);figure, imshow(raw_x_histeq), title('Histogram Equalisation')
raw_x_adapthisteq = adapthisteq(raw_gray,'Distribution','exponential','range','original');figure, imshow(raw_x_adapthisteq), title('Adaptive hisogram equalization')

%I was trying to get the contour of the image using some morphological
%opration but could not get the desired results. 
%using morphological opereations
se = offsetstrel('ball',10,10); 
%Dialation of image
raw_dilate = imdilate(raw_x_imadjust,se);
se2 = strel('disk',50);
%Closing of the image : although I applied this operation many times but
%was not able to close all the gaps. This gives an idea that how difficult
%will that be to obtain the version of the processed image provided in the
%lab report.
raw_dilate3 = imclose((imclose((raw_dilate>50),se2)),se2);
raw_dilate4 = imclose(imclose(raw_dilate3,se2),se2);
figure, imshow(raw_dilate4), title('Result after dialation and closing');

%Applying Gaussian filters:
Iblur2 = imgaussfilt(raw_x_imadjust,4);
figure, imshow(Iblur2), title('Image blurring result using Gaussian filter');


%Gamma Transformation of image:
figure, imshow(imadjust(raw_dilate,[],[],0.1)), title('Gamma Transform of Image')

