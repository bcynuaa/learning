function dire = Direction( theta )
%��÷������2*4
%   ����ֵΪtheta�Ƕ�
lam1 = cos(theta);
lam2 = sin(theta);
dire = [lam1 , lam2 , 0 , 0 ;
        0 , 0 , lam1 , lam2];
end