classdef highPass < audioPlugin
properties
% public interface
Fc = 20
end
properties (Constant)
PluginInterface = ...
audioPluginInterface( ...
audioPluginParameter('Fc', ...
'DisplayName', 'High Pass', ...
'Label', 'Hz', ...
'Mapping', { 'log', 20, 320}))
end
properties
% internal state
z = zeros(2)
b = zeros(1,3)
a = zeros(1,3)
end
methods
function out = process(p, in)
[out,p.z] = filter(p.b, p.a, in, p.z);
end
function reset(p)
% initialize internal state
p.z = zeros(2);
Fs = getSampleRate(p);
[p.b, p.a] = highPassCoeffs(p.Fc, Fs);
end
function set.Fc(p, Fc)
p.Fc = Fc;
Fs = getSampleRate(p);
[p.b, p.a] = highPassCoeffs(Fc, Fs);
end
end
end