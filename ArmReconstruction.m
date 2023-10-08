%----------------------------------------------------------------------
%NOTE:This script only works with original data located in 'Data/UP_Kinematic/KIN_Original'
%----------------------------------------------------------------------
%DESCRIPTION: The inputs for this function are the upper arm, forearm 
% and hand's markers, and the anotomical measures from the subject 
% obtained from the corresponding script 'ID_Definition_SX".
% Using the markers 'XYZ' data from each section of the arm, 
% the normal vector is computed and the multiplied by it corresponding 
% anatomical length. Considering the shoulder as the origin of the world (WRD) 
% frame, the position of the elbow, wrist and center of the hand is estimated.
%----------------------------------------------------------------------

function [JOINTS,Vx,Vy,Vz,rotHand] = ArmReconstruction(trial_data,ArmIDS, ForearmIDS, HandIDS,l1,l2,b3,t1)

        %Reorient markers to ANYexo WRD frame
        [trial_data] = rearrangeData(trial_data);
        trial_data(:,2:4) = trial_data(:,2:4);
        
        %% ARM
        
        [~,ARM_left,ARM_right] = getMarkers(trial_data,ArmIDS,6);
        
        [~,ARM_left_u] = getAvgUnitaryVector_v2(ARM_left);
        [~,ARM_right_u] = getAvgUnitaryVector_v2(ARM_right);
        
        ARM_u = (ARM_left_u + ARM_right_u) / 2;
        
        %% FOREARM
        
        [~,fARM_left,fARM_right] = getMarkers(trial_data,ForearmIDS,6);
        
        [~,fARM_left_u] = getAvgUnitaryVector_v2(fARM_left);
        [~,fARM_right_u] = getAvgUnitaryVector_v2(fARM_right);
        
        fARM_u = (fARM_left_u + fARM_right_u) / 2;
        
        %% HAND
        
        [~,HND_left,HND_right] = getMarkers(trial_data,HandIDS,4);
        
        [Vx_n,Vy_n,Vz_n,rotHand] = getHandUnitaryVectors(HND_left,HND_right);

        HND_u = Vx_n;        
               
        %% ARM JOINTS RECONSTRUCTION

        %Normal vector of each section is multiplied by its corresponding
        %lenghth, according to the data from each subject.
        
        JOINTS(1,:) = [0 0 0];                        %Shoulder
        JOINTS(2,:) = ARM_u * l1;                     %Elbow
        JOINTS(3,:) = JOINTS(2,:) + (fARM_u * l2);    %Wrisrt
        JOINTS(4,:) = JOINTS(3,:) + (HND_u * b3);     %Center of the hand
        JOINTS(5,:) = [0 0 -t1];                      %Hip

        %% HAND ORIENTATION FRAME

        axis_l = 80; %Length of the axis

        Vx(1,:) = JOINTS(4,:);
        Vx(2,:) = (Vx_n * axis_l) + JOINTS(4,:);
        
        Vy(1,:) = JOINTS(4,:);
        Vy(2,:) = (Vy_n * axis_l) + JOINTS(4,:);
        
        Vz(1,:) = JOINTS(4,:);
        Vz(2,:) = (Vz_n * axis_l) + JOINTS(4,:);   
       
end