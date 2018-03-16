clear variables
close all
f=[60,100,150,200,250,300];
angles=[0:pi/90:2*pi];
% c1=1-flattopwin(length(angles))';
% c2=1-abs(cos((angles./2)));
% c3=1-abs(cos((angles./2))).^2;
% c4=1-abs(cos((angles./2))).^4;
% c5=(0.5-(cos(angles)/2));
% c6=((0.5-(cos(angles)/2)).^6);
% c7=0.4.*(1-flattopwin(length(angles)))'+0.7.*(0.5-(cos(angles)/2)).^4;


g=[60 300];
e=[3 7];

coeff=polyfit(g,e,1);


c1=1-abs(cos((angles./2)).^polyval(coeff,f(1)));
c2=1-abs(cos((angles./2)).^polyval(coeff,f(2)));
c3=1-abs(cos((angles./2)).^polyval(coeff,f(3)));
c4=1-abs(cos((angles./2)).^polyval(coeff,f(4)));
c5=1-abs(cos((angles./2)).^polyval(coeff,f(5)));
c6=1-abs(cos((angles./2)).^polyval(coeff,f(6)));


figure
plot(rad2deg(angles),c1);
hold on
plot(rad2deg(angles),c2);
plot(rad2deg(angles),c3);
plot(rad2deg(angles),c4);
plot(rad2deg(angles),c5);
plot(rad2deg(angles),c6);
%plot(rad2deg(angles),c7);