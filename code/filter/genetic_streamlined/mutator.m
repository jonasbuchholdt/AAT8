%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to select parents to solutions
%   %%% IN  %%%
%   population      -       current population                     [struct]
%   n               -       population size                           [int]
%   pmut            -       mutation probability (0-1)                [int]
%   %%% OUT %%%
%   population      -       mutated population                     [struct]
%
%   2018-03-14
%   CK
%%%-----------------------------------------------------------------------
function [population]=mutator(population,n,pmut,M)
for k=1:n
    if population.(strcat('gene',int2str(k))).mut<=pmut
        what_mut=rand();
        if what_mut < 0.3           
        x = [1:1:length(population.(strcat('gene',int2str(k))).ir_estimate)];
       xq = [1:0.1:length(population.(strcat('gene',int2str(k))).ir_estimate)];           
       vq = interp1(x,population.(strcat('gene',int2str(k))).ir_estimate,xq);
       vq = [ vq(1) vq(1) vq(1) vq(1) vq(1:end-4)];
       population.(strcat('gene',int2str(k))).ir_estimate = downsample(vq,10);              
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >= 0.3 && what_mut < 0.5
        x = [1:1:length(population.(strcat('gene',int2str(k))).ir_estimate)];
       xq = [1:0.1:length(population.(strcat('gene',int2str(k))).ir_estimate)];           
       vq = interp1(x,population.(strcat('gene',int2str(k))).ir_estimate,xq);
       vq = [ vq(1) vq(1) vq(1:end-2)];
       population.(strcat('gene',int2str(k))).ir_estimate = downsample(vq,10);              
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.5 && what_mut <0.6
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate.*(1 + 0.001*randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.6 && what_mut<0.7
            nr = abs(ceil(length(population.(strcat('gene',int2str(k))).ir_estimate)*randn()));
            if nr == 0
                nr = 1;
            elseif nr > length(population.(strcat('gene',int2str(k))).ir_estimate)
                nr = length(population.(strcat('gene',int2str(k))).ir_estimate);
            end
            population.(strcat('gene',int2str(k))).ir_estimate(nr) = population.(strcat('gene',int2str(k))).ir_estimate(nr)-0.0001*(randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.5 && what_mut<0.6
            nr = abs(ceil(length(population.(strcat('gene',int2str(k))).ir_estimate)*randn()));
            if nr == 0
                nr = 1;
            elseif nr > length(population.(strcat('gene',int2str(k))).ir_estimate)
                nr = length(population.(strcat('gene',int2str(k))).ir_estimate);
            end
            population.(strcat('gene',int2str(k))).ir_estimate(nr) = population.(strcat('gene',int2str(k))).ir_estimate(nr)+0.0001*(randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.6 && what_mut<0.7            
       x = [1:1:length(population.(strcat('gene',int2str(k))).ir_estimate)];
       xq = [1:0.1:length(population.(strcat('gene',int2str(k))).ir_estimate)];           
       vq = interp1(x,population.(strcat('gene',int2str(k))).ir_estimate,xq);
       vq = [vq(3:end) vq(end) vq(end)];
       population.(strcat('gene',int2str(k))).ir_estimate = downsample(vq,10);              
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.7 && what_mut<0.8
            x = [1:1:length(population.(strcat('gene',int2str(k))).ir_estimate)];
            mu = rand();
            sigma = rand();
            g = 0.001*rand();
            gaussian = g*(1+(1/(sigma*sqrt(2*pi)))*exp((-1/2).*((x-mu)/sigma).^2)); 
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate.*gaussian;
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);  
        else
%            population.(strcat('gene',int2str(k))).Phib= mod(-2*pi+4*pi*(rand()),2*pi);
        end
        population.(strcat('gene',int2str(k))).mut=rand();
    end
end
end