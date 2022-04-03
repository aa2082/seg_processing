load lt_data.mat
threshold = 200;
id_YFP = find(all_inten_t>threshold);
id_noYFP = find(all_inten_t<=threshold);
clf

subplot(2,1,1)
yfp=all_growth_rates(id_YFP);
m_yfp = mean(yfp);
std_yfp = std(yfp);
histogram(yfp,'FaceColor','yellow');
xlim([0,.2])
title("ampR:YFP - μ = "+m_yfp+"; σ = "+std_yfp+"; N = "+length(yfp))

subplot(2,1,2)
noyfp=all_growth_rates(id_noYFP);
m_noyfp = mean(noyfp);
std_noyfp = std(noyfp);
histogram(noyfp,'FaceColor','red');
xlim([0,.2])
title("RFP - μ = "+m_noyfp+"; σ = "+std_noyfp+"; N = "+length(noyfp))