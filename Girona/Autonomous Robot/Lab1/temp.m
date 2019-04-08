end_row = 13;
start_row = 3;
end_column = 2;
start_column = 18;
d_p = map(end_row,end_column);
flag = 1;
neighbour = struct('x',[],'y',[]);

for i = -1:1
    for j = -1:1
        if value_map(start_row+i,start_column+j)>value_map(start_row,start_column)
            neighbour.x = [neighbour.x start_row+i];
            neighbour.y = [neighbour.y start_column+j];
        end
    end
end

ind = [neighbour.x(1,:); neighbour.y(1,:)]
for i = 1:size(ind,2)
   a(i) = value_map(ind(1,i),ind(2,i));
end