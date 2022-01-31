clc 
clear all

im1=imread('example6.jpg');

img = rgb2ycbcr(im1);



%----histogram equalization--------------------
y=img(:,:,1);
h1=imhist(y);

N=prod(size(y));
%Υπολογισμός του n
lowlum = sum(h1(1:124))/N;
highlum = sum(h1(125:256))/N;
n=1.1 + (lowlum - highlum);
%Υπολογισμός του α
numerator = (h1+1).^(1/n);
p1=numerator ./ N;
a= 1 /sum(p1);

p_ahmhe=(a * numerator) ./ N;

c=cumsum(p_ahmhe);
k=255*c;
k_round = round(k); %mapping function
%out_y το διορθωμένο κανάλι φωτεινότητας y
out_y=uint8(zeros(size(y)));
for z=1:size(k_round,1)
    out_y(y==z-1)=k_round(z);
end



%local Contrast map----------------------------------------
newmat1(1:size(y,1)+2,1:size(y,2)+2)=255;
newmat1(2:size(y,1)+1,2:size(y,2)+1)=y;
newmat2(1:size(y,1)+2,1:size(y,2)+2)=255;
newmat2(2:size(y,1)+1,2:size(y,2)+1)=out_y;
for i=2:(size(y,1)+1) 
    for j=2:(size(y,2)+1)
        blur1=  1/9*sum(sum(newmat1(i-1:i+1,j-1:j+1)));
        subLCM1(i-1,j-1)=(y(i-1,j-1)- blur1);
        blur2=  1/9*sum(sum(newmat2(i-1:i+1,j-1:j+1)));
        subLCM2(i-1,j-1)=(out_y(i-1,j-1)- blur2);
    end
end

LCM=((double(y)/255) .* double(subLCM1)) + ((1-(double(out_y)/255)).*double(subLCM2));
LCM=uint8(round(LCM));

y_out=out_y+LCM;

%color enhancement-------------------------------------------------------
%αλλαγή του εύρους χρωματικών καναλιών
Cbin=((double(img(:,:,2))-16)./224) .* 255 -128;
Crin=((double(img(:,:,3))-16)./224).*255 -128;

y_correct=double(y_out./y);
%color weight ανάλογα με την εικόνα και πόση ενίσχυση είναι επιθυμητή
s=1.4;

Cbout=uint8((((s .*y_correct .*Cbin)+128)./255).*224 + 16);
Crout=uint8((((s .*y_correct .*Crin)+128)./255).*224 +16);


im_out(:,:,1)=y_out;
im_out(:,:,2)=Cbout;
im_out(:,:,3)=Crout;


final=ycbcr2rgb(im_out);
