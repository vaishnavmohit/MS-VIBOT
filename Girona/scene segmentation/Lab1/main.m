clc;
clear
close all;

%Reading the images and obtainin the fused image:
path_im = 'p1_images/';
path_seg = 'p1_images/seg/';
imagefiles = dir(strcat(path_im,'*.jpg'));
%counting number of files 
nfiles = length(imagefiles);
threshold = 50;
fuz_cluster = 10    ;
neighbours = 4;
for i = 1:nfiles
    name = imagefiles(i).name;
    filename = strcat(path_seg,num2str(threshold),'_',num2str(neighbours),'_',name);
    file_fuzzy = strcat(path_seg,'fuzzy','_',num2str(fuz_cluster),'_',name);

%     tic
    %Reading the image in double format
    Image_orig = imread( [ path_im, name ] );
    dim = size(Image_orig,3);
    %%
%     %Applying 9 x 9 median filter: 
%     %to be used in case of gray scale image

    %fimage = medfilt2(rgb2gray(Image_orig),[9,9]);
    %%
%     % Calling of function is in by passing parameters as image, threshold,
%     % andnumber of neighbourhood, by default it is taken as 8
%     %       [Image_segmented, numberOfRegions] = regionGrowing(input_Image, threshold, Neighborhood)

    %%
    % uncomment from here to run the regiongrowing algorithm
% 
%     [seg,n] = regionGrowing(Image_orig,threshold,neighbours); 
%     t = toc;  % tic is in line number 19
%     rgb = label2rgb(seg);

%     figure,imshow(uint8(Image_orig));title('Original Image');
%     figure,imshow(rgb), title('Segmented Image(Regions)');

%     fileID = fopen('changing.txt','a');
%     fprintf(fileID,'time taken for %s to segment %d number of regions with %d neighbours connectivity and threshold of %d is %f \n',name,n,neighbours,threshold,t);
%     fclose(fileID);
    %%
    %%
    %Comment this section while running the code for region growing.
    
    %To represent the image in a better way, we have used the command
    %imagesc and saved the image as it is. Output of the algorithm with
    %important parameters have been written in changing_fuzzy.txt
    tic
    fuzzy_segmentation = fuzzyCMeans(double(Image_orig),fuz_cluster);
    t_fuzzy = toc;
    imagesc(fuzzy_segmentation);
    saveas(gcf,file_fuzzy,'jpg')
    fileID = fopen('changing_fuzzy.txt','a');
    fprintf(fileID,'time taken for %s to segment with %d number of clusters is %f \n',name,fuz_cluster,t_fuzzy);
    fclose(fileID);
%figure,imshow(uint8(fimage)),title('Filtered Image');
end