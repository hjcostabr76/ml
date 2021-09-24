import math
import numpy as np

import Adaline

class Perceptron(Adaline):

  def _updateW(self, x: np.array, y: float, yApprox: float) -> tuple:
    '''
      - error: y_i - f(x_i);
      - f(x_i) = Sigmoid Function (activation function);
      - Derivative (gradient descent) = -e*f'(x_i)*x_i
      - w(t + 1) = w(t) + step*e*f'(u_i)*x_i
      - f'(u_i) = f(u_i)*(1 - f(u_i))
    '''

    f_x = 1 / (1 + math.exp(-yApprox))  # Activation Function: Sigmoid Function
    diff = f_x * (1 - f_x)              # Sigmoid Function Derivative
    
    error = y - f_x
    delta = error * diff * x
    self._w += self._step * delta

    return error, self._w