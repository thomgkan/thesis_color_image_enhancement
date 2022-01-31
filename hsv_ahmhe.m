clc 
clear all

im1=imread('example6.jpg');

img=rgb2hsv(im1);
%histogram equalization---------------------
v=img(:,:,3);
h1=imhist(v);

N=prod(size(v));
%Υπολογισμός του n
lowlum = sum(h1(1:124))/N;
highlum = sum(h1(125:256))/N;
n=1.1 + (lowlum - highlum);
%Υπολογισμός του α
numerator = (h1+1).^(1/n);
p1=numerator ./ N;
a=1 /sum(p1);

p_ahmhe=(a * numerator) ./ N;

c=cumsum(p_ahmhe);
k=255*c;
k_round = round(k); %mapping function
%out_v το διορθωμένο κανάλι φωτεινότητας 
out_v=(zeros(size(v)));
for z=1:size(k_round,1)
    out_v(v==((z-1)/255))=(k_round(z)/255);
end

%local Contrast map----------------------------------------
newmat1(1:size(v,1)+2,1:size(v,2)+2)=1;
newmat1(2:size(v,1)+1,2:size(v,2)+1)=v;
newmat2(1:size(v,1)+2,1:size(v,2)+2)=1;
newmat2(2:size(v,1)+1,2:size(v,2)+1)=out_v;

for i=2:(size(v,1)+1) 
    for j=2:(size(v,2)+1)
        blur1=  1/9*sum(sum(newmat1(i-1:i+1,j-1:j+1)));
        subLCM1(i-1,j-1)=(v(i-1,j-1)- blur1);
        blur2=  1/9*sum(sum(newmat2(i-1:i+1,j-1:j+1)));
        subLCM2(i-1,j-1)=(out_v(i-1,j-1)- blur2);
    end
end

LCM=(v .* subLCM1) + ((1-out_v).* subLCM2);
v_out=out_v+LCM;
img(:,:,3)=v_out;
final=uint8(255*hsv2rgb(img));
