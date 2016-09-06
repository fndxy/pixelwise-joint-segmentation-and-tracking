function [phi,TrackRes,j]=registration_JRACS(RGB,I,noFrame,epislon_reg,fore_hist,back_hist,phi,iter_num,nBin,saveTrackBmp,...
    lamda_registration,backgroundRatio,thresh_delta_T,backgroundCurve)
% *************************************************************************
% Function£ºget registration result, i.e, estimate the affine transformation result
% Parameters:
%   RGB£ºtracked frame;
%   I£º
%   noFrame:frame number
%   epislon_reg£º
%   fore_hist£º
%   back_hist£º
%   phi£ºlevel set
%   iter_num: max iteration number
%   nBin£º
%   saveTrackBmp£ºsaving tracking result 1:yes 0:no
%   lamda_registration£ºweights to adjust foreground and background information
%   curMode£ºmode to call get_wfbx_JRACS
%   backgroundRatio: 0-1: the size of background size 
%   thresh_delta_T: convergence threshold of registration step
%   backgroundCurve: 1: draw backgrounnd curve  0: not
% Return£º
%   phi£ºlevel set of registration result
%   TrackRes: registration result
%   j: iteration number of registration segmentation
% -------------------------------------------
% *************************************************************************

old_delta_T=zeros(6,1);  % 

flag=0;   % flag variable whether algorithm is convergence. 1: convergenced 0: no
set(gcf,'DoubleBuffer','on');               % set DoubleBuffer
for j=1:iter_num
    % get foreground and background histogram of current frame   
    [fore_hist_n,back_hist_n,WF,WB,row,col,uv,border]=get_fore_back_hist_JRACS(I,phi,nBin,epislon_reg,backgroundRatio);    
   
    H=zeros(size(row));
    H= Heaviside(phi,epislon_reg,row,col);    % calculate the heaviside function H (refer to fig.2)   
    Delta_h = Delta(phi,epislon_reg,row,col); % the first term of right hand in the Eq.(20)
    gra =get_gradv(phi,col,row); % calculate the second term of the right hand in the Eq.(20)
       
    [Wfx,Wbx]=get_wfbx_JRACS(I,phi,row,col,WF,WB,fore_hist,fore_hist_n,back_hist,back_hist_n,H,nBin,lamda_registration);
    dwdp_v=get_dwdp_v(col,row);  % calculate the third term of the right hand in the  Eq.(20)   

    J= get_J(Delta_h,gra,dwdp_v); % calculate J in the Eq.(20)  
    
    % calculate the first term of the right hand in the Eq.(23)
    cs=0.5*(Wfx(:)./(H(:)+eps)+Wbx(:)./(1-H(:)+eps));  

    cs=cs';
    cs = repmat(cs,6,1);
    JT=J';
    temp=cs.*JT;
    fir_term=temp*J(:,:);
    temp=Wfx(:)-Wbx(:);
    temp=temp';
    temp= repmat(temp,6,1);
    temp=temp.*J';
    sec_term=sum(temp,2);

    % delta_T is the registration matrix used to estimate the affine transformation of the target
     
    
    delta_T=-(fir_term)\(sec_term+eps);

    % The algorithm convergence while the |delta_T0|<thresh_delta_T
    conv_delta_T=norm(delta_T);   
    if (conv_delta_T<thresh_delta_T)
        flag=1;
    else
        old_delta_T=delta_T;
    end;
    
    delta_T = reshape(delta_T, 2, 3)  
    % update the level set in the narrowband  
    [row,col] = find(phi>=-3*border);
    uv_new=[col,row];
    
    % updated target contour by estimated affine matrix
    [phi,uv]=update_phi2(phi,delta_T,uv_new,border);  
    
    TrackRes=makeTrackingRes(RGB,phi,border,1);
    imshow(TrackRes);
    title(strcat(num2str(noFrame),':registration:',num2str(j),'/',num2str(iter_num)));drawnow;
    
    if ((j==iter_num | flag==1) & saveTrackBmp==1)        % save final registration result                               
        TrackRes=makeTrackingRes(RGB,phi,border,backgroundCurve);
        tt1=getprefix(noFrame,10,100);                    % 
        tt2=getprefix(j,0,100);                           % 
        imwrite(TrackRes,['.\registration and segmentation\','_im',tt1,num2str(noFrame),'_reg_',tt2,num2str(j),'.jpg']);
    end
    hold off; 
    
    % the level set is free re-initialization
    for i=1:2
       phi=phi+0.2*4*del2(phi);
    end
    
    if (flag==1)
        break;
    end
end
Mask=zeros(size(phi));
Mask(phi>=0)=1;
phi = -mask2phi(Mask);
phi=reg_levelset(phi);