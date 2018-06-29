function matrix = GenerateMatrix(n, p, func)
    matrix = zeros(n,n);
    for i = 1:n
        for j = 1:n
            matrix(i,j) = func(p, i, j);
        end
    end
end