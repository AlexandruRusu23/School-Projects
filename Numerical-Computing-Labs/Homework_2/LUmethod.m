function solution = LUmethod(n, A, b)
    L = zeros(n, n);
    U = zeros(n, n);
    
    for k = 1:n
        for i = k:n
            auxSum = 0;
            for p = 1:k-1
                auxSum = auxSum + L(i,p)*U(p,k);
            end
            L(i, k) = A(i, k) - auxSum;
        end
        if L(k,k) == 0
            solution = 0/0;
            return;
        end
        
        for j = k+1:n
            auxSum= 0;
            for p = 1:k-1
                auxSum = auxSum + L(k,p)*U(p,j);
            end
            U(k,j) = (A(k, j) - auxSum) / L(k,k);
        end
    end
    
    y = zeros(n, 1);
    
    for i = 1:n
        auxSum = 0;
        for k = 1:i-1
            auxSum = auxSum + L(i,k)*y(k, 1);
        end
        y(i, 1) = (b(i, 1) - auxSum) / L(i,i);
    end
    
    x = zeros(n, 1);
    
    for i = n:-1:1
        auxSum = 0;
        for k = i+1:n
            auxSum = auxSum + U(i, k)*x(k, 1);
        end
        x(i, 1) = y(i, 1) - auxSum;
    end
    
    solution = floor(x);
end