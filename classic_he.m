clc 
clear all

Im1=imread('example6.jpg');

figure, imshow(Im1)
%-------LAB------
lab = rgb2lab(Im1);
l1=lab(:,:,1);
L=lab(:,:,1);
L1=L./100;
L_eq = 100*histeq(L1);
lab(:,:,1)=(L_eq);
rgbnew=uint8(255*(lab2rgb(lab)));
figure, imshow(rgbnew)


%------YCbCr-----
ycbcr=rgb2ycbcr(Im1);
Y=ycbcr(:,:,1);
[Y_eq,T]=histeq(Y);
ycbcr(:,:,1)=Y_eq;
rgbnew2=ycbcr2rgb(ycbcr);
figure, imshow(rgbnew2)



%----HSV-----
hsv=rgb2hsv(Im1);
V=hsv(:,:,3);
[V_eq,T2]=histeq(V);
hsv(:,:,3)=V_eq;
rgbnew3=uint8(255*hsv2rgb(hsv));
hsv2=rgb2hsv(rgbnew3);
V2=hsv2(:,:,3);
figure, imshow(rgbnew3)



