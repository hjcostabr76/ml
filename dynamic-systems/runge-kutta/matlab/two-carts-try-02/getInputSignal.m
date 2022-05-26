function input = getInputSignal(amplitude, tBegin, tEnd, signalType)
    %
    %======================================================================
    %
    % Generate input signals for testing
    % - amplitude: tEnd final
    % - tBegin: tEnd inicial
    % - tEnd: tEnd final
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
    
    input = zeros(tEnd, 1);
    nextT = tBegin + 1;
    step = 10;
    smallStep = round((tEnd - nextT - 1) / 10) - 1;
    
    % Step
    if signalType == SIGN_T_STEP
        input(nextT:tEnd, 1) = amplitude;
        
    % Pulse
    elseif signalType == SIGN_T_PULSE
        input(nextT, 1) = amplitude;
    
    % Pulse (longer)
    elseif signalType == SIGN_T_PULSE_LONGER
        input(nextT:nextT+step, 1) = amplitude;
           
    % 02 pulses
    elseif signalType == SIGN_T_PULSES
        for ii = 1:2
            input(nextT:nextT+smallStep, 1) = amplitude;
            nextT = nextT + 2*smallStep;
        end
    
    % Sine
    elseif signalType == SIGN_T_SINE
           f = 0.0075;
           for ii = 1:tEnd-nextT
               input(nextT + ii) = amplitude*sin(2*pi*f*ii);
           end
    % Random
    elseif signalType == SIGN_T_RANDOM
        for ii = nextT:tEnd
            input(ii,1) = amplitude*rand;
        end
    
    % Increasing steps
    elseif signalType == SIGN_T_INCREASING_STEPS
        for ii = 1:5
         input(nextT:nextT+step, 1) = amplitude*ii;
         nextT = nextT + step;
        end
    end
end