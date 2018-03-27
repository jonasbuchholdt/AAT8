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

scale = 7
fs = 16000
rho = 1.21
c = 343
delta_t = 1/fs
a=1;
Z0 = rho*c*((1+sqrt(1-a))/(1-sqrt(1-a)))

f = 60;
gain = 0.4971;
phase = 2.9423;

room_x = 30;
room_y = 30;
room_z = 1;
speaker_position = [room_x/2 room_y/2 room_z/2];

f_min = 100;
run_time = ceil((1/f_min)/(1/fs));

grid_size = 0.05;

ro = room_x/grid_size-1;
co = room_y/grid_size-1;
la = room_z/grid_size-1;
ti = 2; % store time 


pressure = repmat(0, [ro co la ti]);
p_rms = repmat(0, [ro co la]);
Vx = repmat(0, [ro+1 co la ti]);
Vy = repmat(0, [ro co+1 la ti]);
Vz = repmat(0, [ro co la+1 ti]);

sp = speaker_position/grid_size;





% start point


% calculate inside room pressure
for t=1:ceil(((343/f)/grid_size))*scale

    
    front = sin(2*pi*f*((t-1)/fs));
    back = gain*sin(2*pi*f*((t-1)/fs)+phase);
    pressure(sp(1)+5,sp(2),1,1)=front;
    pressure(sp(1),sp(2)+4,1,1)=back;
    pressure(sp(1),sp(2)-4,1,1)=back;
    
    %front = sin(2*pi*f*((t-1)/fs));
    %pressure(sp(1),sp(2),1,1)=front;

vx_eq
vy_eq

% for i=1:ro
%     k=1;
%     j=i;    
%     vxlb(1,j,k);
%     vxrb(ro+1,j,k);    
%     vytb(i,1,k);
%     vybb(i,ro+1,k);
% end

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

% temp = 20*log10(abs(pressure(:,:,1,1))/(20*10^(-6)));
% surf(temp)
% colormap(jet)
% colorbar
% shading interp


figure
temp = 20*log10(abs(p_rms(:,:,1))/(20*10^(-6)));
for i=1:length(temp)
    for j=1:length(temp)
        if temp(i,j,1) < 0
           temp(i,j,1) = 0;
        end
    end
end
surf(temp)
colormap(jet)
colorbar
shading interp

%%
xlength=[-(room_x/2)+0.05:0.05:(room_x/2)+0.05];
ylength=[-(room_y/2)+0.05:0.05:(room_y/2)+0.05];
[coorx,coory]=meshgrid(ylength,xlength);
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

q = 1
for j=1:ro
    for i=1:co
        k = 1;
        p(i,j,k);
    end
end

tmp = pressure(:,:,:,1);
%P1=P2;
pressure(:,:,:,1)=pressure(:,:,:,2);
%P2=tmp; 
pressure(:,:,:,2)=tmp;
p_vis=pressure(:,:,1,1)';



%%





function p(i,j,k)

global rho
global c
global pressure
global Vx
global Vy
global Vz
global grid_size
global delta_t

pressure(i,j,k,2)=pressure(i,j,k,1)-((rho*(c^2)*delta_t)/grid_size)*(...
(Vx(i+1,j,k,2)-Vx(i,j,k,2))+...
(Vy(i,j+1,k,2)-Vy(i,j,k,2))+...
(Vz(i,j,k+1,2)-Vz(i,j,k,2))...
); 

end

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

function vx(i,j,k)

global rho
global pressure
global Vx
global grid_size
global delta_t

Vx(i+1,j,k,2) = Vx(i+1,j,k,1)-...
(delta_t/(rho*grid_size))*(pressure(i+1,j,k,1)-pressure(i,j,k,1));
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

function vy(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t

Vy(i,j+1,k,2) = Vy(i,j+1,k,1)...
-(delta_t/(rho*grid_size))*(pressure(i,j+1,k,1)-pressure(i,j,k,1));
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


function vxlb(i,j,k)

global rho
global pressure
global Vx
global grid_size
global delta_t
global Z0

Vx(i,j,k,2) = -((((rho*grid_size)/delta_t)-Z0)/(((rho*grid_size)/delta_t)+Z0)*(Vx(i,j,k,1))...
+2*(1/(((rho*grid_size)/delta_t)+Z0))*pressure(i,j,k,1));
end


function vxrb(i,j,k)

global rho
global pressure
global Vx
global grid_size
global delta_t
global Z0

Vx(i,j,k,2) = ((((rho*grid_size)/delta_t)-Z0)/(((rho*grid_size)/delta_t)+Z0)*(-Vx(i,j,k,1))...
+2*1/(((rho*grid_size)/delta_t)+Z0)*pressure(i-1,j,k,1));
end


function vytb(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t
global Z0

Vy(i,j,k,2) = -(((rho*grid_size)/delta_t-Z0)/((rho*grid_size)/delta_t+Z0)*(Vy(i,j,k,1))...
+2*1/((rho*grid_size)/delta_t+Z0)*pressure(i,j,k,1));
end

function vybb(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t
global Z0

Vy(i,j,k,2) = ((rho*grid_size)/delta_t-Z0)/((rho*grid_size)/delta_t+Z0)*(-Vy(i,j,k,1))...
+2*1/((rho*grid_size)/delta_t+Z0)*pressure(i,j-1,k,1);
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
