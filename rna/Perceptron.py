import numpy as np
from Adaline import Adaline

ACT_FUN_STEP = 'step'
ACT_FUN_SIG = 'sigmoid'

class Perceptron(Adaline):

  __actvFuncID: str

  def __init__(self,
              X: np.array, Y: np.array,
              step = .1, tolerance = .1, maxIterations = 100,
              minW = -1, maxW = 1, w: np.array = None,
              actvFunc: str = ACT_FUN_STEP,
              ):

    super().__init__(
              X=X, Y=Y,
              step = step, tolerance = tolerance, maxIterations = maxIterations,
              minW = minW, maxW = maxW, w = w,
              )

    self.__actvFuncID = self.__getValidActFunc(actvFunc)

  def _activationFunction(self, x: float) -> float:
    actFuncID = self.__getValidActFunc()
    if actFuncID == ACT_FUN_SIG:
      return self.__sigmoid(x)
    if actFuncID == ACT_FUN_STEP:
      return self.__step(x)

  def _getWGradient(self, x: np.array, y: float) -> 'tuple[float, float]':
    '''
        TODO: 2021-09-25 - ADD Description
    '''

    dotProduct = self.getApproximation(x)
    diff = self.__getActivFuncDiff(dotProduct)
    prediction = self.getPrediction(x)
    error = y - prediction
    gradient = error * diff * np.append(x, 1)
    return gradient, error


  def __getActivFuncDiff(self, x: float) -> float:
    '''
        TODO: 2021-09-25 - ADD Description
    '''

    actFuncID = self.__getValidActFunc()
    if actFuncID == ACT_FUN_SIG:
      return self.__getActvFuncDiffWithSigmoid(x)
    if actFuncID == ACT_FUN_STEP:
      return self.__getActvFuncDiffWithStep(x)

  def __sigmoid(self, x: float) -> float:
    '''
      Activation function: Sigmoid Function
    '''

    return 1.0 / (1.0 + np.exp(-x))

  def __step(self, x: float) -> float:
    '''
      Activation function: Funcao Degrau
    '''
    
    return 1 if (x > 0) else 0

  def __getActvFuncDiffWithSigmoid(self, x: float) -> float:
    '''
      - Derivative of the Sigmoid Function:
      - f'(u_i) = f(u_i)*(1 - f(u_i))

        TODO: 2021-09-25 - Figure out why the definition equation isn't working (ut only converges without multiplying per diff)
    '''
    return 1
    # actFunction = self._activationFunction(x)
    # return actFunction * (1 - actFunction)

  def __getActvFuncDiffWithStep(self, x: float) -> float:
    '''
        TODO: 2021-09-25 - ADD Description
    '''
    
    return 1

  def __getValidActFunc(self, actvFuncID: str = None) -> str:
    actvFuncID = actvFuncID if (actvFuncID) else self.__actvFuncID
    if (actvFuncID not in [ACT_FUN_STEP, ACT_FUN_SIG]):
      raise ValueError('"' + str(actvFuncID) + '" is not valid as an activation function ID')
    return actvFuncID
