x = 0 : .1 : 2*pi; 
y = sin(x); 

y(find(y > .8)) = .8; 
y(find(y < -.8)) = -.8; 
plot(x,y)