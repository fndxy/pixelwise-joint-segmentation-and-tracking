pii=(2/pi);
i=-50:50
epsilon=1.5;
y1=(0.5*(1+ pii*atan(i)./epsilon)).^2;
plot(i,y1,'b');
%epsilon=1.5;
%y2=0.5*(1+ pii*atan(i)./epsilon);
%hold on;
%plot(i,y2,'r');