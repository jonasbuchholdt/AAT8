clear all
close all
%Delay Effect
%Group 641

%insert your input in this table
filename = '200Hz.wav';
[input, fs] = audioread(filename);
fs 
%user define variable
early = 1; %0.5 int pre delay
scaleroom = 0.36; %0.28 int
scaledamp = 0.4; %0.4 int
drywet = 0.5; % dry/wet

Td = 1/fs
t = 0:Td:107908/44100; %round(3000/44100)

%Pre define array and variable
g = 0.708; %Gain
b = [1,0.9,0.8,0.7,0.6,0.5];
time = 10; % roomsize
damp = 0.5*scaledamp;
room = 0.5*scaleroom+0.7;
allscale = 1;

% filter delay time 
Delay = [round((1.9*time)/(1/fs)/1000),round((2.3*time)/(1/fs)/1000),round(fs/1000*2.9*time),round(fs/1000*3.1*time),round(fs/1000*3.7*time),round(fs/1000*4.1*time),round(fs/1000*1.3*time*allscale),round(fs/1000*1.7*time*allscale)]
Early_delay = [round((5.81)/(1/fs)/1000),round(fs/1000*5.83*early),round(fs/1000*5.85 *early),round(fs/1000*5.88*early)]
%Early_delay = [round((15.6)/(1/fs)/1000),round(fs/1000*21.5*early),round(fs/1000*22.5*early),round(fs/1000*26.8*early)]
row = length(Delay); %total-1 array row.
d_out = (round(length(Delay)*g)+time); %total samples after the input is finist 
d = sum(Delay); %total delay time.

%making the array for sampels
sample_no = length(input); %Length of the input
x = zeros(row+1,round(sample_no+(d*d_out*g)))';
y = zeros(row+1,round(sample_no+(d*d_out*g)))';
w = zeros(row+1,round(sample_no+(d*d_out*g)))';
in = zeros(row+1,round(sample_no+(d*d_out*g)))';

%move all input data the total delay time to the left 
for i = 1:1:sample_no
    in(i+d+1,1) = input(i,1)';
end
%Making the Moorer reverb
for n = 1:1:sample_no+(d*d_out*g)-d-1
    n = n+d+1;
    
    % Early reflection network
    x(n,1) = in(n,1) + in(n-Early_delay(1),1)*0.841 + in(n-Early_delay(2),1)*0.504 + in(n-Early_delay(3),1)*0.491 + in(n-Early_delay(4),1)*0.379;
  
    % Late reflection network
    x(n,2) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,2) + ((room)*(1-damp)* x(n-Delay(1),2));
    x(n,3) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,3) + ((room)*(1-damp)* x(n-Delay(2),3));
    x(n,4) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,4) + ((room)*(1-damp)* x(n-Delay(3),4));
    x(n,5) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,5) + ((room)*(1-damp)* x(n-Delay(4),5));
    x(n,6) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,6) + ((room)*(1-damp)* x(n-Delay(5),6));
    x(n,7) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,7) + ((room)*(1-damp)* x(n-Delay(6),7));
    
    x(n,8) =  x(n,2)*b(6) + x(n,3)*b(2) + x(n,4)*b(3) + x(n,5)*b(4) + x(n,6)*b(5) + x(n,7)*b(6);
    
    w(n,8) = g * w(n-Delay(7),8) + x(n,8);
    x(n,9) = -g * w(n,8) + w(n-Delay(7),8);  
    
    w(n,9) = g * w(n-Delay(8),9) + x(n,9);
    y(n) = ((in(n,1)*(1-drywet/1))+((-g * w(n,9) + w(n-Delay(8),9)))*drywet);
end

% keeps the output of maximum a gain of one.
maximum = 1 / max(abs(y(:,1)));
y(:,1) = y(:,1)*maximum*0.05;



filename = 'reverb_impuls_response_10kHz.csv'; %fasen ligger i nr 4
delimiterIn = ',';
headerlinesIn = 6;
preamp = importdata(filename,delimiterIn,headerlinesIn);

%write and plot
audiowrite('outfa.wav',y(:,1),fs);
%plot(in(:,1),'b')
hold on
grid on
%plot(in(:,1),'b')
t = t-0.210;
plot(t,y(:,1),'r')
plot(preamp.data(:,1),preamp.data(:,2),'b')
legend('Simulated 10kHz impulse response','Measured 10kHz impulse response')
axis([-0.15 1.35 -0.1 0.1])
ylabel('Magnitude [V]')
xlabel('Time [s]')
%FigureToPDF(gcf, '../../figures/design/reverb')