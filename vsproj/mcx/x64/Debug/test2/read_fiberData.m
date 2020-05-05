ndetectors=4;

fname='test2.mcf';
fileID=fopen('test2.mcf','r+');
A = fread(fileID,ndetectors+1,'uint');
fileid=fclose(fileID);

detData=[detData;A];