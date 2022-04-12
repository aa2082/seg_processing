close all
test = false; % set to true of not using to save all lifetimes using N2
lt = false;
if(lt)
    size_dot = 20;
else
    size_dot = 10;
end
cell_of_intrest = 1;
lifetime_of_interest = 1;
if(test==true)
    dir_save = '/Users/ali/Desktop/cell_graphs/';
    f=figure('visible','on');
    cell_num = cell_of_intrest;
    a = lifetime_of_interest;
    index = find((lt_results.mother_cell_number==cell_num...
            & lt_results.lifetime_number==a)==1);
end
if(test==false)
    f=figure('visible','off');
    index = length(lt_results.mother_cell_number);
end
cd(dir_save)


clf
fig_overhang = 5;

hold on
if(lt)
    %limit xrange to lt of interest
    xlim([lt_data{index,1}(1,28)-fig_overhang,lt_data{index,1}(end,28)+fig_overhang])
end

plot(x_sp,sp); %plot the spline interpolation
scatter(x_sp(loc),sp(loc),'*'); %plot the spline interpolation

%plot the observed datapoints
scatter(lt_data{index,1}(:,28),log(lt_data{index,1}(:,2)),size_dot,'filled')

range_for_gr = n_l_trim_gr_fit+1:size(lt_data{index,1},1)-n_r_trim_gr_fit;
scatter(lt_data{index,1}(range_for_gr,28),log(lt_data{index,1}(range_for_gr,2)),size_dot*2,'filled')

%plot the fit
plot(lt_data{index,1}(:,28),polyval(lt_results.poly_fit(index,:),lt_data{index,1}(:,28)))

legend(["spline interpolation","lt segmentation from interpolation",...
         "all observed data","observed data used for linear fit","linear fit"],'Location','Best')

title(["cell#: "+num2str(cell_num)+"     lifetime#: "+num2str(a),...
    "growth rate: "+num2str(lt_results.growth_rate(index,1)),...
    "r2: "+num2str(lt_results.r2(index,1))])
hold off
if(test==false)
    saveas(gcf,cell_num+"_"+a+".png")
end

