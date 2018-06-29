function sol = ChordMethod(a, b, tol, Nmax, func)
	%conditions
    if(a > b)
        sol = 0/0;
        return;
    end
    if(func(a) * func(b) > 0)
        sol = 0/0;
        return;
    end
    
    c = b;
    x0 = a;
    x1 = (c * func(x0) - x0 * func(c)) / (func(x0) - func(c));
    
    N = 1;
    
    while N < Nmax
        if abs( x1 - x0 ) < tol && abs(func(x1)) < tol
            sol = x1;
            return;
        else
            N = N + 1;
            x0 = x1;
            x1 = (c * func(x0) - x0 * func(c)) / (func(x0) - func(c));
        end
    end
    
    sol = 0/0;
end