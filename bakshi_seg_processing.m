dir_save = "/Users/ali/Desktop/mother_cell_segmentation"
g = []; % store g values
n_m = size(data,1);

r2 = nan(n_m,1);
poly_fit = nan(n_m,1,2);
growth_rate = nan(n_m,1);
division_time = nan(n_m,1);
rfp = nan(n_m,1);
yfp = nan(n_m,1);

lt_data = {n_m,1};

v_r2 = [];
v_poly_fit = [];
v_growth_rate = [];
v_division_time = [];
v_rfp = [];
v_yfp = [];
v_number_of_observations = [];

v_lt_data = [];


for i = 1:n_m
    a = data(i,:,2);
    close all
    figure(1); plot(log2(a),'+'); hold on;

    % cleaning up segmentation errors

    [~,lc_e_t1] = findpeaks(a,'Threshold',1);% locating error type 1, joining divided cells
    for it1 = 1:length(lc_e_t1)
        a(lc_e_t1) = (a(lc_e_t1-1)+a(lc_e_t1+1))/2;
    end


    [~,lc_e_t2] = findpeaks(max(a)-a,'Threshold',1);% locating error type 2, cutting cells in halves
    for it2 = 1:length(lc_e_t2)
        a(lc_e_t2) = (a(lc_e_t2-1)+a(lc_e_t2+1))/2;
    end


    plot(log2(a),'k'); hold on;
    [~,lc_pre_div] =findpeaks(a,'MinPeakDistance',5,'MinPeakProminence',1);
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
        plot(x,yfit,'r')
        g = [g,p(1)];
        
        SStot = sum((y-mean(y)).^2);                  
        SSres = sum((y-yfit).^2);      
        Rsq = 1-SSres/SStot;
        
        %lifetime values - stored as matrices - (mother_cell_number x lifetime) 
        poly_fit(i,i_div,:) = p;
        growth_rate(i,i_div) = p(1);
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
        v_division_time(end+1,1) = x(end)-x(1);
        v_number_of_observations(end+1,1) = length(x);
    end
    %more lifetime values that don't need to be stored in the loop
    division_time(i,1:length(lc_pre_div)) = lc_pre_div(:)-lc_post_div(:);
    %pause(0.05);
    cd(dir_save)
    saveas(gcf,i+".png")
    (i/n_m)*100+"%"
end

results = table(poly_fit,growth_rate,division_time,r2,lt_data,rfp,yfp);
v_results = table(v_poly_fit,v_growth_rate,v_division_time,v_r2,v_lt_data,v_rfp,v_yfp,v_number_of_observations);
clearvars -except data results v_results all_fiji_data