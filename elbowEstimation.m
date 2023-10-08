%----------------------------------------------------------------------
%DESCRIPTION: Using a function that considers the Euclidian distance 
% and Angular distance, the similarity between of the desired position and 
% orientation of hand with the ones from the database is obtained.
% Specific weight are given to each swivel angle according to a
% gaussian-linear distribution. This weights are used to compute an estimated
% swive angle.
%----------------------------------------------------------------------

function [elbow_angle, weights, y_gauss, y_linear, x_linear, pointsAll, inflex_point, ADLs] = elbowEstimation(dataset, arm_length, pos, g1, g2, tol)
 
    rotm_pos = eul2rotm(pos(4:6).*(pi/180),"XYZ"); %Extract rotation matrix from given Euler angles
    rot_angle = rotm2axang(rotm_pos)*(180/pi);  %Compute angular rotational angle from rotation matrix  
                                        
    eucledian_dis = sqrt(sum((dataset(:,2:4) - pos(1:3)).^2,2));
    angular_dis = abs(dataset(:,8) - rot_angle(4));
    
    gain1 = g1/arm_length; 
    gain2 = g2/180; 
    dis = gain1*eucledian_dis + gain2*angular_dis;
    
    pointsAll(:,1) = dis;               % Distance between i-position and desired position
    pointsAll(:,2) = dataset(:,1);      % Elbow angle
    pointsAll(:,3) = dataset(:,end);    % ADL ID number     

    pointsAll = sortrows(pointsAll,1,"ascend");
    sigma = tol/2;
    y_gauss = normpdf(pointsAll(:,1),0,sigma); 

    %row_min = find(pointsAll(:,1)<=limit);
    %pointsBest = pointsAll(row_min,:);
    %y_best = y(row_min);

    [~,ADLs] = groupcounts(int64(pointsAll(:,3)));
    %[Counts,ADLs] = groupcounts(int64(pointsAll(:,3)));
    %adl_pos = find(ismember(Counts,max(Counts)));
    %best_ADL = ADLs(adl_pos(1));                                  %Identify ADL with most relevance  

    f = @ (x) (1/(sigma*sqrt(2*pi))) * exp( -(x.^2) / (2*sigma^2));  % Gaussian Distribution Function


    f_dev = @ (x) (-x / (sigma^3 * sqrt(2*pi))) .* exp( -(x.^2) / (2*sigma^2)) ; % 1st Derivative of Gaussian Distribution (slope of curve)
    y_dev = f_dev(sigma);    

    x_linear = pointsAll(pointsAll(:,1)>= sigma);   %Keep distance values above sigma value

    inflex_point = f(sigma);
        
    y_linear = x_linear .* y_dev + 2*inflex_point;
    y_linear = y_linear(y_linear >=0);          %Keep values greater than zero
    i = find(y_linear == min(y_linear));
    x_linear = x_linear(1:i);

    weights = [y_gauss(y_gauss > inflex_point); y_linear]; %Weights vector. Gaussian and linear distributions together.
    angles = pointsAll(1:length(weights),2);  %Elbow Angles

    elbow_angle = sum(angles .* weights) / abs(sum(weights));

end
