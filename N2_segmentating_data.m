dir_save = "/Users/ali/Desktop/mother_cell_segmentation";
delta_t = 2; %time between aquisitions
save_fig = true;
peak_prom = 0.3; %previously 0.5

min_r2 = 0.9;
max_r2 = 1.0;
min_gr = 0;
max_gr = 0.6;
min_dt = 18;
max_dt = 60;
min_n_obs = 4;

g = []; % store g values
n_m = size(data,1);


r2 = nan(n_m,1);
poly_fit = nan(n_m,1,2);
growth_rate = nan(n_m,1);
division_time = nan(n_m,1);
rfp = nan(n_m,1);
yfp = nan(n_m,1);

lt_data = {n_m,1};

v_keep = [];
v_r2 = [];
v_poly_fit = [];
v_growth_rate = [];
v_division_time = [];
v_rfp = [];
v_yfp = [];
v_number_of_observations = [];

v_lt_data = [];


for i = 1:n_m
    clf
    a = data(i,:,2);
    close all
    figure(1); plot(log2(a),'+'); hold on;

    % cleaning up segmentation errors

    plot(log2(a),'k'); hold on;
    [~,lc_pre_div] =findpeaks(-diff(log2(a)),'MinPeakDistance',5,'MinPeakProminence',peak_prom);
    lc_post_div = lc_pre_div+1;

    % check for correct division points. 
    for i_ck = 1:length(lc_post_div)
        i_prediv = lc_pre_div(i_ck);
        i_postdiv = lc_post_div(i_ck);
        if a(i_postdiv)>0.8*a(i_prediv)
           lc_post_div(i_ck) = lc_post_div(i_ck)+1;
        end
    end

    % selecting pre and post division points
    lc_pre_div = lc_pre_div(2:end);
    lc_post_div = lc_post_div(1:end-1);

    plot(lc_pre_div, log2(a(lc_pre_div)), '^m')
    plot(lc_post_div, log2(a(lc_post_div)), 'om')


    for i_div = 1:length(lc_pre_div)
        x = lc_post_div(i_div):1:lc_pre_div(i_div);
        y = log2(a(x));
        p = polyfit(x,y,1);
        yfit = polyval(p,x);
        
        g = [g,p(1)];
        gr = p(1)/delta_t;
        dt = (x(end)-x(1))*delta_t;
        n_obs = length(x);
        
        SStot = sum((y-mean(y)).^2);                  
        SSres = sum((y-yfit).^2);      
        Rsq = 1-SSres/SStot;
        
        %lifetime values - stored as matrices - (mother_cell_number x lifetime) 
        poly_fit(i,i_div,:) = p;
        growth_rate(i,i_div) = gr;
        r2(i,i_div) = Rsq;
        lt_data{i,i_div} = data(i,x,:);
        rfp(i,i_div) = nanmean(data(i,x,23));
        yfp(i,i_div) = nanmean(data(i,x,36));

        v_poly_fit(end+1,:) = p;
        v_growth_rate(end+1,1) = p(1);
        v_r2(end+1,1) = Rsq;
        v_lt_data{end+1,1} = data(i,x,:);
        v_rfp(end+1,1) = nanmean(data(i,x,23));
        v_yfp(end+1,1) = nanmean(data(i,x,36));
        v_division_time(end+1,1) = dt;
        v_number_of_observations(end+1,1) = n_obs;

        if(...
                Rsq>min_r2 & Rsq<max_r2&...
                gr>min_gr & gr<max_gr&...
                dt>min_dt & dt<max_dt&...
                n_obs>min_n_obs...
                )
            plot(x,yfit,'g')
            v_keep(end+1,1) = 1;
        else
            plot(x,yfit,'r')
            v_keep(end+1,1) = 0;
        end
    end
    %more lifetime values that don't need to be stored in the loop
    division_time(i,1:length(lc_pre_div)) = lc_pre_div(:)-lc_post_div(:);
    if save_fig
        export_fig(dir_save+"/"+i+".png")
    end
    %hgsave(gcf,dir_save+"/"+i+".fig",'-v7');
    (i/n_m)*100+"%"
end
v_keep = logical(v_keep);
results = table(poly_fit,growth_rate,division_time,r2,lt_data,rfp,yfp);
v_results = table(v_poly_fit,v_growth_rate,v_division_time,v_r2,v_lt_data,v_rfp,v_yfp,v_number_of_observations,v_keep);
clearvars -except data results v_results all_fiji_data keep