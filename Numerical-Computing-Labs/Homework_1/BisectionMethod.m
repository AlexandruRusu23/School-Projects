function sol = BisectionMethod(a, b, tol, Nmax, func)
    %conditions 
    if(a > b)
        sol = 0/0;
        return;
    end
    if(func(a) * func(b) > 0)
        sol = 0/0;
        return;
    end
    
    N = 1;
    while N < Nmax
        c = (a+b)/2;
        if (((b - a)/ 2^N) < tol)
            sol = c;
            return;
        else
            N = N + 1;
            if(func(a) * func(c) < 0)
                b = c;
            else
                a = c;
            end
        end
    end
    sol = 0/0;
end

