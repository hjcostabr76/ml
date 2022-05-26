function yA = getCubeSpringApprox(x)
    a = 108.33;
    b = 2*a;

    if x <= -2
        yA = a*x + b;
    elseif x >= 2
        yA = a*x + -b;
    else
        yA = 0;
    end
end