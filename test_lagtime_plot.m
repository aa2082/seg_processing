range_fit = 200:700;
lagt = lagtime(0.06,log(data(1,:,2)));
p = polyfit(range_fit,lagt(1,range_fit),1);
fit = polyval(p,1:720);
clf
hold on
plot(lagt);
plot(1:720,fit);
x0 = interp1(fit,1:720,0)
hold off
