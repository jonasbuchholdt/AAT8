clear all;
filename = 'reverb_run_time.csv'; %fasen ligger i nr 4
delimiterIn = ',';
headerlinesIn = 6;
preamp = importdata(filename,delimiterIn,headerlinesIn);

%filename = 'guitar_neck_phase_picup.csv'; %fasen ligger i nr 4
%delimiterIn = ',';
%headerlinesIn = 6;
%phase_neck = importdata(filename,delimiterIn,headerlinesIn);

%for n = 1:8192
 %       preamp_dif(n) = (preamp.data(n,3))-(preamp.data(n,2));
%end

%preamp_deg(:) = (phase_neck.data(:,4));

%for n = 1:5000
 % z_neck(n) = lenght_neck(n)*(cos(deg_neck(n)*pi/180)+i*sin(deg_neck(n)*pi/180));     
%end

figure
plot(preamp.data(:,1),preamp.data(:,2),'m')
axis([-0.0000005 0.000003 0 6])
set(gca,'fontsize',18)
hold on
grid on
legend('Reverb run time')
ylabel('Magnetude [V]')
xlabel('Time [s]')
hold off