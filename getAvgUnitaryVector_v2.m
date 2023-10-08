%----------------------------------------------------------------------
%DESCRIPTION: This function fits a line bweteen three markers.
% The unitary vector of the fitted line is obtained as well.
%----------------------------------------------------------------------

function [v_fit,v_uni] = getAvgUnitaryVector_v2(mat)


mat_z = mat(:,3);
avg = mean(mat);
mat_avg = bsxfun(@minus, mat, avg);
[~,~,V] = svd(mat_avg,0);

x_fit = @(z_fit) avg(1) + (z_fit - avg(3)) / V(3,1) * V(1,1);
y_fit =@(z_fit) avg(2) + (z_fit - avg(3)) / V(3,1) * V(2,1);

v_fit = [x_fit(mat_z),y_fit(mat_z),mat_z];
v_mat_res = v_fit(3,:)-v_fit(1,:);
v_uni = v_mat_res / norm(v_mat_res);       % <--------- Unitary vector

end