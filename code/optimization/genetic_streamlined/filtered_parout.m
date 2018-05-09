clear variables
load('filter_parameter.mat')
phase_offset = -0.00;  % minus move the phase up.
population = 1000;
generation = 7000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;
beamgain=solutions.f1.filter_gain;
ir = generate_ir(solutions,rotate,add_gain,tap,phase);

clear solutions
load('pressureout_03.mat')
f=[solutions.fbot:solutions.fres:solutions.ftop];

fs=44100;
Ts=1/fs;
bw=2*pi*(293);
G=10^(12.5/20);
o0=2*pi*234;
Q=o0/bw;
filtergain=10^(10.4/20);

bc(1)=4*Q+o0*(G)*Ts*2+(o0^2)*(Ts^2)*Q;
bc(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
bc(3)=4*Q-2*o0*Ts*(G)+(o0^2)*(Ts^2)*Q;
ac(1)=4*Q+2*o0*Ts+(o0^2)*(Ts^2)*Q;
ac(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
ac(3)=4*Q-2*o0*Ts+(o0^2)*(Ts^2)*Q;

[FRc,w]=freqz(ac,bc,4000,fs);
[FRb,v]=freqz(ir,1,4000,fs);
semilogx(w,abs(FRc))

for h=1:length(f)
    [~,index]=min(abs(w-f(h)));
    [~,i2]=min(abs(v-f(h)));
    solutions.(strcat('f',int2str(f(h)))).Pa=1*abs(FRc(index))*filtergain;
    solutions.(strcat('f',int2str(f(h)))).Pb=solutions.(strcat('f',int2str(f(h)))).Pa;
    solutions.(strcat('f',int2str(f(h)))).Pc=solutions.(strcat('f',int2str(f(h)))).Pa;
    solutions.(strcat('f',int2str(f(h)))).Phia=angle(FRb(i2));
    solutions.(strcat('f',int2str(f(h)))).Phib=0;
    solutions.(strcat('f',int2str(f(h)))).Phic=0;
    solutions.(strcat('f',int2str(f(h)))).Pa=solutions.(strcat('f',int2str(f(h)))).Pa*beamgain*abs(FRb(index));
    solutions.(strcat('f',int2str(f(h)))).Lx=0.4;
    solutions.(strcat('f',int2str(f(h)))).Ly=-0.4;
end
solutions.Lx=0.4;
solutions.Ly=-0.4;

save('pressureout_05.mat','solutions')