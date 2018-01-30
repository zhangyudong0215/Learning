startdata=2007.1;
enddata=2016.4;
dates = linspace(startdata,enddata,length(ddd));

subplot(4,1,1);
plot(dates, aaa, 'color', 'k');
hold on
plot(dates, bbb, 'color', [0.1,0.2,0.3], 'LineWidth', 1.2); 
hold on
plot(dates, ccc, 'color', [0.1,0.2,0.3], 'LineWidth', 1.2);
hold on
plot(dates, ddd, 'color', [0.7,0.7,0.7], 'LineWidth', 1.8);
xlim([startdata,enddata]);
title({['Daily volatility of Australian NSW electricity market(2007-2016)'];['(a) all']},'fontname','Times New Roman','FontSize',16);

subplot(4,1,2);
plot(dates, aaa, 'color', 'k');
xlim([startdata,enddata]);
title('(b) raw','fontname','Times New Roman','FontSize',16);

subplot(4,1,3);
plot(dates, bbb, 'color', 'k');
xlim([startdata,enddata]);
title('(c) sqrt','fontname','Times New Roman','FontSize',16);

subplot(4,1,4);
plot(dates, ccc, 'color', 'k');
xlim([startdata,enddata]);
title('(d) ln','fontname','Times New Roman','FontSize',16);
