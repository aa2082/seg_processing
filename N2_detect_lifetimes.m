clearvars -except data
plot_lt = false;
dir_save = '/Users/ali/Desktop/lt_graphs/';
dir_workspace = "/Users/ali/seg_processing/";
n_m = size(data,1);
x = 1:721;
res = 0.01;
x_sp = 1:res:721;
% When calculating the growth rate, linear fitting is used on the observed
% datapoints in a lifetime range found from interpolating the data. Often
% there is miss segmentation towards the beginning or end of growth, so
% this variable determines how many observations at the beginning and end
% of a cell's lifetime are not used for linear fitting
n_l_trim_gr_fit = 1;
n_r_trim_gr_fit = 1; 

%div_t = [];
div_t = {};
c = [];
lt_data = {};
lt_results = {};
for cell_num=1:n_m
    cell = log(data(cell_num,:,2));
    sp = spline(x,cell,x_sp);
    der = -diff(sp)./res; %derivative of log area interpolation
    [pk,loc] = findpeaks(der,'MinPeakHeight',0.4,'MinPeakDistance',5); %finding intervals from peaks in der
%     
%     dt = diff(loc).*res;
%     %div_t=[div_t,dt]; %div times are differences between interval seperators 
%     div_t{end+1} = dt;
%     mot = dt(1:end-1);
%     dau = dt(2:end);
%     c = [c;mean((mot-mean(mot)).*(dau-mean(dau)))./(std(mot)*std(dau))];
    
    lt_window = [x_sp(loc(1:end-1)).',x_sp(loc(2:end)).'];
    for a = 1:length(lt_window)
        %"cell# "+cell_num + " lt# " + a
        c_data = squeeze(data(cell_num,:,:));
        lt_data{cell_num,a} = c_data((lt_window(a,1)<c_data(:,28) & lt_window(a,2)>c_data(:,28)),:);
        lt_results{cell_num,a}.divt = lt_data{cell_num,a}(end,28)-lt_data{cell_num,a}(1,28);
        
        %range of observations used for growth rate calculation
        range_for_gr = n_l_trim_gr_fit+1:size(lt_data{cell_num,a},1)-n_r_trim_gr_fit;
        if(length(range_for_gr)>1) %need more than one point of interest for linear interpolation
            lt_results{cell_num,a}.p_fit = polyfit(lt_data{cell_num,a}(range_for_gr,28),log(lt_data{cell_num,a}(range_for_gr,2)),1);
            lt_results{cell_num,a}.gr = lt_results{cell_num,a}.p_fit(1,1);
    
            SS_res = sum(abs(log(lt_data{cell_num,a}(range_for_gr,2))-polyval(lt_results{cell_num,a}.p_fit,lt_data{cell_num,a}(range_for_gr,28))));
            SS_tot = var(log(lt_data{cell_num,a}(range_for_gr,2)))*length(range_for_gr);
            lt_results{cell_num,a}.r2 = 1-(SS_res/SS_tot);
            
            lt_results{cell_num,a}.rfp_intden = nanmean(lt_data{cell_num,a}(:,23));
            lt_results{cell_num,a}.yfp_intden = nanmean(lt_data{cell_num,a}(:,36));
        end
        if(plot_lt==true)
            run(dir_workspace+"single_lt_graph.m");
        end
    end
end
clearvars -except data lt_data lt_results

    