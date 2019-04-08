%%
%This program aims to shows the demonstration of Harris Corner Detection
%technique. To execute the program we have to change the name of imagefile
%amd it will save all the images with the nomenculture mentioned in the
%report. 

clc
clear
close all
filenamae = 'chessboard07.jpg';
im = (imread(filenamae));
im_orig = im;
[r, c]=size(im);


%% Convert the image to gray scale. 
if size(im,3)>1, im=rgb2gray(im); end

%% Derivative masks
dx = [-1 0 1;
 -1 0 1;
 -1 0 1];
dy = dx';

%% Image derivatives
Ix = conv2(double(im), dx, 'same');
Iy = conv2(double(im), dy, 'same');
sigma=2;

%% Generate Gaussian filter of size 9x9 and std. dev. sigma.
g = fspecial('gaussian',9, sigma);
% Smoothed squared image derivatives
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

%% To find the eignevalue of the gradient. 
E = zeros(size(im));
tic
for i = 1:size(im,1)
    for j = 1:size(im,2)
        [V,D] = eig([Ix2(i,j), Ixy(i,j); Ixy(i,j), Iy2(i,j)]);
        E(i,j) = min(D(1,1),D(2,2));
    end
end
toc
subplot(4,2,1),imshow(mat2gray(E)), title('Eigen Matrix E'); 
%saveas(gcf,strcat('Results\E_mat_',filenamae),'jpg')

%% Hard coding way to find out the R matrix of image. 

k= .04;
tic
Det_im = Ix2.*Iy2-Ixy.*Ixy;
Tr_M = (Ix2+Iy2);
Tr_M = Tr_M.*Tr_M;
R = Det_im-k*Tr_M;
toc 

%DIsplaying the eigenvalue approximation in gray image form. 
subplot(4,2,2),imshow(mat2gray(R)), title('Eigen matrix R'); 
%saveas(gcf,strcat('Results\R_mat_',filenamae),'jpg')


%% Displaying 81 top corners in E
[sortR,EIX] = sort(E(:),'descend');
[e_y, e_x] = ind2sub([r c],EIX);%The mapping from linear indexes to subscript equivalents for the matrix
subplot(4,2,3); imshow(im, []); hold on; title('Max 81 points in E');% Get the coordinates with maximum cornerness responses     
for i=1:81
	plot(e_x(i), e_y(i), 'r+'); 
end  
%saveas(gcf,strcat('Results\E_81_',filenamae),'jpg')
%% Displaying 81 top corners in R
im1 = im2double(im);
numPts = 81;
[sortR,RIX] = sort(R(:),'descend');
[r_y, r_x] = ind2sub([r c],RIX);%The mapping from linear indexes to subscript equivalents for the matrix
subplot(4,2,4); imshow(im1, []); hold on; title('Max 81 points in R');% Get the coordinates with maximum cornerness responses     
for i=1:81
	plot(r_x(i), r_y(i), 'r+'); 
end  
%saveas(gcf,strcat('Results\R_81_',filenamae),'jpg')

%%  Displaying 81 top Non Maximally Supressed corners in  E.  
E1= ordfilt2(E,121,ones(11));
E2=(E1==E) & (E > (5*mean(mean(E))));
[sortE2,E2IX] = sort(E2(:),'descend');
[e_y, e_x] = ind2sub([r,c],E2IX); %The mapping from linear indexes to subscript equivalents for the matrix
subplot(4,2,5); imshow(im, []); hold on; title('81 points NMS for E'); %labeling along with X axis    
for i=1:81 
	plot(e_x(i), e_y(i), 'b--o'); 
end
%saveas(gcf,strcat('Results\E_NMS_',filenamae),'jpg')

%%  Displaying 81 top Non Maximally Supressed corners in  R.  
R1= ordfilt2(R,121,ones(11));
R2=(R1==R) & (R > (5*mean(mean(R))));
[sortR2,R2IX] = sort(R2(:),'descend');
[r_y, r_x] = ind2sub([r,c],R2IX); %The mapping from linear indexes to subscript equivalents for the matrix
subplot(4,2,6); imshow(im, []); hold on; title('81 points NMS for R'); %labeling along with X axis    
for i=1:81 
	plot(r_x(i), r_y(i), 'b--o'); 
end
%saveas(gcf,strcat('Results\R_NMS_',filenamae),'jpg')
%% code for calculating subpixel accuracy

corner = 0;
subp_r = zeros(81,2);
subp_e = zeros(81,2);
while corner < 82
    corner = corner + 1;
    e_corner_x = e_y(corner);
    e_corner_y = e_x(corner);
    A = [];
    B = [];
    for rangeI = [-1 0 1]
        for rangeJ = [-1 0 1]
            if e_corner_x+rangeI==0 ||e_corner_y+rangeJ==0||e_corner_y+rangeJ>size(im,2)||e_corner_x+rangeI>size(im,1)
            else
                A = [A;(e_corner_x+rangeI)^2,(e_corner_x+rangeI)*(e_corner_y+rangeJ),(e_corner_y+rangeJ)^2,e_corner_x+rangeI, e_corner_y+rangeJ, 1]; 
                B = [B;E(e_corner_x+rangeI,e_corner_y+rangeJ)];
            end
        end
    end
    P = A\B; % Least mean square method to find all the unknown parameters
    if 4*P(1)*P(3) -P(2)*P(2) <= 0
        subp_e(corner,1) = e_corner_x;
        subp_e(corner,2) = e_corner_y;
    else
        subp_e(corner,:) = [2*P(1) P(2);P(2) 2*P(3)]\[-P(4);-P(5)];
        if abs(subp_e(1) - e_corner_x) > 0.5 || abs(subp_r(2)-e_corner_y) > 0.5
            subp_e(corner,1) = e_corner_x;
            subp_e(corner,2) = e_corner_y;
        end
    end
    
    %% For R Matrix
    %%
    r_corner_x = r_y(corner);
    r_corner_y = r_x(corner);
    A = [];
    B = [];
    for rangeI = [-1 0 1]
        for rangeJ = [-1 0 1]
            if r_corner_x+rangeI==0 ||r_corner_y+rangeJ==0||r_corner_y+rangeJ>size(im,2)||r_corner_x+rangeI>size(im,1)
            else
                A = [A;(r_corner_x+rangeI)^2,(r_corner_x+rangeI)*(r_corner_y+rangeJ),(r_corner_y+rangeJ)^2,r_corner_x+rangeI, r_corner_y+rangeJ, 1]; 
                B = [B;R(r_corner_x+rangeI,r_corner_y+rangeJ)];
            end
        end
    end
    P = A\B; % Least mean square method to find all the unknown parameters
    if 4*P(1)*P(3) -P(2)*P(2) <= 0
        subp_r(corner,1) = r_corner_x;
        subp_r(corner,2) = r_corner_y;
    else
        subp_r(corner,:) = [2*P(1) P(2);P(2) 2*P(3)]\[-P(4);-P(5)];
        if abs(subp_r(1) - r_corner_x) > 0.5 || abs(subp_r(2)-r_corner_y) > 0.5
            subp_r(corner,1) = r_corner_x;
            subp_r(corner,2) = r_corner_y;
        end
    end
end

%Plot with subpixel accuracy
subplot(4,2,7), imshow(im_orig);
title('Subpixel Accuracy for E');
hold on;
for iterator=1:size(subp_e,1)
    plot(subp_e(iterator,2), subp_e(iterator,1), 'g+');
end
hold off;
subplot(4,2,8), imshow(im_orig);
title('Subpixel Accuracy for R');
hold on;
for iterator=1:size(subp_r,1)
    plot(subp_r(iterator,2), subp_r(iterator,1), 'g+');
end
hold off;
saveas(gcf,strcat('Results\',filenamae),'jpg')
