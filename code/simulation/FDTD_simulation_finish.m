clear all
load('impulse_response_3D_40m')
load('pressureout_04.mat')
room_x = 20;
room_y = 20;
room_z = 20;
grid_size = 0.05;
simulation_step = (room_x/grid_size)
%[impulse_response] = FDTD_impulse_response(room_x,room_y,room_z,grid_size,simulation_step+120);
%save((strcat('impulse_response_3D_40m.mat')),'impulse_response');

for f=60:10:60
fprintf('%d Hertz.\n',f);
[p_rms,grid_size] = FDTD_3D(f,room_x,room_y,room_z,simulation_step+100,impulse_response,solutions);
result.(strcat('f',int2str(f))).pressure = p_rms;
%pressure = simulated_pressure_01.(strcat('f',int2str(f)));
end
result.grid = grid_size;
result.room_x = room_x;
result.room_y = room_y;
result.room_z = room_z;

save((strcat('simulated_pressure_01.mat')),'result');
clear simulated_pressure_01;