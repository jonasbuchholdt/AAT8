clear all
room_x = 35;
room_y = 35;
room_z = 35;
grid_size = 0.05;
simulation_step = (room_x/grid_size)
[impulse_response] = FDTD_impulse_response(room_x,room_y,room_z,grid_size,simulation_step+120);
save((strcat('impulse_response_3D_40m.mat')),'impulse_response');