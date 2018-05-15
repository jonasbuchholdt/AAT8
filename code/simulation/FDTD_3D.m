function [p_rms_export,grid_size] = FDTD(frequency,roomx,roomy,roomz,simulation_step,it,solutions)

% this file is able to make an fdtd simulation of a speaket with only knowing the impulse
% response
%%


 %load('pressureout_04.mat')
 % frequency = 60;
 % roomx = 30
 % roomy = 30
 % roomz = 30
 % simulation_step = 600
 
room_x = roomx;
room_y = roomy;
room_z = roomz;

f = frequency;
y_distance = solutions.(strcat('f',int2str(frequency))).Ly;
x_distance = solutions.(strcat('f',int2str(frequency))).Lx;
gain_front = solutions.(strcat('f',int2str(frequency))).Pb;
gain_back  = solutions.(strcat('f',int2str(frequency))).Pa;
phase      = solutions.(strcat('f',int2str(frequency))).Phia;




x_distance_half = x_distance/2;
%grid_size = gcd(round(x_distance_half*100),round(y_distance*100))/100;
grid_size = 0.05;
before= 1;
befores = 0;
c = 343;
fs_min = 1/((sqrt(2/3)*(1/grid_size^2+1/grid_size^2+1/grid_size^2)^(-1/2))/c);
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



v_s = single(-(delta_t/(rho*grid_size)));
p_s = single(-((rho*(c^2)*delta_t)/grid_size));

f_min = 100;
run_time = ceil((1/f_min)/(1/fs));



ro = round(room_x/grid_size)-1;
co = round(room_y/grid_size)-1;
la = round(room_z/grid_size)-1;
ti = 2; % store time 


pressure = repmat(single(0), [ro co la ti]);
p_rms = repmat(single(0), [ro co la]);
Vx = repmat(single(0), [ro+1 co la ti]);
Vy = repmat(single(0), [ro co+1 la ti]);
Vz = repmat(single(0), [ro co la+1 ti]);




    
front(1) = gain_front*sin(2*pi*f*((1-1)/fs));
 %front(t) = sin(2*pi*f*((t-1)/fs));
back(1)  = gain_back*sin(2*pi*f*((1-1)/fs)+phase);

%%
for t=1:simulation_step+1
    
    front(t+1) = gain_front*sin(2*pi*f*((t+1-1)/fs));
    %front(t) = sin(2*pi*f*((t-1)/fs));
    back(t+1)  = gain_back*sin(2*pi*f*((t+1-1)/fs)+phase);
  
    impulse_front=0;
        for m=1:t
            impulse_front = impulse_front+it(t-(m)+1)*front(m);
        end

     impulse_back=0;
        for m=1:t
            impulse_back = impulse_back+it(t-(m)+1)*back(m);
        end
     
     speaker_back(t) = back(t+1)-impulse_back;
     speaker_front(t) = front(t+1)-impulse_front;
     
        
end


tic
% calculate inside room pressure
for t=1:simulation_step
    
%     impulse_front=0;
%         for m=1:t
%             impulse_front = impulse_front+it(t-m+1)*front(m);
%         end
% 
%      impulse_back=0;
%         for m=1:t
%             impulse_back = impulse_back+it(t-m+1)*back(m);
%         end

     pressure(sp(1)+s1y,sp(2)+s1x,sp(3),1)=pressure(sp(1)+s1y,sp(2)+s1x,sp(3),1)+speaker_back(t);
     pressure(sp(1)+s2y,sp(2)+s2x,sp(3),1)=pressure(sp(1)+s2y,sp(2)+s2x,sp(3),1)+speaker_front(t);
     pressure(sp(1)+s3y,sp(2)+s3x,sp(3),1)=pressure(sp(1)+s3y,sp(2)+s3x,sp(3),1)+speaker_front(t);
   %pressure(sp(1),sp(2),1,1)=pressure(sp(1),sp(2),1,1)+front(t+1)-impulse_front;

%vx_eq
Vx(2:end-1,:,:,2) = Vx(2:end-1,:,:,1)+v_s.*(pressure(2:end,:,:,1)-pressure(1:end-1,:,:,1));

%vy_eq
Vy(:,2:end-1,:,2) = Vy(:,2:end-1,:,1)+v_s.*(pressure(:,2:end,:,1)-pressure(:,1:end-1,:,1));

%vz_eq
Vz(:,:,2:end-1,2) = Vz(:,:,2:end-1,1)+v_s.*(pressure(:,:,2:end,1)-pressure(:,:,1:end-1,1));

%vxlb_eq
%k=1;
%Vx(1,:,k,2) = alpha*Vx(1,:,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(1,:,k,1);

%vxrb_eq
%k=1;
%Vx(end,:,k,2) = alpha*Vx(end,:,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(end,:,k,1);

%vytb_eq
%k=1;
%Vy(:,1,k,2) = alpha*Vy(:,1,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(:,1,k,1);

%vybb_eq
%k=1;
%Vy(:,end,k,2) = alpha*Vy(:,end,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(:,end,k,1);

%p_eq
pressure(:,:,:,2)=pressure(:,:,:,1)+p_s.*(...
(Vx(2:end,:,:,2)-Vx(1:end-1,:,:,2))+...
(Vy(:,2:end,:,2)-Vy(:,1:end-1,:,2))+...
(Vz(:,:,2:end,2)-Vz(:,:,1:end-1,2))...
);

p_rms(:,:,sp(3)) = p_rms(:,:,sp(3))+(pressure(:,:,sp(3),1)).^2;


%swapping matrix 

pressure(:,:,:,1)=pressure(:,:,:,2);
Vx(:,:,:,1)=Vx(:,:,:,2);
Vy(:,:,:,1)=Vy(:,:,:,2);
Vz(:,:,:,1)=Vz(:,:,:,2);


 
done = ceil((t/simulation_step)*100);
if done == before
    before = done+1;
    time = toc;
    tic
    est_time = (time*100)-(time*done);
    est_time = est_time/60;
fprintf(strcat('%d percent done of %d Hz,',int2str(est_time) ,' min back \n') ,done,frequency);
end


end

p_rms(:,:,sp(3)) = sqrt(p_rms(:,:,sp(3))./t);

p_rms_export=p_rms(:,:,sp(3));


