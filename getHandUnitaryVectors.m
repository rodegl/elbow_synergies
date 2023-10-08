function [x_n,y_n,z_n,rot_mat] = getHandUnitaryVectors(mat1,mat2)

hnd_avg = (mat1 + mat2)/2;
hnd_avg = hnd_avg(2,:) - hnd_avg(1,:); %Average vector along the hand, based on the four markers
x_n = (hnd_avg)/norm(hnd_avg);
vec = mat2(1,:) - mat1(1,:);
y = cross(vec,hnd_avg);
y_n = y/norm(y);
z = cross(hnd_avg,y);
z_n = z/norm(z);

rot_mat(:,1) = x_n;
rot_mat(:,2) = y_n;
rot_mat(:,3) = z_n;

end