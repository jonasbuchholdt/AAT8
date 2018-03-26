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


fs = 44100
rho = 1.21
c = 343
delta_t = 0.0001




room_x = 5;
room_y = 5;
room_z = 5;
speaker_position = [room_x/2 room_y/2 room_z/2]


grid_size = 0.10;

ro = room_x/grid_size;
co = room_y/grid_size;
la = room_z/grid_size;
ti = 1; % store time 


pressure = repmat(0, [ro co la ti]);
Vx = repmat(0, [ro-1 co-1 la-1 ti]);
Vy = repmat(0, [ro-1 co-1 la-1 ti]);
Vz = repmat(0, [ro-1 co-1 la-1 ti]);







% start point


% calculate inside room pressure
for t=1:20
    x = 100*sin(2*pi*300*((t-1)/fs));
    pressure(1,1,1,1)=x;
for j=1:48
for i=1:48
k = 1;

p(i,j,k);
vx(i,j,k);
vy(i,j,k);
vz(i,j,k);

%swapping matrix 
tmp=P1;
P1=P2;
P2=tmp; 
tmp=Ux1;
Ux1=Ux2;
Ux2=tmp; 
tmp = Uy1; 
Uy1 = Uy2; 
Uy2 = tmp;

end
end

pressure(:,:,:,1)=pressure(:,:,:,2);
figure(t)
x
surf(pressure(:,:,1,1))

end




%%

%equation of continuity 
for i=1:I-1
    for j=1:J-1
        P2(i,j) = P1(i,j)...
        -dt*K/dx*( Ux1(i+1,j)-Ux1(i,j) )... 
        -dt*K/dy*( Uy1(i,j+1)-Uy1(i,j) );
    end
end



%equation of motion 
for i=1:I-1
    for j=1:J-1
        Ux2(i+1,j) = Ux1(i+1,j)... 
        -dt/dx/rho*( P2(i+1,j)-P2(i,j) ); 
    end
end



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
(Vx(i+1,j,k,1)-Vx(i,j,k,1))+...
(Vy(i,j+1,k,1)-Vy(i,j,k,1))+...
(Vz(i,j,k+1,1)-Vz(i,j,k,1))...
); 

% pressure(i,j,k,2)=pressure(i,j,k,1)-rho*c^2*delta_t*(...
% ((Vx(i+1,j,k,2)-Vx(i,j,k,2))/grid_size)+...
% ((Vy(i,j+1,k,2)-Vy(i,j,k,2))/grid_size)+...
% ((Vz(i,j,k+1,2)-Vz(i,j,k,2))/grid_size)...
% ); 
end



function vx(i,j,k)

global rho
global pressure
global Vx
global grid_size
global delta_t

Vx(i+1,j,k,2) = Vx(i+1,j,k,1)-...
(delta_t/(rho*grid_size))*(pressure(i+1,j,k,2)-pressure(i,j,k,2));
end

function vy(i,j,k)

global rho
global pressure
global Vy
global grid_size
global delta_t

Vy(i,j+1,k,2) = Vy(i,j+1,k,1)-...
(delta_t/(rho*grid_size))*(pressure(i,j+1,k,2)-pressure(i,j,k,2));
end

function vz(i,j,k)

global rho
global pressure
global Vz
global grid_size
global delta_t

Vz(i,j,k+1,2) = Vz(i,j,k+1,1)-...
(delta_t/(rho*grid_size))*(pressure(i,j,k+1,2)-pressure(i,j,k,2));
end