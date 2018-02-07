clear all;
filename = 'C:\Users\Sebatian\3SP6\measure\guitar_high_E_flasholet_bridge.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);

%dat = iddata(A.data(:,1),A.data(:,2));

figure
loglog(A.data(:,1),A.data(:,2))
axis([20 20000 -140 -20])
set(gca,'fontsize',18)
hold on
grid on
ylabel('Magnitude [dBu]')
xlabel('Frequency [Hz]')
hold off

