clc,clear,close all
load database person minutiae
a=minutiae(1,1)
a=array2table(a);

b=struct('X',a,'Y',5)
b=struct2table(b)
