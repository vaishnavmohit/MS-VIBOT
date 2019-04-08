function [ graphEdges, edges ] = RPS2( vertices )
    % create new array of edges that contain coordinates of its vertices.
    edges = zeros(size(vertices,1)-2, 4);
    p = 0;
    for i = 2:size(vertices,1)-1
        if vertices(i, 3) == vertices(i+1, 3)
            edges(i-1, 1) = vertices(i,1);
            edges(i-1, 2) = vertices(i,2);
            edges(i-1, 3) = vertices(i+1,1);
            edges(i-1, 4) = vertices(i+1,2);
            p = p + 1;
        else
            edges(i-1, 1) = vertices(i,1);
            edges(i-1, 2) = vertices(i,2);
            edges(i-1, 3) = vertices(i-p,1);
            edges(i-1, 4) = vertices(i-p,2);
            p = 0;
        end;
    end;
    graphEdges = [];
    % for all vertices do
    for curid = 1:size(vertices,1)-1
        % for each vertex compute the angle and keep the indecies from vertices
        % array;
        angles = zeros(size(vertices,1)-1, 2);
        temp = 0;
        for i = 1:size(vertices,1) % don't compute angle for the current vertex (curid)
            if i ~= curid
                temp = temp + 1;
                angles(temp, 1) = atan2(vertices(curid,2)-vertices(i,2), vertices(curid,1)-vertices(i,1));
                angles(temp, 2) = i;
            end;
        end;
        % sort them
        angles = sortrows(angles, 1);
        % declare active list
        activeList = [];
        % if current vertex is an end of any edge, add those edges to the
        % active list
        if curid > 1
            for j = 1:size(edges,1)
                if (edges(j,1) == vertices(curid,1) && edges(j,2) == vertices(curid,2)) || (edges(j,3) == vertices(curid,1) && edges(j,4) == vertices(curid,2))
                    activeList = [activeList, j];
                end;
            end;
        end;
        % and insert all the edges that intersect initial half-line
        for i = 1:size(edges,1)
            if intersect(vertices(curid,1), vertices(curid,2), 100000000, vertices(curid,2), edges(i,1), edges(i,2), edges(i,3), edges(i,4))
                activeList = [activeList, i];
            end;
        end;
        curx = vertices(curid,1); cury = vertices(curid,2);
        for i = 1:size(angles, 1)
            visible = true;
            % check all the vertices for visibility from curid vertex
            for j = 1:length(activeList)
                if intersect(curx, cury, vertices(angles(i,2), 1), vertices(angles(i,2), 2), edges(activeList(j),1), edges(activeList(j),2), edges(activeList(j),3), edges(activeList(j),4))
                    visible = false;
                end;
            end;
            if visible == true
                % add new edge to the visibility graph
                % if not already in the visibility graph
                canBeAdded = true;
                for j = 1:size(graphEdges,1)
                    if (graphEdges(j, 1) == curid && graphEdges(j,2) == angles(i,2)) || (graphEdges(j, 1) == angles(i,2) && graphEdges(j,2) == curid)
                        canBeAdded = false;
                        break;
                    end;
                end;
                if canBeAdded
                    graphEdges = [graphEdges; curid, angles(i,2)];
                end;
            end;
            % find edge where vertice(i) belongs to
            for j = 1:size(edges,1)
                if (edges(j,1) == vertices(angles(i,2),1) && edges(j,2) == vertices(angles(i,2),2)) || (edges(j,3) == vertices(angles(i,2),1) && edges(j,4) == vertices(angles(i,2),2))
                    % check if this edge is in the active list, if so,
                    % remove it
                    inActiveList = false;
                    for k = 1:length(activeList)
                        if j == activeList(k)
                            activeList(k) = [];
                            inActiveList = true;
                            break;
                        end;
                    end;
                    % if this edge is not in the active list, add it.
                    if ~inActiveList
                        activeList = [activeList, j];
                    end;
                end;
            end;
       end;
    end;
    
    % remove edges that inside the polygon
    removeList = [];
    for i = 1:size(graphEdges, 1)
        if vertices(graphEdges(i,1), 3) == vertices(graphEdges(i,2), 3)
            x1 = vertices(graphEdges(i, 1), 1);
            y1 = vertices(graphEdges(i, 1), 2);
            x2 = vertices(graphEdges(i, 2), 1);
            y2 = vertices(graphEdges(i, 2), 2);
            xc = (x1+x2)/2;
            yc = (y1+y2)/2;
            polygon = [];
            for j = 1:size(vertices, 1)
                if vertices(j, 3) == vertices(graphEdges(i,1), 3)
                    polygon = [polygon; vertices(j,:)];
                end;
            end;
            [in, on] = inpolygon(xc, yc, polygon(:,1), polygon(:,2));
            if in == 1 && on == 0
                removeList = [removeList, i];
            end;
        end;
    end;
    graphEdges(removeList(:),:) = [];
    
%     for i = 1:size(vertices,1)-1
%         for j = i+1:size(vertices,1)
%             if vertices(i,3) == vertices(j,3)
%                 notPolygonEdge = true;
%                 for t = 1:size(edges, 1)
%                     if (vertices(i,1)==edges(t,1)&&vertices(i,2)==edges(t,2)...
%                             &&vertices(j,1)==edges(t,3)&&vertices(j,2)==edges(t,4))...
%                         ||(vertices(i,1)==edges(t,3)&&vertices(i,2)==edges(t,4)...
%                             &&vertices(j,1)==edges(t,1)&&vertices(j,2)==edges(t,2))
%                         notPolygonEdge = false;
%                         break;
%                     end;
%                 end;
%                 if notPolygonEdge
%                     for t = 1:size(graphEdges, 1)
%                         if (graphEdges(t,1) == i && graphEdges(t,2) == j) || (graphEdges(t,1) == j && graphEdges(t,2) == i)
%                             graphEdges(t,:) = [];
%                             break;
%                         end;
%                     end;
%                 end;
%             end;
%         end;
%     end;
    
    
    function [out] = intersect(x1, y1, x2, y2, x3, y3, x4, y4)
        out = false;
        p1p2x = x2-x1; p1p2y = y2-y1;
        p1m2x = x4-x1; p1m2y = y4-y1;
        p1m1x = x3-x1; p1m1y = y3-y1;
        m1m2x = x4-x3; m1m2y = y4-y3;
        m1p1x = x1-x3; m1p1y = y1-y3;
        m1p2x = x2-x3; m1p2y = y2-y3;
        if (p1p2x*p1m2y-p1p2y*p1m2x)*(p1p2x*p1m1y-p1p2y*p1m1x) < 0 && (m1m2x*m1p1y-m1m2y*m1p1x)*(m1m2x*m1p2y-m1m2y*m1p2x) < 0
            out = true;
        end;
    end
end
