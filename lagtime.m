function [lagtime,lagtime_asym,csum,cv] = lagtime(max_gr,log_area,range_fit)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    div_threshold = 0.2;
    gr = diff(log_area);
    gr(abs(gr)>div_threshold)=0;
    csum = cumsum(gr);
    lagtime = (0:719) - cumsum(gr)/max_gr;
    g
    lagt_in_range = lagtime(1,range_fit);

    lagtime_asym = polyfit(range_fit,lagt_in_range,0);

    cv = std(lagt_in_range-lagtime_asym)/mean(lagt_in_range-lagtime_asym);
end