function [J,A]=newciecam02(xyzim1)


X=100*xyzim1(:,:,1);
Y=100*xyzim1(:,:,2);
Z=100*xyzim1(:,:,3);

mcat02=[0.7328 0.4296 -0.1624; -0.7036 1.6975 0.0061; 0.0030 0.0136 0.9834];
R=mcat02(1,1).*X + mcat02(1,2).*Y + mcat02(1,3).*Z;
G=mcat02(2,1).*X + mcat02(2,2).*Y + mcat02(2,3).*Z;
B=mcat02(3,1).*X + mcat02(3,2).*Y + mcat02(3,3).*Z;

%If complete discounting-the-illuminant is assumed, then D is simply set to 1.0.

La=0.2;
c=0.69;
D=1;
Rc=(((100*D/96.42))+(1-D)).* R;
Gc=(((100*D/100))+(1-D)).* G;
Bc=(((100*D/82.49))+(1-D)).* B;

k=1/(5*La + 1);
Fl=(0.2* k^4 * (5*La)) + ((0.1*(1-k^4)^2) * (5*La)^(1/3)) ;
Yb= 21.26.* R + 71.52.* G + 7.22.*B;
n=0.2;
Ncb=0.725* ((1./n).^0.2) ;
z=1.48 + sqrt(n);


Mhpe=[0.38971 0.68898 -0.07868; -0.22981 1.18340 0.04641; 0.0000 0.0000 1.0000];
Mcat02inv = inv(mcat02);

newmat= Mhpe * Mcat02inv ;

Rnew=newmat(1,1).*Rc + newmat(1,2).*Gc + newmat(1,3).*Bc;
Gnew=newmat(2,1).*Rc + newmat(2,2).*Gc + newmat(2,3).*Bc;
Bnew=newmat(3,1).*Rc + newmat(3,2).*Gc + newmat(3,3).*Bc;

Ra=((400 * (((Fl .* Rnew)./100).^ 0.42)) ./ (27.13 + ((Fl .* Rnew)./100).^0.42))+0.1;
Ga=((400 * (((Fl .* Gnew)./100).^ 0.42)) ./ (27.13 + ((Fl .* Gnew)./100).^0.42))+0.1;
Ba=((400 * (((Fl .* Bnew)./100).^ 0.42)) ./ (27.13 + ((Fl .* Bnew)./100).^0.42))+0.1;
sumA=((2*Ra) + Ga + (0.05*Ba));
A=(sumA-0.3050) * Ncb ; 
A(A<0.00000000000001)=0;
power=c*z;
J=100.* ((A./100).^power);
J=100.*(J./max(max(J)));