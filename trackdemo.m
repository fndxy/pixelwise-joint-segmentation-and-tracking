% *******************************************************************************************************
% Filename: trackdemo.m                               
% Function: Implement the algorithm described in Joint Registration and                                  
%           Active Contour Segmentation for Object Tracking (JRACS)                                           
%           IEEE Transactions on Circuits and Systems for Video Technology, 23(9):1589 - 159            
% Author :  Jifeng Ning, Lei Zhang, David Zhang, Wei Yu.
%           Jifeng Ning，Wei Yu,College of Information Engineering,Northwest A&F University.
%           Wei Yu is currently pursuing the Ph.D. degree in computer vision
%           at the Institute for Computer Graphics and Vision, Graz, Austria.
%           
%           Lei Zhang, David Zhang, Department of Computing, Biometric Research Center,        
%           Hongkong polytechnic university 
% e-mail:   ningjifeng@gmail.com, cslzhang@comp.polyu.edu.hk,
%           csdzhang@comp.polyu.edu.hk, wei.yu@icg.tugraz.at
% Date    : Demcember 1, 2013 
%                                                                         
% Software: JRACS Version 1.0
% Copyright (c) 2013 by Jifeng Ning, Lei Zhang, David Zhang, Wei Yu
% *************************************************************************

clc;
clear;
close all;
warning off;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% parameter setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nBin=16;                       % bins for histograms
lamda_registration=1;          % weight of background information in the registration step
lamda_segmentation=1;          % weight of background information in the segmentation step
 
iterNum_registration=3;        % iteration number in the registration step
iterNum_segmentation=5;       % iteration number in the segmentation step >=5
epislon_registration=2;        % heaviside parameter in the registration step. more bigger, more faster convergence 
epislon_segmentation=1.5;     % heaviside parameter in the segmentation step. more bigger, more faster convergence
 
thresh_delta_T=1.0;            % registration threshold for registration
backgroundRatio=0.5;           % the size of selected background region
 
updateAppearance=0;            % apparance model updating. 1:yes 0: no
 
backgroundCurve=0;             % background curve display 1:yes :no
 
saveTrackBmp=0;                % saving tracking results as "bmp"
saveAvi=0;                     % saving tracking results as "avi"
 
% video sequence
direct='./test videos/hand/';       % video sequence path
objectFrame=1;               % frame number for target 
startFrame=2;                % start frame for tracking
step=1;                      %
endFrame=28;                 % end frame for tracking
 
if (saveAvi==1)
    aviFilename='./avi tracking results/fish2a.avi';
    avi=avifile(aviFilename);
end

testSequence=dir(direct);
RGB = imread([direct,testSequence(objectFrame+2).name]);   % load object frame
I=double(RGB);

Mask = gettemplate(RGB); % get the initial target region
phi = -mask2phi(Mask);   % signed distance function 

% calculate the foreground and background histogram of the target region
[fore_hist,back_hist,WF,WB,ind_x,ind_y,uv,border]=get_fore_back_hist_JRACS(I,phi,nBin,1,backgroundRatio);
 %文章里的 q 和 o
if (saveTrackBmp==1)
    % save intial target
    plotLevelSet(phi,1,'r');drawnow;
    plotLevelSet_background(phi,border,'r');drawnow;
    frame=getframe(gca);
    frame=frame2im(frame);
    imwrite(frame,['./registration and segmentation/','_initialize.jpg']);
end
   
figure(1);hold on;

% start tracking
k=0;
for i = startFrame:step:endFrame
    % load each frame
    RGB=imread([direct,testSequence(i+2).name]);

    I=double(RGB);
%     I=imageEdgePro(I);    
    % the proposed JRACS algorithm
    [phi,regristRes,segmentRes,iterNum_act]=JRACS(RGB,I,i,epislon_registration,epislon_segmentation,phi,fore_hist,back_hist,...
        nBin,iterNum_registration,iterNum_segmentation,saveTrackBmp,lamda_registration,lamda_segmentation,...
        backgroundRatio,thresh_delta_T,backgroundCurve);
 
    % ****************************** Appearance updating **********************************
    [fore_hist_n back_hist_n,WF,WB]=get_fore_back_hist_JRACS(I,phi,nBin,epislon_registration,backgroundRatio);
 
    fore_hist_matrix(i,:)=fore_hist_n;   % get current frame foreground histogram
    back_hist_matrix(i,:)=back_hist_n;   % get current frame background histogram
 
    if (updateAppearance==1 & i-startFrame>1)       
        fore_hist=0.95*fore_hist+0.05*fore_hist_n;
        fore_hist=fore_hist/sum(fore_hist);
        back_hist=0.95*back_hist+0.05*back_hist_n;
        back_hist=back_hist/sum(back_hist);
    end
    %  *************************************************************
    if (saveAvi==1)
        % avi=addframe(avi,regristRes); % save registration results which estimates the affine transormation
        avi=addframe(avi,segmentRes);  % save segmentation results which refines the registration results.
    end
end
if (saveAvi==1)
    avi=close(avi);
end