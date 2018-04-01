clear all

for f=60:10:300
  
room_x = 80;
room_y = 80;
frequency = f
scale = 18;
[p_rms,grid_size] = FDTD(frequency,room_x,room_y,scale);

pressuresec.(strcat('f',int2str(frequency))).pressure = p_rms;
pressuresec.(strcat('f',int2str(frequency))).grid = grid_size;
pressuresec.(strcat('f',int2str(frequency))).room_x = room_x;
pressuresec.(strcat('f',int2str(frequency))).room_y = room_y;
pressuresec.(strcat('f',int2str(frequency))).scale = scale;
end
