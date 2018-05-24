<h1 align = "center">Predicting the House Prices</h1>
<div align = "center">MF1721023 张煜东</div>
<br></br>

> &emsp;&emsp;学期已经过去大半, 通过这几个月的学习, 我对于统计分析的理解变得更加深刻. 但俗话说读万卷书, 行万里路. 课本上的知识多半只是理论方面的描述和推导, 对于实际的应用还是存在很大的欠缺. 所以我尝试这通过一些统计分析或者机器学习的项目, 在实践中巩固学习. 在具体的实践, 我主要参考的是`Kaggle`这个网站上的一些入门项目. 这篇文章中我将要完成的是`House Prices`, 一个房价预测项目. 另外, 分析工具为`python3`.

![pic1](./pictures/cartoon1.png)

> &emsp;&emsp;如果我们询问一个买房者他们对于房子特征优先级的排名, 他们可能不会从地下室高度或者离某条主干道的距离这些开始谈论. 但是通过这个项目的分析, 我们明确地发现了买房者确实会对这些问题投入更多的关注, 相较来说他们反而对卧室数量, 有没有装修过关注较少. `House Prices`提供的数据集有`79`列, 几乎涵盖了一个房子的所有特征, 我们需要利用训练集的数据训练一个预测模型, 然后用于测试集的预测. 接下来正式开始!

> &emsp;&emsp;首先是数据预处理部分. 在数据分析的学习中, 我曾经看到很多人这样描述数据预处理步骤:"`数据分析所消耗的时间往往有七成都在处理数据.`" 可见数据预处理(特征提取)的重要性. 本文的数据预处理主要分为下面五个部分:
+ `补全缺失值` 
+ `变换` 将部分数值变量转变成分类变量
+ `解析标签` 部分标签中隐含重要信息
+ `Box Cox变换`
+ `分类变量虚拟化`

```python
# import some necessary libraries
import numpy as np
import pandas as pd
pd.set_option('display.float_format', lambda x: '{: .3f}'.format(x))

%matplotlib inline
import matplotlib.pyplot as plt
import seaborn as sns
color = sns.color_palette()
sns.set_style('darkgrid')

from scipy import stats
from scipy.stats import norm, skew
```
> &emsp;&emsp;这里导入的是`python`中的一些模块以及一些常用的设置, 这些都是数据分析项目常用的工具. 包含了一部分数据预处理的工具集和图形绘制工具. 

```python
# train = pd.read_csv('/home/zhangyd/Data/HousePrices/train.csv')
# test = pd.read_csv('/home/zhangyd/Data/HousePrices/test.csv')
train = pd.read_csv('D:/Data/Kaggle/HousePrices/train.csv')
test = pd.read_csv('D:/Data/Kaggle/HousePrices/test.csv')
```
> &emsp;&emsp;以上分别是`Linux`系统和`Windows`系统导入数据的代码. 因为这个项目用到了一些最近比较流行的模型工具, 如`XGBoost`, 这个工具在`Windows`中比较难安装, 所以完整的实现还是需要在`Linux`中进行.

> &emsp;&emsp;输出训练集的前5行数据
```python
train.head()
```
![train_head](./pictures/train_head.png)

> &emsp;&emsp;输出测试集的前5行数据
```python
test.head()
```
![test_head](./pictures/test_head.png)

> &emsp;&emsp;通过比较我们可以发现, 训练集和测试集的数据唯一的不同就是训练集提供了`SalePrice`这一列. 我们的目的就是利用其他数据训练一个回归模型, 用于预测`SalePrice`. 使得定义的误差最小.

```python
# 输出数据维度
print('The train data size before dropping Id feature is : {}'.format(train.shape))
print('The test data size before dropping Id feature is : {}'.format(test.shape))

train_ID = train['Id']
test_ID = test['Id']

# 删除Id列
train.drop('Id', axis=1, inplace=True)
test.drop('Id', axis=1, inplace=True)

# 删除了Id列之后的数据维度
print('\nThe train data size after dropping Id feature is : {}'.format(train.shape))
print('The test data size after dropping Id feature is : {}'.format(test.shape))
```
```
The train data size before dropping Id feature is : (1460, 81)
The test data size before dropping Id feature is : (1459, 80)

The train data size after dropping Id feature is : (1460, 80)
The test data size after dropping Id feature is : (1459, 79)
```

> &emsp;&emsp;我们首先要做的是检查数据中的异常点.
```python
fig, ax = plt.subplots()
ax.scatter(x=train['GrLivArea'], y=train['SalePrice'])
plt.ylabel('SalePrice', fontsize=13)
plt.xlabel('GrLivArea', fontsize=13)
plt.show()
```
![Outliers](./pictures/Outliers.png)
> &emsp;&emsp;我们注意到在右下角, `GrLivArea`这个描述房屋面积之一的指标特别大, 但是相对应的价格`SalePrice`却特别低, 我们认为这两个点是不正常的, 应该去除.

```python
# deleting outliers
train = train.drop(train[(train['GrLivArea'] > 4000) & (train['SalePrice'] < 300000)].index)

# check the graphic again
fig, ax = plt.subplots()
ax.scatter(train['GrLivArea'], train['SalePrice'])
plt.ylabel('SalePrice', fontsize=13)
plt.xlabel('GrLivArea', fontsize=13)
plt.show()
```
![Outliers2](./pictures/Outliers2.png)
> &emsp;&emsp;从`python`代码中我们可以看出来, 我们把`GrLivArea`大于`4000`且`SalePrice`小于`300000`的数据点移除了. 之后绘制出来的散点图大致存在一个递增的趋势.

> &emsp;&emsp;我在查阅资料的同时, 注意到许多人提及异常点的问题. 在大部分情况下, 移除异常点是安全的. 这些房价数据基本来自同一地区的房地产市场, 而这两个数据点代表的面积很大但是出售价格极低的数据显然是不正常的, 因此我们将它们去除. 在不同的场景下, 去除异常点都需要经过充分考虑. 另一方面, 虽然这些异常点很不合寻常, 但是由于测试集中也可能存在这样的点, 如果我们在训练集中将这部分的点全部去掉了, 那么我们在测试集中对于类似的点的估计偏差就会很大, 这也是一个问题. 如果我们能通过特征提取, 找到这些不同寻常的点出现的原因, 那就是最好的情况了.

> &emsp;&emsp;接下来我们来看看应变量`SalePrice`的一些特征.
```python
sns.distplot(train['SalePrice'], fit=norm)

# Get the fitted parameters used by the function
(mu, sigma) = norm.fit(train['SalePrice'])
print('\n mu = {: .2f} and sigma = {: .2f}\n'.format(mu, sigma))

# now plot the distribution
plt.legend(['Normal dist. ($\mu=$ {: .2f} and $\sigma=$ {: .2f} )'.format(mu, sigma)], loc='best')
plt.ylabel('Frequency')
plt.title('SalePrice distribution')

# Get also the QQ-plot
fig = plt.figure()
res = stats.probplot(train['SalePrice'], plot=plt)
plt.show()
```
$\mu =  180932.92$ and $\sigma =  79467.79$

![distribution1](./pictures/distribution1.png)
![distribution2](./pictures/distribution2.png)
> &emsp;&emsp;我们尝试用正态分布去拟合`SalePrice`的直方图. 并绘制了QQ图去看`SalePrice`对正态分布的拟合情况. 结果是显然的, 对`SalePrice`的拟合曲线并不能很好地接近正态分布的曲线. 拟合曲线存在右偏的情况, QQ图也不能拟合一条直线. 因此我们需要对`SalePrice`做一些变换. 

```python
# we use the numpy function loglp which applies log(1+x) to all elements of the column
train['SalePrice'] = np.log1p(train['SalePrice'])

# check the new distribution
sns.distplot(train['SalePrice'], fit=norm)

# get the fitted parameters used by the function
(mu, sigma) = norm.fit(train['SalePrice'])
print('\n mu = {: .2f} and sigma = {: .2f}\n'.format(mu, sigma))

# now plot the distribution
plt.legend(['Normal dist. ($\mu=$ {: .2f} and $\sigma=$ {: .2f})'.format(mu, sigma)], loc='best')
plt.ylabel('Frequency')
plt.title('SalePrice distribution')

# get also the QQ-plot
fig = plt.figure()
res = stats.probplot(train['SalePrice'], plot=plt)
plt.show()
```
$\mu =  12.02$ and $\sigma =  0.40$

![distribution3](./pictures/distribution3.png)
![distribution4](./pictures/distribution4.png)
> &emsp;&emsp;经过 $Log(1+x)$ 变换之后, `SalePrice`的拟合曲线就比较接近正态分布了.

> &emsp;&emsp;接下来我们要进行特征提取. 首先, 为了方便起见, 我们先把训练数据集和测试数据集合在一起进行处理. 
```python
ntrain = train.shape[0]
ntest = test.shape[0]
y_train = train.SalePrice.values
all_data = pd.concat((train, test)).reset_index(drop=True)
all_data.drop(['SalePrice'], axis=1, inplace=True)
print('all_data size is : {}'.format(all_data.shape))
```
```
all_data size is : (2917, 79)
```

> &emsp;&emsp;检查数据中的缺失值的情况.
```python
all_data_na = (all_data.isnull().sum() / len(all_data)) * 100
all_data_na = all_data_na.drop(all_data_na[all_data_na == 0].index).sort_values(ascending=False)[:30]
missing_data = pd.DataFrame({'Missing Ratio': all_data_na})
missing_data.head(20) # 查看缺失值最多的20列
```
![missing_data](./pictures/missing_data.png)

> &emsp;&emsp;我们用图形来可视化以上结果.
```python
fig, ax = plt.subplots(figsize=(15, 12))
plt.xticks(rotation='90')
sns.barplot(x=all_data_na.index, y=all_data_na)
plt.xlabel('Features', fontsize=15)
plt.ylabel('Percent of missing values', fontsize=15)
plt.title('Percent missing data by feature', fontsize=15)
```
![missing_data2](./pictures/missing_data2.png)

> &emsp;&emsp;并且绘制热点图来观察不同特征之间的相关性.
```python
# correlation map to see how features are correlated with SalePrice
corrmat = train.corr()
plt.subplots(figsize=(12, 9))
sns.heatmap(corrmat, vmax=0.9, square=True)
```
![correlation](./pictures/correlation.png)

> &emsp;&emsp;接下来的就是处理缺失数据的操作了.
+ 首先是`PoolQC`, 这个特征存在大量的`NA`值, `python`认为这些是确实数据, 但是我们查看说明文档会发现, `PoolQC`的意思是住房是否带有游泳池, 如果没有, 那么就会显示`NA`. 显然大部分的住房是不会有游泳池的, 所以这个特征列99%以上的都是缺失值. 我们只需要将`NA`替换为另一个值, 同样表示住房不带有游泳池即可.
```python
all_data['PoolQC'] = all_data['PoolQC'].fillna('None')
```
+ `MiscFeature`性质和`PoolQC`相同, 说明文档显示`NA`代表没有一个叫做`misc feature`的东西, 我也不懂是啥, 只不过需要进行的操作和之前相同, 都是替换为`None`.
```python
all_data['MiscFeature'] = all_data['MiscFeature'].fillna('None')
```
+ `Alley`, 代表有没有一条小路? `NA`的意思同样是没有, 所以替换为`None`.
```python
all_data['Alley'] = all_data['Alley'].fillna('None')
```
+ `Fence`和`FireplaceQu`同上, 补全缺失值为`None`即可.
```python
all_data['Fence'] = all_data['Fence'].fillna('None')
all_data['FireplaceQu'] = all_data['FireplaceQu'].fillna('None')
```
+ `LotFrontage`描述的是住房门口街道的宽度. 考虑到同一个地区街道宽度大致是相同的, 那么我们就可以用邻近地区的数据来填充. 这里我们使用的是中位数.
```python
# Group by neighborhood and fill in missing values by the median lotFrontage 
# of all the neighborhood
all_data['LotFrontage'] = all_data.groupby('Neighborhood')['LotFrontage'].transform(
    lambda x: x.fillna(x.median()))
```
+ `GarageType`, `GarageFinish`, `GarageQual`和`GarageCond`描述的是`Garage`车库相关的特征, 如果存在缺失值一般就说明这个住房不带有车库, 所以缺失值填充`None`即可.
```python
for col in ['GarageType', 'GarageFinish', 'GarageQual', 'GarageCond']:
    all_data[col] = all_data[col].fillna('None')
```
+ `GarageYrBlt`, `GarageArea`和`GarageCars`同样是用来描述车库相关的特征. 但是和之前四个不同的是, 这三个特征是数值型的变量, 我们不能用`None`字符串去填充缺失值, 而是应该填充`0`来代表不存在.
```python
for col in ['GarageYrBlt', 'GarageArea', 'GarageCars']:
    all_data[col] = all_data[col].fillna(0)
```
+ `BsmtQual`, `BsmtCond`, `BsmtExposure`, `BsmtFinType1`, `BsmtFinTyep2`这几个特征是描述地下室相关信息的. 由于都是分类变量, 我们用`None`去填充缺失值.
```python
for col in ['BsmtQual', 'BsmtCond', 'BsmtExposure', 'BsmtFinType1' ,'BsmtFinType2']:
    all_data[col] = all_data[col].fillna('None')
```
+ `BsmtFinSF1`, `BsmtFinSF2`, `BsmtUnfSF`, `TotalBsmtSF`, `BsmtFullBath`, `BsmtHalfBath`特征就是描述地下室的数值型变量, 我们用`0`去填充缺失值.
```python
for col in ['BsmtFinSF1', 'BsmtFinSF2', 'BsmtUnfSF', 'TotalBsmtSF', 'BsmtFullBath', 'BsmtHalfBath']:
    all_data[col] = all_data[col].fillna(0)
```
+ `MasVnrArea`和`MasVnrType`描述的大概是瓷砖之类的属性. 分别填充`0`和`None`.
```python
all_data['MasVnrType'] = all_data['MasVnrType'].fillna('None')
all_data['MasVnrArea'] = all_data['MasVnrArea'].fillna(0)
```
+ `MSZoning`描述的是区域属性. 其中`RL`占绝对多数, 所以我们将缺失值填充为`RL`.
```python
all_data['MSZoning'] = all_data['MSZoning'].fillna(all_data['MSZoning'].mode()[0])
```
+ `Utilities`, 这个特征几乎都是`AllPub`, 只有一个例外和两个`NA`, 因此我们认为这个对于最后预测的结果帮助不大, 所以直接去除.
```python
all_data = all_data.drop(['Utilities'], axis=1)
```
+ `Functional`, 数据说明文件中说`NA`就是`typical`的意思.
```python
all_data['Functional'] = all_data['Functional'].fillna('Typ')
```
+ `Electrical`描述住宅是否优点, 只有一个缺失值`NA`, 其他都是`SBrkr`, 所以就填充这个值.
```python
all_data['Electrical'] = all_data['Electrical'].fillna(all_data['Electrical'].mode()[0])
```
+ `SaleType`, `KitchenQual`, `Exterior1st`和`Exterior2nd`这四个特征和`Electrical`相同, 几乎没有缺失值, 因此我们都利用频繁项填充.
```python
all_data['SaleType'] = all_data['SaleType'].fillna(all_data['SaleType'].mode()[0])
all_data['KitchenQual'] = all_data['KitchenQual'].fillna(all_data['KitchenQual'].mode()[0])
all_data['Exterior1st'] = all_data['Exterior1st'].fillna(all_data['Exterior1st'].mode()[0])
all_data['Exterior2nd'] = all_data['Exterior2nd'].fillna(all_data['Exterior2nd'].mode()[0])
```
+ `MSSubClass` 缺失值最有可能意味着不存在, 所以用`None`填充.
```python
all_data['MSSubClass'] = all_data['MSSubClass'].fillna("None")
```

> &emsp;&emsp;以上是缺失值处理步骤, 最后检查一下是否仍然存在缺失值.
```python
# check remaining missing values if any
all_data_na = (all_data.isnull().sum() / len(all_data)) * 100
all_data_na = all_data_na.drop(all_data_na[all_data_na == 0].index)
    .sort_values(ascending=False)
missing_data = pd.DataFrame({'Missing Ratio': all_data_na})
missing_data.head()
```
![missing_data](./pictures/missing_data3.png)

> &emsp;&emsp;接下来是一些特征工程的任务.
```python
# MSSubClass = The building class
all_data['MSSubClass'] = all_data['MSSubClass'].apply(str)

# Change OverallCond into a categorical variable
all_data['OverallCond'] = all_data['OverallCond'].astype(str)

# Year and month sold are transformed into categorical features
all_data['YrSold'] = all_data['YrSold'].astype(str)
all_data['MoSold'] = all_data['MoSold'].astype(str)
```

> &emsp;&emsp;将部分分类变量进行序号标记.
```python
from sklearn.preprocessing import LabelEncoder
cols = ('FireplaceQu', 'BsmtQual', 'BsmtCond', 'GarageQual', 'GarageCond', 
        'ExterQual', 'ExterCond','HeatingQC', 'PoolQC', 'KitchenQual', 'BsmtFinType1', 
        'BsmtFinType2', 'Functional', 'Fence', 'BsmtExposure', 'GarageFinish', 'LandSlope',
        'LotShape', 'PavedDrive', 'Street', 'Alley', 'CentralAir', 'MSSubClass', 'OverallCond', 
        'YrSold', 'MoSold')

# process columns, apply LabelEncoder to categorical features
for col in cols:
    lbl = LabelEncoder() 
    lbl.fit(list(all_data[col].values)) 
    all_data[col] = lbl.transform(list(all_data[col].values))

# shape        
print('Shape all_data: {}'.format(all_data.shape))
```
```
Shape all_data: (2917, 78)
```

> &emsp;&emsp;考虑到面积相关的特征对于放假具有很重要的影响, 所以我们新建一个变量, 为地下室, 一层, 二层面积的综合.
```python
all_data['TotalSF'] = all_data['TotalBsmtSF'] + all_data['1stFlrSF'] + all_data['2ndFlrSF']
```

> &emsp;&emsp;接下来的步骤是检查数值型变量的偏度, 想之前的`SalePrice`一样, 我们也希望数值型变量都满足正态分布, 如果不满足, 那么我们应该通过某些变换, 使得数值型数据的分部具有良好的性质.
```python
numeric_feats = all_data.dtypes[all_data.dtypes != 'object'].index
# Check the skew of all numerical features
skewed_feats = all_data[numeric_feats].apply(lambda x: skew(x.dropna())).sort_values(ascending=False)
skewness = pd.DataFrame({'Skew': skewed_feats})
skewness.head()
```
![skewness](./pictures/skewness.png)

> &emsp;&emsp;注意到还是有相当一部分数值型变量具有较大的偏度, 所以我们对于偏度较大的特征进行Box-Cox变换.
```python
skewness = skewness[abs(skewness) > 0.75]
print('There are {} skewed numerical features to Box Cox transform'
    .format(skewness.shape[0]))

from scipy.special import boxcox1p
skewed_features = skewness.index
lam = 0.15
for feat in skewed_features:
    all_data[feat] = boxcox1p(all_data[feat], lam)
```
```
There are 59 skewed numerical features to Box Cox transform
```

> &emsp;&emsp;将特征转变为虚拟变量, 重新划分训练集和测试集, 准备开始建模.
```python
all_data = pd.get_dummies(all_data)
print(all_data.shape)
train = all_data[: ntrain]
test = all_data[ntrain: ]
```
## <div align = "center">Modelling</div>
> &emsp;&emsp;首先我们要导入一些Kaggle常用的回归模型, 主要用到的是sklearn中现有的一些模块. 另外, 我参考kaggle上参赛者分享的代码, 还是用了微软开源的lightgbm模型和陈天奇教授提出的xgboost模型. 这两种模型在kaggle中运用的比较多, 而且往往能够取得比较好的效果. 
```python
from sklearn.linear_model import ElasticNet, Lasso, BayesianRidge, LassoLarsIC
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.kernel_ridge import KernelRidge
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import RobustScaler
from sklearn.base import BaseEstimator, TransformerMixin, RegressorMixin, clone
from sklearn.model_selection import KFold, cross_val_score, train_test_split
from sklearn.metrics import mean_squared_error
import xgboost as xgb
import lightgbm as lgb
```
> &emsp;&emsp;在训练模型的时候, 我们使用RMSE作为损失函数. 同时, 考虑到训练数据集中数据数量较少, 我们希望充分利用训练集中的数据, 而不是简单的在训练集中进行拆分. 简单来说, 我们要利用交叉验证的方法来替代留出法, 使用尽可能多的数据来训练模型. 这里我们使用了sklearn包中的KFold函数, 制定k值来进行k-折交叉验证. 为了方便多个模型的使用, 我们将交叉验证和计算RMSE打包成一个函数.
```python
# Validation function
n_folds = 5

def rmse_cv(model):
    kf = KFold(n_folds, shuffle=True, random_state=42).get_n_splits(train.values)
    rmse = np.sqrt(
        -cross_val_score(
            model, train.values, y_train, scoring='neg_mean_squared_error', cv=kf
        )
    )
    return(rmse)
```
> &emsp;&emsp;接下来是调用一些基础的模型.
### <div align = "center">Base models</div>
+ **LASSO Regression**
LASSO回归模型对异常敏感, 所以这里使用了RobustScal(), 作用是利用四分位数进行放缩, 解决异常点对于模型精度的影响. 
```python
lasso = make_pipeline(RobustScaler(), Lasso(alpha=0.0005, random_state=1))
```
+ **Elastic Net Regression**
同样对于异常点比较敏感, 所以才去和上面相同的处理.
```python
ENet = make_pipeline(RobustScaler(), ElasticNet(alpha=0.0005, l1_ratio=0.9, random_state=3))
```
+ **Kernel Ridge Regression**
```python
KRR = KernelRidge(alpha=0.6, kernel='polynomial', degree=2, coef0=2.5)
```
+ **Gradient Boosting Regression**
梯度提升树模型, 损失函数loss选择huber将会提高模型对于异常点的泛化能力.
```python
GBoost = GradientBoostingRegressor(
    n_estimators=3000, 
    learning_rate=0.05, 
    max_depth=4, 
    max_features='sqrt', 
    min_samples_leaf=15, 
    min_samples_split=10, 
    loss='huber', 
    random_state=5
)
```
+ **XGBoost**
这个模型是梯度提升树衍生物, 在很多kaggle比赛中都有应用. 而且据说对于结果的提升效果相当好. 
```python
model_xgb = xgb.XGBRegressor(
    colsample_bytree=0.4603, 
    gamma=0.0468, 
    learning_rate=0.05, 
    max_depth=3, 
    min_child_weight=1.7817, 
    n_estimators=2200, 
    reg_alpha=0.4640, 
    reg_lambda=0.8571, 
    subsample=0.5213, 
    silent=1, 
    random_state=7, 
    nthread=-1
)
```

+ **LightGBM**
这个模型我不是很了解, 还需要进一步学习. 
```python
model_lgb = lgb.LGBMRegressor(
    objective='regression', 
    num_leaves=5, 
    learning_rate=0.05, 
    n_estimators=720, 
    max_bin=55, 
    bagging_fraction=0.8, 
    bagging_freq=5, 
    feature_fraction=0.2319, 
    feature_fraction_seed=9, 
    bagging_seed=9, 
    min_data_in_leaf=6, 
    min_sum_hessian_in_leaf=11
)
```

> &emsp;&emsp;检查上述模型经过调参之后的结果.
```python
basemodel_list = [lasso, ENet, KRR, GBoost, model_xgb, model_lgb]
for i in range(len(basemodel_list)):
    score = rmse_cv(basemodel_list[i])
    print('\n'+str(i), ' score: {: .4f} ({:.4f})\n'.format(score.mean(), score.std()))
```
```
0  score:  0.1115 (0.0074)
1  score:  0.1116 (0.0074)
2  score:  0.1153 (0.0075)
3  score:  0.1177 (0.0080)
4  score:  0.1151 (0.0069)
5  score:  0.1144 (0.0071)
```
### <div align = "center">Stacking models</div>
> &emsp;&emsp;我把`stacking models`称为学习模型. 
+ Simplest Stacking approach: Averaging base models
```python
class AveragingModels(BaseEstimator, RegressorMixin, TransformerMixin):
    def __init__(self, models):
        self.models = models

    def fit(self, X, y):
        self.models_ = [clone(x) for x in self.models]       
        # Train cloned base models
        for model in self.models_:
            model.fit(X, y)          
        return self

    def predict(self, X):
        predictions = np.column_stack([
            model.predict(X) for model in self.models_
        ])
        return np.mean(predictions, axis=1)  
```
> &emsp;&emsp;`predict`函数最后一行`np.mean`函数取平均值, 输出的结果是所有简单模型的均值.
```python
# Averaged base models socre
averaged_models = AveragingModels(models=(ENet, GBoost, KRR, lasso))
score = rmse_cv(averaged_models)
print('Averaged base models score: {:.4f} ({:.4f})\n'.format(score.mean(), score.std()))
```
```
Averaged base models score: 0.1091 (0.0075)
```
+ Less simple Stacking: Adding a Meta-model
> &emsp;&emsp;这个部分才是真正的`stacking`. 原理简单来说就是先用几个简单模型训练, 然后在训练集上得到预测结果; 然后就是`stacking`的核心步骤, `stacking`将所有简单模型得到的预测结果作为特征代入指定的`meta-model`进行训练. 两部分得到的模型的组合就是最终的`stacking model`. (这部分的代码是参考别人的)
```python
class StackingAveragedModels(BaseEstimator, RegressorMixin, TransformerMixin):
    def __init__(self, base_models, meta_model, n_fold=5):
        self.base_models = base_models
        self.meta_model = meta_model
        self.n_folds = n_folds
        
    # We again fit the data on clones of the original models
    def fit(self, X, y):
        self.base_models_ = [list() for x in self.base_models]
        self.meta_model_ = clone(self.meta_model)
        kfold = KFold(n_splits=self.n_folds, shuffle=True, random_state=156)
        
        # Train cloned base models then create out-of-fold predictions
        # that are needed to train the cloned meta-model
        out_of_fold_predictions = np.zeros((X.shape[0], len(self.base_models)))
        for i, model in enumerate(self.base_models):
            for train_index, holdout_index in kfold.split(X, y):
                instance = clone(model)
                self.base_models_[i].append(instance)
                instance.fit(X[train_index], y[train_index])
                y_pred = instance.predict(X[holdout_index])
                out_of_fold_predictions[holdout_index, i] = y_pred
        
        # Now train the cloned meta-model using the out-of-fold 
        # predictions as new feature
        self.meta_model_.fit(out_of_fold_predictions, y)
        return self
    
    # Do the predictions of all base models on the test data and 
    # use the averaged predictions as 
    # meta-features for the final prediction which is done by the meta-model
    def predict(self, X):
        meta_features = np.column_stack([
            np.column_stack([model.predict(X) for model in base_models]).mean(axis=1)
            for base_models in self.base_models_
        ])
        return self.meta_model_.predict(meta_features)
```
```python
# stacking Averaged models Score
stacked_averaged_models = StackingAveragedModels(
    base_models = (ENet, GBoost, KRR), 
    meta_model = lasso
)
score = rmse_cv(stacked_averaged_models)
print('Stacking Averaged models score: {:.4f} ({:.4f})'.format(score.mean(), score.std()))
```
```
Stacking Averaged models score: 0.1085 (0.0074)
```
> &emsp;&emsp;第一层简单模型是`(ENet, GBoost, KRR)`, 第二层`meta-model`是`lasso`.最后的结果很好.
+ Ensembling StackedRegressor, XGBoost and LightGBM
> &emsp;&emsp;最后尝试`XGBoost`和`LightGBM`的效果. 下面计算`RMSE`时使用的`y_train`时真实值, 而不是之前进行对数变换之后得到的值. 因此最后得到的`RMSE`的大小也有明显的变化.
```python
def rmse(y, y_pred):
    return np.sqrt(mean_squared_error(y, y_pred))
```
```python
# StackedRegressor
stacked_averaged_models.fit(train.values, y_train)
stacked_train_pred = stacked_averaged_models.predict(train.values)
stacked_pred = np.expm1(stacked_averaged_models.predict(test.values))
print(rmse(y_train, stacked_train_pred))
```
```
0.0781571937916
```
```python
# XGBoost
model_xgb.fit(train, y_train)
xgb_train_pred = model_xgb.predict(train)
xgb_pred = np.expm1(model_xgb.predict(test))
print(rmse(y_train, xgb_train_pred))
```
```
0.0787989479925
```
```python
# LightGBM
model_lgb.fit(train, y_train)
lgb_train_pred = model_lgb.predict(train)
lgb_pred = np.expm1(model_lgb.predict(test.values))
print(rmse(y_train, lgb_train_pred))
```
```
0.0710388626653
```
> &emsp;&emsp;参考`Serigne`分享的代码, 对这几个模型计算加权平均.
```python
print('RMSE score on train data:', rmse(y_train, stacked_train_pred*0.7 + xgb_train_pred*0.15 + lgb_train_pred*0.15))
```
**
**<div align = "center">最后得到的集成模型为:`ensemble = stacked_pred*0.7 + xgb_pred*0.15 + lgb_pred*0.15`</div>**

至此, 这篇实战报告全部结束! 谢谢!
