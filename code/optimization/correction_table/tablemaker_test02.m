clear variables
load('acoustics_center_01.mat')

flower=60;
fupper=300;

ang_res=5;

finter=202;
phinter=deg2rad(140);

[discard ilower]=min(abs(faxis-flower));
[discard iupper]=min(abs(faxis-fupper));

angle_vector=[deg2rad(ang_res):deg2rad(ang_res):2*pi];

phi_mat=[];
f_mat=[];
p_raw=[];
p_mat=[];

for k=[ang_res:ang_res:360]
    discard=eval(strcat('data',int2str(k*10),'.tf'));
    p_raw(:,(k/ang_res))=discard(ilower:iupper);
    f_mat(:,(k/ang_res))=faxis(ilower:iupper);
end

for k=1:size(p_raw,1)
    p_mat(k,:)=abs(p_raw(k,:))./max(abs(p_raw(k,:)));
end

for k=1:size(p_raw,1)
    phi_mat(:,(k))=angle_vector;
end
phi_mat=phi_mat';

p_mat=[p_mat(:,38:72) p_mat(:,1:37)];
% phi_mat=[phi_mat(:,37:72) phi_mat(:,1:36)];
% f_mat=[f_mat(:,37:72) f_mat(:,1:36)];

%save('cor_table_01.mat','phi_mat','f_mat','p_mat')
%correction=20*log10(interp2(phi_mat,f_mat,p_mat,phinter,finter,'spline'))

%close all
figure
p_mat(1,end) = 0.4;

p_mat= [p_mat(:,end) p_mat];
phi_mat = [zeros(size(p_mat,1),1) phi_mat];
f_mat = [f_mat(:,end) f_mat];

%s=surf(rad2deg(phi_mat),f_mat,20*log10(p_mat))
s=contourf(rad2deg(phi_mat),f_mat,20*log10(p_mat),'LineStyle','none','LevelList',[-8:1:0])
colormap('jet(8)')
c=colorbar
set(c, 'YTick', linspace(-7, 0, 8));
c.Label.String='Deviation [dB]'
axis([0 360 60 300 -7 1])
xlabel('Angle [Deg]');
xticks([0 60 120 180 240 300 360])
xticklabels({'-180','-120','-60','0','60','120','180'})
ylabel('Frequency [Hz]');
zlabel('Deviation [dB]');

%set(s, 'EdgeColor', 'interp', 'FaceColor', 'interp');
%s.EdgeColor = 'none';
view(90,90)
set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';
c.Label.FontSize = 13;


