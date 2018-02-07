x = 0 : .1 : 2*pi; 
y = .9*sin(x); 

y(find(y > .8)) = .8; 
y(find(y < -.8)) = -.8; 
plot(x,y)
xticks([ 0 pi/2 pi 1.5*pi 2*pi])
xticklabels({'0','\pi/2','\pi','1.5\pi','2\pi'})
axis([0 2*pi -1 1])
xlabel('Radian [rad/s]')
ylabel('Magnitude')
title('Distortion')