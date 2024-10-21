# figure box,using the package numpy v2.0.0,matplotlib v3.9.0,pandas v1.3.3
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_excel('', engine='openpyxl')

continent_order = ['Europe', 'North America', 'Asia', 'South America', 'Oceania', 'Africa']

continent_colors = {
    'Europe': 'silver',
    'Asia': 'yellow',
    'North America': 'skyblue',
    'Africa': 'orchid',
    'South America': 'greenyellow',
    'Oceania': 'lightsalmon'
}

fig, ax = plt.subplots(figsize=(8, 4))
np.random.seed(0)
jitter_range = 0.2

box_width = 0.2
positions = np.arange(len(continent_order))

for i, continent in enumerate(continent_order):
    subset = df[df[''] == continent]
    subset[''] = subset['']
    ax.boxplot([subset['Percent']], positions=[positions[i]], patch_artist=True,
               boxprops={'facecolor': continent_colors[continent], 'linewidth': 2, },
               medianprops={'color': 'black', 'linewidth': 2},
               flierprops={'marker': '.', 'markerfacecolor': 'white', 'markersize': 0},
               capprops={'color': 'white', 'linewidth': 0},
               whiskerprops={'color': 'black', 'linewidth': 1}
               )

    x = np.random.uniform(positions[i] - jitter_range, positions[i] + jitter_range, size=len(subset))
    ax.scatter(x, subset[''], color=continent_colors[continent], alpha=0.7, s=30)

# China
china_data = df[df['Country'] == 'China']
china_log_median = (china_data['']).median()
ax.scatter(positions[2], china_log_median, color='red', alpha=0.7, s=30, zorder=5)

ax.set_xticks(range(len(continent_order)))
ax.set_xticklabels(continent_order, rotation=45)

ax.set_title('')
ax.set_ylabel('')
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

plt.tight_layout()
plt.show()
