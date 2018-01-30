function forecast = forecast_HAR(y_data, x_data, estsample, k)
% estsample表示行数减去19
    result_forecast = zeros(length(y_data), 1);
    result_forecast(1:estsample+k-1, 1) = y_data(1:estsample+k-1, 1); 
    Regression = regression_HAR(y_data(k+1:estsample+k, 1), x_data(1:estsample, :)); 
    coef = Regression(:, 1); 
    for i = 1:length(y_data) - estsample - k + 1
        result_forecast(estsample+k+i-1) = x_data(estsample+i-1, :) * coef;
        if mod(i, 10) == 0   %recursive rolling
            Regression = regression_HAR(y_data(k+1:estsample+k+i-1), x_data(1:estsample+i-1, :));
            coef = Regression(:, 1);
        end
    end
    forecast = [y_data(estsample+k:end, 1), result_forecast(estsample+k:end, 1)];
