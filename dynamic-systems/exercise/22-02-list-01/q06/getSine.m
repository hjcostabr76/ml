function x = getSine(A, f, fs, phi, N)
    %
    %======================================================================
    %
    % Returns an array of numbers coresponding to a discrete sine function output.
    %
    % HOW TO CALL:
    % - e.g: `x = getSine(3, 400, 1000, pi, 25);`
    %
    % PARAMS:
    % - A: Amplitude;
    % - f: Frequency (main);
    % - fs: Sampling frequency;
    % - phi: Phase (radians);
    % - N: Number of samples;
    %
    % RETURN:
    % - 1xN array;
    %
    % AUTHOR:
    % - hjcostabr76
    %
    %======================================================================
    %

    fN = 2*f; % Nyquist frequency
    if fs < fN
        throw(MException('myComponent:inputError', "Error! Sampling frequency must greater then the Nyquist frequency (2f))"));
    end
    
    x = zeros(0, N - 1);
    
    for n = 1:N
        x(n) = A*sin(2*pi*(f / fs)*n + phi);
    end
end