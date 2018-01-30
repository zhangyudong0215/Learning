tic
% Load data
clear
loadname = 'origin_ln';
load(loadname);
k = 22;
loadname = 'RV_raw';
load(loadname);
RV_t_k=normalizedsum(RV_raw, k);
RV_t_k = log(RV_t_k);
%estsample = ceil(T*0.67);  %2284行
% RV_t_k=normalizedsum(RV,k);
date_xy=zeros(T,1);
for i=1:T
    date_xy(i)=i;     %定义x和y的时间
end

DataY=RV_t_k(k:end);
DataYdate =date_xy(k:end);
DataXdate=date_xy(k:end);


% Specify lag structure and sample size 
Xlag = 60;
Ylag = 0;
Horizon = 1;
EstStart = k;
EstEnd = 2303;
Method = 'Recursive';
%Method = 'FixedWindow';

% Forecast with various weight polynomials
%---------------MIDAS-RV----------------%
[MIDAS_RV.OutputForecast,MIDAS_RV.OutputEstimate,MIDAS_RV.MixedFreqData] = MIDAS_ADL(DataY,DataYdate,RV(1:end-k+1),DataXdate,...
    'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
MIDAS_RV.out_of_sample_forecast = [MIDAS_RV.MixedFreqData.OutY ,MIDAS_RV.OutputForecast.Yf];
MIDAS_RV.out_of_sample_forecast = exp(MIDAS_RV.out_of_sample_forecast);
MIDAS_RV.loss = lossfunction(MIDAS_RV.out_of_sample_forecast);
MIDAS_RV.series = lossfunction_series(MIDAS_RV.out_of_sample_forecast);

%------------MIDAS-RV-BPV--------------%
[MIDAS_RV_BPV.OutputForecast,MIDAS_RV_BPV.OutputEstimate,MIDAS_RV_BPV.MixedFreqData] = MIDAS_ADL(DataY,DataYdate,BPV(1:end-k+1),DataXdate,...
    'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
MIDAS_RV_BPV.out_of_sample_forecast = [MIDAS_RV_BPV.MixedFreqData.OutY ,MIDAS_RV_BPV.OutputForecast.Yf];
MIDAS_RV_BPV.out_of_sample_forecast = exp(MIDAS_RV_BPV.out_of_sample_forecast);
MIDAS_RV_BPV.loss = lossfunction(MIDAS_RV_BPV.out_of_sample_forecast);
MIDAS_RV_BPV.series = lossfunction_series(MIDAS_RV_BPV.out_of_sample_forecast);
[MIDAS_RV_BPV.dm, MIDAS_RV_BPV.p] = modified_DMtest(MIDAS_RV.series.MSE, MIDAS_RV_BPV.series.MSE, k);

%------------MIDAS-RV-C--------------%
[MIDAS_RV_C.OutputForecast,MIDAS_RV_C.OutputEstimate,MIDAS_RV_C.MixedFreqData] = MIDAS_ADL(DataY,DataYdate,C(1:end-k+1),DataXdate,...
    'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
MIDAS_RV_C.out_of_sample_forecast = [MIDAS_RV_C.MixedFreqData.OutY ,MIDAS_RV_C.OutputForecast.Yf];
MIDAS_RV_C.out_of_sample_forecast = exp(MIDAS_RV_C.out_of_sample_forecast);
MIDAS_RV_C.loss = lossfunction(MIDAS_RV_C.out_of_sample_forecast);
MIDAS_RV_C.series = lossfunction_series(MIDAS_RV_C.out_of_sample_forecast);
[MIDAS_RV_C.dm, MIDAS_RV_C.p] = modified_DMtest(MIDAS_RV.series.MSE, MIDAS_RV_C.series.MSE, k);

%------------MIDAS-RV-CJ--------------%
[MIDAS_RV_CJ.OutputForecast,MIDAS_RV_CJ.OutputEstimate,MIDAS_RV_CJ.MixedFreqData] = bi_MIDAS_ADL(DataY,DataYdate,C(1:end-k+1),DataXdate,J(1:end-k+1),DataXdate,...
    'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
MIDAS_RV_CJ.out_of_sample_forecast = [MIDAS_RV_CJ.MixedFreqData.OutY ,MIDAS_RV_CJ.OutputForecast.Yf];
MIDAS_RV_CJ.out_of_sample_forecast = exp(MIDAS_RV_CJ.out_of_sample_forecast);
MIDAS_RV_CJ.loss = lossfunction(MIDAS_RV_CJ.out_of_sample_forecast);
MIDAS_RV_CJ.series = lossfunction_series(MIDAS_RV_CJ.out_of_sample_forecast);
[MIDAS_RV_CJ.dm, MIDAS_RV_CJ.p] = modified_DMtest(MIDAS_RV.series.MSE, MIDAS_RV_CJ.series.MSE, k);

%------------MIDAS-RV-RPV--------------%
[MIDAS_RV_RPV.OutputForecast,MIDAS_RV_RPV.OutputEstimate,MIDAS_RV_RPV.MixedFreqData] = MIDAS_ADL(DataY,DataYdate,RPV(1:end-k+1),DataXdate,...
    'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
MIDAS_RV_RPV.out_of_sample_forecast = [MIDAS_RV_RPV.MixedFreqData.OutY ,MIDAS_RV_RPV.OutputForecast.Yf];
MIDAS_RV_RPV.out_of_sample_forecast = exp(MIDAS_RV_RPV.out_of_sample_forecast);
MIDAS_RV_RPV.loss = lossfunction(MIDAS_RV_RPV.out_of_sample_forecast);
MIDAS_RV_RPV.series = lossfunction_series(MIDAS_RV_RPV.out_of_sample_forecast);
[MIDAS_RV_RPV.dm, MIDAS_RV_RPV.p] = modified_DMtest(MIDAS_RV.series.MSE, MIDAS_RV_RPV.series.MSE, k);

% %------------MIDAS-RV-RPV_2--------------%
% [MIDAS_RV_RPV_2.OutputForecast,MIDAS_RV_RPV_2.OutputEstimate,MIDAS_RV_RPV_2.MixedFreqData] = MIDAS_ADL(DataY,DataYdate,RPV_2(1:end-k+1),DataXdate,...
%     'Xlag',Xlag,'Ylag',Ylag,'Horizon',Horizon,'EstStart',EstStart,'EstEnd',EstEnd,'Polynomial','beta','Method',Method);
% MIDAS_RV_RPV_2.out_of_sample_forecast = [MIDAS_RV_RPV_2.MixedFreqData.OutY ,MIDAS_RV_RPV_2.OutputForecast.Yf];
% MIDAS_RV_RPV_2.loss = lossfunction(MIDAS_RV_RPV_2.out_of_sample_forecast);
% MIDAS_RV_RPV_2.series = lossfunction_series(MIDAS_RV_RPV_2.out_of_sample_forecast);
% [MIDAS_RV_RPV_2.dm, MIDAS_RV_RPV_2.p] = modified_DMtest(MIDAS_RV.series.MSE, MIDAS_RV_RPV_2.series.MSE, k);

toc
load chirp
sound(y,Fs)
save MIDAS_Forecasting_results_Ln_22days
