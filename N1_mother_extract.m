clear all
path_to_seg_results = '/Users/ali/Desktop/exp1_seg_gif_with_roi/';
dir_save = '/Users/ali/Desktop/test3'; %directory to save figures to
min_cell_log_area = 5;
n_trenches = 8*ones(1,20);
n_trenches(1,3) = 7;
n_trenches(1,17) = 7;
n_cells = sum(n_trenches);
data = nan(n_cells,721,37);
cell = 1;
for f=0:19 %iterating over FOVs
    fov = "xy"+num2str(f,'%03d'); %fov name
    for tr=0:n_trenches(1,f+1)
        fov + " tr"+tr
        
        %paths to segmentation "mCherry" csv and info "YFP" csv
        path_to_data_seg = path_to_seg_results+fov+'/Data/data_'+fov+'_tr_'+tr+'_mCherry.csv'; 
        path_to_data_info = path_to_seg_results+fov+'/Data/data_'+fov+'_tr_'+tr+'_YFP.csv';  
        %converting csvs to matrices
        seg = table2array(readtable(path_to_data_seg,'VariableNamingRule','preserve')); % convert table to an array
        info = table2array(readtable(path_to_data_info,'VariableNamingRule','preserve'));
        %taking intensity information from info matrix and adding to end of seg
        %matrix
        A = [seg,info(:,[23,27])];
        clear seg info
        
        A=sortrows(A,28);% sort the data in time
        A=A((log(A(:,2))>min_cell_log_area),:); %remove anything to small
        for t=1:721
            cur = A((A(:,28)==t),:);
            cells_in_cur = size(cur,1);
            cur = sortrows(cur,11,"ascend");
            if(size(cur,1)>0)
                data(cell,t,:) = cur(1,:);
            end
        end
        cell = cell +1;
    end
end

clearvars -except data