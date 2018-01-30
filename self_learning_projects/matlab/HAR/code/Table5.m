clear
% model1 = 'midasforecasting'; 
model1 = 'Combineforecasting';
% model2 = 'Forecasting_results';
model2 = 'midasforecasting'; 
% model3 = 'Raw';
% model3 = 'Sqrt';
model3 = 'Ln';

list1 = [1, 5, 11, 16, 22];
for iii = 1:5
    k = list1(iii);
    
    loadname1 = [model1, '_', model3, '_', num2str(k), 'days.mat'];
    load(loadname1);
    if strcmp(model1, 'midasforecasting')
        series1.RV = MIDAS_RV.series.MSE(k:end);
        series1.BPV = MIDAS_RV_BPV.series.MSE(k:end);
        series1.C = MIDAS_RV_C.series.MSE(k:end);
        series1.CJ = MIDAS_RV_CJ.series.MSE(k:end);
        series1.RPV = MIDAS_RV_RPV.series.MSE(k:end);
        if strcmp(model3, 'Raw')
            series1.RPV_2 = MIDAS_RV_RPV_2.series.MSE(k:end);
        end
    elseif strcmp(model1, 'Combineforecasting')
        series1.RV = Comb_RV.series.MSE;
        series1.BPV = Comb_RV_BPV.series.MSE;
        series1.C = Comb_RV_C.series.MSE;
        series1.CJ = Comb_RV_CJ.series.MSE;
        series1.RPV = Comb_RV_RPV.series.MSE;
        if strcmp(model3, 'Raw')
            series1.RPV_2 = Comb_RV_RPV_2.series.MSE;
        end
    end
    
    loadname2 = [model2, '_', model3, '_', num2str(k), 'days.mat'];
    load(loadname2);
    if strcmp(model2, 'midasforecasting')
        series2.RV = MIDAS_RV.series.MSE(k:end);
        series2.BPV = MIDAS_RV_BPV.series.MSE(k:end);
        series2.C = MIDAS_RV_C.series.MSE(k:end);
        series2.CJ = MIDAS_RV_CJ.series.MSE(k:end);
        series2.RPV = MIDAS_RV_RPV.series.MSE(k:end);
        if strcmp(model3, 'Raw')
            series2.RPV_2 = MIDAS_RV_RPV_2.series.MSE(k:end);
        end
    elseif strcmp(model2, 'Forecasting_results')
        series2.RV = HAR_RV.series.MSE;
        series2.BPV = HAR_RV_BPV.series.MSE;
        series2.C = HAR_RV_C.series.MSE;
        series2.CJ = HAR_RV_CJ.series.MSE;
        series2.RPV = HAR_RV_RPV.series.MSE;
        if strcmp(model3, 'Raw')
            series2.RPV_2 = HAR_RV_RPV_2.series.MSE;
        end
    end
    
    [sheet(iii, 1), sheet2(iii, 1)] = modified_DMtest(series1.RV, series2.RV, k);
    [sheet(iii, 2), sheet2(iii, 2)] = modified_DMtest(series1.BPV, series2.BPV, k);
    [sheet(iii, 3), sheet2(iii, 3)] = modified_DMtest(series1.C, series2.C, k);
    [sheet(iii, 4), sheet2(iii, 4)] = modified_DMtest(series1.CJ, series2.CJ, k);
    [sheet(iii, 5), sheet2(iii, 5)] = modified_DMtest(series1.RPV, series2.RPV, k);
    if strcmp(model3, 'Raw')
        [sheet(iii, 6), sheet2(iii, 6)] = modified_DMtest(series1.RPV_2, series2.RPV_2, k);
    end
end

    