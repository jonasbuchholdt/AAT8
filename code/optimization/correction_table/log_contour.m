clear variables
load('acoustics_center_01.mat')

flower=20;
fupper=20000;

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
end
    fm=faxis(ilower:iupper);
    [phi_mat,f_mat]=meshgrid(angle_vector,fm);
    

for k=1:size(p_raw,1)
    p_mat(k,:)=abs(p_raw(k,:))./max(abs(p_raw(k,:)));
        for l=1:size(p_raw,2)
        if p_mat(k,l)<=10^(-26.99/20)
            p_mat(k,l)=10^(-26.12345/20);
        end
    end
end

% for k=1:size(p_raw,1)
%     phi_mat(:,(k))=angle_vector;
% end
% phi_mat=phi_mat';

p_mat=[p_mat(:,38:72) p_mat(:,1:37)];
% phi_mat=[phi_mat(:,37:72) phi_mat(:,1:36)];
% f_mat=[f_mat(:,37:72) f_mat(:,1:36)];

%save('cor_table_01.mat','phi_mat','f_mat','p_mat')
%correction=20*log10(interp2(phi_mat,f_mat,p_mat,phinter,finter,'spline'))

close all
figure

%s=surf(rad2deg(phi_mat),f_mat,20*log10(p_mat))
hA1 = subplot(1,1,1);
s=contourf(rad2deg(phi_mat),f_mat,20*log10(p_mat),'LineStyle','none','LevelList',[-27:3:0]);
set(hA1,'yscale','log');
colormap('jet');
c=colorbar;
c.Label.String='Deviation [dB]';
axis([5 360 flower fupper -7 1]);
xlabel('Angle [Deg]');
xticks([0 60 120 180 240 300 360])
xticklabels({'-180','-120','-60','0','60','120','180'})
ylabel('Frequency [Hz]');
zlabel('Deviation [dB]');
pbaspect([1 2 1])
%set(s, 'EdgeColor', 'interp', 'FaceColor', 'interp');
%s.EdgeColor = 'none';
view(90,90)
set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';