function x=normalizedsum(x_data,k)
    T=length(x_data);
    x=zeros(T,1);
    for t=0:T-k
        x(t+k)=mean(x_data(t+1:t+k));  %��k��������ʾ��k��ı�׼����һ����
    end
end