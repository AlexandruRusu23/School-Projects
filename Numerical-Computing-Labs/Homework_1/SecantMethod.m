function sol = SecantMethod(a, b, tol, Nmax, func)
	%conditions
    if(a > b)
        sol = 0/0;
        return;
    end
    if(func(a) * func(b) > 0)
        sol = 0/0;
        return;
    end

    x0 = a;
    x1 = b;
    x2 = ( x0*func(x1) - x1*func(x0) ) / ( func(x1) - func(x0) );
    
    N = 1;
    
    while N < Nmax
       if abs(x2 - x1) < tol && abs(func(x1)) < tol
           sol = x1;
           return;
       else
           N = N + 1;
           x0 = x1;
           x1 = x2;
           x2 = ( x0*func(x1) - x1*func(x0) ) / ( func(x1) - func(x0) );
       end
    end
    
end