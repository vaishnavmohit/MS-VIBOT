%% Author: Mohit Vaishnav
%% Medical Imaging Project

% clearing the workspace
close all;
clear;
clc;

%% Load Initial parameters
load Jointlabel1.mat
load Jointlabel2.mat
load Jointlabel3.mat
load training-set/output/labels/prob/prob1.mat
load training-set/output/labels/prob/prob2.mat
load training-set/output/labels/prob/prob3.mat

%% Normalizing
counter_lab1 = counter_lab1/sum(counter_lab1);
counter_lab2 = counter_lab2/sum(counter_lab2);
counter_lab3 = counter_lab3/sum(counter_lab3);
%% Initializing path and creating folders if not present

% creating output folder
if (exist('testing-set/output/', 'dir') == 0), mkdir('testing-set/output/'); end

nii_label_GT = 'testing-set/output/labels/';
if (exist(nii_label_GT, 'dir') == 0), mkdir(nii_label_GT); end

nii_label_OP = 'testing-set/output/labels/OP/';
if (exist(nii_label_OP, 'dir') == 0), mkdir(nii_label_OP); end

nii_out_images = 'testing-set/output/nii/';
if (exist(nii_out_images, 'dir') == 0), mkdir(nii_out_images); end

readpath = 'testing-set/output/images/';
readimagemask = niftiread('training-set/mask/1000_1C.nii');

%% To unzip the training images:
%{
imagefiles = dir(strcat(readpath,'*.nii.gz'));
nfiles = length(imagefiles);

for img_idx = 1:nfiles
    % read files from directory
    filename = imagefiles(img_idx).name;
    currentfilename = strcat(readpath,filename);
    gunzip(currentfilename,nii_out_images);
end
%}
%% Program to find the probabilities 
niifiles = dir(strcat(nii_out_images,'*.nii'));
nfiles = length(niifiles);

for img_idx = 1:nfiles
    % read files from directory
    filename = niifiles(img_idx).name;
    currentfilename = strcat(nii_out_images,filename);
    savefilename = strcat(nii_label_OP,filename);
    nii_image = niftiread(currentfilename);
    
    [l,b,h] = size(nii_image);
    
    % label file
    label = zeros(size(nii_image));
    
    for i = 1:l
        for j = 1:b
            for k = 1:h
                intensity = round(nii_image(i,j,k));
                if intensity>0 && intensity<4901
                    [~, idx] = max(1000*[prob1(i,j,k)*counter_lab1(intensity),...
                        prob2(i,j,k)*counter_lab2(intensity),...
                        prob3(i,j,k)*counter_lab3(intensity)]);
                    label(i,j,k) = idx;
                end
            end
        end
    end
    
    label = label.*readimagemask;
    
    niftiwrite(label,savefilename);
    
end

%% To get the evaluation values
labelGT = dir(strcat(nii_label_GT,'*.nii'));
labelOP = dir(strcat(nii_label_OP,'*.nii'));
nfiles = length(labelGT);

for img_idx = 1:nfiles
    % read files from directory
    filenameGT = labelGT(img_idx).name;
    filenameOP = labelOP(img_idx).name;
    currentfilenameGT = strcat(nii_label_GT,filenameGT);
    currentfilenameOP = strcat(nii_label_OP,filenameOP);
    m = niftiread(currentfilenameGT);
    o = niftiread(currentfilenameOP);
    [Jaccard,Dice,rfp,rfn]=sevaluate(m,o,1);
    X = sprintf('For image %s Jaccard is %f, Dice is %f, rpf is %f and rfn is %f',filenameGT,Jaccard,Dice,rfp,rfn);
    disp(X)
    [Jaccard,Dice,rfp,rfn]=sevaluate(m,o,2);
    X = sprintf('For image %s Jaccard is %f, Dice is %f, rpf is %f and rfn is %f',filenameGT,Jaccard,Dice,rfp,rfn);
    disp(X)
    [Jaccard,Dice,rfp,rfn]=sevaluate(m,o,3);
    X = sprintf('For image %s Jaccard is %f, Dice is %f, rpf is %f and rfn is %f',filenameGT,Jaccard,Dice,rfp,rfn);
    disp(X)
end
  