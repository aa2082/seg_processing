g = []; % store g values
for i = 1:1 %CHANGED FROM: size(A_bg,2)
    a = data(1,:,2);    %CHANGED FROM: a = A_bg(:,i);
    close all
    figure(1); plot(log2(a),'+'); hold on;

    % cleaning up segmentation errors

    [~,lc_e_t1] = findpeaks(a,'Threshold',1);% locating error type 1, joining divided cells
    for it1 = 1:length(lc_e_t1)
        a(lc_e_t1) = (a(lc_e_t1-1)+a(lc_e_t1+1))/2;
    end


    [~,lc_e_t2] = findpeaks(max(a)-a,'Threshold',1);% locating error type 2, cutting cells in halves
    for it2 = 1:length(lc_e_t2)
        a(lc_e_t2) = (a(lc_e_t2-1)+a(lc_e_t2+1))/2;
    end


    plot(log2(a),'k'); hold on;
    [~,lc_pre_div] =findpeaks(a,'MinPeakDistance',5,'MinPeakProminence',1);
    lc_post_div = lc_pre_div+1;

    % check for correct division points. 
    for i_ck = 1:length(lc_post_div)
        i_prediv = lc_pre_div(i_ck);
        i_postdiv = lc_post_div(i_ck);
        if a(i_postdiv)>0.8*a(i_prediv)
           lc_post_div(i_ck) = lc_post_div(i_ck)+1;
        end
    end

    % selecting pre and post division points
    lc_pre_div = lc_pre_div(2:end);
    lc_post_div = lc_post_div(1:end-1);

    plot(lc_pre_div, log2(a(lc_pre_div)), '^m')
    plot(lc_post_div, log2(a(lc_post_div)), 'om')


    for i_div = 1:length(lc_pre_div)
        x = lc_post_div(i_div):1:lc_pre_div(i_div);
        y = log2(a(x));
        p = polyfit(x,y,1);
        yfit = polyval(p,x);
        plot(x,yfit,'r')
        g = [g,p(1)];
    end
    pause(0.05);
end

