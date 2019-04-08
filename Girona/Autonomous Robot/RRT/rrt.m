% To run this function, input arguments are required such as :
% map		: Map which containts the obstacle around.
% q_start	: From where the robot has to start in the map.
% q_goal	: Till where the robot has to reach in the map.
% delta_q	: Defining the distance parameter
% p 		: Comparing with the probability of the random parameter if come out to be greater than p, values are assigned. 
%% Output parameter
% vertices 	: List of vertices traversed during searching of the path
% Edges and Path gives the desired result wherever the function is called. 
function [vertices, edges, path] = rrt(map, q_start, q_goal, num, delta_q, p)
% Displaying the Map
    figure;
    colormap = [1,1,1; 0,0,0; 1,0,0; 0,1,0; 0,0,1];
    imshow(uint8(map), colormap)
    hold on
    
% Finding the dimension of Map
    [length,bredth] = size(map);
     
% Creating and starting list of vertices
    vertices(1,:) = q_start;
    
%% loop for generating tree
    
% initializing count inside the loop
    i = 1;
    while(i<=num)
        % To generate random sample point
        while(1)
        % Random probability 
            probability = rand(1);
            % Generate a random sample point
            if probability > p
                x = round(rand(1)*length);
                y = round(rand(1)*bredth);
                if x > 0 && y > 0
                    if map(x,y) == 0
                        break;
                    end
                end
                % Defining the goal location
            else
                y = q_goal(1,1);
                x = q_goal(1,2);
                break
            end
        end
        %% Finding the nearest node
        [node_count, ~] = size(vertices);
        
        % Set very high initial distance
        dist = inf;
        for j = 1:node_count
            dist_temp = sqrt((vertices(j,1)-y)^2 + (vertices(j,2)-x)^2);
            if dist_temp < dist
                dist = dist_temp;
                q_near = j;
            end
        end
        % Obtaining point wrt delta_q distance
        if dist > delta_q
            dist = delta_q;
        end
        
        % Checking the free space around
        check = 0;
        nearby = 0:5:dist;
        theta = atan2(x-vertices(q_near,2),y-vertices(q_near,1));
        x = round(nearby*sin(theta) + vertices(q_near,2));
        y = round(nearby*cos(theta) + vertices(q_near,1));
        for k = 1:size(x,2)
            if map(abs(x(k)), abs(y(k))) == 1
                check = 1;
                break
            end
        end
        
        % Creating connection
        x = round(dist*sin(theta) + vertices(q_near,2));
        y = round(dist*cos(theta) + vertices(q_near,1));
        
        % Checking validity of point
        if check == 1 || map(abs(x),abs(y)) == 1
            continue;
        end
        
        % Updating vertices and edges
        vertices(i+1,:) = [y,x];
        edges(i,:) = [q_near, i+1];
        
        % Defining the termination statement
        if x == q_goal(2) && y == q_goal(1)
            break;
        end
        
        % Checking the maximum iteration conditoin
        i = i + 1;
    end
    if i == 1001
        printf('Path could not be found:---------');
        return
    end
    
    %% Displaying the tree 
    plot(q_start(1), q_start(2), 'k*', 'Markersize', 10);
    plot(q_goal(1), q_goal(2), 'b*', 'Markersize', 10);
    
    % Displaying rest of the points
    for i = 1:size(edges,1)
        plot([vertices(edges(i,1),1); vertices(edges(i,2),1)], [vertices(edges(i,1),2); vertices(edges(i,2),2)], 'r');
    end
    
    %%  Finding the path between start and goal
    k = 1;
    path(k) = edges(end,2);
    while(1)
        if path(k) == 1
            break;
        end
        for j = 1:i
            if (edges(j,2) == path(k))
                k = k + 1;
                path(k) = edges(j,1);
                break;
            end
        end
    end
    
    % Listing branches for a path
    for i = 1:size(path',1)-1
        branch(i,:) = [path(i), path(i +1)];
    end
    
    % Displaying the path
    for i = 1:size(branch,1)
        plot([vertices(branch(i,1),1); vertices(branch(i,2),1)], [vertices(branch(i,1),2); vertices(branch(i,2),2)], 'g');
    end
    
    % Sorting the path
    path = sort(path);
end