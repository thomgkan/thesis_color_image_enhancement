clc 
clear all

im1=imread('allstar-strawberry1.jpg');

YCBCR1 = rgb2ycbcr(im1); %μετατροπή εικόνας σε ycbcr
ycbcr=double(YCBCR1);
Y1=(YCBCR1(:,:,1));

Cb1=YCBCR1(:,:,2);
Cr1=YCBCR1(:,:,3);
cw=1.6; %color weight
%αλλαγή εύρους χρωματικών καναλιών
Cb1n=((ycbcr(:,:,2)-16)./224).*255 -128; 
Cr1n=((ycbcr(:,:,3)-16)./224).*255 -128;
%πολλαπλασιασμός με βάρος
Cb2n=cw*Cb1n; 
Cr2n=cw*Cr1n;
%επαναφορά στο αρχικό εύρος
YCBCR1(:,:,2)=((Cb2n+128)./255 ).*224 +16;
YCBCR1(:,:,3)=((Cr2n+128)./255) .*224 +16;

%ενισχυμένη εικόνα χωρίς Δluma
im2=ycbcr2rgb(uint8(YCBCR1));

%κάλεσμα της συνάρτησης newciecam02 
%οι παράμετροι του συστήματος ciecam02 έχουν οριστεί για έναν μέσο χρήστη 
J1=newciecam02(rgb2xyz(im1));
J2=newciecam02(rgb2xyz(im2));


Ycbcrnew=rgb2ycbcr(im2);
ynew=double(Ycbcrnew(:,:,1));
dluma=(J1-J2);
max_w=100;
for i=0:10
    dluma_w = dluma * i;
    YCBCR1(:,:,1)=uint8(ynew+dluma_w);
    im3=ycbcr2rgb(uint8(YCBCR1));
    J3=newciecam02(rgb2xyz(im3));
    if max(max(abs(J3-J1))) < max_w
        max_w=max(max(abs(J3-J1)));
        weight=i;
    end
end

dlumanew=dluma*weight;
YCBCR1(:,:,1)=uint8(ynew+dlumanew);
Y3=YCBCR1(:,:,1);
im3=ycbcr2rgb(uint8(YCBCR1));
J3=newciecam02(rgb2xyz(im3));

mse(J1,J2)
10*log(10000/ans)
mse(J1,J3)
10*log(10000/ans)


