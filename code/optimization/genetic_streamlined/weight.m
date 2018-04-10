function [weight]=weight(angles,f,polylf,polyhf)

coeff=polyfit([60 300],[polylf polyhf],1);
weight=1-abs(cos((angles./2)).^polyval(coeff,f));

end