function Tema2(n, p)
    A = GenerateMatrix(n, p, @ElementGenerator);
    b = ones(n, 1);
    fprintf('LU Method:');
    sol = LUmethod(n, A, b);
    display(sol);
    At = A.';
    bcho = At * b;
    Acho = At * A;
    fprintf('Cholesky Method:');
    sol = CholeskyMethod(n, Acho, bcho);
    display(sol);
    fprintf('QR Method:');
    sol = QRmethod(n, A, b);
    display(sol);
end