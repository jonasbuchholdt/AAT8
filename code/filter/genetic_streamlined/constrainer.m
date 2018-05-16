function [penalty]=constrainer(h)
penalty=0;


Lxconstraintupper=2;
Lxconstraintlower=0.5;

Lyconstraintupper=2;
Lyconstraintlower=0.2;

Vconstraintupper=1;
Vconstraintlower=0.0001;

if population.(strcat('gene',int2str(h))).Lx > Lxconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif population.(strcat('gene',int2str(h))).Lx < Lxconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(h))).Lx))^2;
end
if population.(strcat('gene',int2str(h))).Ly > Lyconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif population.(strcat('gene',int2str(h))).Ly < Lyconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(h))).Ly))^2;
end

penalty = penalty+population.(strcat('gene',int2str(h))).age^1.5;
end