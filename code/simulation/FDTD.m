function [p_rms,grid_size] = FDTD(frequency,roomx,roomy,scale)

% this file is able to make an fdtd simulation of a speaket with only knowing the impulse
% response
%%


load('jonas_sol01.mat')

% frequency = 60;
% roomx = 30
% roomy = 30

room_x = roomx;
room_y = roomy;
room_z = 1;

f = frequency;
y_distance = solutions.(strcat('f',int2str(frequency))).Ly
x_distance = solutions.(strcat('f',int2str(frequency))).Lx
gain = solutions.(strcat('f',int2str(frequency))).Vb/solutions.(strcat('f',int2str(frequency))).Va;
phase = solutions.(strcat('f',int2str(frequency))).Phib;




x_distance_half = x_distance/2;
grid_size = gcd(round(x_distance_half*100),round(y_distance*100))/100
before= 0;
c = 343;
fs_min = 1/((sqrt(2/3)*(1/grid_size^2+1/grid_size^2+1/grid_size^2)^(-1/2))/c)
fs = round(fs_min/10)*10;
rho = 1.21;
c = 343;
delta_t = 1/fs;

a=1;
Z_FDTD = (rho*grid_size)/delta_t;
Z0 = rho*c*((1+sqrt(1-a))/(1-sqrt(1-a)));
alpha = (1-Z0/Z_FDTD)/(1+Z0/Z_FDTD);
beta = 1/(1+Z0/Z_FDTD);






speaker_center = [room_x/2 room_y/2 room_z/2];
sp = speaker_center/grid_size;



xa=x_distance/2;
ya=y_distance;
xb=x_distance;
yb=0;
xc=0;
yc=0;
xs=(xa+xb+xc)/3;
ys=(ya+yb+yc)/3;

s1xr=xa-xs;
s1x = round(s1xr/grid_size)*grid_size;
s2x = (s1x+x_distance/2)/grid_size;
s3x = (s1x-x_distance/2)/grid_size;
s1x = s1x/grid_size;

s1yr=ya-ys;
s1y = round(s1yr/grid_size)*grid_size;
s2y = (s1y-y_distance)/grid_size;
s3y = (s1y-y_distance)/grid_size;
s1y = s1y/grid_size;



f_min = 100;
run_time = ceil((1/f_min)/(1/fs));



ro = round(room_x/grid_size)-1;
co = round(room_y/grid_size)-1;
la = round(room_z/grid_size)-1;
ti = 2; % store time 


pressure = repmat(0, [ro co la ti]);
p_rms = repmat(0, [ro co la]);
Vx = repmat(0, [ro+1 co la ti]);
Vy = repmat(0, [ro co+1 la ti]);
Vz = repmat(0, [ro co la+1 ti]);







% start point


% calculate inside room pressure
for t=1:ceil(((343/60)/grid_size))*scale

    
     front = sin(2*pi*f*((t-1)/fs));
     back = gain*sin(2*pi*f*((t-1)/fs)+phase);
     pressure(sp(1)+s1y,sp(2)+s1x,1,1)=pressure(sp(1)+s1y,sp(2)+s1x,1,1)+front;
     pressure(sp(1)+s2y,sp(2)+s2x,1,1)=pressure(sp(1)+s2y,sp(2)+s2x,1,1)+back;
     pressure(sp(1)+s3y,sp(2)+s3x,1,1)=pressure(sp(1)+s3y,sp(2)+s3x,1,1)+back;
    
    %front = sin(2*pi*f*((t-1)/fs));
    %pressure(sp(1),sp(2),1,1)=front;

%vx_eq
k = 1;
Vx(2:end-1,:,k,2) = Vx(2:end-1,:,k,1)-...
(delta_t/(rho*grid_size)).*(pressure(2:end,:,k,1)-pressure(1:end-1,:,k,1));

%vy_eq
k=1;
Vy(:,2:end-1,k,2) = Vy(:,2:end-1,k,1)...
-(delta_t/(rho*grid_size)).*(pressure(:,2:end,k,1)-pressure(:,1:end-1,k,1));

%vxlb_eq
k=1;
Vx(1,:,k,2) = alpha*Vx(1,:,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(1,:,k,1);

%vxrb_eq
k=1;
Vx(end,:,k,2) = alpha*Vx(end,:,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(end,:,k,1);

%vytb_eq
k=1;
Vy(:,1,k,2) = alpha*Vy(:,1,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(:,1,k,1);

%vybb_eq
k=1;
Vy(:,end,k,2) = alpha*Vy(:,end,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(:,end,k,1);

%p_eq
k=1;
pressure(:,:,k,2)=pressure(:,:,k,1)-((rho*(c^2)*delta_t)/grid_size).*(...
(Vx(2:end,:,k,2)-Vx(1:end-1,:,k,2))+...
(Vy(:,2:end,k,2)-Vy(:,1:end-1,k,2))...
);

p_rms(:,:,1) = p_rms(:,:,1)+(pressure(:,:,1,1)).^2;


%swapping matrix 

pressure(:,:,:,1)=pressure(:,:,:,2);
Vx(:,:,:,1)=Vx(:,:,:,2);
Vy(:,:,:,1)=Vy(:,:,:,2);
% Vz(:,:,:,1)=Vz(:,:,:,2);


done = ceil(((t/ceil(((343/60)/grid_size)))*100/scale));
if done ~= before
    before = done;
fprintf('%d percent done.\n',done);
end


end

k=1;
p_rms(:,:,k) = sqrt(p_rms(:,:,k)./t);




