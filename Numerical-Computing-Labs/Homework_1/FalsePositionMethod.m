function sol = FalsePositionMethod(a, b, tol, Nmax, func)
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
    side = 0;
    fa = func(a);
    fb = func(b);
    
    while N < Nmax
        r = (fa*b - fb*a)/(fa - fb);
        if (abs(b-a) < tol * abs(a+b))
            break;
        end
        
        fr = func(r);
        
        if (fr * fb > 0)
           b = r;
           fb = fr;
           if (side == -1)
               fa = fa/2;
           end
           side = -1;
        else if (fa * fr > 0)
                a = r;
                fa = fr;
                if (side == 1)
                    fb = fb / 2;
                end
                side = 1;
            else
                break;
            end
        end
        sol = r;
        N = N + 1;
    end
end
