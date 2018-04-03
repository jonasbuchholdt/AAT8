%clear all

room_x = 40;
room_y = 40;
grid_size = 0.05;
simulation_step = (room_x/grid_size)-10
%[impulse_response] = FDTD_impulse_response(room_x,room_y,grid_size,simulation_step);
impulse_response = it;
for f=60:10:60
 
[p_rms,grid_size] = FDTD(f,room_x,room_y,simulation_step,impulse_response);
pressuretra.(strcat('f',int2str(f))).pressure = p_rms;
pressuretra.(strcat('f',int2str(f))).grid = grid_size;
pressuretra.(strcat('f',int2str(f))).room_x = room_x;
pressuretra.(strcat('f',int2str(f))).room_y = room_y;
end

%%
xlength=[-(room_x/2)+grid_size:grid_size:(room_x/2)-grid_size];
ylength=[-(room_y/2)+grid_size:grid_size:(room_y/2)-grid_size];
[coorx,coory]=meshgrid(ylength,xlength);


temp = 20*log10(abs(p_rms(:,:,1))/(20*10^(-6)));
for m=1:length(temp)
    for j=1:length(temp)
        if temp(m,j,1) < 10
           temp(m,j,1) = 10;
        end
    end
end
s = surf(coorx,coory,temp)
colormap(jet)
colorbar
s.EdgeColor='none'
%shading interp
axis equal

figure
contour(coorx,coory,temp,'ShowText','on')
axis equal
%%
psum = p_rms(:,:,1);
r=10;
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