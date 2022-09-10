function tFunc = get2ndOrderSystem(k, zeta, omegaN)
    %
    %======================================================================
    %
    %% Set 2nd order system
    % 
    % - Characteristic Eq:
    % s^2 + 2.zeta.omegaN.s + omegaN^2
    % 
    % - General equation: 2nd Order systems:
    % omegaN^2 / [characteristic eq]
    %
    % - Stability -> System is stable if roots of characteristic eq. are;
    %   s1, s2 < 0
    %
    % - Underdamping -> System will be underdamped if:
    %   0 < zeta < 1
    %
    % PARAMS:
    % - k: Gain
    % - zeta: Damping coeficient
    % - omegaN: Natural frequency
    %
    % RETURN:
    % - tFunc: The 2nd order transfer functon.
    %
    %======================================================================
    %

    ftNumerator = k * omegaN^2;
    eqCharacteristic = [1 2*zeta*omegaN omegaN^2];
    
    eqCharacteristic2 = [1 2*zeta*omegaN omegaN^2];
    tFunc = tf(ftNumerator, eqCharacteristic);
end