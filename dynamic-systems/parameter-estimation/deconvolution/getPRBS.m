function prbs = getPRBS(sampleSize, n, m, bits);
   %
   %======================================================================
   % 
   % HOW TO CALL:
   % prbs = prbs(sampleSize, n, m)
   % 
   % Generates a PRBS.
   % - For n = 8 the PRBS will not be an m - sequence;
   %
   % PARAMS:
   % - sampleSize: Signal length;
   % - n: Number of bits of the PRBS;
   % - m: Inteval between bits (each value is held during m sampling times);
   %
   % AUTHOR:
   % Luis A. Aguirre - BH 18/10/95 (modified)
   %
   %======================================================================
   %

   %% Set which bit the last bit XOR will be made with;
   j = 1; % For most cases j will be 01 bit before the last

   if n == 5
      j = 2;
   elseif n == 7
      j = 3;
   elseif n == 9
      j = 4;
   elseif n == 10
      j = 3;
   elseif n == 11
      j = 2;
   end

   %% Set PRBS
   prbs = zeros(1, sampleSize);

   if ~exist('bits','var')
      bits = rand(1, n) > 0.5;
    end

   for i = 1:sampleSize / m
      
      % Set 01 piece of the prbs
      firstIdx = m*(i - 1) + 1;
      mRange = firstIdx:m*i;
      prbs(mRange) = bits(n) * ones(1, m);
      
      % Displace bits
      bit1 = prbs(firstIdx);
      bits = [xor(bit1, bits(n - j)) bits(1:n-1)];
   end
end
