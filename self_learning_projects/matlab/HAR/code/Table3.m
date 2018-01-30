list1 = [1, 5, 11, 16, 22];
model = 'Sqrt';
for i = 1:5
    % 加负号只是为了在excel中转化为括号方便
    k = list1(i);
    loadname = ['Forecasting_results_', model, '_', num2str(k), 'days.mat'];
    load(loadname);
    sheet(2*i-1, 1) = HAR_RV.loss.MSE;
    sheet(2*i-1, 2) = HAR_RV_BPV.loss.MSE;
    sheet(2*i, 2) = -HAR_RV_BPV.p;
    sheet(2*i-1, 3) = HAR_RV_C.loss.MSE;
    sheet(2*i, 3) = -HAR_RV_C.p;
    sheet(2*i-1, 4) = HAR_RV_CJ.loss.MSE;
    sheet(2*i, 4) = -HAR_RV_CJ.p;
    sheet(2*i-1, 5) = HAR_RV_RPV.loss.MSE;
    sheet(2*i, 5) = -HAR_RV_RPV.p;
%     sheet(2*i-1, 6) = HAR_RV_RPV_2.loss.MSE;
%     sheet(2*i, 6) = -HAR_RV_RPV_2.p;   
end

list1 = [1, 5, 11, 16, 22];
model = 'Sqrt'; 
for i = 1:5
    k = list1(i);
    loadname1 = ['Forecasting_results_', model, '_', num2str(k), 'days.mat'];
    load(loadname1);
    series1.RV = HAR_RV.series.MSE;
    series1.BPV = HAR_RV_BPV.series.MSE;
    series1.C = HAR_RV_C.series.MSE;
    series1.CJ = HAR_RV_CJ.series.MSE;
    series1.RPV = HAR_RV_RPV.series.MSE;
    
    loadname2 = ['Forecasting_results_Raw_', num2str(k), 'days.mat'];
    load(loadname2);
    series2.RV = HAR_RV.series.MSE;
    series2.BPV = HAR_RV_BPV.series.MSE;
    series2.C = HAR_RV_C.series.MSE;
    series2.CJ = HAR_RV_CJ.series.MSE;
    series2.RPV = HAR_RV_RPV.series.MSE;
    
    [~, sheet2(i, 1)] = modified_DMtest(series1.RV, series2.RV, k);
    [~, sheet2(i, 2)] = modified_DMtest(series1.BPV, series2.BPV, k);
    [~, sheet2(i, 3)] = modified_DMtest(series1.C, series2.C, k);
    [~, sheet2(i, 4)] = modified_DMtest(series1.CJ, series2.CJ, k);
    [~, sheet2(i, 5)] = modified_DMtest(series1.RPV, series2.RPV, k);
end
for i = 1:5
    for j = 1:4
        if sheet2(i, j) < 0.1
            sheet3(i, j) = 1;
        end
    end
end
    