function [It] = FDTD_impulse_response(roomx,roomy,grid_size,simulation_step)

% this file is able to make an fdtd simulation of a speaket with only knowing the impulse
% response
%%


room_x = roomx;
room_y = roomy;
room_z = 1;


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
for t=1:simulation_step+1

    if t == 1
        k_delta = 1;
    else
        k_delta = 0;
    end
    pressure(sp(1),sp(2),1,1)=k_delta;

%         front = sin(2*pi*100*((t-1)/fs));
%         pressure(sp(1),sp(2),1,1)=front;

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




%swapping matrix 

pressure(:,:,:,1)=pressure(:,:,:,2);
Vx(:,:,:,1)=Vx(:,:,:,2);
Vy(:,:,:,1)=Vy(:,:,:,2);
% Vz(:,:,:,1)=Vz(:,:,:,2);

k = 1;
It(t) = pressure(sp(1),sp(2),1,1);


done = ceil(t/simulation_step);
if done ~= before
    before = done;
fprintf('%d percent done.\n',done);
end


end






