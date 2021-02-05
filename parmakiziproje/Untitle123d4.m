clc,clear,close all
res=imread('deneme.png');

R=res(:,:,1);   G =res(:,:,2);  B=res(:,:,3);
yres(:,:,:)=R+G+B;
imshow(yres);


