clc
close all
clear 
%%
%Defining Maps
map=[
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 0 0 0 1;
1 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1;
1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1;
1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1;
1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1;
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;];
%%
%Passing to the function
%%
%I found that map(1,1)=0 which was suppose to be a boundary condition and
%hence 1, so my algorithm was working fine with specified  values assuming
%that the boundary pixels are of values 1. Though I can change the code
%accordingly.
tic
m = brushfire(map);
toc
figure, heatmap(m); title('BushFire Algorithm for small map');
start = [3, 18];
goal = [13,2];
tic
[path, cost]=wavefront_position(map, start, goal);
toc
% figure, heatmap(cost); title('Wavefront Algorithm: small');
for i = 1:length(path)
    map(path(1,i),path(2,i))= 50;
end
figure, imagesc(map)

%%If you need to have a different colormap
% color_map = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0];
% colormap(color_map)


%%
%Applying algorithm in maze.mat matrix

load maze.mat
tic
m = brushfire(map);
toc
figure, heatmap(m); title('BushFire Algorithm: Maze');

tic
start = [45,4];
goal = [5,150];
[path, cost]=wavefront_position(map, start, goal);
toc

for i = 1:length(path)
    map(path(1,i),path(2,i))= 50;
end

figure, imagesc(map), title('Wavefront Algorithm: Maze');
% color_map = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0];
% colormap(color_map)


%%
% Applying algorithm in mazeBig.mat matrix
load mazeBig.mat
map(1,1)=1;
tic
m = brushfire(map);
toc
figure, imagesc(m); title('BushFire Algorithm: BigMaze');

% hold off
% figure, heatmap(cost); title('Wavefront Algorithm: BigMaze');

%%
% load mazeBig.mat
% map(1,1)=1;
% tic
% [path, cost]=wavefront_position(map, 45, 4, 5, 150);
% toc
% hold on
% set(gcf,'color','r');
% figure, imshow(cost); title('Wavefront Algorithm: BigMaze');
% for i = 1:length(path)
%     map(path(1,i),path(2,i))= 50;
% end
% color_map = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0];
% figure, imagesc(map)
% colormap(ax_map3,color_map)
% subplot(2,2,4)
% ax_map3 = subplot(2,2,4);
% map_solution = map;
% color_map = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0];
% for i = 1:length(path) % For displaying the trajectory on the original image
%     map_solution(path(1,i),path(2,i)) = 2;
% end
% map_solution(start(1),start(2)) = 3;
% map_solution(goal(1),goal(2)) = 4;
% imagesc(map_solution)
% colormap(ax_map3,color_map)
% title('Generated trajectory')

load obstaclesBig.mat
map(1,1)=1;
tic
m = brushfire(map);
toc
figure, imagesc(m); title('BushFire Algorithm: ObstacleBig');
% figure, imagesc(map)
% color_map = [1 1 1; 0 0 0; 1 0 0; 0 0 1; 0 1 0];
% colormap(color_map)