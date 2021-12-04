import random
import math

from numpy import linalg as LA
import numpy as np

class FuzzyCMeans:
    '''
        Fuzzy C Means clustering algorithm raw implementation using numpy only.
    '''

    __k: int
    __m: float
    __maxDelta: float
    __maxEpochs: int
    __X: np.array

    __U: np.array
    __obj: float
    __centroids: np.array

    def __init__(self, X: np.array, k: int, m: float, maxDelta=.001, maxEpochs=1000, useDistributedInit=True) -> object:

        if (maxDelta <= 0 or maxDelta > 1):
            raise ValueError('"maxDelta" should be a positive float minor then 1')
        if (maxEpochs <= 0):
            raise ValueError('"maxEpochs" should be a positive integer')

        self.__X = X
        self.__k = k
        self.__m = m
        self.__maxDelta = maxDelta
        self.__maxEpochs = maxEpochs

        self.__setInitialPartition(useDistributedInit=useDistributedInit)
        self.__setCentroids()
        self.__objFunction()
    
    def __setInitialPartition(self, useDistributedInit) -> None:
        
        n = self.__X.shape[0]
        self.__U = np.zeros( (n, self.__k) )
        
        # Initialize U with distribution
        if useDistributedInit:
            self.__U = np.apply_along_axis(lambda _: FuzzyCMeans.__getNumbersSummingToOne(self.__k), 1, self.__U)
            return
        
        # Initialize U with discrete values
        for i in range(n):
            c = random.randint(0, self.__k - 1)
            self.__U[i, c] = 1

    def getPartition(self) -> np.array:
        return self.__U

    def getCentroids(self) -> np.array:
        return self.__centroids

    def fit(self) -> object:
        delta = math.inf
        epoch = 0

        while delta > self.__maxDelta and epoch < self.__maxEpochs:
            epoch = epoch + 1
            prevObj = self.__obj
            
            self.__setCentroids()
            self.__setPartitionMatrix()
            self.__objFunction()
            
            delta = math.fabs((self.__obj - prevObj) / prevObj)

        return self

    def __setCentroids(self) -> None:
        '''
            Determines the coordinates of all k centroids.
        '''

        n, dimension = self.__X.shape
        centroids = np.zeros( (self.__k, dimension) )
        for j in range(self.__k):
            uColumn = self.__U[:, j].reshape( (n, 1) )
            centroids[j, :] = self.__getOneCentroid(uColumn=uColumn)
        self.__centroids = centroids

    def __setPartitionMatrix(self) -> None:
        '''
            Determines the matrix that holds the membership of each i-th point to each j-th centroid.
        '''
        
        # Matrix of distances of each point related to each centroid
        distances = np.apply_along_axis(lambda x: self.__getDistances(point=x), 1, self.__X)

        # Build U: Partition matrix
        distancesSum = distances.sum(axis=0)
        self.__U = np.apply_along_axis(lambda x: self.__getPartition(distances=x, distancesSum=distancesSum), 1, distances)
    
    def __objFunction(self) -> float:
        '''
            Determines the objective measure which should be minimized in order to improve the partition matrix.
            It might be interpreted as something like a weighted sum of distances between points and centroids;
        '''

        obj = 0
        for j in range(self.__k):
            c = self.__centroids[j, :]
            uColumn = np.power(self.__U[:, j], self.__m)
            distances = np.apply_along_axis(lambda x: LA.norm(x - c)**2, 1, self.__X)
            obj += np.dot(uColumn, distances)
        self.__obj = obj

    def __getDistances(self, point: np.array) -> np.array:
        '''
            Returns the distances of 01 i-th point to each of the k centroids.
        '''

        distances = np.zeros(self.__k)
        for j in range(self.__k):
            distances[j] = LA.norm(point - self.__centroids[j, :])
        return distances

    def __getPartition(self, distances: np.array, distancesSum: np.array) -> np.array:
        '''
            Returns the pertinence of 01 i-th point to each of the k centroids (they all must sum to 01).
            - distances: Distances of this i-th point to each of the k centroids;
            - distancesSum: Sum of all distances of all points to each of the k centroids;
        '''
        
        exp = 2 / (self.__m - 1)
        pertinence = lambda dist, sum: 1 / (dist / sum)**exp
        
        P = np.zeros(self.__k)
        for j, dist in enumerate(distances):
            P[j] = pertinence(dist, distancesSum[j])
        return P / np.sum(P)

    def __getOneCentroid(self, uColumn: np.array) -> np.array:
        '''
            Returns the coordinates of 01 of the k centroids.
            - uColumn: 01 k-th column from partition matrix;
        '''

        poweredU = np.power(uColumn, self.__m)
        weightedX = poweredU * self.__X
        dimension = self.__X.shape[1]
        c = np.zeros(dimension)
        for j in range(dimension):
            c[j] = weightedX[:, j].sum() / poweredU.sum()
        return c

    @staticmethod
    def __getNumbersSummingToOne(n: int) -> list:
        '''
            Returns a list of n floats summing to 01.
        '''

        r = [random.random() for i in range(0, n)]
        randomSum = sum(r)
        return [ i / randomSum for i in r ]
