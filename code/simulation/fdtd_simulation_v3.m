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


fs = 8000
rho = 1.21
c = 343
delta_t = 1/fs
f = 300;
Z0 = 0;%rho*c

room_x = 1;
room_y = 1;
room_z = 1;
speaker_position = [room_x/2 room_y/2 room_z/2];

f_min = 60;
run_time = ceil((1/f_min)/(1/8000));

grid_size = 0.10;

ro = room_x/grid_size-1;
co = room_y/grid_size-1;
la = room_z/grid_size-1;
ti = 2; % store time 


pressure = repmat(0, [ro co la ti]);
p_rms = repmat(0, [ro co la ti]);
Vx = repmat(0, [ro+1 co la ti]);
Vy = repmat(0, [ro co+1 la ti]);
Vz = repmat(0, [ro co la+1 ti]);

sp = speaker_position/grid_size;





% start point


% calculate inside room pressure
for t=1:4
    %if t<15
    xs = sin(2*pi*f*((t-1)/fs));
    pressure(sp(1),sp(2),1,1)=xs;
    %end
    %xc = 50*cos(2*pi*f*((t-1)/fs));   
    %pressure(sp(1)+2,sp(2),1,1)=xc;


for i=1:ro-1
    for j=1:co
        k = 1;
        vx(i,j,k);
    end
end


for i=1:ro
    for j=1:co-1
        k = 1;
        vy(i,j,k);
    end

end

for i=1:ro
    k=1;
    j=i;    
    %vxlb(1,j,k);
    %vxrb(ro-1,j,k);    
    %vytb(i,1,k);
    %vybb(i,ro-1,k);
end

for i=1:ro
    for j=1:co
        k = 1;
        p(i,j,k);
    end
end




for i=1:ro
    for j=1:co
        k = 1;
        p_rms(i,j,k) = p_rms(i,j,k) +(pressure(i,j,k,1))^2;
    end
end
%swapping matrix 

%tmp=P1;
tmp = pressure(:,:,:,1);
%P1=P2;
pressure(:,:,:,1)=pressure(:,:,:,2);
%P2=tmp; 
pressure(:,:,:,2)=tmp;
%tmp=Ux1;
tmp=Vx(:,:,:,1);
%Ux1=Ux2;
Vx(:,:,:,1)=Vx(:,:,:,2);
%Ux2=tmp;
Vx(:,:,:,2)=tmp;
%tmp=Uy1;
tmp=Vy(:,:,:,1);
%Uy1=Uy2;
Vy(:,:,:,1)=Vy(:,:,:,2);
%Uy2=tmp;
Vy(:,:,:,2)=tmp;
% %tmp=Uz1;
% tmp=Vz(:,:,:,1);
% %Uz1=Uz2;
% Vz(:,:,:,1)=Vz(:,:,:,2);
% %Uz2=tmp;
% Vz(:,:,:,2)=tmp;

%figure(t)
t



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

temp = 20*log10(abs(pressure(:,:,1,1))/(20*10^(-6)));
surf(temp)
colormap(jet)
colorbar
shading interp
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

pressure(i,j,k,2)=pressure(i,j,k,1)-((rho*c^2*delta_t)/grid_size)*(...
(Vx(i+1,j,k,2)-Vx(i,j,k,2))+...
(Vy(i,j+1,k,2)-Vy(i,j,k,2))+...
(Vz(i,j,k+1,2)-Vz(i,j,k,2))...
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

function vy(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t

Vy(i,j+1,k,2) = Vy(i,j+1,k,1)...
-(delta_t/(rho*grid_size))*(pressure(i,j+1,k,1)-pressure(i,j,k,1));
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

Vx(i,j,k,2) = ((((rho*grid_size)/delta_t)-Z0)/(((rho*grid_size)/delta_t)+Z0)*Vx(i,j,k,1)...
+2*(1/(((rho*grid_size)/delta_t)+Z0))*pressure(i,j,k,1));
end


function vxrb(i,j,k)

global rho
global pressure
global Vx
global grid_size
global delta_t
global Z0

Vx(i,j,k,2) = ((((rho*grid_size)/delta_t)-Z0)/(((rho*grid_size)/delta_t)+Z0)*Vx(i,j,k,1)...
+2*1/(((rho*grid_size)/delta_t)+Z0)*pressure(i-1,j,k,1));
end


function vytb(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t
global Z0

Vy(i,j,k,2) = (((rho*grid_size)/delta_t-Z0)/((rho*grid_size)/delta_t+Z0)*Vy(i,j,k,1)...
+2*1/((rho*grid_size)/delta_t+Z0)*pressure(i,j,k,1));
end

function vybb(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t
global Z0

Vy(i,j,k,2) = ((rho*grid_size)/delta_t-Z0)/((rho*grid_size)/delta_t+Z0)*Vy(i,j,k,1)...
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
