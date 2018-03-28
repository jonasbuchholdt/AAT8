% this file is able to make an fdtd simulation of a speaket with only knowing the impulse
% response

clear all
global fs
global rho
global c
global delta_t
global pressure
global Vx
global Vy
global Vz
global grid_size
global Z0
global alpha
global beta


room_x = 20;
room_y = 20;
room_z = 1;

y_distance = 0.25
x_distance = 0.40

scale = 7;


x_distance_half = x_distance/2;
grid_size = (y_distance*x_distance_half);
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


f = 60;
gain = 0.4971;
phase = 2.9423;


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



ro = room_x/grid_size-1;
co = room_y/grid_size-1;
la = room_z/grid_size-1;
ti = 2; % store time 


pressure = repmat(0, [ro co la ti]);
p_rms = repmat(0, [ro co la]);
Vx = repmat(0, [ro+1 co la ti]);
Vy = repmat(0, [ro co+1 la ti]);
Vz = repmat(0, [ro co la+1 ti]);







% start point


% calculate inside room pressure
for t=1:ceil(((343/f)/grid_size))*scale

    
     front = sin(2*pi*f*((t-1)/fs));
     back = gain*sin(2*pi*f*((t-1)/fs)+phase);
     pressure(sp(1)+s1y,sp(2)+s1x,1,1)=pressure(sp(1)+s1y,sp(2)+s1x,1,1)+front;
     pressure(sp(1)+s2y,sp(2)+s2x,1,1)=pressure(sp(1)+s2y,sp(2)+s2x,1,1)+back;
     pressure(sp(1)+s3y,sp(2)+s3x,1,1)=pressure(sp(1)+s3y,sp(2)+s3x,1,1)+back;
    
    %front = sin(2*pi*f*((t-1)/fs));
    %pressure(sp(1),sp(2),1,1)=front;

vx_eq
vy_eq
vxlb_eq
vxrb_eq
vytb_eq
vybb_eq
p_eq
p_rms(:,:,1) = p_rms(:,:,1)+(pressure(:,:,1,1)).^2;


%swapping matrix 

pressure(:,:,:,1)=pressure(:,:,:,2);
Vx(:,:,:,1)=Vx(:,:,:,2);
Vy(:,:,:,1)=Vy(:,:,:,2);
% Vz(:,:,:,1)=Vz(:,:,:,2);


done = ceil(((t/ceil(((343/f)/grid_size)))*100/scale));
if done ~= before
    before = done;
fprintf('%d percent done.\n',done);
end


end

for i=1:ro
    for j=1:co
        k = 1;
        p_rms(i,j,k) = sqrt(p_rms(i,j,k)/t);
    end
end

x_vis=Vx(:,:,1,1)';
y_vis=Vy(:,:,1,1)';
p_vis=pressure(:,:,1,1)';


xlength=[-(room_x/2)+0.05:0.05:(room_x/2)-0.05];
ylength=[-(room_y/2)+0.05:0.05:(room_y/2)-0.05];
[coorx,coory]=meshgrid(ylength,xlength);

figure
temp = 20*log10(abs(p_rms(:,:,1))/(20*10^(-6)));
for i=1:length(temp)
    for j=1:length(temp)
        if temp(i,j,1) < 0
           temp(i,j,1) = 0;
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

[thetasort,sortindex]=sort(thetap);
pp=pp(sortindex);

ppnorm=pp./max(pp);
Lppolar=20.*log10(abs(ppnorm));

figure
polarplot(thetasort,Lppolar)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-24 0])







%%







function p_eq

global rho
global c
global pressure
global Vx
global Vy
global Vz
global grid_size
global delta_t

k=1;
pressure(:,:,k,2)=pressure(:,:,k,1)-((rho*(c^2)*delta_t)/grid_size).*(...
(Vx(2:end,:,k,2)-Vx(1:end-1,:,k,2))+...
(Vy(:,2:end,k,2)-Vy(:,1:end-1,k,2))...
);
end

function vx_eq

global rho
global pressure
global Vx
global grid_size
global delta_t

k = 1;
Vx(2:end-1,:,k,2) = Vx(2:end-1,:,k,1)-...
(delta_t/(rho*grid_size)).*(pressure(2:end,:,k,1)-pressure(1:end-1,:,k,1));
end

function vy_eq

global rho
global pressure
global Vy
global grid_size
global delta_t

k=1;
Vy(:,2:end-1,k,2) = Vy(:,2:end-1,k,1)...
-(delta_t/(rho*grid_size)).*(pressure(:,2:end,k,1)-pressure(:,1:end-1,k,1));
end

function vz(i,j,k)

global rho
global pressure
global Vz
global grid_size
global delta_t

Vz(i,j,k+1,2) = Vz(i,j,k+1,1)-...
(delta_t/(rho*grid_size))*(pressure(i,j,k+1,1)-pressure(i,j,k,1));
end

function vxlb_eq

global rho
global pressure
global Vx
global grid_size
global delta_t
global alpha
global beta

k=1;
Vx(1,:,k,2) = alpha*Vx(1,:,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(1,:,k,1);
end

function vxrb_eq

global rho
global pressure
global Vx
global grid_size
global delta_t
global alpha
global beta 

k=1;
Vx(end,:,k,2) = alpha*Vx(end,:,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(end,:,k,1);
%beta*(2*delta_t)/(rho*grid_size)
end

function vytb_eq

global rho
global pressure
global Vy
global grid_size
global delta_t
global alpha
global beta 

k=1;
Vy(:,1,k,2) = alpha*Vy(:,1,k,1) - beta*(2*delta_t)/(rho*grid_size).*pressure(:,1,k,1);
end

function vybb_eq

global rho
global pressure
global Vy
global grid_size
global delta_t
global Z0
global alpha
global beta 

k=1;
Vy(:,end,k,2) = alpha*Vy(:,end,k,1) + beta*(2*delta_t)/(rho*grid_size).*pressure(:,end,k,1);
end

function vzb(i,k)

global rho
global pressure
global Vz
global grid_size
global delta_t
global Z0

Vz(i,1,k,2) = ((rho*grid_size)/delta_t-Z0)/((rho*grid_size)/delta_t+Z0)*Vz(i,1,k,1)...
+2*1/((rho*grid_size)/delta_t+Z0)*pressure(i,1,k,2);
end
