kind = 'ln';

dates = linspace(2007.0, 2016.4, length(RV)); % 绘图时域
plt = figure();
plot(dates, RV, 'color', [0.1,0.2,0.3], 'LineWidth', 1.2); 
title('(a) Realized variance in standard deviation form');
set(plt,'visible','off');
saveas(plt, ['RV', '_', kind], 'emf')
cla(plt);

dates = linspace(2007.0, 2016.4, length(C)); % 绘图时域
plt = figure();
plot(dates, C, 'color', [0.1,0.2,0.3], 'LineWidth', 1.2); 
title('(b) Continuous component');
set(plt,'visible','off');
saveas(plt, ['Continuous', '_', kind], 'emf')
cla(plt);

dates = linspace(2007.0, 2016.4, length(J)); % 绘图时域
plt = figure();
plot(dates, J, 'color', [0.1,0.2,0.3], 'LineWidth', 1.2); 
title('(c) Jump component');
set(plt,'visible','off');
saveas(plt, ['Jump', '_', kind], 'emf')
cla(plt);
  

