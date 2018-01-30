function loss = lossfunction( result_prediction )

s=find(result_prediction(:,2)==0);
result_prediction(s,2)=nanmean(result_prediction(:, 2)); %(result_prediction(s-1,2)+result_prediction(s+1,2))/2;

RHMSE = sqrt(mean((1-result_prediction(:,1)./result_prediction(:,2)).^2));
RHMAE = sqrt(mean(abs((1-result_prediction(:,1)./result_prediction(:,2)))));


%-------再加入八个损失函数-------%

MSE = mean((result_prediction(:,1)-result_prediction(:,2)).^2);
MAE = mean(abs(1-result_prediction(:,1)-result_prediction(:,2)));
HMSE = mean((1-result_prediction(:,1)./result_prediction(:,2)).^2);
HMAE = mean(abs((1-result_prediction(:,1)./result_prediction(:,2))));
R2LOG = mean((log(result_prediction(:,1)./result_prediction(:,2))).^2);
QLIKE = mean(log(result_prediction(:,2))+result_prediction(:,1)./result_prediction(:,2));
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
    MMEO=(MMEO3+MMEO4)/length(result_prediction);
    MMEU=(MMEU3+MMEU4)/length(result_prediction);
end
forecastError = result_prediction(:,2)-result_prediction(:,1);
root_forecastError=result_prediction(:,2).^(0.5)-result_prediction(:,1).^(0.5);
RMSE = sqrt(mean(forecastError(:).^2));
RMAE = sqrt(mean(abs(forecastError(:))));
RMSD = sqrt(mean(root_forecastError(:).^2));
RMAD = sqrt(mean(abs(root_forecastError(:))));
loss.MSE = MSE;
loss.MAE = MAE;
loss.RMSE = RMSE;
loss.RMAE = RMAE;
% loss.RMSD = RMSD;
% loss.RMAD = RMAD;
loss.HMSE = HMSE;
loss.HMAE = HMAE;
loss.RHMSE = RHMSE;
loss.RHMAE = RHMAE;
loss.MMEO = MMEO;
loss.MMEU = MMEU;
% loss.R2LOG = R2LOG;
% loss.QLIKE = QLIKE;

end

