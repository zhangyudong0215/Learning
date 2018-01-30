function [modified_DM, pValue] = modified_DMtest(series1, series2, k)
    d=series1-series2;
    dMean = mean(d);
    gamma0 = var(d);
    N=size(series1, 1);
    n=N;
    if n>1
        gamma = zeros(n-1,1);
        for tau = 1:(n-1)
            for t=(tau+1):n
                gamma(tau) =(sum((d(t,1)-dMean)*(d(t-tau,1)-dMean)))/N;
            end
        end
        varD = gamma0 + 2*sum(gamma);
    else
        varD = gamma0;
    end
    % Retrieve the diebold mariano statistic DM ~N(0,1)
    DM = dMean / sqrt ( (1/N)*varD );
    modified_DM=sqrt( (N+1-2*k+1/N*k*(k-1)) / N )*DM;
    pValue = 2*erfc(abs(modified_DM)/sqrt(2))/2;
end


