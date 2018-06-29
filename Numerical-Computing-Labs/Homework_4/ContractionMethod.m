function X = ContractionMethod(f1, f2, x1, x2, eps)
    n = 0;
    condition = true;
    while condition
        n = n + 1;
        y1 = f1(x1, x2);
        y2 = f2(x1, x2);
        abs1 = abs(y1 - x1);
        abs2 = abs(y2 - x2);
        maxim = [abs1, abs2];
        maxim = max(maxim);
        x1 = y1;
        x2 = y2;
        condition = maxim >= eps;
    end
    X = [x1, x2];
end