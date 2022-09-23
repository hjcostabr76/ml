import cv2
import numpy as np

class TemplateMatching():
    '''
        TODO: 2021-10-27 - ADD Description
        TODO: 2021-10-27 - Finish implementation
    '''

    __img = np.array([])
    __template = np.array([])
    __correlation = np.array([])

    def __init__(self, imgPath: str, templatePath: str) -> None:
        self.__img = self.__readGrayScaleImg(imgPath)
        self.__template = self.__readGrayScaleImg(templatePath)

    def match(self):
        '''
            TODO: 2021-10-27 - ADD Description
        '''

        self.__correlation = cv2.matchTemplate(self.__img, self.__template, cv2.TM_CCOEFF_NORMED)
        return self

    def getCovarMatrix(self) -> np.array:
        '''
            TODO: 2021-10-27 - ADD Description
        '''
        
        return self.__correlation

    def getImageDimensions(self) -> tuple:
        return self.__img.shape

    def getTemplateDimensions(self) -> tuple:
        return self.__template.shape

    # def drawRectangle(self, topLeft: tuple, bottomRight: tuple):
    #     '''
    #         TODO: 2021-10-27 - ADD Description
    #     '''
        
    #     cv2.rectangle(self.__img, topLeft, bottomRight, (255, 0, 0), 1) 
    #     return self

    def __readGrayScaleImg(self, path: str) -> np.array:
        '''
            TODO: 2021-10-26 - ADD Description
        '''

        imgBgr = cv2.imread(path)
        return np.array(cv2.cvtColor(imgBgr, cv2.COLOR_BGR2GRAY))
