

for k = ini:length(y)
    y(k) = dot([y(k-1), y(k-2), y(k-3), y(k-4), y(k-5), u(k-1), u(k-2), u(k-3), u(k-4), u(k-5)], params);
end