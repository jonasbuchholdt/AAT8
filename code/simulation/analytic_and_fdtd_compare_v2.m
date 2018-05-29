clear all
load('impulse_response_3D_40m')
load('pressureout_05.mat')
room_x = 16;
room_y = 16;
room_z = 16;
grid_size = 0.10;
simulation_step = (room_x/grid_size)+20
%[impulse_response] = FDTD_impulse_response(room_x,room_y,room_z,grid_size,simulation_step+120);
%save((strcat('impulse_response_3D_40m.mat')),'impulse_response');
%
load('impulse_response_3D_40m')
%impulse_response=[impulse_response(1) impulse_response(1:end-1)];
for f=60:10:60
fprintf('%d Hertz.\n',f);
[p_rms,grid_size] = FDTD_3D(f,room_x,room_y,room_z,simulation_step+10,impulse_response,solutions);
result.(strcat('f',int2str(f))).pressure = p_rms;
%pressure = simulated_pressure_01.(strcat('f',int2str(f)));
end
result.grid = grid_size;
result.room_x = room_x;
result.room_y = room_y;
result.room_z = room_z;

save((strcat('simulated_pressure_prov.mat')),'result');
clear simulated_pressure_prov;
%
speaker_center = [room_x/2 room_y/2 room_z/2];
sp = speaker_center/grid_size;

p_rms(:,:)=result.f60.pressure(:,:);
xlength=[-(room_x/2)+grid_size:grid_size:(room_x/2)-grid_size];
ylength=[-(room_y/2)+grid_size:grid_size:(room_y/2)-grid_size];
[coorx,coory]=meshgrid(ylength,xlength);


temp = 20*log10(abs(p_rms(:,:))/(20*10^(-6)));
for m=1:length(temp)
    for j=1:length(temp)
        if temp(m,j,1) < 10
           temp(m,j,1) = 10;
        end
    end
end
figure
%s = contourf(coorx,coory,temp,110,'LineColor','none');
s = surf(coorx,coory,temp)
s.EdgeColor='none'
shading interp
hold on
colormap(jet)
h = colorbar
axis equal
xlim([-25 25])
ylim([-25 25])
view(2)
ylabel('Meter [m]')
xlabel('Meter [m]')
set(get(h,'label'),'string','Pascal [Pa]','fontsize', 10);


%%
figure
contour(coorx,coory,temp,'ShowText','on')
axis equal
%%
psum = p_rms(:,:);
r=3;
pp=[];
thetap=[];

for n=1:size(psum,1)
   for m=1:size(psum,2)
       if round(sqrt(((coorx(m,n))^2)+((coory(m,n))^2)),2)==r
           pp=[pp psum(m,n)];
           if coory(m,n)>0
               thetap=[thetap atan(coorx(m,n)/coory(m,n))];
           elseif (coory(m,n)<0)&&(coorx(m,n)>=0)
               thetap=[thetap (atan(coorx(m,n)/coory(m,n))+pi)];
           elseif (coory(m,n)<0)&&(coorx(m,n)<0)
               thetap=[thetap (atan(coorx(m,n)/coory(m,n))-pi)];
           elseif (coory(m,n)==0)&&(coorx(m,n)>0)
               thetap=[thetap (pi/2)];
           elseif (coory(m,n)==0)&&(coorx(m,n)<0)
               thetap=[thetap (-pi/2)];
           end
       end
   end
end

[thetasort_sim,sortindex]=sort(thetap);
pp=pp(sortindex);

ppnorm_sim=pp./max(pp);
Lppolar_sim=20.*log10(abs(ppnorm_sim));

figure
polarplot(thetasort_sim,Lppolar_sim)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-24 0])
