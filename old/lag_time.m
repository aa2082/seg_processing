close all
figure('visible','on');
cell1 = squeeze(data(1,:,:));
cell1_gr = lt_results.growth_rate(lt_results.mother_cell_number==1);
lamda_max = mean(cell1_gr);
cell_divide = int16(lt_window(:,1));

lag_t = (2:721)' - cumsum(diff(log(cell1(:,2))))/lamda_max;

for i=1:length(cell_divide)
    t_div = cell_divide(i)-1;
    lag_t(t_div:720,1) = (double(t_div+1):721)' - cumsum(diff(log(cell1(t_div:end,2))))/lamda_max;
end

hold on
plot(lag_t);
scatter(cell_divide,lag_t(cell_divide),'filled');
hold off