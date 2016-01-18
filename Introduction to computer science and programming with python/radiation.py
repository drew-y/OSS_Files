def f(x):
    import math
    return 10*math.e**(math.log(0.5)/5.27 * x)

def radiationExposure(start, stop, step):
    totalExposure = 0
    totalWidth = stop - start
    xPos = start
    for i in range(int(totalWidth / step)):
        height = f(xPos)
        totalExposure += height * step
        xPos += step
    return totalExposure

print radiationExposure(40, 100, 1.5)

