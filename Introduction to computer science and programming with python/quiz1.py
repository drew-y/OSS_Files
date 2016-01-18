def myLog(x, b):
    '''
    x: a positive integer
    b: a positive integer; b >= 2

    returns: log_b(x), or, the logarithm of x relative to a base b.
    '''
    # Your Code Here
    step = 0
    while True:
        nextStep = step + 1
        if (b ** step) == x or (b ** nextStep) > x:
            return step
        else:
            step = nextStep

def lessThan4(aList):
    '''
    aList: a list of strings
    '''
    # Your code here
    newList = []
    for word in aList:
        if len(word) < 4:
            newList.append(word)
    return newList

def sumDigits(N):
    '''
    N: a non-negative integer
    '''
    # Your code here
    if N <= 9:
        return N
    else:
        return N % 10 + sumDigits(N / 10)

def keysWithValue(aDict, target):
    '''
    aDict: a dictionary
    target: an integer
    '''
    # Your code here
    keyList = []
    for key in aDict:
        if aDict[key] == target:
            keyList.append(key)
    keyList.sort()
    return keyList

def f(str):
    return True

def satisfiesF(L):
    """
    Assumes L is a list of strings
    Assume function f is already defined for you and it maps a string to a Boolean
    Mutates L such that it contains all of the strings, s, originally in L such
            that f(s) returns True, and no other elements
    Returns the length of L after mutation
    """
    # Your function implementation here
    i = 0
    oldL = list(L)
    for str in oldL:
        if not f(str):
            L.remove(str)
    return len(L)

