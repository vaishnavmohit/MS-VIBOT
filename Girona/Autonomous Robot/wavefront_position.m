function [path, cost] = wavefront_position(value_map, start, goal)
% Calculate a wavefront path plan, given the current position, goal position, 
% and current occupancy map.

% Create a cost map
cost = zeros(size(value_map));

% Find index of goal and current pos:
goali = goal(1);
goalj = goal(2);
posi = start(1);
posj = start(2);
xaxis = size(value_map,1);
yaxis = size(value_map,2);

open = [goali goalj];
cost(goali, goalj) = 1;

%%
%Choosing between 4point or 8 point connectivity.
%adjacent = [ 1 0; 0 1; -1 0; 0 -1];  % immediate adjacents
adjacent = [ 1 -1; 1 0; 1 1; 0 -1; 0 0; 0 1; -1 -1; -1 0; -1 1 ]; 
%%

while size(open,1) ~= 0
  % Iterate through cells adjacent to the cell at the top of the open queue:
  for k=1:size(adjacent,1)
    % Calculate index for current adjacent cell:
    adj = open(1,:)+adjacent(k,:);
    % Make sure adjacent cell is in the map
    if min(adj) < 1
      continue
    end
    if adj(1) > (xaxis)
      continue
    end
    if adj(2) > (yaxis)
      continue
    end
    % Make sure the adjacent cell is not an obstacle 
    if value_map(adj(1), adj(2)) == 1
      continue
    end
    % Make sure the adjacent cell is not closed:
    if cost(adj(1), adj(2)) ~= 0
      continue
    end
    % Set the cost and add the adjacent to the open set
    cost(adj(1), adj(2)) = cost(open(1,1), open(1,2)) + 1;
    open(size(open,1)+1,:) = adj;
  end

  % Pop the top open cell from the queue
  open = open(2:end,:);
end

% Find a path to the goal.
path = [posi; posj];
while 1
  i = size(path,2);
  if path(:,i) == [goali; goalj]
    break
  end

  curc = cost(path(1,i),path(2,i));
  if curc == 0
    % if we're in an obstacle (bad initial state, most likely)
    curc = max(reshape(cost,1,[]));
  end

  noMove = 1;
  for k=1:size(adjacent,1)
    % Calculate index for current adjacent cell:
    adj = path(:,i)+adjacent(k,:)';
    % Make sure adjacent cell is in the map
    if min(adj) < 1
      continue
    end
    if adj(1) > (xaxis)
      continue
    end
    if adj(2) > (yaxis)
      continue
    end
   
    % If this adjacent cell reduces cost, add it to the path.
    if cost(adj(1),adj(2)) == 0
      % (obstacle)
      continue;
    end
    if cost(adj(1),adj(2)) < curc
      noMove = 0;
      path(:,i+1) = adj;
      break
    end
  end
  if noMove
    path = [posi; posj];
    break;
  end
end