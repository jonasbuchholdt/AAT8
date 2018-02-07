%Flanger Effect
%Group 641

%insert your input in this table

filename = 'inputt.wav';
[input, fs] = audioread(filename);
%input = [1 2 3 4 5 6 7 8 9 10]

fl = 1;  %LFO Frequency
sample_no = length(input); %Length of the input
g = 10; %Gain
delay_s = 0.01; % delay in seconds 
after_delay = (1:1:sample_no); 
before_delay = (1:1:sample_no);
output = (1:1:sample_no);
max_delay = delay_s * fs;  %convert the delay from delay in seconds to delay in samples



buffer = zeros(1,abs(round(delay))); %create the buffer array 
    
for i = 1:1:sample_no %loop for an output with one delay value
    delay = max_delay * cos(2*pi*i*(fl/fs)); %Calculate time varying delay (unit is samples)
    buffer = [buffer(2:end) input(i)]; %move the values in the buffer ==> first value overwritten, one new value added at the end
    after_delay(i) = buffer(1) * g;  %sound from the delay line in the block diagram
    before_delay(i) = input(i);  %sound from the direct line
    output(i) = after_delay(i) + before_delay(i); %output of the delayed signal 
end
audiowrite('out.wav',output,fs);
plot(output,'r')
hold on
grid
plot(before_delay,'b')

