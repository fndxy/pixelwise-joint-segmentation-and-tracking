function tt=getprefix(i,ge,bai)

if (i<ge)
    tt='00';
elseif (i<100)
    tt='0';
else
    tt=[];
end