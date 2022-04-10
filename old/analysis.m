%load lt_data.mat
close all
threshold = 200;
id_YFP = (all_inten_t>threshold);
id_noYFP = (all_inten_t<=threshold);
clf

figure('visible','on');

% Growth Rates
figure(1)
hold on
sgtitle("Growth Rate Distributions")
%subplot(2,1,1)
yfp=all_growth_rates(id_YFP);
m_yfp = mean(yfp(yfp<.1));
std_yfp = std(yfp(yfp<.1));
E = 0:0.004:0.12;
[N,edges] = histcounts(yfp,E,'Normalization','probability');
bar(E(1:end-1)+0.002,N,'yellow','FaceAlpha',0.2)
%xlim([0,.2])
%title("ampR:YFP - μ = "+m_yfp+"; σ = "+std_yfp+"; N = "+length(yfp))

%subplot(2,1,2)
noyfp=all_growth_rates(id_noYFP);
m_noyfp = mean(noyfp(yfp<.1));
std_noyfp = std(noyfp(yfp<.1));
[N2,edges] = histcounts(noyfp,E,'Normalization','probability');
bar(E(1:end-1)+0.002,N2,'red','FaceAlpha',0.2)
title("RFP - μ = "+m_noyfp+"; σ = "+std_noyfp+"; N = "+length(noyfp))
hold off

%division time distributions
figure(2)
nbin = 300;
sgtitle(["Division Time Distributions","nbins = "+nbin])
subplot(2,1,1)
yfp=all_div_times(id_YFP);
m_yfp = mean(yfp);
std_yfp = std(yfp);
histogram(yfp,nbin,'FaceColor','yellow');
xlim([0,60])
title("ampR:YFP - μ = "+m_yfp+"; σ = "+std_yfp+"; N = "+length(yfp))

subplot(2,1,2)
noyfp=all_div_times(id_noYFP);
m_noyfp = mean(noyfp);
std_noyfp = std(noyfp);
histogram(noyfp,nbin,'FaceColor','red');
xlim([0,60])
title("RFP - μ = "+m_noyfp+"; σ = "+std_noyfp+"; N = "+length(noyfp))

%mean ycm histogram
figure(3)
ycm_mean_lt = [];
for lt=1:length(cell_prop_lt)
    ycm_mean_lt = [ycm_mean_lt; nanmean(cell_prop_lt{1,lt}(:,11))];
end
histogram(ycm_mean_lt)
title("histogram of mean ycm for all cell lifetimes")
xlabel("mean ycm in pixels - trench length is 1100px")

%mean ycm histogram for different populations
figure(4)
nbin = 100;
sgtitle(["mean ycm histogram for the two populations","nbins = "+nbin])
subplot(2,1,1)
yfp=ycm_mean_lt(id_YFP);
m_yfp = mean(yfp);
std_yfp = std(yfp);
histogram(yfp,nbin,'FaceColor','yellow');
xlim([0,1100])
title("ampR:YFP - μ = "+m_yfp+"; σ = "+std_yfp+"; N = "+length(yfp))

subplot(2,1,2)
noyfp=ycm_mean_lt(id_noYFP);
m_noyfp = mean(noyfp);
std_noyfp = std(noyfp);
histogram(noyfp,nbin,'FaceColor','red');
xlim([0,1100])
title("RFP - μ = "+m_noyfp+"; σ = "+std_noyfp+"; N = "+length(noyfp))

% y_ranges = [0,200;200 400; 400 600; 600 800; 800 1000];
% y_m = [];
% y_std = [];
% y_N = [];
% for ycm = 1:length(y_ranges)
%     figure
%     id1 = (ycm_mean_lt>=y_ranges(ycm,1) & ycm_mean_lt<=y_ranges(ycm,2) & all_inten_t>threshold);
%     subplot(2,1,1)
%     yfp=all_growth_rates(id1);
%     m_yfp = mean(yfp);
%     std_yfp = std(yfp);
%     histogram(yfp,'FaceColor','yellow');
%     %xlim([0,.2])
%     title(["ampR:YFP","range = "+ y_ranges(ycm,:),"μ = "+m_yfp+"; σ = "+std_yfp+"; N = "+length(yfp)])
%     
%     id2 = (ycm_mean_lt>=y_ranges(ycm,1) & ycm_mean_lt<=y_ranges(ycm,2) & all_inten_t<=threshold);
%     subplot(2,1,2)
%     noyfp=all_growth_rates(id2);
%     m_noyfp = mean(noyfp);
%     std_noyfp = std(noyfp);
%     histogram(noyfp,'FaceColor','red');
%     %xlim([0,.2])
%     title(["YFP","range = "+ y_ranges(ycm,:),"μ = "+m_noyfp+"; σ = "+std_noyfp+"; N = "+length(noyfp)])
%     y_N = [y_N; length(yfp),length(noyfp)];
%     y_m = [y_m; m_yfp,m_noyfp];
%     y_std = [y_std; std_yfp,std_noyfp];
% end

y_ranges = [transpose(0:900),transpose(200:1100)];
y_m = [];
y_std = [];
y_N = [];
for ycm = 1:length(y_ranges)
    id1 = (ycm_mean_lt>=y_ranges(ycm,1) & ycm_mean_lt<=y_ranges(ycm,2) & all_inten_t>threshold);
    yfp=all_growth_rates(id1);
    m_yfp = mean(yfp);
    std_yfp = std(yfp);
    
    id2 = (ycm_mean_lt>=y_ranges(ycm,1) & ycm_mean_lt<=y_ranges(ycm,2) & all_inten_t<=threshold);
    noyfp=all_growth_rates(id2);
    m_noyfp = mean(noyfp);
    std_noyfp = std(noyfp);

    y_N = [y_N; length(yfp),length(noyfp)];
    y_m = [y_m; m_yfp,m_noyfp];
    y_std = [y_std; std_yfp,std_noyfp];
end
figure(5)
sgtitle("mean growth rate of cells in rolling forward window of 200px")
hold on
plot(0:900,y_m(:,1),'red')
%plot(0:900,y_std(:,1)./sqrt(y_N(:,1)),'black')
xlim([0 900])
xlabel("ycm at start of window")
ylabel("mean growth rate of window")
%title("RFP")
%set(gca,'color',0.8*[1 1 1])
%legend(["mean gr", "std error: σ/sqrt(N)"],'Location','best')
%hold off

%subplot(2,1,2)
hold on
plot(y_m(:,2),'yellow')
%plot(y_std(:,2)./sqrt(y_N(:,2)),'black')
set(gca,'color',0.8*[1 1 1])
xlabel("ycm at start of window")
ylabel("mean growth rate of window")
title("ampR:YFP")
legend(["mean gr", "std error: σ/sqrt(N)"],'Location','best')
xlim([0 900])
hold off