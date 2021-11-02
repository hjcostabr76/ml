import numpy as np

from matplotlib import pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator

'''
    TODO: 2021-11-02 - Learn how to place it in a parent folder
'''

def plot3dSurface(
        fig, axis,
        z: np.array,
        x: np.array = None, y: np.array = None,
        shouldCreateMesh: bool = True,
        position = (),
        title: str = None,
    ):
    '''
        TODO: 2021-10-27 - ADD Description
        TODO: 2021-10-27 - ADD surface title
    '''

    # Set surface mesh
    if shouldCreateMesh:
        meshGrid = np.meshgrid(x, y)
        x, y = meshGrid

    # Create surface
    surf = axis.plot_surface(x, y, z, cmap=cm.Reds)
    fig.colorbar(surf, aspect=5, shrink=.5, ax=axis)

    # axis.set_zlim(-1.01, 1.01)
    axis.zaxis.set_major_locator(LinearLocator(10)) # Alters the grid visible scale
    axis.zaxis.set_major_formatter('{x:.02f}')
    
    if title != None:
        axis.set_title(title)
    
    # Customize position
    if len(position):
        azim, elev, dist = position
        axis.azim = azim
        axis.elev = elev
        axis.dist = dist

def plot3dSurfacesGrid(
        surfaces: np.array,
        gridCols = 1,
        colHeight = 5, colWidth = 5,
        positions = [],
    ) -> None:
    '''
        TODO: 2021-10-27 - Finish Description
        
        About surface positions:

        - Azimuth: Rotation around the z axis;
        - Elev(ation)?: Angle between the eye and the xy plane;
        - Distance: Distance to the center of the surface space;

        Thanks to: https://stackoverflow.com/a/64849390/5959978
    '''
    
    # Build grid
    gridRows = len(surfaces)
    figHeight = gridRows * colHeight
    figWidth = gridCols * colWidth
    fig, axes = plt.subplots(subplot_kw={"projection": "3d"}, nrows=gridRows, ncols=gridCols, figsize=(figWidth, figHeight))

    # Plot surfaces
    for surfaceNumber in range(0, gridRows):
        for axisNumber in range(0, gridCols):
            x, y, z, shouldCreateMesh, title = surfaces[surfaceNumber]
            a = axes[surfaceNumber, axisNumber] if gridRows > 1 else axes[axisNumber]
            position = positions[axisNumber] if (len(positions) >= axisNumber) else ()
            plot3dSurface(fig=fig, axis=a, x=x, y=y, z=z, position=position, shouldCreateMesh=shouldCreateMesh, title=title)
    
    plt.show()
