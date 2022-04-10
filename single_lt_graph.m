close all
test = false; % set to true of not using to save all lifetimes using N2

if(test==true)
    dir_save = '/Users/ali/Desktop/lt_graphs/';
    f=figure('visible','on');
end
if(test==false)
    f=figure('visible','off');
end
cd(dir_save)


clf
fig_overhang = 5;

hold on
%limit xrange to lt of interest
xlim([lt_data{cell_num,a}(1,28)-fig_overhang,lt_data{cell_num,a}(end,28)+fig_overhang])

plot(x_sp,sp); %plot the spline interpolation
scatter(x_sp(loc),sp(loc),'*'); %plot the spline interpolation

%plot the observed datapoints
scatter(lt_data{cell_num,a}(:,28),log(lt_data{cell_num,a}(:,2)),20,'filled')

range_for_gr = n_l_trim_gr_fit+1:size(lt_data{cell_num,a},1)-n_r_trim_gr_fit;
scatter(lt_data{cell_num,a}(range_for_gr,28),log(lt_data{cell_num,a}(range_for_gr,2)),40,'filled')

%plot the fit
plot(lt_data{cell_num,a}(:,28),polyval(lt_results{cell_num,a}.p_fit,lt_data{cell_num,a}(:,28)))

legend(["spline interpolation","lt segmentation from interpolation",...
         "all observed data","observed data used for linear fit","linear fit"],'Location','Best')

title(["cell#: "+num2str(cell_num)+"     lifetime#: "+num2str(a),...
    "growth rate: "+num2str(lt_results{cell_num,a}.gr),...
    "r2: "+num2str(lt_results{cell_num,a}.r2)])
hold off
if(test==false)
    saveas(gcf,cell_num+"_"+a+".png")
end

