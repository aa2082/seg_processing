gr_MM = [];
gr_pop = [];
for cell_num = 1:178;
    tau = results.division_time(cell_num,:);
    tau(tau==0) = [];
    
    
    moth_tau = tau(1:end-1);
    daug_tau = tau(2:end);
    c = mean((moth_tau-mean(moth_tau)) .* (daug_tau-mean(daug_tau)))/...
        (std(moth_tau)*std(daug_tau));
    
    p_gr = (2*log(2)/mean(tau))/...
                (...
                    1+sqrt(1-2*log(2)*...
                        (std(tau)/(mean(tau))^2) * ((1+c)/(1-c))...
                    ) ...
                );
    %"mean gr from MM " + mean(results.growth_rate(cell_num,:))+...
    %" p_gr " + p_gr
    gr_MM = [gr_MM, mean(results.growth_rate(cell_num,:))];
    gr_pop = [gr_pop, p_gr];
end
clf
hold on
histogram(gr_MM,20)
histogram(gr_pop,20)
hold off
legend("MM","Pop")