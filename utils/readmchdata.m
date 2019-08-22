function [data, headerstruct, photonseed]=readmchdata(fname,format,endian)
%
%    [data, header]=loadmch(fname,format,endian)
%
%    author: Qianqian Fang (q.fang <at> neu.edu)
%
%    input:
%        fname: the file name to the output .mch file
%        format:a string to indicate the format used to save
%               the .mch file; if omitted, it is set to 'float'
%        endian: optional, specifying the endianness of the binary file
%               can be either 'ieee-be' or 'ieee-le' (default)
%
%    output:
%        data:   the output detected photon data array
%                data has at least M*2+2 columns (M=header.medium), the first column is the 
%                ID of the detector; columns 2 to M+1 store the number of 
%                scattering events for every tissue region; the following M
%                columns are the partial path lengths (in mm) for each medium type;
%                the last column is the initial weight at launch time of each detecetd
%                photon; when the momentum transfer is recorded, M columns of
%                momentum tranfer for each medium is inserted after the partial path;
%                when the exit photon position/dir are recorded, 6 additional columns
%                are inserted before the last column, first 3 columns represent the
%                exiting position (x/y/z); the next 3 columns are the dir vector (vx/vy/vz).
%                in other words, data is stored in the follow format
%                    [detid(1) nscat(M) ppath(M) mom(M) p(3) v(3) w0(1)]
%        header: file header info, a structure has the following fields
%                [version,medianum,detnum,recordnum,totalphoton,detectedphoton,
%                 savedphoton,lengthunit,seedbyte,normalizer,respin,srcnum,savedetflag]
%        photonseed: (optional) if the mch file contains a seed section, this
%                returns the seed data for each detected photon. Each row of 
%                photonseed is a byte array, which can be used to initialize a  
%                seeded simulation. Note that the seed is RNG specific. You must use
%                the an identical RNG to utilize these seeds for a new simulation.
%
%    this file is part of Monte Carlo eXtreme (MCX)
%    License: GPLv3, see http://mcx.sf.net for details
%

if(nargin==1)
   format='float32=>float32';
end

if(nargin<3)
   endian='ieee-le';
end

fid=fopen(fname,'rb',endian);

data=[];
header=[];
photonseed=[];

%  while(~feof(fid))
	magicheader=fread(fid,4,'char');
	if(strcmp(char(magicheader(:))','MCXH')~=1)
		if(isempty(header))
			fclose(fid);
			error('can not find a MCX history data block');
		end
% 		break;
	end
	hd=fread(fid,7,'uint'); % version, maxmedia, detnum, colcount, totalphoton, detected, savedphoton
	if(hd(1)~=1) warning('WARNING: version higher than 1 is not supported'); end
    unitmm=fread(fid,1,'float32');
	seedbyte=fread(fid,1,'uint');
    normalizer=fread(fid,1,'float32');
	respin=fread(fid,1,'int');
	srcnum=fread(fid,1,'uint');
	savedetflag=fread(fid,1,'uint');
	junk=fread(fid,2,'uint');
   
    data=zeros(hd(4),hd(7));
    for i=1:hd(4)
        data(i,:)=fread(fid,hd(7),'float32');        
    end

    
%  end
     fclose(fid);
     
%      
% if(nargout>=2)
%    headerstruct=struct('version',header(1),'medianum',header(2),'detnum',header(3),...
%                        'recordnum',header(4),'totalphoton',header(5),...
%                        'detectedphoton',header(6),'savedphoton',header(7),...
%                        'lengthunit',header(8),'seedbyte',seedbyte,'normalizer',normalizer,...
% 		       'respin',respin,'srcnum',srcnum,'savedetflag',savedetflag);
% end