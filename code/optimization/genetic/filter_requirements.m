clear variables
close all
load('sol5.mat')


f=flip([fbot:fres:ftop]);

for h=1:length(f)
    amplitude(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Vb)/(solutions.(strcat('f',int2str(f(h)))).Va));
    phase(h)=(solutions.(strcat('f',int2str(f(h)))).Phib);
end

figure
yyaxis left
plot(f,amplitude)
hold on
yyaxis right
plot(f,rad2deg(phase))