function Image=imageEdgePro(Image)
height=size(Image,1);
width=size(Image,2);

% Ç°5ĞĞ£¬ÖÃÎª0
Image([1:3,end-2:end],:)=255;
Image(:,[1:3,end-2:end],:)=255;