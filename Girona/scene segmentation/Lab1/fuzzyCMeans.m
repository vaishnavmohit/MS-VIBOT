function seg = fuzzyCMeans(image, no_cluster)
    data = reshape(image, [], 1);
    intensities = linspace(0, 255, no_cluster);
    seg = zeros(size(image, 1), size(image, 2));
    [center, U] = fcm(data, no_cluster);
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            temp = 1;
            m = abs(image(i,j) - center(temp));
            for k = 2:no_cluster
                if abs(image(i,j) - center(k)) < m
                    temp = k;
                    m = abs(image(i,j) - center(k));
                end
            end
            seg(i, j) = intensities(temp);
        end
    end
end