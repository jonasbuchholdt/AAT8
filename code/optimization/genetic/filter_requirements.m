clear variables
close all
load('sol14.mat')


f=flip([fbot:fres:ftop]);

for h=1:length(f)
    amplitude1(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Vb)/(solutions.(strcat('f',int2str(f(h)))).Va));
    phase1(h)=(solutions.(strcat('f',int2str(f(h)))).Phib);
end

% load('sol6.mat')
% 
% for h=1:length(f)
%     amplitude2(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Vb)/(solutions.(strcat('f',int2str(f(h)))).Va));
%     phase2(h)=(solutions.(strcat('f',int2str(f(h)))).Phib);
% end
% 
% load('sol7.mat')
% 
% for h=1:length(f)
%     amplitude3(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Vb)/(solutions.(strcat('f',int2str(f(h)))).Va));
%     phase3(h)=(solutions.(strcat('f',int2str(f(h)))).Phib);
% end


figure
yyaxis left
plot(f,amplitude1)
hold on
% plot(f,amplitude2)
% plot(f,amplitude3)
yyaxis right
plot(f,rad2deg(phase1))
% plot(f,rad2deg(phase2))
% plot(f,rad2deg(phase3))