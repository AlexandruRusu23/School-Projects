function [sol, n] = ConjugateGradientMethod(m, A, b, eps)
    X0 = zeros(m, 1);
    R0 = b - A*X0;
    V0 = R0;
    n = 0;
    condition = true;
    while condition
        auxSum1 = 0;
        for i = 1:m
            auxSum1 = auxSum1 + R0(i, 1) * R0(i, 1);
        end
        Av = A*V0;
        auxSum2 = 0;
        for i = 1:m
            auxSum2 = auxSum2 + Av(i, 1) * V0(i, 1);
        end
        a = auxSum1 / auxSum2;
        
        X1 = X0 + a * V0;
        R1 = R0 - a * A * V0;
        
        auxSum1 = 0;
        for i = 1:m
            auxSum1 = auxSum1 + R1(i, 1) * R1(i, 1);
        end
        auxSum2 = 0;
        for i = 1:m
            auxSum2 = auxSum2 + R0(i, 1) * R0(i, 1);
        end
        c = auxSum1 / auxSum2;
        V1 = R1 + c*V0;
        n = n + 1;
        
        auxSum = 0;
        X1mX0 = X1 - X0;
        for i = 1:m
            auxSum = auxSum + X1mX0(i, 1) * X1mX0(i, 1);
        end
        
        X0 = X1;
        V0 = V1;
        R0 = R1;
        
        condition = (sqrt(auxSum) >= eps);
    end
    sol = X0;
end