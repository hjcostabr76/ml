import numpy as np
import pandas as pd

from typing import Callable

def normalize(arr: np.array) -> np.array:
    '''
        TODO: 2022-02-22 - ADD Description
    '''
    
    diff = np.max(arr) - arr
    delta = np.max(arr) - np.min(arr)
    prob = 1 - (diff / delta)
    return prob / np.sum(prob)

def roulette(members: np.array, dbg = False) -> int:
    '''
        Returns the index of a random selected member through turning the wheel of a roulette.
        - The greater the value of a member the bigger the probability of it being selected;
        - A random number is generated simulating a point in the wheel of a roulette;
        - The first member whose accumulated probability range fits the selected point is the winner;

        PARAMS
        - members: Should be an array of numbers
    '''

    m1 = members[0]
    equals, = np.where(members == m1)
    
    areAllEqual = len(equals) == len(members)
    if areAllEqual:
        shares = None
    else:
        shares = normalize(members)

    idx, = np.where(members == np.random.choice(a=members, p=shares))
    return idx[0]



class Genetic:

    def __init__(self,
        initPopulation: np.array, fitFunc: Callable[[np.array], float],
        crossoverProb: float, mutationProb: float,
        nOffspring: int, nElite: int, nGenerations: int,
    ):
        self.nPopulation, self.nGenes = initPopulation.shape
        self.population = initPopulation
        
        self.nElite = nElite
        self.nOffspring = nOffspring
        self.nGenerations = nGenerations
        
        self.fitFunc = fitFunc
        self.mutationProb = mutationProb
        self.crossoverProb = crossoverProb
    
    def evolve(self) -> tuple:
        '''
            TODO: 2022-02-21 - Rename
            TODO: 2022-02-21 - ADD Description
        '''

        evolution = np.zeros( (self.nGenerations, ) )
        bestSolution = -np.inf
        bestGeneration = np.zeros( (self.nPopulation) )

        for i in range(self.nGenerations):
            prev = self.population
            self.population = self.__getNewGeneration(self.population)
            fits = self.__getFits(generation=self.population, sort=True)
            best = fits[0]
            if (best > bestSolution):
                bestGeneration = self.population
            evolution[i] = fits[0]

        return bestGeneration, evolution

    def __getNewGeneration(self, generation: np.array) -> np.array:
        '''
            TODO: 2022-02-22 - ADD Description
        '''

        # Variation
        mutants = self.__getRecombined(generation)
        mutants = self.__getMutants(mutants)

        # Natural selection
        parents = self.__getParents(mutants)
        survivals = self.__getSurvivals(parents)
        return survivals

    def __getRecombined(self, generation: np.array) -> np.array:
        '''
            TODO: 2022-02-22 - ADD Description
        '''
        
        mutants = np.copy(generation)

        for i in range(1, len(mutants), 2):
            child1, child2 = self.__crossover(generation[i - 1], generation[i])
            mutants[i - 1] = child1
            mutants[i] = child2
        
        return mutants

    def __getMutants(self, generation: np.array) -> np.array:
        '''
            TODO: 2022-02-22 - ADD Description
        '''

        mutants = np.copy(generation)
        for i in range(len(mutants)):
            if np.random.rand() > self.mutationProb:
                mutants[i] = np.logical_not(mutants[i]) # Bit flip

        return mutants

    def __getParents(self, generation: np.array) -> np.array:
        '''
            TODO: 2022-02-21 - ADD Description
        '''

        population = np.concatenate( (generation, self.population) )
        fits = self.__getFits(population)
        
        nParents = self.nOffspring
        parents = np.zeros( (nParents, self.nGenes) )

        # Assure best parents are always preserved
        elite, population, fits = self.__getBestNIndividuals(n=self.nElite, generation=population, fits=fits)
        parents[:self.nElite, :] = elite

        # Select other random parents
        selected, _, _ = self.__getBestNIndividuals(n=nParents - self.nElite, generation=population, fits=fits, testFunc=roulette)
        parents[self.nElite:, :] = selected

        return parents

    def __getSurvivals(self, generation: np.array) -> np.array:
        '''
            TODO: 2022-02-22 - ADD Description
            TODO: 2022-02-22 - Finish implementation
        '''
        return generation

        # if self.nOffspring == self.nPopulation:
        #     return generation # Replace the whole generation

        # survivals = np.zeros( (self.nPopulation, self.nGenes) )
        
        # # Replace with best new individuals
        # newFits = self.__getFits(generation=generation)
        # offspring, _, _ = self.__getBestNIndividuals(n=self.nOffspring, generation=generation, fits=newFits)
        # survivals[:self.nOffspring, :] = offspring

        # # Keep some of the best current individuals
        # currentFits = self.__getFits(generation=self.population)
        # nRemaining = self.nPopulation - self.nOffspring
        # elders, _, _ = self.__getBestNIndividuals(n=nRemaining, generation=self.population, fits=currentFits)
        # survivals[self.nOffspring:, :] = elders

        # return survivals

    def __crossover(self, parent1: np.array, parent2: np.array) -> tuple:
        '''
            TODO: 2022-02-22 - ADD Description
        '''

        willRecombine = np.random.rand() > self.crossoverProb
        if not willRecombine:
            return parent1, parent2

        mid = int(np.floor(self.nGenes / 2))
        
        child1 = np.concatenate( (parent1[:mid], parent2[mid:]) )
        child2 = np.concatenate( (parent2[:mid], parent1[mid:]) )
        return child1, child2

    def __getFits(self, generation: np.array, sort = False) -> np.array:
        '''
            TODO: 2022-02-22 - ADD Description
        '''

        fits = np.apply_along_axis(self.fitFunc, arr=generation, axis=1)
        if sort:
            fits = -np.sort(-fits) # Sort Descending
        return fits

    def __getBestNIndividuals(self, n: int, generation: np.array, fits: np.array, testFunc: Callable[[np.array], bool] = np.argmax) -> tuple:
        '''
            TODO: 2022-02-22 - ADD Description
        '''

        _fits = np.copy(fits)
        _generation = np.copy(generation)

        best = np.zeros( (n, self.nGenes) )
        for i in range(n):
            idx = testFunc(_fits)
            best[i, :] = _generation[idx]
            _fits = np.delete(_fits, idx, axis=0)
            _generation = np.delete(_generation, idx, axis=0)
        
        return best, _generation, _fits




capacity = 35
weights = np.array([10, 18, 12, 14, 13, 11, 8, 6])
values = np.array([5, 8, 7, 6, 9, 5, 4, 3])

nElite = 2
nGenes = len(weights)
nOffspring = 8
nPopulation = 10
nGenerations = 1000

mutationProb = .05
crossoverProb = .6

initPopulation = np.random.randint(low=0, high=2, size=(nPopulation, nGenes))

def fitnessFunction(individual: np.array) -> float:
    '''
        TODO: 2022-02-21 - ADD Description
    '''

    benefit = np.sum(individual * values)
    totalWeight = np.sum(individual * weights)
    
    if totalWeight <= capacity: # Solution is OK
        return benefit

    # Solution is heavier then maximum capacity
    rho = np.max(values / weights) # Penalization factor
    penalties = [(w - capacity) for w in weights] # Penalties for each item
    penalty = rho * np.fabs(sum(penalties))

    return benefit - penalty


# print(f'initPopulation: {initPopulation}')
print(f'initFit: {np.apply_along_axis(fitnessFunction, arr=initPopulation, axis=1)}')

genetic = Genetic(
    initPopulation=initPopulation,
    fitFunc=fitnessFunction,
    nElite=nElite,
    nOffspring=nOffspring,
    nGenerations=nGenerations,
    crossoverProb=crossoverProb,
    mutationProb=mutationProb,
)

bestGeneration, evolution = genetic.evolve()
print(f'evolution: {evolution}')
print(f'bestGeneration: {bestGeneration}')
print(f'bestFit: {np.min(np.apply_along_axis(fitnessFunction, arr=bestGeneration, axis=1))}')

# foo = np.array([1, 3, 5, 7])
# idx = np.array([1, 3])

# foo = np.array([-102.15384615,   16.,         -109.15384615,  -97.15384615, -110.15384615,
#  -108.15384615,  -97.15384615, -106.15384615])

# initPopulation[2]