n=10;
population=pop_init(n);
parent1=1;
parent2=2;

infl_factor=0.25+0.5*rand();                 % factor that biases influence of one parent
child=struct;
child.Lx=infl_factor*population.(strcat('Lx',int2str(parent1)))+(1-infl_factor)*population.(strcat('Lx',int2str(parent2)));
child.Ly=infl_factor*population.(strcat('Ly',int2str(parent1)))+(1-infl_factor)*population.(strcat('Ly',int2str(parent2)));
infl_factor=0.25+0.5*rand();
child.Va=infl_factor*population.(strcat('Va',int2str(parent1)))+(1-infl_factor)*population.(strcat('Va',int2str(parent2)));
child.Vb=infl_factor*population.(strcat('Vb',int2str(parent1)))+(1-infl_factor)*population.(strcat('Vb',int2str(parent2)));
child.Vc=infl_factor*population.(strcat('Vc',int2str(parent1)))+(1-infl_factor)*population.(strcat('Vc',int2str(parent2)));
infl_factor=0.25+0.5*rand();
child.Phia=infl_factor*population.(strcat('Phia',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phia',int2str(parent2)));
child.Phib=infl_factor*population.(strcat('Phib',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phib',int2str(parent2)));
child.Phic=infl_factor*population.(strcat('Phic',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phic',int2str(parent2)));
child.age=0;
child.mut=rand();


