import numpy as np
from scipy.stats import multivariate_normal

class BayesClassifier:

    classParamsDict = dict()
    classes = list()

    def fit(self, X: np.array, Y: np.array):
        '''
            Build dictionary of data of each feature.
        '''
        self.classes = np.unique(Y)

        for _class in self.classes:
            values = X[ Y == _class ]
            count = values.shape[0]

            self.classParamsDict[_class] = {
                'values': values,
                'count': count,
                'priorProb': count / X.shape[0],
                'mu': np.mean(a=values, axis=0),
                'cov': np.cov(values.T),
            }
        
        return self


    def predict(self, X: np.array) -> int:
        '''
            Predict labels for input data after classifier being fitted.
        '''

        likelihoods = np.zeros(X.shape)
        for j, jClass in enumerate(self.classParamsDict.values()):
            cLikelihood = lambda x: jClass.get('priorProb') * multivariate_normal.pdf(x, jClass.get('mu'), jClass.get('cov'))
            likelihoods[:, j] = cLikelihood(X)
        
        aux = lambda i: self.classes[i]
        return aux(np.argmax(a=likelihoods, axis=1))
