function result = GenerateMatrix(m)
    A = zeros(m, m);
    for i = 1:m
       A(i,i) = 2 + (1/(m*m)); 
    end
    
    for i = 1:m-1
       A(i, i+1) = -1;
       A(i+1, i) = -1;
    end
    result = A;
end