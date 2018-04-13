function [regsol,plotdata]=regressor(master,Lxopt,Lyopt,f)

regsol=master.og.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100))));

for h=1:length(f)
    amplitude1(h)=20*log10((regsol.(strcat('f',int2str(f(h)))).Va)/(regsol.(strcat('f',int2str(f(h)))).Vb));
    phase1(h)=-(regsol.(strcat('f',int2str(f(h)))).Phib);
    if phase1(h)<0
        phase1(h)=phase1(h)+2*pi;
    end
end


pgain=polyfit(f,10.^(amplitude1./20),2);
pphase=polyfit(f,phase1,2);

for h=1:length(f)
    regsol.(strcat('f',int2str(f(h)))).Vb =0.01;
    regsol.(strcat('f',int2str(f(h)))).Vc =0.01;
    regsol.(strcat('f',int2str(f(h)))).Va =0.01*polyval(pgain,f(h));
    regsol.(strcat('f',int2str(f(h)))).Phib =0;
    regsol.(strcat('f',int2str(f(h)))).Phic =0;
    regsol.(strcat('f',int2str(f(h)))).Phia=polyval(pphase,f(h));
end

plotdata.ogpres=amplitude1;
plotdata.regpres=20*log10(polyval(pgain,f));
plotdata.ogphase=phase1;
plotdata.regphase=polyval(pphase,f);

end