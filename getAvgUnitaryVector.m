function [uniVec,v1,v2] = getAvgUnitaryVector(mat1,mat2)

mean1 = mean(mat1,2);
A1 = mat1 - mean1;
[U1,~,~] = svd(A1);
d1 = U1(:,1);
t1 = d1'*A1;
v1 = (mean1 + [min(t1),max(t1)].*d1)';
v1_res = v1(1,:) - v1(2,:);
v1_n = v1_res / norm(v1_res);

mean2 = mean(mat2,2);
A2 = mat2 - mean2;
[U2,~,~] = svd(A2);
d2 = U2(:,1);
t2 = d2'*A2;
v2 = (mean2 + [min(t2),max(t2)].*d2)';
v2_res = v2(1,:) - v2(2,:);
v2_n = v2_res / norm(v2_res);


uniVec = ((v1_n + v2_n)/2).*1;


end