num_cells = 1:5;
dir_save = '/Users/ali/Desktop/test3'; %directory to save figures to
min_cell_log_area = 5;
n_trenches = 8*ones(1,20);
n_trenches(1,3) = 7;
n_trenches(1,17) = 7;

all_growth_rates = [];
all_inten_t = [];

%cell_prop_lt = {}; %cell array where each index is a cell lifetime associated with gr vector

for f=0:19 %iterating over FOVs
    fov = "xy"+num2str(f,'%03d'); %fov name
    for tr=0:n_trenches(1,f+1)
        fov + " tr"+tr
        
        %paths to segmentation "mCherry" csv and info "YFP" csv
        path_to_data_seg = '/Users/ali/Desktop/exp1_seg_2/'+fov+'/Data/data_'+fov+'_tr_'+tr+'_mCherry.csv'; 
        path_to_data_info = '/Users/ali/Desktop/exp1_seg_2/'+fov+'/Data/data_'+fov+'_tr_'+tr+'_YFP.csv';  
        %converting csvs to matrices
        seg = table2array(readtable(path_to_data_seg,'VariableNamingRule','preserve')); % convert table to an array
        info = table2array(readtable(path_to_data_info,'VariableNamingRule','preserve'));
        %taking intensity information from info matrix and adding to end of seg
        %matrix
        A = [seg,info(:,[23,27])];
        clear seg info
        
        A=sortrows(A,28);% sort the data in time
        data = nan(721,length(num_cells),37);
        for t=1:721
            cur = A(find(A(:,28)==t),:);
            cells_in_cur = size(cur,1);
            cur = sortrows(cur,11,"ascend");
            data(t,1:cells_in_cur,:) = cur(1:cells_in_cur,:);
        end
        
        clf
        close
        f = figure('visible','off');
        subplot(2,1,1)
        hold on
        mean_total_inten_t = [];
        for c=num_cells
            cell = squeeze(data(:,c,:));
            ind = find(log(cell(:,2))>min_cell_log_area);
            cell = cell(ind,:);
            plot(log(cell(:,2)))
            if(size(cell,1)>0)
                [ph,lh] = findpeaks(-diff(log(cell(:,2))),"threshold",0.25,'MinPeakDistance',5);
                xh=lh;
                yh=log(cell(lh,2));
                xl=lh+1;
                yl=log(cell(lh+1,2));

                gr=(yh(2:end)-yl(1:end-1))./(xh(2:end)-xl(1:end-1));
                all_growth_rates = [all_growth_rates;gr];
                
                lt_end = xh(2:end);
                lt_start = xl(1:end-1);
                for a=1:length(gr)
                    inten_lifetime = nanmean(cell(lt_start(a,1):lt_end(a,1),36));
                    all_inten_t = [all_inten_t;inten_lifetime];

                    %cell_prop_lt{end+1}=cell(lt_start(a,1):lt_end(a,1),:);
                end
                scatter(xh,yh,'o');
                scatter(xl,yl,'b*');
                total_inten_t = nanmean(cell(:,36));
                mean_total_inten_t = [mean_total_inten_t,total_inten_t];

                


            end
        end
        hold off
        %ylim([5 8])
        xlim([400 721])
        title("log(area)")
        cd(dir_save)
        subplot(2,1,2)
        bar(mean_total_inten_t)
        ylim([0 1000])
        saveas(gcf,fov+"_"+tr+".png")
    end
end