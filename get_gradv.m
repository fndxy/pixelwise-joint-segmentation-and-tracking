function  gra =get_gradv(f,ind_x,ind_y)
% get the central different of the narrowband


[Gx,Gy]=gradient(f);
%  
num = size(ind_x);
for i=1:num
    col=ind_x(i);
    row=ind_y(i);
    gra(i,:)=[Gx(row,col),Gy(row,col)];
end