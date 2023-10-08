%----------------------------------------------------------------------
%DESCRIPTION: This scripts allows to visualize how the normal vector
% for the upper arm, forearm and hand are obtained from the markers.
%----------------------------------------------------------------------

clc; clear; close all;

set(0,'DefaultFigureWindowStyle','normal');

Subj_name = 'S9'; %1,3,38 NOT AVAILABLE
Task_id = '12';   
Repetition_id = '3';

trial = ['Data/UP_Kinematic/KIN_Original/' Subj_name '/' Subj_name '_' Task_id '_' Repetition_id '.mat'];
sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_' Subj_name '.m'];

%load data in 'filename'
load(trial)
run(sub_markers_id) %Load marker IDs of the subject

table = cell2mat(data);
frames = length(data);
speed = 12; %Increase the speed of the animation

for i = 1:speed:frames

    trial_data = cell2mat(data(i)); % Load data for 'i' frame
    
    %Reorient markers to ANYexo WRD frame
    [trial_data] = rearrangeData(trial_data);
    trial_data(:,2:4) = trial_data(:,2:4);
    
    %% ARM
    
    [ARM,ARM_left,ARM_right] = getMarkers(trial_data,ArmIDS,6);
    
    [ARM_left_fit,ARM_left_u] = getAvgUnitaryVector_v2(ARM_left);
    [ARM_right_fit,ARM_right_u] = getAvgUnitaryVector_v2(ARM_right);
    
    ARM_u = (ARM_left_u + ARM_right_u) / 2;
    ARM_u_v(1,:) = (ARM_left(1,:) + ARM_right(1,:))/2;
    ARM_u_v(2,:) = ARM_u * 110 + ARM_u_v(1,:);
    
    %% FOREARM
    
    [fARM,fARM_left,fARM_right] = getMarkers(trial_data,ForearmIDS,6);
    
    [fARM_left_fit,fARM_left_u] = getAvgUnitaryVector_v2(fARM_left);
    [fARM_right_fit,fARM_right_u] = getAvgUnitaryVector_v2(fARM_right);
    
    fARM_u = (fARM_left_u + fARM_right_u) / 2;
    fARM_u_v(1,:) = (fARM_left(1,:) + fARM_right(1,:))/2;
    fARM_u_v(2,:) = fARM_u * 110 + fARM_u_v(1,:);
    
    %% HAND
    
    [HND,HND_left,HND_right] = getMarkers(trial_data,HandIDS,4);
    
    [Vx_n,Vy_n,Vz_n,rotHand] = getHandUnitaryVectors(HND_left,HND_right);
    
    HND_u_v(1,:) = (HND_left(1,:)+HND_right(1,:))/2;
    HND_u_v(2,:) = Vx_n * 30 + HND_u_v(1,:);
    
    axis_l = 30;
    mid_hnd = (HND_left(1,:)+HND_right(2,:))/2;
    Vx(1,:) = mid_hnd;
    Vx(2,:) = (Vx_n * axis_l) + mid_hnd;
    
    Vy(1,:) = mid_hnd;
    Vy(2,:) = (Vy_n * axis_l) + mid_hnd;
    
    Vz(1,:) = mid_hnd;
    Vz(2,:) = (Vz_n * axis_l) + mid_hnd;
    
    %% PLOTTING
    
    figure(1)
    
    %Plot Arm data
    scatter3(ARM(:,1),ARM(:,2),ARM(:,3), 20, 'blue','filled')                                                 %Arm markers
    hold on
    plot3(ARM_left_fit(:,1),ARM_left_fit(:,2),ARM_left_fit(:,3),'green')                                %Fitted line 1 - Arm
    hold on
    plot3(ARM_right_fit(:,1),ARM_right_fit(:,2),ARM_right_fit(:,3),'green')                                %Fitted line 1 - Arm
    hold on
    plot3(ARM_u_v(:,1),ARM_u_v(:,2),ARM_u_v(:,3),'blue', LineStyle='-.',LineWidth=1)                     %Normalized vector 1 - Arm     
    
    % Plot Forearm data
    scatter3(fARM(:,1),fARM(:,2),fARM(:,3), 20, 'red','filled')                                                 %Arm markers
    hold on
    plot3(fARM_left_fit(:,1),fARM_left_fit(:,2),fARM_left_fit(:,3),'green')                                %Fitted line 1 - Arm
    hold on
    plot3(fARM_right_fit(:,1),fARM_right_fit(:,2),fARM_right_fit(:,3),'green')                                %Fitted line 1 - Arm
    hold on
    plot3(fARM_u_v(:,1),fARM_u_v(:,2),fARM_u_v(:,3),'red', LineStyle='-.',LineWidth=1)                     %Normalized vector 1 - Arm
    
    
    %Plot hand
    scatter3(HND(:,1),HND(:,2),HND(:,3), 20, 'm','filled')                                                %Hand markers
    hold on
    plot3(HND_u_v(:,1),HND_u_v(:,2),HND_u_v(:,3),LineStyle='-.',LineWidth=1,Color='m')              %Hand center line
    
    %Plot XYZ axes on the center of the hand
    hold on
    plot3(Vx(:,1),Vx(:,2),Vx(:,3),LineStyle='-',LineWidth=2,Color='red') %'X' axis
    hold on
    plot3(Vy(:,1),Vy(:,2),Vy(:,3),LineStyle='-',LineWidth=2,Color='green') %'Y' axis
    hold on
    plot3(Vz(:,1),Vz(:,2),Vz(:,3),LineStyle='-',LineWidth=2,Color='blue') %'Z' axis
    
    hold off
    %view(-90,0)        % left (YZ)
    %view(0,90)         % top (XY)
    %view(0,0)          % front (XZ)
    %view(3)
    grid on
    view(3)
    axis equal
    title('Obtain Normal Vectors')
    xlabel('X [mm]')
    ylabel('Y [mm]')
    zlabel('Z [mm]')

end



