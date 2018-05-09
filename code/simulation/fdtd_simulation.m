function FDTD_SIMULATION(frequency,pressure)

%room_x = 20;
%room_y = 20;
%grid_size = 0.05;

p_rms=pressure.(strcat('f',int2str(frequency))).pressure;
xlength=[-(pressure.room_x/2)+pressure.grid:pressure.grid:(pressure.room_x/2)-pressure.grid];
ylength=[-(pressure.room_y/2)+pressure.grid:pressure.grid:(pressure.room_y/2)-pressure.grid];
[coorx,coory]=meshgrid(ylength,xlength);

% p_rms(:,:,1)=pressure.f60.pressure(:,:,1);
% xlength=[-(room_x/2)+grid_size:grid_size:(room_x/2)-grid_size];
% ylength=[-(room_y/2)+grid_size:grid_size:(room_y/2)-grid_size];
% [coorx,coory]=meshgrid(ylength,xlength);

speaker_center = [pressure.room_x/2 pressure.room_y/2 pressure.room_z/2];
sp = speaker_center/pressure.grid;

temp = 20*log10(abs(p_rms(:,:,sp(3)))/(20*10^(-6)));
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
%shading interp
hold on
colormap(jet)
h = colorbar
axis equal
xlim([-25 25])
ylim([-25 25])
view(2)
ylabel('Meter [m]')
xlabel('Meter [m]')
set(get(h,'label'),'string','Pascal [Pa]');

set(gca,'FontSize', 16);


