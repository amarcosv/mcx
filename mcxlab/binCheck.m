file='data2fluoro_small.mc';
fileID=fopen(file,'r');
RNphotons=fread(fileID,1,'uint32');
RData=fread(fileID,RNphotons*10,'single');
fclose(fileID);
% calculate the flux 