clear all
ndetectors=4;
unitmm=1;
probeR=1.25;
fiberR=0.125;

zpos=[0,0.5,1,1.5,2,3,4,5];

mediumSize=[60,60]


angstep=2*pi/ndetectors;

theta=linspace(0,2*pi*(1-1/ndetectors),ndetectors);
r=probeR*ones(1,ndetectors);

[x,y]=pol2cart(theta,r);
xMed=(x)./unitmm+mediumSize(1)/2-1;
yMed=(y)./unitmm+mediumSize(1)/2-1;
radMed=fiberR./unitmm;

prob=[xMed;yMed]
probZ=zpos