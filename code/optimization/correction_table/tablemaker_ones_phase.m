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
phase_raw=[];
phase_mat=[];

for k=[ang_res:ang_res:360]
    discard=eval(strcat('data',int2str(k*10),'.tf'));
    phase_raw(:,(k/ang_res))=angle(discard(ilower:iupper));
    f_mat(:,(k/ang_res))=faxis(ilower:iupper);
end

for k=1:size(phase_raw,1)
    phase_mat(k,:)=zeros(1,size(phase_raw,2));%abs(p_raw(k,:))./max(abs(p_raw(k,:)));
end

for k=1:size(phase_raw,1)
    phi_mat(:,(k))=angle_vector;
end
phi_mat=phi_mat';

save('phase_table_ones.mat','phi_mat','f_mat','phase_mat')
%correction=20*log10(interp2(phi_mat,f_mat,p_mat,phinter,finter,'spline'))

close all
figure

s=surf(rad2deg(phi_mat),f_mat,20*log10(phase_mat))
colormap('jet')
c=colorbar
axis([0 360 60 300 -7 1])
xlabel('Angle [Deg]');
ylabel('Frequency [Hz]');
zlabel('Deviation [dB]');
ylabel(c,'Deviation [dB]');
%set(s, 'EdgeColor', 'interp', 'FaceColor', 'interp');
s.EdgeColor = 'none';
view(210,30)