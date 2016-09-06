function  [fore_hist,back_hist,WF,WB,row,col,uv,border]=get_fore_back_hist_JRACS(I,...
    phi,nBin,epislon,backgroundRatio)
% ==================================================%
% Function: Calculate the foreground histogram and background histogram
% Parameters:
%   I: frame                   %
%   phi: signed distance function
%   nBin:
%   epislon:
%   backgroundRatio:
% Return:
%   fore_hist:
%   back_hist:
%   WF:
%   WB:
%   row,col,
%   uv:
%   border:
% ==================================================%

I1=double(I);       
Hf=zeros(nBin,nBin,nBin);    % initialize the foreground histogram
Hb=zeros(nBin,nBin,nBin);    % initialize the background histogram
level=256/nBin;              

 [y,x]=find(phi>=0);
border=backgroundRatio*sqrt(size(x,1)/3.14);   % select the background region
[y,x] = find(phi>=-border); %?±³¾°ÇøÓò

% ±³¾°Ö±·½Í¼ 
H= Heaviside(phi,epislon,y,x);    % calculate the heaviside function (see paper fig.2)
for i=1:size(x)
    R = floor(I1(y(i),x(i),1)/level)+1;
    G = floor(I1(y(i),x(i),2)/level)+1;
    B = floor(I1(y(i),x(i),3)/level)+1;  
    
    Hf(R,G,B)=Hf(R,G,B)+H(i);
    Hb(R,G,B)=Hb(R,G,B)+(1-H(i));    
end

for i=1:nBin
    for j=1:nBin
        for k=1:nBin
            index=(i-1)*nBin*nBin+(j-1)*nBin+k; 
            fore_hist(index)=Hf(i,j,k);
            back_hist(index)=Hb(i,j,k);
        end
    end
end
WF=sum(fore_hist);
fore_hist=fore_hist/sum(fore_hist);
WB=sum(back_hist);
back_hist=back_hist/sum(back_hist);

% [row,col]=find(phi>min(-border,-6) & phi<max(border,6));
row = y;
col = x;
uv=[row,col];