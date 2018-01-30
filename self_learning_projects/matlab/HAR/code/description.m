% ----------√Ë ˆ–‘Õ≥º∆------------
% RV, BPV, C, J, RPV_2(RPV)
temp.RV.mean = mean(RV);
temp.RV.std = std(RV);
temp.RV.skewness = skewness(RV);
temp.RV.kurtosis = kurtosis(RV);
[~,pValue,stat,~] = lbqtest(RV, 'lags', 10);
temp.RV.Q.stat = stat;
temp.RV.Q.pValue = pValue;
[~,pValue,stat,~] = lbqtest(RV, 'lags', 5);
temp.RV.Q.stat2 = stat;
temp.RV.Q.pValue2 = pValue;
temp.RV.ADF = adftest(RV);
temp.RV.pp = pptest(RV);

temp.BPV.mean = mean(BPV);
temp.BPV.std = std(BPV);
temp.BPV.skewness = skewness(BPV);
temp.BPV.kurtosis = kurtosis(BPV);
[~,pValue,stat,~] = lbqtest(BPV, 'lags', 10);
temp.BPV.Q.stat = stat;
temp.BPV.Q.pValue = pValue;
[~,pValue,stat,~] = lbqtest(BPV, 'lags', 5);
temp.BPV.Q.stat2 = stat;
temp.BPV.Q.pValue2 = pValue;
temp.BPV.ADF = adftest(BPV);
temp.BPV.pp = pptest(BPV);

temp.C.mean = mean(C);
temp.C.std = std(C);
temp.C.skewness = skewness(C);
temp.C.kurtosis = kurtosis(C);
[~,pValue,stat,~] = lbqtest(C, 'lags', 10);
temp.C.Q.stat = stat;
temp.C.Q.pValue = pValue;
[~,pValue,stat,~] = lbqtest(C, 'lags', 5);
temp.C.Q.stat2 = stat;
temp.C.Q.pValue2 = pValue;
temp.C.ADF = adftest(C);
temp.C.pp = pptest(C);

temp.J.mean = mean(J);
temp.J.std = std(J);
temp.J.skewness = skewness(J);
temp.J.kurtosis = kurtosis(J);
[~,pValue,stat,~] = lbqtest(J, 'lags', 10);
temp.J.Q.stat = stat;
temp.J.Q.pValue = pValue;
[~,pValue,stat,~] = lbqtest(J, 'lags', 5);
temp.J.Q.stat2 = stat;
temp.J.Q.pValue2 = pValue;
temp.J.ADF = adftest(J);
temp.J.pp = pptest(J);

% temp.RPV_2.mean = mean(RPV_2);
% temp.RPV_2.std = std(RPV_2);
% temp.RPV_2.skewness = skewness(RPV_2);
% temp.RPV_2.kurtosis = kurtosis(RPV_2);
% [~,pValue,stat,~] = lbqtest(RPV_2, 'lags', 10);
% temp.RPV_2.Q.stat = stat;
% temp.RPV_2.Q.pValue = pValue;
% [~,pValue,stat,~] = lbqtest(RPV_2, 'lags', 5);
% temp.RPV_2.Q.stat2 = stat;
% temp.RPV_2.Q.pValue2 = pValue;
% temp.RPV_2.ADF = adftest(RPV_2);
% temp.RPV_2.pp = pptest(RPV_2);

temp.RPV.mean = mean(RPV);
temp.RPV.std = std(RPV);
temp.RPV.skewness = skewness(RPV);
temp.RPV.kurtosis = kurtosis(RPV);
[~,pValue,stat,~] = lbqtest(RPV, 'lags', 10);
temp.RPV.Q.stat = stat;
temp.RPV.Q.pValue = pValue;
[~,pValue,stat,~] = lbqtest(RPV, 'lags', 5);
temp.RPV.Q.stat2 = stat;
temp.RPV.Q.pValue2 = pValue;
temp.RPV.ADF = adftest(RPV);
temp.RPV.pp = pptest(RPV);

description_3 = temp;


