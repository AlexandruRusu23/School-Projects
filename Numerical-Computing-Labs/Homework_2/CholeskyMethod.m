function solution = CholeskyMethod(n, A, b)
    L = zeros(n, n);
    
    for j = 1:n
        auxSum = 0;
        for k = 1:j-1
           auxSum = auxSum + L(j, k)*L(j,k); 
        end
        if A(j,j) - auxSum <= 0
            display('Conditie neindeplinita');
            solution = 0/0;
            return;
        end
        
        auxSum = 0;
        for k = 1:j-1
            auxSum = auxSum + L(j,k)*L(j,k);
        end
        L(j, j) = sqrt(A(j, j) - auxSum);
        for i = j+1:n
            auxSum = 0;
            for k = 1:j-1
                auxSum = auxSum + L(i,k)*L(j,k);
            end
            L(i,j) = (A(i,j) - auxSum) / L(j, j); 
        end
    end
    
    y = zeros(n, 1);
    
    for i = 1:n
        auxSum = 0;
        for k = 1:i-1
            auxSum = auxSum + L(i, k)*y(k, 1);
        end
        y(i, 1) = ( b(i, 1) - auxSum ) / L(i, i);
    end
    
    x = zeros(n, 1);
    
    for i = n:-1:1
        auxSum = 0;
        for k = i+1:n
            auxSum = auxSum + L(k, i)*x(k, 1);
        end
        x(i, 1) = ( y(i, 1) - auxSum ) / L(i, i);
    end
    solution = floor(x);
end