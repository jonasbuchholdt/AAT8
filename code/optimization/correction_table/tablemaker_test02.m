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

save('cor_table_01.mat','phi_mat','f_mat','p_mat')
correction=20*log10(interp2(phi_mat,f_mat,p_mat,phinter,finter,'spline'))

close all
s=surf(rad2deg(phi_mat),f_mat,20*log10(p_mat))
colormap('jet')
colorbar
axis([0 360 60 300 -7 1])
xlabel('Angle [Deg]');
ylabel('Frequency [Hz]');
zlabel('Deviation [dB]');
s.EdgeColor = 'none';