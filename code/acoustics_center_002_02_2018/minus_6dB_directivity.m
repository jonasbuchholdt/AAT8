clear all
load('acoustics_center_01.mat')
load('faxis.mat')


refference=20*log10(abs(data3600.tf)/(20*10^-6));

for k=1:(70/2)+1

    st = eval(['data' num2str(k*50)])   
    test=20*log10(abs(st.tf)/(20*10^-6));

for i=30:length(refference)
    
if refference(i) >= test(i)+6
 b(k) = faxis(i);
 b_axis(k) = k*5;
    break
end 
end
end


for k=(70/2)+1:72

    st = eval(['data' num2str(k*50)])   
    test=20*log10(abs(st.tf)/(20*10^-6));

for i=30:length(refference)
    
if refference(i) >= test(i)+6
 c(k) = faxis(i);
 c_axis(k) = k*5-360;
    break
end 
end
end

f_axis=[b_axis c_axis];
f = [b c];

f(find(f_axis==10)) = f(find(f_axis==-10));


semilogx(f,f_axis)
hold on
grid on
axis([20 20000 -180 180])
%set(gca,'xtick',[20:500:20000])
set(gca,'ytick',[-180:30:180])
xlabel('Frequency [Hz]')
ylabel('Angle [°]')
%%
semilogx(faxis,refference)
hold on
semilogx(faxis,20*log10(abs(data1250.tf)/(20*10^-6)))
semilogx(faxis,20*log10(abs(data1750.tf)/(20*10^-6)))
grid on

axis([20 20000 20 100])
xlabel('Frequency [Hz]')
ylabel('Pressure [dB]')
%%

plot(data100.ir)
hold on
plot(data3500.ir)
grid on