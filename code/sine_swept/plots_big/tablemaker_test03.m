clear variables
%close all


fs=44100;

ares=4;
astart=ares;
astop=360;

flower=60;
fupper=300;

angles=[astart:ares:astop];

for h=1:(astop/ares)
    load('ir_01.mat',(strcat('data',int2str((astart+(h-1)*ares)*10))));
    IR1s=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf1(:,h),w]=freqz(IR1s,1,20000,fs);
    clearlist={strcat('data',int2str((astart+(h-1)*ares)*10))};
    clear(clearlist{:})
end
%[discard index]=min(abs(w-f));
[trash iupper]=min(abs(w-fupper));
[trash ilower]=min(abs(w-flower));
clear trash
for k=[astart:ares:360]
    f_mat(:,(k/ares))=w(ilower:iupper);
end
tf1=tf1(ilower:iupper,:);
for k=1:size(tf1,1)
    p_mat(k,:)=abs(tf1(k,:))./max(abs(tf1(k,:)));
    for l=1:size(tf1,2)
        if p_mat(k,l)<=10^(-26.99/20)
            p_mat(k,l)=10^(-26.12345/20);
        end
    end
end
p_mat(1,1)=10^(-26.12345/20);
for k=1:size(tf1,1)
    phi_mat(:,(k))=angles;
end
phi_mat=phi_mat';
phi_mat=phi_mat(1:iupper-ilower+1,:);
p_mat=[p_mat(:,((length(angles)/2)+1):length(angles)) p_mat(:,1:length(angles)/2)];
% phi_mat=[phi_mat(:,37:72) phi_mat(:,1:36)];
% f_mat=[f_mat(:,37:72) f_mat(:,1:36)];

%save('cor_table_01.mat','phi_mat','f_mat','p_mat')
%correction=20*log10(interp2(phi_mat,f_mat,p_mat,phinter,finter,'spline'))
%%
close all 
figure(1)

s=surf(rad2deg(phi_mat),f_mat,20*log10(p_mat))
s=contourf((phi_mat),f_mat,20*log10(p_mat),'ShowText','On','LevelList',[-27:3:0]);
colormap('jet')
c=colorbar;
c.Label.String='Attenuation [dB]';
c.Limits=[-27 0];
%s=contourfcmap(phi_mat,f_mat,20*log10(p_mat),[-5 -3 -2:.5:2 3 5],jet(12))
axis([5 360 flower fupper -27 0])
xlabel('Angle [Deg]');
xticks([0 60 120 180 240 300 360])
xticklabels({'-180','-120','-60','0','60','120','180'})
ylabel('Frequency [Hz]');
zlabel('Attenution [dB]');
set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';

%set(s, 'EdgeColor', 'interp', 'FaceColor', 'interp');
%s.EdgeColor = 'none';
view(90,90)
pbaspect([1 2 1])