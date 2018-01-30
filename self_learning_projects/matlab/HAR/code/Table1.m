m = zeros(5, 8);

v = description_3.RV;
i = 1;
m(i, 1) = v.mean;
m(i, 2) = v.std;
m(i, 3) = v.skewness;
m(i, 4) = v.kurtosis;
m(i, 5) = v.Q.stat;
m(i, 6) = v.Q.pValue;
m(i, 7) = v.Q.stat2;
m(i, 8) = v.Q.pValue2;

v = description_3.BPV;
i = 2;
m(i, 1) = v.mean;
m(i, 2) = v.std;
m(i, 3) = v.skewness;
m(i, 4) = v.kurtosis;
m(i, 5) = v.Q.stat;
m(i, 6) = v.Q.pValue;
m(i, 7) = v.Q.stat2;
m(i, 8) = v.Q.pValue2;

v = description_3.C;
i = 3;
m(i, 1) = v.mean;
m(i, 2) = v.std;
m(i, 3) = v.skewness;
m(i, 4) = v.kurtosis;
m(i, 5) = v.Q.stat;
m(i, 6) = v.Q.pValue;
m(i, 7) = v.Q.stat2;
m(i, 8) = v.Q.pValue2;

v = description_3.J;
i = 4;
m(i, 1) = v.mean;
m(i, 2) = v.std;
m(i, 3) = v.skewness;
m(i, 4) = v.kurtosis;
m(i, 5) = v.Q.stat;
m(i, 6) = v.Q.pValue;
m(i, 7) = v.Q.stat2;
m(i, 8) = v.Q.pValue2;

v = description_3.RPV;
i = 5;
m(i, 1) = v.mean;
m(i, 2) = v.std;
m(i, 3) = v.skewness;
m(i, 4) = v.kurtosis;
m(i, 5) = v.Q.stat;
m(i, 6) = v.Q.pValue;
m(i, 7) = v.Q.stat2;
m(i, 8) = v.Q.pValue2;

