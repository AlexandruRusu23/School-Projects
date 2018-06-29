function value = ElementGenerator(p, i, j)
    value = nchoosek((p+j-1), (i-1));
end