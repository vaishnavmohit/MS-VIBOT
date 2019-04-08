%% Author: Mohit Vaishnav
%% Medical Imaging Project

% clearing the workspace
close all;
clear;
clc;

%% Initializing path and creating folders if not present

% creating output folder
if (exist('training-set/output/', 'dir') == 0), mkdir('training-set/output/'); end

nii_read_label = 'training-set/output/labels/';
if (exist(nii_read_label, 'dir') == 0), mkdir(nii_read_label); end

nii_read_image = 'training-set/output/images/nii/';
if (exist(nii_read_image, 'dir') == 0), mkdir(nii_read_image); end

nii_label_out = 'training-set/output/labels/nii/';
if (exist(nii_label_out, 'dir') == 0), mkdir(nii_label_out); end

lab1path = 'training-set/output/labels/lab1/';
if (exist(lab1path, 'dir') == 0), mkdir(lab1path); end

lab2path = 'training-set/output/labels/lab2/';
if (exist(lab2path, 'dir') == 0), mkdir(lab2path); end

lab3path = 'training-set/output/labels/lab3/';
if (exist(lab3path, 'dir') == 0), mkdir(lab3path); end

probpath = 'training-set/output/labels/prob/';
if (exist(probpath, 'dir') == 0), mkdir(probpath); end

%% Reading image to initialize few parameters
readnii_sample = 'training-set/images/1000.nii';
readpath = 'training-set/output/images/';
readimage_sample = niftiread(readnii_sample);
readimagemask = niftiread('training-set/mask/1000_1C.nii');
nii_size = size(readimage_sample);
%{
%% To unzip the training images:
imagefiles = dir(strcat(readpath,'*.nii.gz'));
nfiles = length(imagefiles);

for img_idx = 1:nfiles
    % read files from directory
    filename = imagefiles(img_idx).name;
    currentfilename = strcat(readpath,filename);
    gunzip(currentfilename,nii_read_image);
end

%% To unzip label images
imagefiles = dir(strcat(nii_read_label,'*.nii.gz'));
nfiles = length(imagefiles);
%{//
for img_idx = 1:nfiles
    % read files from directory
    filename = imagefiles(img_idx).name;
    currentfilename = strcat(nii_read_label,filename);
    gunzip(currentfilename,nii_label_out);
end
%}

%% Program to find the probabilities 
niifiles = dir(strcat(nii_label_out,'*.nii'));
nfiles = length(niifiles);

prob1 = zeros(nii_size);
prob2 = zeros(nii_size);
prob3 = zeros(nii_size);

for img_idx = 1:nfiles
    % read files from directory
    filename = niifiles(img_idx).name;
    currentfilename = strcat(nii_label_out,filename);
%     savefilename = strcat(nii_out,filename);
    nii_image = niftiread(currentfilename);
    nii_image = nii_image.*single(readimagemask);
    
    lab1 = (nii_image == 1)*1;
    lab2 = (nii_image == 2)*1;
    lab3 = (nii_image == 3)*1;

    %To get the probability maps
    prob1 =  prob1 + lab1;
    prob2 =  prob2 + lab2;
    prob3 =  prob3 + lab3;
           
%     niftiwrite(lab1,savefilename);
%     niftiwrite(lab2,savefilename);
%     niftiwrite(lab3,savefilename);
end
  
prob1 = prob1/nfiles;
prob2 = prob2/nfiles;
prob3 = prob3/nfiles;

prob1filename = strcat(probpath,'prob1.nii');
prob2filename = strcat(probpath,'prob2.nii');
prob3filename = strcat(probpath,'prob3.nii');

niftiwrite(lab1,prob1filename);
niftiwrite(lab2,prob2filename);
niftiwrite(lab3,prob3filename);

save(strcat(probpath,'prob1.mat'),'prob1');
save(strcat(probpath,'prob2.mat'),'prob2');
save(strcat(probpath,'prob3.mat'),'prob3');


%% Program to create the histogram
niifiles_image = dir(strcat(nii_read_image,'*.nii'));
nfiles = length(niifiles_image);

niifiles_label = dir(strcat(nii_label_out,'*.nii'));

nii_counter_lab1 = zeros(4900,nfiles);
nii_counter_lab2 = zeros(4900,nfiles);
nii_counter_lab3 = zeros(4900,nfiles);

for img_idx = 1:nfiles
    % read files from directory
    filename_i = niifiles_image(img_idx).name;
    filename_l = niifiles_label(img_idx).name;
    currentfilename_i = strcat(nii_read_image,filename_i);
    currentfilename_l = strcat(nii_label_out,filename_l);
%     savefilename = strcat(nii_out,filename_i);
    nii_image = niftiread(currentfilename_i);
    nii_label = niftiread(currentfilename_l);
    nii_label = nii_label.*single(readimagemask);
    
    lab1 = (nii_label == 1).*nii_image;
    lab2 = (nii_label == 2).*nii_image;
    lab3 = (nii_label == 3).*nii_image;
    
    nii_single_lab1 = round(reshape(lab1,[1,256*287*256]));
    nii_single_lab2 = round(reshape(lab2,[1,256*287*256]));
    nii_single_lab3 = round(reshape(lab3,[1,256*287*256]));
    
    size(unique(nii_single_lab1))
    size(unique(nii_single_lab2))
    size(unique(nii_single_lab3))
    
    for i = 1:4900
        nii_counter_lab1(i,img_idx) = sum(nii_single_lab1==i);
        nii_counter_lab2(i,img_idx) = sum(nii_single_lab2==i);
        nii_counter_lab3(i,img_idx) = sum(nii_single_lab3==i);
    end

end
y = 1:4900;
counter_lab1 = sum(nii_counter_lab1,2);
counter_lab2 = sum(nii_counter_lab2,2);
counter_lab3 = sum(nii_counter_lab3,2);

%% Save the labels
save('Jointlabel1.mat','counter_lab1');
save('Jointlabel2.mat','counter_lab2');
save('Jointlabel3.mat','counter_lab3');
save('counter_lab1.mat','nii_counter_lab1');
save('counter_lab2.mat','nii_counter_lab2');
save('counter_lab3.mat','nii_counter_lab3');

%% Display the histogram
figure
plot(y,counter_lab1/sum(counter_lab1),y,counter_lab2/sum(counter_lab2),y,counter_lab3/sum(counter_lab3))
xlabel('Pixel Intensity') % x-axis label
ylabel('Occurances') % y-axis label
legend('label 1','label 2','label 3')
