function K = getK( E , A , L , theta )
%ֱ�Ӹ���ĳһ�Ƕ��¸˵ĸնȾ���
%   �������룺����ģ��E�������A���˳�L���Ƕ�theta
Kp = Kpole(E , A , L);
lambda = Direction(theta);
K = lambda.' * Kp * lambda;
end