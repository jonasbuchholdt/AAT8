f=[60 300];
e=[3 7];

coeff=polyfit(f,e,1);

e2=polyval(coeff,f)