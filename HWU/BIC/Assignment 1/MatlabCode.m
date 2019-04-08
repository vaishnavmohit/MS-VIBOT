%%Load dataset
%h5disp('train_catvnoncat.h5')
A = h5read('testCats.h5', '/test_set_x');
AA = h5read('trainCats.h5', '/train_set_x');
ndim = numel(size(A));
B = permute(A,[ndim:-1:1]);
ndim = numel(size(AA));
BB = permute(AA,[ndim:-1:1]);

% Show a Picture
index = 20;
C = (B (index,:,:,:));
D = reshape(C,[64,64,3]);
imshow(D)

% Flatten the image
E = reshape(AA, [12288,209]);

% Printing the cost
figure
costValues = 1:1:100;
plot(costValues)
ylabel('Cost')
xlabel('Iterations')
title('Convergence')