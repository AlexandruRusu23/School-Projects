function solution = QRmethod(n, A, b)
    Q = zeros(n, n);
    R = zeros(n, n);

    auxSum = 0;
  	for i = 1:n
        auxSum = auxSum + A(i,1)*A(i,1);
    end
    R(1,1) = sqrt(auxSum);
    if R(1,1) == 0
        solution = 0/0;
        return;
    end
    
    for i = 1:n
        Q(i,1) = A(i, 1) / R(1,1);
    end

    for k = 1:n
        for j = 1:k-1
            auxSum = 0;
            for i = 1:n
                auxSum = auxSum + A(i, k)*Q(i, j);
            end
            R(j, k) = auxSum;
        end
        
        auxSum1 = 0;
        auxSum2 = 0;
        for i = 1:n
            auxSum1 = auxSum1 + A(i, k) * A(i, k);
        end
        for i = 1:k-1
            auxSum2 = auxSum2 + R(i, k)*R(i, k);
        end
        
        R(k, k) = sqrt(auxSum1 - auxSum2);
        for i = 1:n
            auxSum = 0;
            for j = 1:k-1
                auxSum = auxSum + R(j,k)*Q(i,j);
            end
            Q(i, k) = (A(i, k) - auxSum) / R(k, k);
        end
    end
    
    y = zeros(n, 1);
    x = zeros(n, 1);
    
    %display(Q);
    %display(R);
    
    for i = 1:n
        auxSum = 0;
        for j = 1:n
            auxSum = auxSum + Q(j, i)*b(j, 1);
        end
        y(i, 1) = auxSum;
    end
    
    for i = n:-1:1
        auxSum = 0;
        for j = i+1:n
            auxSum = auxSum + R(i, j)*x(j, 1);
        end
        x(i, 1) = (y(i, 1) - auxSum) / R(i, i);
    end
    
    solution = floor(x);
end