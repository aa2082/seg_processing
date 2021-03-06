clearvars -except data
plot_lt = false;
dir_save = '/Users/ali/Desktop/lt_graphs/';
dir_workspace = "/Users/ali/seg_processing/";
n_m = size(data,1);
x_t = 1:721;
res = 0.01;
x_sp = 1:res:721;
% When calculating the growth rate, linear fitting is used on the observed
% datapoints in a lifetime range found from interpolating the data. Often
% there is miss segmentation towards the beginning or end of growth, so
% this variable determines how many observations at the beginning and end
% of a cell's lifetime are not used for linear fitting
n_l_trim_gr_fit = 1;
n_r_trim_gr_fit = 1; 

lt_data = {};
lt_results = struct;
lt_results.mother_cell_number = [];
lt_results.lifetime_number = [];
lt_results.division_time = [];
lt_results.rfp_intensity = [];
lt_results.yfp_intensity = [];
lt_results.number_of_observations = [];
lt_results.r2 = [];
lt_results.poly_fit = [];
lt_results.growth_rate = [];
for cell_num=1:n_m
    cell = log(data(cell_num,:,2));
    sp = spline(x_t,cell,x_sp);
    der = -diff(sp)./res; %derivative of log area interpolation
    [pk,loc] = findpeaks(der,'MinPeakHeight',0.4,'MinPeakDistance',5/res); %finding intervals from peaks in der
    
    lt_window = [x_sp(loc(1:end-1)).',x_sp(loc(2:end)).'];
    for a = 1:size(lt_window,1)
        lt_results.mother_cell_number(end+1,1)= cell_num;
        lt_results.lifetime_number(end+1,1)= a;

        c_data = squeeze(data(cell_num,:,:));
        lt_data{end+1,1} = c_data((lt_window(a,1)<c_data(:,28) & lt_window(a,2)>c_data(:,28)),:);
        lt_results.division_time(end+1,1) = lt_data{end,1}(end,28)-lt_data{end,1}(1,28);
        
        lt_results.rfp_intensity(end+1,1) = nanmean(lt_data{end,1}(:,23));
        lt_results.yfp_intensity(end+1,1)= nanmean(lt_data{end,1}(:,36));

        lt_results.number_of_observations(end+1,1) = size(lt_data{end,1},1);
        %range of observations used for growth rate calculation
        range_for_gr = n_l_trim_gr_fit+1:size(lt_data{end,1},1)-n_r_trim_gr_fit;
        if(length(range_for_gr)>1) %need more than one point of interest for linear interpolation
            x = lt_data{end,1}(range_for_gr,28);
            y = log(lt_data{end,1}(range_for_gr,2));

            p = polyfit(x,y,1);
            yfit = polyval(p,x);
            
            SStot = sum((y-mean(y)).^2);                  
            SSres = sum((y-yfit).^2);      
            Rsq = 1-SSres/SStot;
        
            lt_results.poly_fit(end+1,:) = p;
            lt_results.growth_rate(end+1,1) = p(1,1);
            lt_results.r2(end+1,1) = Rsq;
        else
            lt_results.poly_fit(end+1,1) = nan;
            lt_results.growth_rate(end+1,1) = nan;
            lt_results.r2(end+1,1) = nan;

        end
        if(plot_lt==true)
            run(dir_workspace+"single_lt_graph.m");
        end
    end
end
clearvars -except data lt_data lt_results

    