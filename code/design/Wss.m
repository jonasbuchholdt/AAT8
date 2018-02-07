clear all


M = 10000;

U = 3+9*randn(M+1,1);
X=U(2:M+1)-(1/2)*U(1:M);

for i=(1:M)
    u(i) = (1/i)*sum(X(1:i)); 
end

plot(u)
hold on

x = [0 M]
y = [1.5 1.5]

pl = line(x,y)
pl.Color = 'red';
%help randn

