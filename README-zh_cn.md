# **covid19-genome-sharing-analysis**

该项目存储了对GISAID数据库的数据处理过程及使用代码，关于具体的研究细节与结论请参考以下文章

**Trends and Impacts of SARS-CoV-2 Genome Sharing: A Comparative Analysis of China and the Global Community, 2020-2023**
Yenan Feng, Songqi Chen, Anqi Wang, Zhongfu Zhao, Cao Chen(Correspondence)

**[论文地址]**

## 目录
1. [软件环境与数据预处理](#软件环境与数据预处理)
2. [统计分析代码](#统计分析代码)
3. [图形图片绘制](#图形图片绘制)

## 软件环境与数据预处理

### 软件环境

本项目代码在Win11、Docker Desktop v4.28.0 (139021)、Docker Engine v25.0.3、Mysql v8.3.0、DataGrip 2023.3.4、conda 24.3.0、Python 3.11.8运行产生结果

### 数据下载与预处理

1. 访问[GISAID官方网站](https://gisaid.org/)，点击右上角 `Login` 按钮登陆。随后选择 `EpiCoV™ - Downloads`，在弹出的窗口中**Download packages** 分类下找到 `metadata` 并点击下载
   注意：修稿在进行代码梳理时，使用相同的代码用20241007日提取到的数据源对20240401提取的数据源进行复核，发现总数据量的增加，猜测GISAID存在数据未及时释放情况。即2024年4月至10月之间，释放了多个国家和地区于2020至2023年上报的数据。且下载得到的metadata中未标出数据审核通过和释放的时间，因此在进行复现时，请尽可能使用20241007版本数据源进行测试。如无法确保一致，则可能在少数国家发生数据总量不同的问题，但其数量较小不会对结果产生显著影响。
2. 部署Mysql 8+版本（本文中通过Docker容器完成部署搭建），随后链接并创建数据库
3. 使用DataGrip或者其他数据库操作管理程序将下载到的两个数据库tsv或csv文件作为数据源导入到数据库中，尽可能保留列名为原始名称不变（由于数据量较大此处耗时较长，可能需要10分钟甚至更长时间）
   注意：导入过程中可能由于部分记录的AA Substitutions字段长度过长，超过mysql数据库text类型的最大长度限制导致导入失败（在研究时遇到两条记录）。由于AA Substitutions不在本次文章的讨论范围内，将在下一步预处理时替换该部分内容，并通过sql语句手动插入导入失败的记录。请根据您运行时的错误反馈，参考本方法对导入失败的数据进行处理。
4. 导入完毕后，得到表metadata_gisaid，随后运行项目中preprocess文件夹内sql文件中的代码，对数据进行预处理。各预处理步骤的具体意义详见代码注释。

## 统计分析代码

1. 完成环境部署、数据下载与预处理（[软件环境与数据预处理](#软件环境与数据预处理)）
2. 根据图表编号切换到对应的analysis目录下对应文件夹中，并打开sql文件。
3. 详细的执行步骤及代码在sql文件中，请根据文件内注释进行操作。如无sql文件，则打开python文件按照注释操作。

## 图形图片绘制

完成数据分析后，将结果导出为excel或csv等格式文件，随后切换到 visualization 文件夹中并执行对应python代码段。代码所需的依赖包及说明见文件注释。

## License
Licensed under an MIT license.

