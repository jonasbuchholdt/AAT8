clear all
room_x = 40;
room_y = 40;
room_z = 40;
grid_size = 0.05;
simulation_step = (room_x/grid_size)
[impulse_response] = FDTD_impulse_response(room_x,room_y,room_z,grid_size,simulation_step+100);
save((strcat('impulse_response_3D_40m.mat')),'impulse_response');