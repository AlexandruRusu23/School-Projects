function Y = RotationsMethod(m, A, eps)
    X = A;
    Y = zeros(m, m);
    n = 0;
    condition = true;
    while condition
        p = 1;
        q = 1;
        maxim = abs(X(1,1));
        for i = 1:m
            for j = 1:m
                if i<j
                    if abs(X(i,j)) > maxim
                        p = i;
                        q = j;
                        maxim = abs(X(i, j));
                    end
                end
            end
        end
        
        if X(p,p) == X(q, q)
            tetha = pi/4;
        else
            tetha = 1/2*atan((2*X(p,q))/(X(p, p) - X(q, q)));
        end
        c = cos(tetha);
        s = sin(tetha);
        for i = 1:m
            for j = 1:m 
                if i ~= p && i ~= q && j~= p && j ~= q
                    Y(i, j) = X(i, j);
                end
            end
        end
        for j = 1:m 
            if j ~= p && j ~= q
                Y(p, j) = c*X(p, j) + s*X(q, j);
                Y(j, p) = c*X(p, j) + s*X(q, j);
                Y(q, j) = -s*X(p, j) + c*X(q, j);
                Y(j, q) = -s*X(p, j) + c*X(q, j);
            end
        end
        Y(p, q) = 0;
        Y(q, p) = 0;
        Y(p, p) = c*c*X(p, p) + 2*c*s*X(p, q) + s*s*X(q, q);
        Y(q, q) = s*s*X(p, p) - 2*c*s*X(p, q) + c*c*X(q, q);
        auxSum = 0;
        for i = 1:m
            for j = 1:m
                if i ~= j
                    auxSum = auxSum + Y(i, j) * Y(i, j);
                end
            end
        end
        modul = sqrt(auxSum);
        X = Y;
        n = n + 1;
        condition = (modul >= eps) && n < 500;
    end
    display(n);
end