%% Author: Mohit Vaishnav
%% Autonomous Robots
% RRT algorithm
%%
%clearing the workspace
close all;
clear;
clc;

%load the environmen%change the name accordingly
load('map.mat');

%parameters for the functions
%% To be used with Map
q_start=[80 70];
q_goal=[707 615];
%% To be used with Maze 
% q_start=[206, 198]; 
% q_goal=[416, 612];
k=1000;
delta_q=20;
p=0.5;
delta=1;

%calling RRT function
[vertices,edges,path]=rrt(map,q_start,q_goal,k,delta_q,p);

%calling the smoothing function
[path_smooth]=smooth(map,path,vertices,delta);

