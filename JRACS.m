function [phi,regristRes,segmentRes,iterNum_reg,iterNum_seg]=JRACS(RGB,...
    I,noFrame,epislon_registration,epislon_segmentation,phi,fore_hist,...
    back_hist,nBin,iterNum_reg,iterNum_seg,saveTrackBmp,lamda_alignment,...
    lamda_segment,backgroundRatio,thresh_delta_p,backgroundCurve)
% function: implment the registration and segmentation of tracked object.
% parameters:
%   RGB- current frame
%   I- image  
%   epislon_registration：
%   epislon_segmentation：
%   phi- the level set function  
%   fore_hist- foreground histogram  
%   back_hist- background histogram
%   nBin - the num of bins per channel in histogram   直方图的量化等级
%   iterNum_reg
%   iterNum_seg
%   saveTrackBmp
%   lamda_alignment
%   lamda_segment
%   updateAppearance  
%   backgroundRatio
%   thresh_delta_p
%   backgroundCurve
% output:
%   phi- new level set function
%   registrationRes: registration result
%   segmentRes: segment result
%   iterNum_reg: iteration number in registration step
%   iterNum_seg: iteration number in segmentation step
% --------------------------------------------------------------------------------

% registration step: estimated afftine tranformation motion of the target
[phi,regristRes,iterNum_reg]=registration_JRACS(RGB,I,noFrame,epislon_registration,fore_hist,back_hist,phi,iterNum_reg,...
    nBin,saveTrackBmp,lamda_alignment,backgroundRatio,thresh_delta_p,backgroundCurve);
% 
% % segmentation step: refine the registration results
[phi,segmentRes,iterNum_seg]=seg_JRACS(RGB,I,phi,noFrame,epislon_segmentation,fore_hist,back_hist,iterNum_seg,nBin,...
    lamda_segment,saveTrackBmp,backgroundRatio,backgroundCurve);
segmentRes = 0;
epislon_segmentation=0;
lamda_segment = 0;
