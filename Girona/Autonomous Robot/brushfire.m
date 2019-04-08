function [map] = brushfire(map)
%%
%size of map
[l,b] = size(map);
flag = sum(sum(map));
count = l*b - flag;
%%
%for marking end of the loop
%K value is assumed to be 100, could also be any bigger value as per the requirements and environment given.
%%
%traversing the map
tmp_count = 0;
for k = 2:1000
    for i = 1:l
        for j = 1:b
            if tmp_count <= count
                if map(i,j)==0
                    %Defining the connectivity (for 4 point just use the above four)
                    topcell = map(i-1,j);
                    bottomcell = map(i,j+1);
                    rightcell = map(i+1,j);
                    leftcell = map(i,j-1);
                    NE = map(i+1,j-1);
                    NW = map(i-1,j-1);
                    SE = map(i+1,j+1);
                    SW = map(i-1,j+1);
                    %if(bottomcell==k-1 || topcell==k-1 || rightcell==k-1
                    %|| leftcell==k-1) %for 4 point connectivity
                    if(bottomcell==k-1 || topcell==k-1 || rightcell==k-1|| leftcell==k-1|| NW ==k-1|| NE==k-1|| SW==k-1|| SE ==k-1)
                        map(i,j) = k;
                        tmp_count = tmp_count+1;
                    end
                end
            else
                break
            end
        end
    end
end
end