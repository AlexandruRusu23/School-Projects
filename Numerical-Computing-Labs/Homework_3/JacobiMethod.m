function [no, Z] = JacobiMethod(m, A, b, eps, p)    
    maxSum = 0;
    for i = 1:m
        currentSum = 0;
        for j = 1:m
           currentSum = currentSum + abs(A(i, j));
        end
        if currentSum > maxSum
            maxSum = currentSum;
        end
    end
    
    infiniteNorm = maxSum;
    no = 0;
    
    for k = 1:p
        sigma = (2 * k)/(infiniteNorm *(p + 1));
        B = zeros(m,m);
        for i = 1:m
            B(i, i) = 1 - sigma * A(i, i);
        end
        for i = 1:m
            for j = 1:m
                if i ~= j
                    B(i, j) = -sigma * A(i, j);
                end
            end
        end
        bSigma = zeros(m, 1);
        for i = 1:m
            bSigma(i, 1) = sigma * b(i, 1);
        end
        X = zeros(m, 1);
        n = 0;
        Y = zeros(m, 1);
        condition = true;
        while condition
            n = n + 1;
            for i = 1:m
                auxSum = 0;
                for j = 1:m
                    auxSum = auxSum + B(i,j)*X(j, 1);
                end
                Y(i, 1) = auxSum + bSigma(i, 1);
            end
            auxSum = 0;
            for i = 1:m
                for j = 1:m
                    auxSum = auxSum + A(i, j) * (Y(i, 1) - X(i, 1))*(Y(j, 1) - X(j, 1));
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