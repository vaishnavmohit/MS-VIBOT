clc
clear 
close all
run('vlfeat-0.9.21/toolbox/vl_setup.m')
I1 = im2single(imresize(rgb2gray(imread('photo/8.jpg')),[500,300]));
I2 = im2single(imresize(rgb2gray(imread('photo/9.jpg')),[500,300]));

%% Run SIFT

peak_thresh = 0; % increase to limit; default is 0
edge_thresh = 10; % decrease to limit; default is 10

[fa, da] = vl_sift(I1, ...
'PeakThresh', peak_thresh, ...
'edgethresh', edge_thresh );
[fb, db] = vl_sift(I2, ...
'PeakThresh', peak_thresh, ...
'edgethresh', edge_thresh );

%% Visualize keypoints
figure;
imagesc(I1) ; colormap gray; hold on ;
vl_plotframe(fa) ;

figure;
imagesc(I2) ; colormap gray; hold on ;
vl_plotframe(fb) ;

%% visualize descriptors
figure;
imagesc(I1) ; colormap gray; hold on ;
vl_plotsiftdescriptor(da(:,60), fa(:,60)) 

%% Random selection of 50 features
figure;
imagesc(I1) ; colormap gray; hold on ;
perm = randperm(size(fa,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(fa(:,sel)) ;
h2 = vl_plotframe(fa(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

% Overlay of descriptors
h3 = vl_plotsiftdescriptor(da(:,sel),fa(:,sel)) ;
set(h3,'color','g') 


%% Matching code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Threshold for matching
% Descriptor D1 is matched to a descriptor D2 only if the distance d(D1,D2)
% multiplied by THRESH is not greater than the distance of D1 to all other
% descriptors

thresh = 1.5; % default = 1.5; increase to limit matches

[matches, scores] = vl_ubcmatch(da,db,thresh);
[val, Idx] = sort(scores, 'descend');

figure; clf ;
% imagesc(cat(2, I1, I2)), colormap gray ;
imshow([I1, I2], []), colormap gray ;

f1 = fa;
f2 = fb;
d1 = da;
d2 = db;

last_point = 10;
xa = f1(1,matches(1,Idx(1:last_point))) ;
xb = f2(1,matches(2,Idx(1:last_point))) + size(I1,2) ;
ya = f1(2,matches(1,Idx(1:last_point))) ;
yb = f2(2,matches(2,Idx(1:last_point))) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(f1(:,matches(1,Idx(1:last_point)))) ;
f2(1,:) = f2(1,:) + size(I1,2) ;
vl_plotframe(f2(:,matches(2,Idx(1:last_point)))) ;
axis image off ;

%% One more algo to show all the keypoints
[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

figure(1) ; clf ;
imagesc(cat(2, I1, I2)) ;
axis image off ;

figure(2) ; clf ;
imagesc(cat(2, I1, I2)) ;

f1 = fa;
f2 = fb;
d1 = da;
d2 = db;

xa = f1(1,matches(1,:)) ;
xb = f2(1,matches(2,:)) + size(I1,2) ;
ya = f1(2,matches(1,:)) ;
yb = f2(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(f1(:,matches(1,:))) ;
f2(1,:) = f2(1,:) + size(I1,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;

%% Another matching algorithm

% m1 = f1 (1:2,matches(1,:));
% m2 = f2 (1:2,matches(2,:));
% m2(1,:)= m2(1,:)+size(I1,2)*ones(1,size(m2,2));
% X=[m1(1,:);m2(1,:)];
% Y=[m1(2,:);m2(2,:)];
% c=[I1 I2];
% imshow(c,[]);
% hold on;
% line(X(:,1:3:end),Y(:,1:3:end))

% mosaic = sift_mosaic(I1, I2);
%% descriptor of a SIFT frame centered at position (100,100), of scale 10 and orientation -pi/8 
fc = [100;100;10;-pi/8] ;
[f,d] = vl_sift(I1,'frames',fc) ;
figure;
imagesc(I1) ; colormap gray; hold on ;
vl_plotsiftdescriptor(d, f) 

%% descriptor of a SIFT frame centered at position (100,100), of scale 10 and orientation 0 degree 

fc = [100;100;10;0] ;
[f,d] = vl_sift(I1,'frames',fc,'orientations') ;
figure;
imagesc(I1) ; colormap gray; hold on ;
vl_plotsiftdescriptor(d, f) 

%% For Fundamental Matrix

I1 = im2single(imresize(rgb2gray(imread('photo/8.jpg')),.5));
I2 = im2single(imresize(rgb2gray(imread('photo/9.jpg')),.5));

% Detect SURF features:
 points1 = detectSURFFeatures(I1);
 points2 = detectSURFFeatures(I2);
 
% Display 50 Strong Points
[features1, valid_points1] = extractFeatures(I1, points1);
[features2, valid_points2] = extractFeatures(I2, points2);

figure
strongest1 = valid_points1.selectStrongest(20);
imshow(I1); hold on;
plot(strongest1);

figure
strongest2 = valid_points2.selectStrongest(20);
imshow(I2); hold on;
plot(strongest2);

% Find Essential Matrix
[fLMedS, inliers] = estimateFundamentalMatrix(strongest1,strongest2,'NumTrials',2000);
figure;
showMatchedFeatures(I1, I2, strongest1(inliers,:),strongest2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');


% Show matched features
figure;
showMatchedFeatures(I1,I2,strongest1,strongest2,'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');