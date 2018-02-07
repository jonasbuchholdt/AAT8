clear all
%Delay Effect
%Group 641

%insert your input in this table
filename = 'sin_out.wav';
[input, fs] = audioread(filename);

%Pre define array and variable
sample_no = length(input); %Length of the input
g = 0.7; %Gain
d = 3000;
d_out = 17;
x = zeros(1,sample_no+(d*d_out*g));
y = zeros(1,sample_no+(d*d_out*g));
w = zeros(1,sample_no+(d*d_out*g));

%Input data to x
for i = 1:1:sample_no
    x(i+d+1) = input(i,1);
end

%Making the delay
for n = 1:1:sample_no+(d*d_out*g)-d-1 %loop for an output with one delay value
    n = n+d+1;   
    w(n) = g * w(n-d) + x(n);
end

for n = 1:1:sample_no+(d*d_out*g)-d-1 %loop for an output with one delay value
    n = n+d+1;   
    y(n) = -g * w(n) + w(n-d);
end

%plot
audiowrite('outf.wav',y,fs);
plot(y,'r')
hold on
grid on
plot(x,'b')
ylabel('Magnitude [V]')
xlabel('Time [S]')
FigureToPDF(gcf, '../../figures/design/delay')