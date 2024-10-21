# figure plot,using the package numpy v2.0.0,matplotlib v3.9.0,pandas v1.3.3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_excel('')
df = df[(df[''] > 0) & (df[''] > 0)]

df[''] = np.log10(df[''])  # count
df[''] = np.log10(df[''])  # median

plt.figure(figsize=(8, 4))

china_data = df[df[''] == 'China']  # China
plt.scatter(china_data[''], china_data[''], c='r', marker='.', label='')  # China

Europe_data = df[df[')'] == 'Europe']
plt.scatter(Europe_data[''], Europe_data[''], c='silver', marker='.', label='Europe')

Africa_data = df[df[''] == 'Africa']
plt.scatter(Africa_data[''], Africa_data[''], c='orchid', marker='.', label='Africa')

North_America_data = df[df[''] == 'North America']
plt.scatter(North_America_data[''], North_America_data[''], c='skyblue', marker='.', label='North America')

South_America_data = df[df[''] == 'South America']
plt.scatter(South_America_data[''], South_America_data[''], c='greenyellow', marker='.', label='South America')

Oceania_data = df[df[''] == 'Oceania']
plt.scatter(Oceania_data[''], Oceania_data[''], c='lightsalmon', marker='.', label='Oceania')

Asia_data = df[df[''] == 'Asia']
plt.scatter(Asia_data[''], Asia_data[''], c='yellow', marker='.', label='Asia')

china_data = df[df[''] == 'China']
plt.scatter(china_data[''], china_data[''], c='red', marker='.', label='_nolegend_')

plt.xlim(min(df[''].min(), 1), max(df[''].max(), 3))
plt.ylim(min(df[''].min(), 0), max(df[''].max(), 6))

plt.xlabel('')
plt.ylabel('')

plt.xlim(0, 3)
plt.xticks(np.arange(0, 3.5, 0.5))

plt.ylim(0, 7)
plt.yticks(np.arange(0, 7.5, 1))

plt.title('')

plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

plt.legend(bbox_to_anchor=(1.02, 1), loc=2, borderaxespad=0.5)
plt.show()
plt.close()
