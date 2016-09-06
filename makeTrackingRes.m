function TrackRes=makeTrackingRes(IM,phi,border,isBG)
% Function: Make tracking result
% Parameters:
%  IM: orginal image
%  phi: level set
%  border: the size of background region
%  isBG: Dost draw background contour. 1:yes, 0:no
% Return:
%  TrackRes: tracking result
% -----------------------------------------------------------------

BW_F=phi>=0;  % get foregournd region
SE=strel('disk',2);
BW_F=BW_F-imerode(BW_F,SE);
Ind=find(BW_F>0);

Red=IM(:,:,1);
Green=IM(:,:,2);
Blue=IM(:,:,3);

Red(Ind)=255;
Green(Ind)=65;
Blue(Ind)=128;

if isBG
    BW_B=phi>-border-1;
    BW_B=BW_B-imerode(BW_B,SE);
    Ind=find(BW_B>0);
    
    Red(Ind)=65;
    Green(Ind)=128;
    Blue(Ind)=255;
end

TrackRes=cat(3,Red,Green,Blue);