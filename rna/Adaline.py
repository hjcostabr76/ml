import numpy as np

from random import uniform

class Adaline():

  _maxIterations: int = 100
  _tolerance = .1
  _step = .1

  _errorHistory = np.array([])
  
  _X = np.array([])
  _Y = np.array([])
  _w = np.array([])

  def __init__(self,
              X: np.array, Y: np.array,
              step = .1, tolerance = .1, maxIterations = 100,
              minW = -1, maxW = 1, w: np.array = None,
              ):  

    self._maxIterations = maxIterations
    self._tolerance = tolerance
    self._step = step

    self._Y = Y
    self._X = X
    self._w = w if w else Adaline.getRandomW(np.size(X, 1) + 1, False, minW, maxW)

  @staticmethod
  def getRandomW(nRows: int, shouldTranspose: bool = False, min: float = -1, max: float = 1) -> np.array:
    '''
    Generates & return a random column vector of weights constrained inside the
    range from minW and maxW.
    '''

    randomW = []
    for _ in range(0, nRows):
      randomValue = uniform(min, max)
      randomW = np.append(randomW, randomValue)
    return randomW if (not shouldTranspose) else np.transpose([randomW])

  def train(self) -> np.array:
    '''
    Generates the best vector of weights (W) to approximate the coeficients of the
    linear function under analysis.
    '''
    
    sampleSize = np.size(self._X, 0) # How many entries for training
    avgSquaredErr = self._tolerance + self._step
    count = 0
    
    while (avgSquaredErr > self._tolerance and count < self._maxIterations):

      randomLines = np.arange(len(self._X))
      np.random.shuffle(randomLines)

      squaredErr = 0

      for i in randomLines:
        gradient, error = self._getWGradient(self._X[i], self._Y[i])
        self._w += self._step * gradient
        squaredErr += error**2
      
      avgSquaredErr = squaredErr / sampleSize
      self._errorHistory = np.append(self._errorHistory, avgSquaredErr)
      count += 1
    
    return self._w

  def getPrediction(self, x: np.array) -> float:
    return self._activationFunction(self.getApproximation(x))

  def getApproximation(self, x: np.array) -> float:
    '''
        TODO: 2021-09-23 - ADD Description
    '''
    
    # Validate
    xExtended = np.append(x, 1)
    xShape = np.shape(xExtended)
    wShape = np.shape(self._w)
    if xShape != wShape:
      raise ValueError('x vector and w vector must have the same shape. ' + str(xShape) + ' and ' + str(wShape) + ' received.')
    
    # Approximate
    return np.dot(xExtended, self._w)

  def getW(self) -> np.array:
    return self._w

  def getErrorHistory(self) -> np.array:
    return self._errorHistory

  def _getWGradient(self, x: np.array, y: float) -> 'tuple[float, float]':
    '''
        Set and return the gradient for the w weights vector.
    '''
    
    error = y - self.getPrediction(x)
    gradient = error * np.append(x, 1)
    return gradient, error

  def _activationFunction(self, yApprox: float) -> float:
    '''
        Activation Function: Identity Function
    '''

    return yApprox
