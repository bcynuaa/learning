# 复合材料力学python程序说明

[toc]

## 0.简介

根据复合材料力学一书写出的程序，用于求解层合板问题。定义有两个类：layer针对某一层进行抽象定义，plate则是有layer堆叠而成的层合板进行性能计算。一些算例在test.ipynb里面。注意都为国际单位制。

## 1.layer层类

### 概述

针对复合板某一层设计的类，内置两个基本的材料：*HT3/5224*，和*HT3/QY8911*，可以通过如下函数进行layer类的初始化：

```python
import Compound as cp
a=cp.layer('HT3/5224')
```

其变量很多：
- E1、E2、v12、v21、G23：工程弹性常数
- S、Q：刚柔度矩阵
- angle、t、hk：角度，厚度，铺设位置
- S_、Q_:当前角度下刚柔度矩阵
- name：名称

### __init__(self,name='A kind of material')函数

传入名字如果是上述两个材料，将直接计算完成，自动计算S，Q矩阵值和v21值，交还于self中。

并且预先将厚度t，角度angle和所在位置hk置为0，示意代码如下：

```python
import Compound as cp
a=cp.layer('HT3/5224')
b=cp.layer()
```
### set_by_basic(self,E1,E2,v12,G23)函数

根据材料的基本弹性常数定义，需要给出四个参量，如下：

```python
E1,E2,v12,G23=...  #给出值
b.set_by_basic(E1,E2,v12,G23)
```

设置完后，自动计算S，Q矩阵值和v21值，交还于self中。

### set_by_Q(self,Q11,Q12,Q22,Q66)函数

给出Q矩阵，反过来计算S矩阵，如下：

```python
import Compound as cp
c=cp.layer()
Q11,Q12,Q22,Q66=...  #给出值
c.set_by_Q(Q11,Q12,Q22,Q66)
```

### set_by_S(self,S11,S12,S22,S66)函数

给出S矩阵，反过来计算S矩阵，方法同上不再赘述。

### __get_basic(self)私有函数

用于给S或者给Q矩阵的初始化情况下，反过来计算弹性常数的函数，把结果计算中的E1,E2,v12,G23交还给self。

### set_angle(self,theta)函数

设置该层旋转角度，默认为0，以角度制传入，计算出旋转矩阵T和其逆矩阵T_inv，并且调用__set_SQ_theta(self)私有函数，计算获得当前旋转角度下的S_和Q_，把结果交还给self,如下：

```python
c.set_angle(45)
```

### __set_SQ_theta(self)私有函数

用以在set_angle(self,theta)中调用，计算旋转后的S_和Q_矩阵。

### set_t(self,t)函数

用以设置层合板厚度t，把结果交还给self。

```python
a.set_t(10)
```

### set_hk(self,hk)函数

用已设置层合板位置,hk，其中hk-1=hk-t。

```python
a.set_hk(50)
```

### info(self)函数

用以打印各种基本信息。

```python
a.info()
```


## 2.plate层合板类

### 概述

给一个layer的线性表list，使其生成一个层合板类性。list中的layer层需要按照铺设顺序给出。其变量有：

- layout：铺设的layer线性表
- H：总高度
- Hm：总共高度的一半，用于计算A,B,D矩阵
- name:名称

### __init__(self,list_layer,name='this is a laminate')函数

给出layer线性表，并定义一个层合板类性，如下(书本例47)：

```python
name='HT3/5224'
t=0.125
plate47=list()
theta=[45,-45,0,0,0,0,-45,45]
for i in range(len(theta)):
    tmp=cp.layer(name)
    tmp.set_t(t)
    tmp.set_angle(theta[i])
    plate47.append(tmp)
    pass
plate47=cp.plate(plate47)
```

### __get_t(self)/__get_angle(self)私有函数

用于抽取layer线性表中各层的信息，把一个厚度、角度数组交还给self，在__init__()中自动调用

### set(self)函数

用以根据当前信息，计算矩阵A，B，D在__init__()和reset(self)中有调用，把计算结果A,B,D交还给self，并拼装6*6矩阵NM交还给self。

### set_angle(self,angle)函数

如果最初没有设定各个层的铺设角度，可以调用此函数重新设置铺设方式，并调用reset()重新计算。输入值自上而下给出各层铺设角度即可，如下：

```python
angle=[...]#给出一个铺设顺序
plate47.set_angle(angle)
```

### set_t(self,t)函数

同上，给出自上而下的一个t铺设厚度顺序表，自动重新计算矩阵，如下：

```python
t=[...]
plate47.set(t)
```

### info(self):

打印这个层合板各个信息，如下：

```python
plate47.info()
```

### info_detailed(self):

打印每一层的详细信息，如下：

```python
plate47.info_detailed()
```