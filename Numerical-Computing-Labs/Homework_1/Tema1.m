function Tema1(a, b, sections, tol, Nmax, func)
    h = (b-a)/sections;
    a1 = a;
    b1 = h;
    while b1 <= b
        %Bisection Method
        Out = BisectionMethod(a1, b1, tol, Nmax, func);
        if ~isnan(Out)
            fprintf('Intervalul: [%f,%f]\n', a1, b1);
            fprintf('   Bisection: %.20f\n', Out);
            %False Position Method
            Out = FalsePositionMethod(a1, b1, tol, Nmax, func);
            if ~isnan(Out)
                fprintf('   False Position: %.20f\n', Out);
            end
            %Chord Method
            Out = ChordMethod(a1, b1, tol, Nmax, func);
            if ~isnan(Out)
                fprintf('   Chord: %.20f\n', Out);
            end
            %Secant Method
            Out = SecantMethod(a1, b1, tol, Nmax, func);
            if ~isnan(Out)
                fprintf('   Secant: %.20f\n', Out);
            end
            Out = NewtonMethod(a1, b1, tol, Nmax, func);
            if ~isnan(Out)
                fprintf('   Newton: %.20f\n', Out);
            end
            fprintf('\n');
        end
        a1 = b1;
        b1 = b1 + h;
    end
end