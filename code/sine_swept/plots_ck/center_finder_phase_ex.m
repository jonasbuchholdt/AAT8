clear variables
close all
load('../turn_01.mat')
f=250;

[discard,faxis]=freqz(data900.ir,1,16384,44100);

angles=[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355];
angles=angles.*(pi/180);

[discard index]=min(abs(faxis-f));
responses=[data3600.ir data50.ir data100.ir data150.ir data200.ir data250.ir data300.ir data350.ir data400.ir data450.ir data500.ir data550.ir data600.ir data650.ir data700.ir data750.ir data800.ir data850.ir data900.ir data950.ir data1000.ir data1050.ir data1100.ir data1150.ir data1200.ir data1250.ir data1300.ir data1350.ir data1400.ir data1450.ir data1500.ir data1550.ir data1600.ir data1650.ir data1700.ir data1750.ir data1800.ir data1850.ir data1900.ir data1950.ir data2000.ir data2050.ir data2100.ir data2150.ir data2200.ir data2250.ir data2300.ir data2350.ir data2400.ir data2450.ir data2500.ir data2550.ir data2600.ir data2650.ir data2700.ir data2750.ir data2800.ir data2850.ir data2900.ir data2950.ir data3000.ir data3050.ir data3100.ir data3150.ir data3200.ir data3250.ir data3300.ir data3350.ir data3400.ir data3450.ir data3500.ir data3550.ir];
responses=-responses;
%responses(:,2)=[responses((926:end),2);zeros(925,1)];
tfs=[];

for k=1:size(responses,2)
[tfs(k,:),discard]=freqz(responses(:,k),1,16384,44100);
            if real(tfs(k,index))>0
                phi(k)=rad2deg(atan(imag(tfs(k,index))./real(tfs(k,index))));
            elseif (real(tfs(k,index))<0)&&(imag(tfs(k,index))>=0)
                phi(k)=rad2deg(atan(imag(tfs(k,index))./real(tfs(k,index))))+180;
            elseif (real(tfs(k,index))<0)&&(imag(tfs(k,index))<0)
                phi(k)=rad2deg(atan(imag(tfs(k,index))./real(tfs(k,index))))-180;
            elseif (real(tfs(k,index))==0)&&(imag(tfs(k,index))>0)
                phi(k)=180;
            elseif (real(tfs(k,index))==0)&&(imag(tfs(k,index))<0)
                phi(k)=-180;
            end
phi(k)=mod(rad2deg(atan(imag(tfs(k,index))./real(tfs(k,index)))),360);
if phi(k)>180
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end

%%%% ATTENTION: HARDCODE
phi(2)=phi(end);



lambda=343/f;
for k=1:length(angles)
    if k<=0.5*length(angles)
        dif=phi(k)-phi(k+0.5*length(phi));
    else
        dif=phi(k)-phi(k-0.5*length(phi));
    shiftsum(k)=(dif/720)*lambda;
    shifty(k)=(shiftsum(k))/sqrt(((sin(phi(k)))^2)+1);
    shiftx(k)=sin(phi(k))*shifty(k);
    end
end
avgx=mean(shiftx)
avgy=mean(shifty)

%save('dat250.mat','phi')

figure

polarplot(angles,phi)
hold on
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-180 180])
