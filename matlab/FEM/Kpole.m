function mat = Kpole( E , A , L )
%�����˵ľֲ�����նȾ���
%   ����ֵ��E����ģ����A��������L�˵ĳ���
mat = [1 , 1 ; 1 , 1];
mat = mat.*E*A/L;
end

