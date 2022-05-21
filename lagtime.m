function [lagt] = lagtime(max_gr,log_area)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    div_threshold = 0.2;
    gr = diff(log_area);
    gr(abs(gr)>div_threshold)=0;
    csum = cumsum(gr);
    lagt = (0:719) - cumsum(gr)/max_gr;


%     smooth_lagt =  smoothdata(lagt,'gaussian');
%     findpeaks(diff(smooth_lagt),"SortStr",'descend','MinPeakDistance',100)
%     [pks,locs] = findpeaks(diff(smooth_lagt),"SortStr",'descend','MinPeakDistance',10);
%     loc_exp = locs(1);
%     lag_to_exp = lagt(loc_exp);
end