function [b, a] = BFilter()

load('filter_parameter.mat')

phase_offset = -0.00;  % minus move the phase up.
population = 1000;
generation = 7000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;

b = solutions.f1.filter_gain*(generate_ir(solutions,rotate,add_gain,tap,phase));
a =1;

end