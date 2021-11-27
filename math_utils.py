import numpy as np

def linFunc(x: float, coefficients: np.array) -> float:
    '''
        y = a*x + b
        
        c1*x + c2*y + c3 = 0
        c2*y = -c1*x - c3
        y = -(1 / c2) * (c1*x + c3)
        a = -c1 / c2
        b = -c3 / c2
    '''

    c1, c2, c3 = coefficients
    a = -(c1 / c2)
    b = -(c3 / c2)
    return a*x + b
