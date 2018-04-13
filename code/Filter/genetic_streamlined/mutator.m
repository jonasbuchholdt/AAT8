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
        x = [1:1:M/2];
       xq = [1:0.1:M/2];           
       vq = interp1(x,population.(strcat('gene',int2str(k))).ir_estimate,xq);
       vq = [ vq(1) vq(1) vq(1) vq(1) vq(1:end-4)];
       population.(strcat('gene',int2str(k))).ir_estimate = downsample(vq,10);              
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >= 0.3 && what_mut < 0.5
        x = [1:1:M/2];
       xq = [1:0.1:M/2];           
       vq = interp1(x,population.(strcat('gene',int2str(k))).ir_estimate,xq);
       vq = [ vq(1) vq(1) vq(1:end-2)];
       population.(strcat('gene',int2str(k))).ir_estimate = downsample(vq,10);              
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.5 && what_mut <0.6
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate.*(1 + 0.001*randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.6 && what_mut<0.7
            nr = abs(ceil(M*randn()));
            if nr == 0
                nr = 1;
            elseif nr > M/2
                nr = M/2;
            end
            population.(strcat('gene',int2str(k))).ir_estimate(nr) = population.(strcat('gene',int2str(k))).ir_estimate(nr)-0.0001*(randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.5 && what_mut<0.6
            nr = abs(ceil(M*randn()));
            if nr == 0
                nr = 1;
            elseif nr > M/2
                nr = M/2;
            end
            population.(strcat('gene',int2str(k))).ir_estimate(nr) = population.(strcat('gene',int2str(k))).ir_estimate(nr)+0.0001*(randn());
            population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.6 && what_mut<0.7
            
            %population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.7 && what_mut<0.8     
            %irEstimate = population.(strcat('gene',int2str(k))).ir_estimate;
           
            %population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        elseif what_mut >=0.8 && what_mut<0.9     
            %irEstimate = population.(strcat('gene',int2str(k))).ir_estimate;
            %irEstimate = [flip(irEstimate) irEstimate];
            %x = [1:1:M];
            %xq = [1:0.01:M];
            %vq = interp1(x,irEstimate,xq);
            %vq = circshift(vq ,-10);
            %irEstimate = downsample(vq,100);
            %irEstimate = circshift(irEstimate ,-M/2);
            %irEstimate = irEstimate(1:end/2);
            %population.(strcat('gene',int2str(k))).ir_estimate = irEstimate;        
            %population.(strcat('gene',int2str(k))).ir_estimate(1) = population.(strcat('gene',int2str(k))).ir_estimate(1)-0.0001*(randn());
            %population.(strcat('gene',int2str(k))).ir_estimate(2) = population.(strcat('gene',int2str(k))).ir_estimate(2)-0.0001*(randn());
            %population.(strcat('gene',int2str(k))).ir_estimate(3) = population.(strcat('gene',int2str(k))).ir_estimate(3)-0.00001*(randn());
            %population.(strcat('gene',int2str(k))).ir_estimate = population.(strcat('gene',int2str(k))).ir_estimate - population.(strcat('gene',int2str(k))).ir_estimate(end);
        else
%            population.(strcat('gene',int2str(k))).Phib= mod(-2*pi+4*pi*(rand()),2*pi);
        end
        population.(strcat('gene',int2str(k))).mut=rand();
    end
end
end