function Tema3(m, eps, p)
    A = GenerateMatrix(m);
    b = ones(m, 1) * (1 / (m*m));
    fprintf('Jacobi method:\n');
    [n, X] = JacobiMethod(m, A, b, eps, p);
    display(n);
    display(X);
    fprintf('Gauss-Seidel method:\n');
    [n, X] = GaussSeidelMethod(m, A, b, eps, p);
    display(n);
    display(X);
    fprintf('Conjugate gradient method:\n');
    [X, n] = ConjugateGradientMethod(m, A, b, eps);
    display(n);
    display(X);
    fprintf('Valorile proprii ale matricei:');
    X = RotationsMethod(m, A, eps);
    %display(diag(X));
    X = eig(A);
    display(X);
end