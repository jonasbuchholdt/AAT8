n=10;

population=pop_init(n);
population.gene1
for k=1:n
    if population.(strcat('gene',int2str(k))).mut<=1
        what_mut=rand();
        if what_mut < 0.125
            population.(strcat('gene',int2str(k))).Lx=0.5+0.3*(randn());
        elseif what_mut >= 0.125 && what_mut < 0.25
            population.(strcat('gene',int2str(k))).Ly=0.5+0.3*(randn());
        elseif what_mut >=0.25 && what_mut <0.375
            population.(strcat('gene',int2str(k))).Va=0.03+0.2*(randn());
        elseif what_mut >=0.375 && what_mut<0.5
            population.(strcat('gene',int2str(k))).Vb=0.03+0.2*(randn());
        elseif what_mut >=0.5 && what_mut<0.625
            population.(strcat('gene',int2str(k))).Vc=0.03+0.2*(randn());
        elseif what_mut >= 0.625 && what_mut<0.75
            population.(strcat('gene',int2str(k))).Phia=mod(-2*pi+4*pi*(rand()),2*pi);
        elseif what_mut >=0.75 && what_mut<0.875
            population.(strcat('gene',int2str(k))).Phib=mod(-2*pi+4*pi*(rand()),2*pi);
        else
            population.(strcat('gene',int2str(k))).Phib=mod(-2*pi+4*pi*(rand()),2*pi);
        end
        population.(strcat('gene',int2str(k))).mut=rand();
    end
end
population.gene1