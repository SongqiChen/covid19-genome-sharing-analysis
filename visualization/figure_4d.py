# figure male vs female,using the package numpy v2.0.0,matplotlib v3.9.0
import numpy as np
import matplotlib.pyplot as plt
from pylab import *

mpl.rcParams['font.sans-serif'] = ['SimHei']

x = np.array([])  # male
y = np.array([])  # female

plt.figure(figsize=(12, 8))
plt.barh(range(len(y)), -x, color='darkorange', label='male')
plt.barh(range(len(x)), y, color='limegreen', label='female')

plt.xlim(())
plt.xticks((), ())
plt.yticks((), ())

plt.xlabel('')

plt.legend()
plt.show()
