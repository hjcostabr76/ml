function signal = getSignal(amplitude, tBegin, tEnd, signalType)
    %
    %======================================================================
    %
    % Generate generic signal according to signal parameters.
    %
    % PARAMS:
    % - amplitude: TODO: Describe
    % - tBegin: tEnd inicial
    % - tEnd: tEnd final
    % - signalType: TODO: Describe
    %
    % RETURN:
    % - signal: Array of signal values through the specified time interval.
    %
    %======================================================================
    %

    SIGN_T_STEP = 1;
    SIGN_T_PULSE = 2;
    SIGN_T_PULSE_LONGER = 3;
    SIGN_T_PULSES = 4;
    SIGN_T_SINE = 5;
    SIGN_T_RANDOM = 6;
    SIGN_T_INCREASING_STEPS = 7;
    
    signal = zeros(tEnd, 1);
    nextT = tBegin + 1;
    step = 10;
    smallStep = round((tEnd - nextT - 1) / 10) - 1;
    
    % Step
    if signalType == SIGN_T_STEP
        signal(nextT:tEnd, 1) = amplitude;
        
    % Pulse
    elseif signalType == SIGN_T_PULSE
        signal(nextT, 1) = amplitude;
    
    % Pulse (longer)
    elseif signalType == SIGN_T_PULSE_LONGER
        signal(nextT:nextT+step, 1) = amplitude;
           
    % 02 pulses
    elseif signalType == SIGN_T_PULSES
        for ii = 1:2
            signal(nextT:nextT+smallStep, 1) = amplitude;
            nextT = nextT + 2*smallStep;
        end
    
    % Sine
    elseif signalType == SIGN_T_SINE
           f = 0.0075;
           for ii = 1:tEnd-nextT
               signal(nextT + ii) = amplitude*sin(2*pi*f*ii);
           end
    % Random
    elseif signalType == SIGN_T_RANDOM
        for ii = nextT:tEnd
            signal(ii,1) = amplitude*rand;
        end
    
    % Increasing steps
    elseif signalType == SIGN_T_INCREASING_STEPS
        for ii = 1:5
         signal(nextT:nextT+step, 1) = amplitude*ii;
         nextT = nextT + step;
        end
    end
end
