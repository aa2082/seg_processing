close all
cell = log(data(1,:,2));
x = 1:721;
res = 0.01;
x_sp = 1:res:721;
sp = spline(1:721,cell,x_sp);

figure
hold on
scatter(x,cell,10,'filled');
plot(x_sp,sp);
hold off

der = -diff(sp)./res;
figure 
plot(der)

figure
[pk,loc] = findpeaks(der,'MinPeakHeight',0.4);

hold on
scatter(x,cell,5,'filled');
scatter(x_sp(loc),sp(loc),'*');
hold off
div_time = diff(loc).*res;
c = corr(div_time(1:end-1),div_time(2:end));

lt_windows = [loc(1:end-1).',loc(2:end).'].*res;

