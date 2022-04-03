num_cells = 1:5;
dir_save = '/Users/ali/Desktop/test';
for f=0:19

    fov = "xy"+num2str(f,'%03d');
    tr = 3;
    
    
    path_to_data_seg = '/Users/ali/Desktop/exp1_seg_2/'+fov+'/Data/data_'+fov+'_tr_'+tr+'_mCherry.csv'; 
    path_to_data_info = '/Users/ali/Desktop/exp1_seg_2/'+fov+'/Data/data_'+fov+'_tr_'+tr+'_YFP.csv';  
    seg = table2array(readtable(path_to_data_seg,'VariableNamingRule','preserve')); % convert table to an array
    info = table2array(readtable(path_to_data_info,'VariableNamingRule','preserve'));
    A = [seg,info(:,[23,27])];
    
    A=sortrows(A,28);% sort the data in time, and then y-axis position
    data = nan(721,length(num_cells),37);
    for t=1:721
        cur = A(find(A(:,28)==t),:);
        cells_in_cur = size(cur,1);
        cur = sortrows(cur,11,"ascend");
        data(t,1:cells_in_cur,:) = cur(1:cells_in_cur,:);
    end
    
    clf
    figure(1)
    subplot(3,1,1)
    hold on
    for cell=num_cells
        cell = squeeze(data(:,cell,:));
        cell = cell(find(log(cell(:,2))>5),:);
        plot(log(cell(:,2)))
        [ph,lh] = findpeaks(abs(diff(log(cell(:,2)))),"threshold",0.25,'MinPeakDistance',5);
        scatter(lh,log(cell(lh,2)),'o');
        scatter(lh+1,log(cell(lh+1,2)),'b*');
    end
    hold off
    ylim([5 8])
    xlim([400 721])
    title("log(area)")
    subplot(3,1,2)
    hold on
    mean_inten_t = [];
    for cell=num_cells
        cell = squeeze(data(:,cell,:));
        %plot(log(cell(:,37)))
        plot(cell(:,36))
        mean_inten_t = [mean_inten_t,nanmean(cell(:,36))];
    end
    title("IntDen - YFP")
    ylim([0, 10000])
    legend(string(num_cells));
    hold off
    cd(dir_save)
    subplot(3,1,3)
    bar(mean_inten_t)
    ylim([0 1000])
    saveas(gcf,fov+"_"+tr+".png")
    pause(1)
    close
end