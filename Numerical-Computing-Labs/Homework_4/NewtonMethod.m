function X = NewtonMethod(f1, f2, eps)
    
%{
    -1.2869   -1.0501 (x)
    -1.2517   -0.2116 (x)
    -1.1819    1.2614 (x)
    -0.0217    1.2165 (x)
    1.2033    1.1633 (x)
    1.0664   -1.1756 (x)
    1.1424    0.0129 (x)
    0.1090   -0.0814 (x)
    0.2211   -1.1355 (x)
%}

    newtonSolutions = zeros(1,2);

    contor = 0;
    
    procent = 0;
    fprintf('%d %%', floor( (contor / 1680) * 100));
    
    syms x;
    syms y;
    df(1,1) = symfun(diff(7*x^3 - 10*x - y + 1, x), [x, y]);
    df(1,2) = symfun(diff(7*x^3 - 10*x - y + 1, y), [x, y]);
    df(2,1) = symfun(diff(8*y^3 - 11*y + x - 1, x), [x, y]);
    df(2,2) = symfun(diff(8*y^3 - 11*y + x - 1, y), [x, y]);
    
    for i = -2:0.1:2
        for j = -2:0.1:2
            n = 0;
            x0 = [i, j];
            condition = true;
            while condition
                n = n + 1;
                A = double(subs(df, [x, y], x0));
                B = inv(A);
                
                a = x0(1);
                b = x0(2);
                auxSum(1) = B(1,1)*f1(a, b) + B(1,2)*f2(a, b);
                auxSum(2) = B(2,1)*f1(a, b) + B(2,2)*f2(a, b);
                y0 = x0 - auxSum;
                maxim = max(abs(y0 - x0));
                x0 = y0;
                condition = (maxim >= eps) && (n <= 20);
            end
            X = x0;
            if procent < floor( (contor / 1680) * 100)
                fprintf(repmat('\b',1,length(int2str(procent)) + 2));
                fprintf('%d %%', floor( (contor / 1680) * 100)); 
                procent = floor( (contor / 1680) * 100);
            end
            if contor == 0
                newtonSolutions = X;
            end
            newtonSolutions = [newtonSolutions; X(1), X(2)];
            newtonSolutions = unique(newtonSolutions, 'rows');
            contor = contor + 1;
        end
    end
    
    pre = unique(newtonSolutions, 'rows');
    X = unique(pre, 'rows');
end