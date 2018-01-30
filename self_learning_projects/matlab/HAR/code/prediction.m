% X = xlsread('D:\Data\matlab\HAR\data_elec.xlsx');
% % clc;
% % clear;
% 
% % Replace missing values by the sample average
% X(isnan(X)) = nanmean(X);
% 
% %%统计量RV，RPV，BPV，RPV^2
% T = length(X)/48; %表示日数
% delta = 1/48; %表示频率，半小时
% inverse_delta = 1/delta;
% mu1 = sqrt(2/pi);
% RV = zeros(T,1);
% BPV = zeros(T,1);
% RPV = zeros(T,1);
% TQ = zeros(T,1);
% for t = 1:T
%     for j = 1:inverse_delta
%         RV(t) = RV(t)+X(inverse_delta*(t-1)+j)^2;
%         RPV(t) = RPV(t)+abs(X(inverse_delta*(t-1)+j));
%     end
%     
%     for j = 2:inverse_delta
%         BPV(t) = BPV(t)+abs(X(inverse_delta*(t-1)+j))*abs(X(inverse_delta*(t-1)+j-1));
%     end  
%     
%     for j = 3:inverse_delta
%         TQ(t) = TQ(t)+abs(X(inverse_delta*(t-1)+j))^(4/3)*abs(X(inverse_delta*(t-1)+j-1))^(4/3)*abs(X(inverse_delta*(t-1)+j-2))^(4/3);
%     end
% end
% BPV = BPV.*mu1^(-2);
% RPV = RPV.*mu1^(-1)*sqrt(delta);
% RPV_2 = RPV.^2;
% TQ = TQ.*delta^(-1) * (2^(2/3) * gamma(7/6) * inv(gamma(1/2)))^(-3);
% 
% %--------统计量J,C-------------%
% alpha=0.1;
% J = zeros(T, 1);
% C = zeros(T, 1);
% Z= zeros(T, 1);
% for t = 1:T
%     y = TQ(t) * BPV(t)^(-2); 
%     Z(t) = delta^-0.5 * [RV(t)-BPV(t)] * inv(RV(t));
%     Z(t) = Z(t) / sqrt((mu1^(-4)+2*mu1^(-2)-5) * max(1,y));
% end
% for t=1:T
%     %if Z(t) > norminv(1-alpha,mean(Z),std(Z))
%     if Z(t)>norminv(1-alpha)
%         J(t) = RV(t) - BPV(t);
%         C(t) = BPV(t);
%     else
%         J(t) = 0;
%         C(t) = RV(t);
%     end
% end
% 
% % RV = sqrt(RV);
% % BPV = sqrt(BPV);
% % C = sqrt(C);
% % J = sqrt(J);
% 
% % RV = log(RV);
% % BPV = log(BPV);
% % C = log(C);
% % J = log(J+1);
% % RPV = log(RPV);
% 
% 
% RV_week = normalizedsum(RV,5);
% RV_month =normalizedsum(RV,20);
% BPV_week = normalizedsum(BPV,5);
% BPV_month =normalizedsum(BPV,20);
% C_week = normalizedsum(C,5);
% C_month = normalizedsum(C,20);
% J_week = normalizedsum(J,5);
% J_month = normalizedsum(J,20);
% RPV_week = normalizedsum(RPV,5);
% RPV_month = normalizedsum(RPV,20);
% RPV_2_week = normalizedsum(RPV_2,5);
% RPV_2_month = normalizedsum(RPV_2,20);

% 全样本参数估计
clear
loadname = 'origin_ln';
load(loadname);
k = 22;
estsample = ceil(T*0.67);
% RV_t_k=normalizedsum(RV,k);
loadname = 'RV_raw';
load(loadname);
RV_t_k=normalizedsum(RV_raw, k);
RV_t_k = log(RV_t_k);

%------------HAR-RV--------------
x_data = [ones(T-19,1), RV(20:end), RV_week(20:end), RV_month(20:end)];
HAR_RV.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k).^2;
HAR_RV.out_of_sample_forecast = exp(forecast_HAR(RV_t_k(20:end), x_data, estsample, k));
HAR_RV.loss = lossfunction(HAR_RV.out_of_sample_forecast);
HAR_RV.series = lossfunction_series(HAR_RV.out_of_sample_forecast);

%------------HAR-RV-BPV--------------
x_data = [ones(T-19,1), BPV(20:end), BPV_week(20:end), BPV_month(20:end)];
HAR_RV_BPV.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV_BPV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV_BPV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k).^2;
HAR_RV_BPV.out_of_sample_forecast = exp(forecast_HAR(RV_t_k(20:end), x_data, estsample, k));
HAR_RV_BPV.loss = lossfunction(HAR_RV_BPV.out_of_sample_forecast);
HAR_RV_BPV.series = lossfunction_series(HAR_RV_BPV.out_of_sample_forecast);
[HAR_RV_BPV.dm, HAR_RV_BPV.p] = modified_DMtest(HAR_RV.series.MSE, HAR_RV_BPV.series.MSE, k);

%------------HAR-RV-C--------------
x_data = [ones(T-19,1), C(20:end), C_week(20:end), C_month(20:end)];
HAR_RV_C.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV_C.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV_C.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k).^2;
HAR_RV_C.out_of_sample_forecast = exp(forecast_HAR(RV_t_k(20:end), x_data, estsample, k));
HAR_RV_C.loss = lossfunction(HAR_RV_C.out_of_sample_forecast);
HAR_RV_C.series = lossfunction_series(HAR_RV_C.out_of_sample_forecast);
[HAR_RV_C.dm, HAR_RV_C.p] = modified_DMtest(HAR_RV.series.MSE, HAR_RV_C.series.MSE, k);

%------------HAR-RV-CJ--------------
x_data = [ones(T-19,1), C(20:end), C_week(20:end), C_month(20:end), J(20:end), J_week(20:end), J_month(20:end)];
HAR_RV_CJ.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV_CJ.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV_CJ.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k).^2;
HAR_RV_CJ.out_of_sample_forecast = exp(forecast_HAR(RV_t_k(20:end), x_data, estsample, k));
HAR_RV_CJ.loss = lossfunction(HAR_RV_CJ.out_of_sample_forecast);
HAR_RV_CJ.series = lossfunction_series(HAR_RV_CJ.out_of_sample_forecast);
[HAR_RV_CJ.dm, HAR_RV_CJ.p] = modified_DMtest(HAR_RV.series.MSE, HAR_RV_CJ.series.MSE, k);

%------------HAR-RV-RPV--------------
x_data = [ones(T-19,1), RPV(20:end), RPV_week(20:end), RPV_month(20:end)];
HAR_RV_RPV.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV_RPV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV_RPV.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k).^2;
HAR_RV_RPV.out_of_sample_forecast = exp(forecast_HAR(RV_t_k(20:end), x_data, estsample, k));
HAR_RV_RPV.loss = lossfunction(HAR_RV_RPV.out_of_sample_forecast);
HAR_RV_RPV.series = lossfunction_series(HAR_RV_RPV.out_of_sample_forecast);
[HAR_RV_RPV.dm, HAR_RV_RPV.p] = modified_DMtest(HAR_RV.series.MSE, HAR_RV_RPV.series.MSE, k);

% %------------HAR-RV-RPV^2--------------
% x_data = [ones(T-19,1), RPV_2(20:end), RPV_2_week(20:end), RPV_2_month(20:end)];
% HAR_RV_RPV_2.in_sample = regression_HAR(RV_t_k(20+k:end), x_data(1:end-k, :));
% HAR_RV_RPV_2.out_of_sample_forecast = forecast_HAR(RV_t_k(20:end), x_data, estsample, k);
% HAR_RV_RPV_2.loss = lossfunction(HAR_RV_RPV_2.out_of_sample_forecast);
% HAR_RV_RPV_2.series = lossfunction_series(HAR_RV_RPV_2.out_of_sample_forecast);
% [HAR_RV_RPV_2.dm, HAR_RV_RPV_2.p] = modified_DMtest(HAR_RV.series.MSE, HAR_RV_RPV_2.series.MSE, k);
