% Processing data from segmentation
%PARAMETERS
number_FOVs = 20; %number of FOVs
channels = ["mCherry","YFP"]; %names of channels
path = "/Users/ali/Desktop/exp1_seg/";

s.mCherry={};
s.YFP = {};

for f=0:number_FOVs-1
    
        channel = "mCherry";
        fov = "xy" + num2str(f,"%03d");

        path_to_data = path+fov+"/"+channel+"/Data/";
        cd(path_to_data)
        list = dir('*.csv');
        filenames = string({list.name});        
        for i = 1:length(filenames)
            T = readtable(filenames(i)); % read the results as a table
            A = table2array(T); % convert table to an array
            %A(:,9) = max(A(:,9)) - A(:,9); % invert the y axis for trenches at the bottom
            A_t_y_sorted=sortrows(A,[28,9]);% sort the data in time, and then y-axis position
            
            % tracking mother-cell
            t_diff = vertcat(1,diff(A_t_y_sorted(:,28)));% finding when a mother appeared in different frame
            A_m = A_t_y_sorted(find(t_diff),:);% ordering with y, to get mothers on top
            data{c,end+1} = A_m;
        end
    
    "FOV "+(f+1)+"/"+number_FOVs
end