function phi=reg_levelset(phi)

Ind1=find(phi([1:2,end-1:end],:));
Ind2=find(phi(:,[1:2,end-1:end]));

N=size(Ind1,1);
for i=1:N
    if (phi(Ind1(i))>=0)
        phi(Ind1(i))=-10;
    end
end

N=size(Ind2,1);
for i=1:N
    if (phi(Ind2(i))>=0)
        phi(Ind2(i))=-10;
    end
end