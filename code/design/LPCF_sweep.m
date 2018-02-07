clear all
close all
%Delay Effect
%Group 641

%insert your input in this table
filename = '16Hz-20kHz-Lin-CA-10sec.mp3';
[input, fs] = audioread(filename);
fs
%user define variable
early = 1; % pre delay
scaleroom = 0.28; %0.28 int
scaledamp = 0.4; %0.4 int
 

%Pre define array and variable
g = 0.708; %Gain
b = [1,0.9,0.8,0.7,0.6,0.5];
time = 10; % roomsize
damp = 0.5*scaledamp;
room = 0.5*scaleroom+0.7;
allscale = 1;

% filter delay time 
Delay = [round(fs/1000*1.9*time),round(fs/1000*2.3*time),round(fs/1000*2.97*time),round(fs/1000*3.71*time),round(fs/1000*4.1*time),round(fs/1000*4.37*time),round(fs/1000*1.3*time*allscale),round(fs/1000*1.7*time*allscale)]
row = length(Delay); %total-1 array row.
d_out = (round(length(Delay)*g)+time); %total samples after the input is finist 
d = sum(Delay); %total delay time.

%making the array for sampels
sample_no = length(input); %Length of the input
x = zeros(row+1,round(sample_no+(d*d_out*g)))';

%move all input data the total delay time to the left 
for i = 1:1:sample_no
    x(i+d+1,1) = input(i,1)';
end
%Making the Moorer reverb
for n = 1:1:sample_no+(d*d_out*g)-d-1
    n = n+d+1;
   
  
    % Late reflection network
    x(n,2) = x(n,1) - damp*x(n-1,1) + damp*x(n-1,2) + ((room)*(1-damp)* x(n-Delay(1),2));
    end

% keeps the output of maximum a gain of one.
%maximum = 1 / max(abs(y(:,1)));
%y(:,1) = y(:,1)*maximum*0.98;

%write and plot
%audiowrite('outfa.wav',y(:,1),fs);
%plot(in(:,1),'b')
hold on
grid on
semilogx(x(:,2),'b')
semilogx(input(:,1),'r')
ylabel('Magnitude [V]')
xlabel('sample')
FigureToPDF(gcf, '../../figures/design/lpcf_sweep')