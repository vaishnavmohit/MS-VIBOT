function [ edges ] = RPS( vertices )
%RPS find the visibility graph from given vertices

    % create the edges according to the vertices
    [ edges ] = create_edges( vertices );

    % draw the graph according to the vertices and edges
    draw_graph( vertices, edges );

    visibility_graph = [];

    [h w] = size(vertices);

    S_active_list = zeros(h, h);

    % traverse the all vertices
    for i = 1: h

        [ angles ] = calculate_angle( i, vertices );

        [ S_active_list ] = init( i, vertices, edges, S_active_list );
        % display_edge( S_active_list );

        [k l] = size(angles);

        for j = 1: k

            vertex_1 = i;

            vertex_2 = angles(j, 3);

            [ draw_line, adjacency_list ] = check_intersection( vertex_1, vertex_2, vertices, edges, S_active_list );

            if draw_line == 1

                node_1 = [vertices(vertex_1, 1) vertices(vertex_1, 2)];

                node_2 = [vertices(vertex_2, 1) vertices(vertex_2, 2)];

                line([node_1(1, 1), node_2(1, 1)], [node_1(1, 2), node_2(1, 2)], 'Color', 'r');

                visibility_graph = [visibility_graph; vertex_1 vertex_2];

            else

            end

            [ S_active_list ] = check_active_list( vertex_1, vertex_2, vertices, adjacency_list, S_active_list );

        end

        S_active_list = zeros(h, h);

    end

    [h w] = size(visibility_graph);

    % traverse the all vertices
    for k = 1: h

        i = visibility_graph(k, 1);
        j = visibility_graph(k, 2);

        edges(i, j) = 1;
        edges(j, i) = 1;

    end

    [h w] = size(edges);

    result = [];

    % traverse the edges
    for i = 1: h

        for j = 1: i

            if edges(i, j) ~= 0

                result = [result; j i];

            end

        end

    end

    edges = sortrows(result);

end



function [ edges ] = create_edges( vertices )
%create_edges create edges from given vertices

    [h w] = size(vertices);

    edges = zeros(h, h);

    current_index = 2;

    % create edges
    for i = 2: h - 1

        if vertices(i, 3) == vertices(i + 1, 3)

            edges(i, i + 1) = 1;

            edges(i + 1, i) = 1;

        else

            edges(i, current_index) = 1;

            edges(current_index, i) = 1;

            current_index = i + 1;

        end

    end

end



function draw_graph( vertices, edges )
%draw_graph draw the whole graph from given vertices and edges

    figure;

    axis([0 12 0 12]);

    hold on;

    [h w] = size(vertices);

    % draw points
    for i = 1: h

        plot(vertices(i, 1), vertices(i, 2), 'bo');
        
        text(vertices(i, 1), vertices(i, 2), num2str(i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    end

    [h w] = size(edges);

    % draw edges
    for i = 1: h
        
        for j = 1: i 
        
            % check there is an edge between vertices or not
            if edges(i, j) == 1
                
                % get the x and y values of the first vertex
                x_1 = vertices(i, 1);
                y_1 = vertices(i, 2);

                % get the x and y values of the second vertex
                x_2 = vertices(j, 1);
                y_2 = vertices(j, 2);

                line([x_1, x_2], [y_1, y_2], 'Color', 'b');
            
            end
        
        end

    end

end



function [ angles ] = calculate_angle( i, vertices )
%calculate_angle calculate the angle of the each vertices

    [h w] = size(vertices);

    angles = [];

    % and look at all other vertices
    for j = 1: h

        % do NOT look if there is an edge between two vertices or the indexes are the same

            vertex_1  = [vertices(i, 1), vertices(i, 2)];
            
            vertex_2  = [vertices(j, 1), vertices(j, 2)];

            angle_mod = mod(atan2(vertex_2(2) - vertex_1(2), vertex_2(1) - vertex_1(1)), 2 * pi);

            angle     = atan2(vertex_2(2) - vertex_1(2), vertex_2(1) - vertex_1(1));

            angles    = [angles; angle_mod angle j];

    end
    
    angles = sortrows(angles);
    
end



function [ S_active_list ] = init( vertex_1, vertices, edges, S_active_list )
%init initialization process for the list S

    [h w] = size(edges);

    indexed_edge = [];

    lines = [];

    % traverse the edges
    for i = 1: h
        
        for j = 1: i 
        
            % check there is an edge between vertices or not
            if edges(i, j) == 1 && i ~= vertex_1 && j ~= vertex_1
                
                % get the x and y values of the first vertex
                x_1 = vertices(i, 1);
                y_1 = vertices(i, 2);

                % get the x and y values of the second vertex
                x_2 = vertices(j, 1);
                y_2 = vertices(j, 2);

                lines = [lines; x_1 y_1 x_2 y_2];
                % line([x_1, x_2], [y_1, y_2], 'Color', 'g');

                x_0 = vertices(vertex_1, 1);
                y_0 = vertices(vertex_1, 2);
                [ distance ] = calculate_distance( x_0, y_0, x_1, y_1, x_2, y_2 );
                
                % wait = waitforbuttonpress;
                indexed_edge = [indexed_edge; i j distance];
            
            end
        
        end

    end

	current_line = [vertices(vertex_1, 1) vertices(vertex_1, 2) vertices(vertex_1, 1) + cos(0) * 20 vertices(vertex_1, 2) + sin(0) * 20];

    out = lineSegmentIntersect(current_line, lines);

    indexes = find(out.intAdjacencyMatrix);

    [h w] = size(indexes);

    for k = 1: w
        
        i = indexed_edge(indexes(k), 1);
        j = indexed_edge(indexes(k), 2);
        
        S_active_list(i, j) = indexed_edge(indexes(k), 3);   
        S_active_list(j, i) = indexed_edge(indexes(k), 3);
    
    end

end



function [ draw_line, adjacency_list ] = check_intersection( vertex_1, vertex_2, vertices, edges, S_active_list )
%check_intersection check whether there is an intersection between two lines or not

    draw_line = 0;

    adjacency_list = find(edges(vertex_2, :));

    if vertices(vertex_1, 3) ~= vertices(vertex_2, 3)

        [h w] = size(S_active_list);
        
        weight_lines = [];

        % draw edges
        for i = 1: h

            for j = 1: i 

                % check there is an edge between vertices or not
                if S_active_list(i, j) ~= 0 && i ~= vertex_2 && j ~= vertex_2 && i ~= vertex_1 && j ~= vertex_1

                    % get the x and y values of the first vertex
                    x_1 = vertices(i, 1);
                    y_1 = vertices(i, 2);

                    % get the x and y values of the second vertex
                    x_2 = vertices(j, 1);
                    y_2 = vertices(j, 2);

                    weight_lines = [weight_lines; S_active_list(i, j) i j x_1 y_1 x_2 y_2];

                end

            end
            
        end

        weight_lines = sortrows(weight_lines);

        if ~isempty(weight_lines)
          
            shortest_line = weight_lines(1, :);

            current_line = [vertices(vertex_1, 1) vertices(vertex_1, 2) vertices(vertex_2, 1) vertices(vertex_2, 2)];
            % line([vertices(vertex_1, 1), vertices(vertex_2, 1)], [vertices(vertex_1, 2), vertices(vertex_2, 2)], 'Color', 'g');

            out = lineSegmentIntersect(current_line, shortest_line(4: end));

            % isempty(find(out.intAdjacencyMatrix) == 1 ise intersection yok
            draw_line = isempty(find(out.intAdjacencyMatrix));

        else

            draw_line = 1;

        end

    end

end



function [ S_active_list ] = check_active_list( vertex_0, vertex_1, vertices, adjacency_list, S_active_list )
%check_active_list add or remove the edge to the list S

    if isempty(adjacency_list)
       
        return;
        
    end

    [h w] = size(adjacency_list);
    
    for i = 1: w
        
        vertex_2 = adjacency_list(i);

        if S_active_list(vertex_1, vertex_2) ~= 0 || S_active_list(vertex_2, vertex_1) ~= 0 
            
            S_active_list(vertex_1, vertex_2) = 0;
            
            S_active_list(vertex_2, vertex_1) = 0;
            
        else

            % get the x and y values of the first vertex
            x_1 = vertices(vertex_1, 1);
            y_1 = vertices(vertex_1, 2);

            % get the x and y values of the second vertex
            x_2 = vertices(vertex_2, 1);
            y_2 = vertices(vertex_2, 2);

            x_0 = vertices(vertex_0, 1);
            y_0 = vertices(vertex_0, 2);
            
            [ distance ] = calculate_distance( x_0, y_0, x_1, y_1, x_2, y_2 );

            S_active_list(vertex_1, vertex_2) = distance;
            
            S_active_list(vertex_2, vertex_1) = distance;

        end
        
    end

end



function display_edge( edges )
%display_edge display the given edge

    [h w] = size(edges);
    
    result = [];

    % draw edges
    for i = 1: h
        
        for j = 1: i
            
            if edges(i, j) ~= 0
            
                result = [result; edges(i, j) i j];
                % result = [result; i j];
            
            end
        
        end

    end

    sortrows(result)
    
    size(result)
   
end



function [ distance ] = calculate_distance( x_0, y_0, x_1, y_1, x_2, y_2 )
%calculate_distance calculate the distance between one point to the line segment
    
    distance_1 = sqrt((y_1 - y_0)^2 + (x_1 - x_0)^2);
    
    distance_2 = sqrt((y_2 - y_0)^2 + (x_2 - x_0)^2);

    distance = (distance_1 + distance_2) / 2;
    
end



function out = lineSegmentIntersect(XY1,XY2)
%LINESEGMENTINTERSECT Intersections of line segments.
%   OUT = LINESEGMENTINTERSECT(XY1,XY2) finds the 2D Cartesian Coordinates of
%   intersection points between the set of line segments given in XY1 and XY2.
%
%   XY1 and XY2 are N1x4 and N2x4 matrices. Rows correspond to line segments. 
%   Each row is of the form [x1 y1 x2 y2] where (x1,y1) is the start point and 
%   (x2,y2) is the end point of a line segment:
%
%                  Line Segment
%       o--------------------------------o
%       ^                                ^
%    (x1,y1)                          (x2,y2)
%
%   OUT is a structure with fields:
%
%   'intAdjacencyMatrix' : N1xN2 indicator matrix where the entry (i,j) is 1 if
%       line segments XY1(i,:) and XY2(j,:) intersect.
%
%   'intMatrixX' : N1xN2 matrix where the entry (i,j) is the X coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intMatrixY' : N1xN2 matrix where the entry (i,j) is the Y coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intNormalizedDistance1To2' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(i,:) to the
%       intersection point with XY2(j,:).
%
%   'intNormalizedDistance2To1' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(j,:) to the
%       intersection point with XY2(i,:).
%
%   'parAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 if
%       line segments XY1(i,:) and XY2(j,:) are parallel.
%
%   'coincAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 
%       if line segments XY1(i,:) and XY2(j,:) are coincident.

% Version: 1.00, April 03, 2010
% Version: 1.10, April 10, 2010
% Author:  U. Murat Erdem

% CHANGELOG:
%
% Ver. 1.00: 
%   -Initial release.
% 
% Ver. 1.10:
%   - Changed the input parameters. Now the function accepts two sets of line
%   segments. The intersection analysis is done between these sets and not in
%   the same set.
%   - Changed and added fields of the output. Now the analysis provides more
%   information about the intersections and line segments.
%   - Performance tweaks.
% The math behind is given in:
%   http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
% If you really are interested in squeezing as much horse power as possible out
% of this code I would advise to remove the argument checks and tweak the
% creation of the OUT a little bit.

%%% Argument check.
%-------------------------------------------------------------------------------

validateattributes(XY1,{'numeric'},{'2d','finite'});
validateattributes(XY2,{'numeric'},{'2d','finite'});

[n_rows_1,n_cols_1] = size(XY1);
[n_rows_2,n_cols_2] = size(XY2);

if n_cols_1 ~= 4 || n_cols_2 ~= 4
    error('Arguments must be a Nx4 matrices.');
end

%%% Prepare matrices for vectorized computation of line intersection points.
%-------------------------------------------------------------------------------
X1 = repmat(XY1(:,1),1,n_rows_2);
X2 = repmat(XY1(:,3),1,n_rows_2);
Y1 = repmat(XY1(:,2),1,n_rows_2);
Y2 = repmat(XY1(:,4),1,n_rows_2);

XY2 = XY2';

X3 = repmat(XY2(1,:),n_rows_1,1);
X4 = repmat(XY2(3,:),n_rows_1,1);
Y3 = repmat(XY2(2,:),n_rows_1,1);
Y4 = repmat(XY2(4,:),n_rows_1,1);

X4_X3 = (X4-X3);
Y1_Y3 = (Y1-Y3);
Y4_Y3 = (Y4-Y3);
X1_X3 = (X1-X3);
X2_X1 = (X2-X1);
Y2_Y1 = (Y2-Y1);

numerator_a = X4_X3 .* Y1_Y3 - Y4_Y3 .* X1_X3;
numerator_b = X2_X1 .* Y1_Y3 - Y2_Y1 .* X1_X3;
denominator = Y4_Y3 .* X2_X1 - X4_X3 .* Y2_Y1;

u_a = numerator_a ./ denominator;
u_b = numerator_b ./ denominator;

% Find the adjacency matrix A of intersecting lines.
INT_X = X1+X2_X1.*u_a;
INT_Y = Y1+Y2_Y1.*u_a;
INT_B = (u_a >= 0) & (u_a <= 1) & (u_b >= 0) & (u_b <= 1);
PAR_B = denominator == 0;
COINC_B = (numerator_a == 0 & numerator_b == 0 & PAR_B);


% Arrange output.
out.intAdjacencyMatrix = INT_B;
out.intMatrixX = INT_X .* INT_B;
out.intMatrixY = INT_Y .* INT_B;
out.intNormalizedDistance1To2 = u_a;
out.intNormalizedDistance2To1 = u_b;
out.parAdjacencyMatrix = PAR_B;
out.coincAdjacencyMatrix= COINC_B;

end