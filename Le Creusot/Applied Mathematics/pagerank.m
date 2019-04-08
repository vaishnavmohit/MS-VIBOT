N = input('Enter the number of webpages: ')
for(i = 1:N)
    for(j = 1:N)
        j
        i
        A(j,i) = input('Enter the values for i column: ')
    end
    H(:,i) = A(:,i)/(sum(A(:,i)));
    v(1,i) = 1/N;
end
%Solving Dangling Node Fix:
T(1:N, 1:N) = 1/N; 
a = input('Enter the damping factor value: ')
G = a*A + (1-a)*T;
iter=input('Enter the number of iterations: ');
while(i<iter) 
    v2 = G*v;
    v = v2;
    i = i + 1;
end
printf('PageRank for the matrix is: ')
v
