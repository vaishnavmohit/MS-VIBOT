%%
% Calling of function is in by passing parameters as image, threshold,
% and number of neighbourhood, by default it is taken as 8
%
function [Image_segmented, No_Region] = regionGrowing(image, threshold, Neighborhood)
    % to know the dimensionality of image
    [row, col, dim] = size(image);
    
    %parameter to save mean of the region which is to be compared with the threshold 
    avg_par(:) = zeros(1,dim);
   
    I = [];
    Image_segmented = zeros(row, col);
    x_nd = [0, 1, 0, -1, 1, -1, 1, -1];
    y_nd = [-1, 0, 1, 0, 1, 1, -1, -1];
    % 4 or 8 connectivity
    nN = 8;
    if Neighborhood == 4 || Neighborhood == 8
        nN = Neighborhood;
    end

    T = threshold;

    No_Region = 0;

    for i = 1 : row
        for j = 1 : col
            if Image_segmented(i, j) == 0
               len = 1;               
               r = 1;               
               avg_par(:) = image(i, j,:); 
               I(len, 1) = i;      
               I(len, 2) = j;      
               n = 1;                
               No_Region = No_Region + 1;         
               Image_segmented(i, j) = No_Region;       
               while len <= r         
                   x_c = I(len, 1); 
                   y_c = I(len, 2); 
                   for k = 1 : nN    
                      
                       if x_c+x_nd(k) > 0 && x_c+x_nd(k) <= row && y_c+y_nd(k) > 0 && y_c+y_nd(k) <= col && Image_segmented(x_c+x_nd(k), y_c+y_nd(k)) == 0
                       
                           tmp(:) = zeros(1,dim);
                           tmp(:) = image(x_c+x_nd(k), y_c+y_nd(k), :);
                           dist = norm(tmp(:) - (avg_par(:)/n),2);
                           % if euclidean distance is below the threshold
                           if dist <= T
                               % add that pixel to the queue
                               r = r + 1;
                               I(r, 1) = x_c + x_nd(k);
                               I(r, 2) = y_c + y_nd(k);
                               % assign the label
                               Image_segmented(x_c+x_nd(k), y_c+y_nd(k)) = No_Region;
                               % increase the number of pixels in the region
                               n = n + 1;
                               % update mean
                               tmp(:) = zeros(1, dim);
                               tmp(:) = image(x_c+x_nd(k), y_c+y_nd(k), :);
                               avg_par(:) = avg_par(:) + tmp(:);
                           end
                       end
                   end
                   len = len + 1;
               end
            end
        end
    end
end