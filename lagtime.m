function [lagtime] = lagtime(max_gr,log_area)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    div_threshold = -0.4;
    gr = diff(log_area);
    gr(gr<div_threshold)=0;
    lagtime = cumsum(gr);
end