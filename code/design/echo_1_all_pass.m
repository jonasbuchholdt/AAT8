clear all

n = 0; %init
k = 1; %init
Y = 1; %input
b = 0.9; % 1,0.9,0.8,0.7,0.6,0.5

%LPCF
while Y > 0.001 && k > 0
   n = n+1;
   Y = 1*0.708^n; %1*0.708*0.708
   Y = Y*b;
   
   %all pass
   k = 0; %init
   X = 1; %init
   while X > 0.001
   k = k+1;
   X = Y*0.708^k;
   end
   k = k-1;
   out = k + 1
end
n = n-1;
%FigureToPDF(gcf, '../../figures/design/reverbcal')