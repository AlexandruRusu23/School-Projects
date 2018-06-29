function Tema4(eps)
    fprintf('*******************************************************\n');
    fprintf('Exercitiul  1. a):\n');
    fprintf('\nMetoda Contractiei:\n');
    x1 = 0;
    x2 = 0;
    X = ContractionMethod(@ex1Afunction1, @ex1Afunction2, x1, x2, eps);
    display(X);
    fprintf('\nMetoda Gauss-Seidel:\n');
    x1 = 0;
    x2 = 0;
    X = GaussSeidelMethod(@ex1Afunction1, @ex1Afunction2, x1, x2, eps);
    display(X);
    
    fprintf('*******************************************************\n');
    fprintf('Exercitiul 1. b):\n');
    fprintf('\nMetoda Newton:\n');
	X = NewtonMethod(@ex1Bfunction1, @ex1Bfunction2, eps);
    out = unique(X, 'rows');
    display(out);
end