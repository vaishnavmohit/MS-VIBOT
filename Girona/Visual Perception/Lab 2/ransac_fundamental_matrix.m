function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

%placeholders, you can delete all of this
%Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
%inliers_a = matches_a(1:30,:);
%inliers_b = matches_b(1:30,:);
ptsPerItr = 8;
maxInliers = 0;
errThreshold = 0.05;
% % Rushmore: 0.02
% % woodruff: 0.05
% % NotreDame: 0.05
% % Gaudi: 0.05

Best_Fmatrix = zeros(3,3);
xa = [matches_a ones(size(matches_a,1),1)];
xb = [matches_b ones(size(matches_b,1),1)];

for i = 1:1000
    ind = randi(size(matches_a,1), [ptsPerItr,1]);
    FmatrixEstimate = Normalized_estimate_fundamental_matrix(matches_a(ind,:), matches_b(ind,:));   
    err = sum((xb .* (FmatrixEstimate * xa')'),2);
    currentInliers = size( find(abs(err) <= errThreshold) , 1);
    if (currentInliers > maxInliers)
       Best_Fmatrix = FmatrixEstimate; 
       maxInliers = currentInliers;
       %[I,J]  = find(abs(err) <= errThreshold);
       %inliers_a = matches_a(I,:);
       %inliers_b = matches_b(I,:);
    end    
end

maxInliers
err = sum((xb .* (Best_Fmatrix * xa')'),2);
[Y,I]  = sort(abs(err),'ascend');
inliers_a = matches_a(I(1:30),:);
inliers_b = matches_b(I(1:30),:);


end
