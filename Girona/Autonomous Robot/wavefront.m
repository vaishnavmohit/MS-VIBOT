function [value_map]=wavefront(map, start_row, start_column,end_row,end_column)
%%
%size of map
[l,b] = size(map);
flag = sum(sum(map));
count = l*b - flag; %used as a flag to stop the loop
map(start_row, start_column)=2;
tmp_count = 0;

% minimum = 2;
for k = 3:100
    for i = start_row:1:l
        for j = start_column:1:b
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
%4th quadranat
% for i = start_row:2:l
%     for j = start_column:2:b
% %         if tmp_count <= count
%                 if map(i,j)==0
%                     %Defining the connectivity (for 4 point just use the above four)
%                     topcell = map(i-1,j);
%                     bottomcell = map(i,j+1);
%                     rightcell = map(i+1,j);
%                     leftcell = map(i,j-1);
%                     NE = map(i+1,j-1);
%                     NW = map(i-1,j-1);
%                     SE = map(i+1,j+1);
%                     SW = map(i-1,j+1);
%                     index = [bottomcell topcell rightcell leftcell NW NE SW SE];
%                     
%                     [bottomcell topcell rightcell leftcell NW NE SW SE].*(index==0) = minimum;
%                     tmp_idx = 
%                     %if(bottomcell==k-1 || topcell==k-1 || rightcell==k-1
%                     %|| leftcell==k-1) %for 4 point connectivity
%                     if(bottomcell==k-1 || topcell==k-1 || rightcell==k-1|| leftcell==k-1|| NW ==k-1|| NE==k-1|| SW==k-1|| SE ==k-1)
%                         map(i,j) = k;
%                         tmp_count = tmp_count+1;
%                     end
%                     minimum = min(index.*(index>1));
%                 end
% %             else
% %                 break
% %         end
%     end
% end

%1st quadrant
for k = 3:100
    for i = start_row:l
        for j = start_column:-1:1
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
%3rd quadrant
for k = 3:100
    for i = start_row:-1:1
        for j = start_column:b
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

%2nd quadrant
for k = 3:100
    for i = start_row:-1:1
        for j = start_column:-1:1
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
value_map = map;
fprintf('Destination is in %d wavefront value \n', map(end_row,end_column));
%Destination Point
log_mat = false(size(value_map));
flag = 1;
k=3;
r_m = zeros(3);
while(flag)
    [row,col] = find(value_map==k);
    ind = [row';col'];
    for i = 1:size(ind,2)
        r_m = regional_m(value_map,ind(1,i),ind(2,i));
        if max(max(r_m))==k
            log_mat(ind(1,i),ind(2,i))=1;
            continue
        else
            k = k+1;
        end
    end

end

    function a = regional_m(value_map,s_x,s_y)
        a = zeros(3);
        for r_i = -1:1
            for r_j = -1:1
                if(s_x+r_i>0&&s_y+r_j>0&&s_x+r_i<=size(value_map,2)&&s_y+r_j<=size(value_map,2))
                    a(r_i+2,r_j+2) = value_map(s_x+r_i,s_y+r_j);
                end
            end
        end
    end

end
