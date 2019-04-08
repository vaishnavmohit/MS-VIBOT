%% Input Arguments: 
% Map		: Input map which contains all the obstacles. 
% Vertices	: List of vertices traversed to reach the destination to goal position
% Delta		: Parameter to check the line connecting two nodes. 

%% Output
% Smooth_Path: Shortest path between destination and goal position
function [smooth_path] = smooth(map, path, vertices, delta)

%% Smoothing Function
flip_path = flip(path);
vertex_end = vertices(flip_path(end),:); % Goal point starting
vertex_end_index = flip_path(end);
smooth_path = flip_path(end); % Goal point index initialization

while(smooth_path(end)~=1) % Checking the initial reaching point
    i = 1;
    while(i < vertex_end_index) % To find the connectable path
        vertex_start = vertices(flip_path(i),:);
        obstacle_check = 0;
        for j = 1:ceil(norm(vertex_start(1)-vertex_end(1), vertex_start(2)-vertex_end(2))/delta) % Checking the line connecting two nodes
            f = @(theta)([cos(theta) -sin(theta) vertex_start(1); sin(theta) cos(theta) vertex_start(2)]); % Transformation Matrix
            xy=round(f(atan2(v_end(2)-v_start(2),v_end(1)-v_start(1)))*[j*delta;0;1]) ;
              xy=xy';
              if(map(xy(2),xy(1))==1) % Checking the path passage through obstacle
                  belong_to_obstacle=1;
                  break;
              end
        end
        if(belong_to_obstacle==0) % Checking lines which they lie in free space
            smooth_path=[smooth_path flip_path(i)];
            break;
        else
            i=i+1;

        end
    end
    % move to a nearer vertex to the start
    v_end_index=flip_path(i);
    v_end=vertices(flip_path(i),:);
end
end