function [phi,TrackRes,p]=seg_JRACS(RGB,I,phi,noFrame,epislon_seg,fore_hist,back_hist,max_iter_num,nBin,lamda_segment,...
    saveTrackBmp,backgroundRatio,backgroundCurve,pxphipy,Pf,Pb)
%*************************************************************************
% Function：tracking result in the segmentation step
% Parameters:
%   RGB：tracked frame;
%   I：
%   noFrame:frame number
%   epislon_seg：
%   fore_hist：
%   back_hist：
%   phi：level set
%   max_iter_num: max iteration number
%   nBin：
%   lamda_segment：weights to adjust foreground and background information
%   saveTrackBmp：saving tracking result 1:yes 0:no
%   videoFileName：is used to save tracking result
%   curMode：mode to call get_wfbx_JRACS
%   backgroundRatio: 0-1: the size of background size 
%   thresh_delta_p: convergence threshold of registration step
%   backgroundCurve: 1: draw backgrounnd curve  0: not
% Return：
%   phi：level set of registration result
%   TrackRes: registration result
%   j: iteration number of registration segmentation
% -------------------------------------------
% *************************************************************************

flag=1;
oldphi = phi>=0;
for p=1:max_iter_num
    if flag==0
        break;
    end
    [band_x,band_y]=find(phi<=5 & phi>=-5);
    [fore_hist,back_hist,WF,WB,ind_x,ind_y,uv,border]=get_fore_back_hist_JRACS(I,phi,nBin,1,backgroundRatio);

%     求解 P（yi|Mf） P(yi|Mb)in article
    [PMf,PMb] = caculate_P(I,fore_hist,back_hist,band_x,band_y,nBin);
    [nf,nb,~] = caculate_n(phi,band_x,band_y,1);
    
    % 根据贝叶斯公式 求P(Mf|yi) P(Mb|yi) according to article
    n = nf+nb;
    PMB = nb/n;
    PMF = nf/n;
    PMbB = PMb*PMB./(PMb*PMB+PMf*PMF);
    PMbF = PMf*PMF./(PMb*PMB+PMf*PMF);
    %求P(xi|phi,p,Mf) p(xi|phi,p,Mb)
    H = Heaviside(phi,1,band_x,band_y);
    PxMf = H/nf;
    PxMb = (1-H)/nb;
    %求P（xi|phi,p,yi） 
    size(PxMf)
    size(PMbF)
    Pxpyf = PxMf.*PMbF';
    Pxpyb = PxMb.*PMbB';
    
    sum(Pxpyf+Pxpyb);
    
   
    Pf = PMf./(nf*PMf+nb*PMb);
    Pb = PMb./(nf*PMf+nb*PMb);
    pxphipy = H.*(PMf./(nf*PMf+nb*PMb))' + (1-H).*(PMb./(nf*PMf+nb*PMb))';
    
    [Delta_h delta_s] = Delta2(phi,epislon_seg,band_x,band_y);


    diff=Delta_h(:).*((Pf(:)-Pb(:))./pxphipy(:));
    
    Lall = del2(phi);
    num = size(Delta_h,2);
    t12345 = size(Delta_h,1);
    for s1 = 1:num
        L(s1) = Lall(band_x(s1),band_y(s1));
        L(s1);
        s1;
    end
    Call = curvature(phi);
    for s1 = 1:num
        C(s1) = Call(band_x(s1),band_y(s1));
    end
    diff = diff - 1/50*(L(:) - C(:));
    t=1/max(abs(diff));
%     if mod(p,5)==1
%         oldphi=phi>=0;
%     end
    for p_n=1:size(Delta_h,1)
        phi(band_x(p_n),band_y(p_n))= phi(band_x(p_n),band_y(p_n))+t*diff(p_n);
    end
 
    for f=1:2
        phi=phi+0.24*4*del2(phi);
    end
    
    set(gcf,'DoubleBuffer','on');
    if (mod(p,5)==0)
        TrackRes=makeTrackingRes(RGB,phi,border,1);
        imshow(TrackRes);
        title(strcat(num2str(noFrame),' segment:',num2str(p),'/',num2str(max_iter_num)));
        drawnow
        
        % is it convergenced?
        newphi=(phi>=0);
        
        num=sum(abs(newphi(:)));
        num2 = sum(abs(oldphi(:)));
        if (abs(num/num2-1)<=0.1 || p==max_iter_num)       
            flag=0;
        end
    end    
end

Mask=zeros(size(phi));
Mask(phi>=0)=1;
phi = -mask2phi(Mask);
phi=reg_levelset(phi);

TrackRes=makeTrackingRes(RGB,phi,border,backgroundCurve);
tt1=getprefix(noFrame,10,100);
tt2=getprefix(p,0,100);
imwrite(TrackRes,['.\registration and segmentation\','_im',tt1,num2str(noFrame),'_seg_',tt2,num2str(p),'.jpg']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% phi = phi;
% TrackRes = 0;
% p = 0;