fs = 44100;
Ts = 1/fs;

scaleroom = 0.28; %0.28 int
scaledamp = 0.4; %0.4 int
 

%Pre define array and variable
d = 0.5*scaledamp;
f = 0.5*scaleroom+0.7;
N = round(fs/1000*2.9*10)

z = tf('z',Ts) 

H = (1-d)/(1-d*z^(-1));

bode(H)