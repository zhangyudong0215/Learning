function series = lossfunction(result_prediction)

s=find(result_prediction(:,2)==0);
result_prediction(s,2)=nanmean(result_prediction(:, 2)); %(result_prediction(s-1,2)+result_prediction(s+1,2))/2;

RHMSE = (1-result_prediction(:,1)./result_prediction(:,2)).^2;
RHMAE = abs((1-result_prediction(:,1)./result_prediction(:,2)));


%-------再加入八个损失函数-------%

MSE = (result_prediction(:,1)-result_prediction(:,2)).^2;
MAE = abs(1-result_prediction(:,1)-result_prediction(:,2));
HMSE = (1-result_prediction(:,1)./result_prediction(:,2)).^2;
HMAE = abs((1-result_prediction(:,1)./result_prediction(:,2)));
R2LOG = (log(result_prediction(:,1)./result_prediction(:,2))).^2;
QLIKE = log(result_prediction(:,2))+result_prediction(:,1)./result_prediction(:,2);
MMEO3=0;
MMEO4=0;
MMEU3=0;
MMEU4=0;
for i=1:size(result_prediction,1) %这里有疑问
    if result_prediction(i,1)>result_prediction(i,2)
        MMEO3=MMEO3+abs((result_prediction(i,2)-result_prediction(i,1)).^2);
        MMEU4=MMEU4+sqrt(abs((result_prediction(i,2)-result_prediction(i,1)).^2));
    else
        MMEO4=MMEO4+sqrt(abs((result_prediction(i,2)-result_prediction(i,1)).^2));
        MMEU3=MMEO3+abs((result_prediction(i,2)-result_prediction(i,1)).^2);
    end
    MMEO(i) = (MMEO3+MMEO4)/length(result_prediction);
    MMEU(i) = (MMEU3+MMEU4)/length(result_prediction);
end
forecastError = result_prediction(:,2)-result_prediction(:,1);
root_forecastError=result_prediction(:,2).^(0.5)-result_prediction(:,1).^(0.5);
RMSE = forecastError(:).^2;
RMAE = abs(forecastError(:));
RMSD = root_forecastError(:).^2;
RMAD = abs(root_forecastError(:));
series.MSE = MSE;
series.MAE = MAE;
series.RMSE = RMSE;
series.RMAE = RMAE;
% series.RMSD = RMSD;
% series.RMAD = RMAD;
series.HMSE = HMSE;
series.HMAE = HMAE;
series.RHMSE = RHMSE;
series.RHMAE = RHMAE;
series.MMEO = MMEO;
series.MMEU = MMEU;
% series.R2LOG = R2LOG;
% series.QLIKE = QLIKE;

end

