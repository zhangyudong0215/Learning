function Regression = regression_HAR(YY, XX)
%     XX=[ones(T-19,1),RV(20:end),RV_week(20:end),RV_month(20:end)];
    NumCross=size(XX,1);
    NumIV=size(XX,2);
%     YY=RV_t_k(20:end);
    VecB=regress(YY,XX);
    ehat=YY-XX*VecB;
    VecSE=[diag(sum(ehat.^2)/(NumCross-NumIV)*inv(XX'*XX))].^0.5;
    VecT=VecB./VecSE;
    VecP=(1-tcdf(abs(VecT),NumCross-NumIV))*2;
    %Regression=table(VecB,VecSE,VecT,VecP,{'Coef','Std_Err','T','P'});
%     Regression=table(VecB,VecSE,VecT,VecP);
    Regression=[VecB,VecSE,VecT,VecP];
  

