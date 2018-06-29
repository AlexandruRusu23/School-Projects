function sol = NewtonMethod(a, b, tol, Nmax, func)
	%conditions
    if(a > b)
        sol = 0/0;
        return;
    end
    if(func(a) * func(b) > 0)
        sol = 0/0;
        return;
    end

    x0 = ( a + b ) / 2;
    funcDerived = Ecuatie1Derivata1(x0);
    x1 = x0 - func(x0)/funcDerived;
    
    N = 1;
    while N < Nmax
       if abs(x1 - x0) < tol && abs(func(x0)) < tol
          sol = x0;
          return;
       else
          N = N + 1;
          x0 = x1;
          funcDerived = Ecuatie1Derivata1(x0);
          x1 = x0 - func(x0)/funcDerived;
       end
    end
end