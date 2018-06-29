function [no, Z] = GaussSeidelMethod(m, A, b, eps, p)
    no = 0;
    for k = 1:p
        sigma = (2 * k) / (p + 1);
        X = zeros(m, 1);
        Y = zeros(m, 1);
        n = 0;
        condition = true;
        while condition
            n = n + 1;
            for i = 1:m 
                auxSum1 = 0;
                auxSum2 = 0;
                for j = 1:i-1
                    auxSum1 = auxSum1 + A(i, j) * Y(j, 1);
                end
                for j = i+1:m
                    auxSum2 = auxSum2 + A(i, j) * X(j, 1);
                end
                Y(i, 1) = (1 - sigma)*X(i, 1) + (sigma/A(i,i)) * (b(i, 1) - auxSum1 - auxSum2);
            end
            auxSum = 0;
            for i = 1:m
                for j = 1:m
                    auxSum = auxSum + A(i, j)*(Y(i, 1) - X(i, 1))*(Y(j, 1) - X(j, 1));
                end
            end
            na = sqrt(auxSum);
            X = Y;
            condition = (na >= eps);
        end
        if k == 1 || n < no
            no = n;
            Z = X;
        end
        
    end
end