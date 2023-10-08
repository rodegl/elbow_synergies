%----------------------------------------------------------------------
%NOTE:This script only works with filtered data located in 'Data/UP_Kinematic/KIN_Filtered'
%----------------------------------------------------------------------
%DESCRIPTION: This script process the XYZ values from the kinematic data
% to obtain an estimated position of the elbow, wrist and center of the hand, 
% as well as the orientaiton of this last one.
% The position of these joints are used as the inputs for the function 'elbowElevationAngle' 
% to calculate the elevation of the elbow (swivel angle) from the subject at each frame.
% Data is stored in a cell matrix, where the columns are the tasks and the rows are the repetitions. 
% Each cell contains the values for each task, the data is arranged in the following format:
% [ Swivel_Angle, X, Y, Z, Roll, Pitch, Yaw, Axis_Rotation_Angle ]
%----------------------------------------------------------------------

clc; clear; close all;

speed = 1; %Amount of frames to skip from the original data

tasks = 1:30;
repetitions = 1:3;

tic

for r = [4:37,39:42] % Subject's data to be processed [1,3,38] NOT AVAILABLE, up to 42

    Subj_name = int2str(r); 

    sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];
    run(sub_markers_id) %Load marker IDs of the subject

    for k = tasks %TASKS
        Task_id = int2str(k); 
    
        for j = repetitions %REPETITIONS    
           
            disp("Analizing " + Subj_name + "; task: " + k + "; repetition: " + j)
        
            Repetition_id = int2str(j);
            trial = ['Data/UP_Kinematic/KIN_Filtered/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
            
            %Load data in 'filename'
            load(trial)     %This data has already been filtered from the original dataset
            frames = length(cell2mat(trial_filt(1)));

            ARM1 = cell2mat(trial_filt(1));
            ARM2 = cell2mat(trial_filt(2));
            ARM3 = cell2mat(trial_filt(3));
            ARM4 = cell2mat(trial_filt(4));
            ARM5 = cell2mat(trial_filt(5));
            ARM6 = cell2mat(trial_filt(6));
            
            fARM1 = cell2mat(trial_filt(7));
            fARM2 = cell2mat(trial_filt(8));
            fARM3 = cell2mat(trial_filt(9));
            fARM4 = cell2mat(trial_filt(10));
            fARM5 = cell2mat(trial_filt(11));
            fARM6 = cell2mat(trial_filt(12));
            
            HAND1 = cell2mat(trial_filt(13));
            HAND2 = cell2mat(trial_filt(14));
            HAND3 = cell2mat(trial_filt(15));
            HAND4 = cell2mat(trial_filt(16));
        
            for i = 1:frames %FRAME ITERATIONS

                %Arm data
                ARM(1,:) = ARM1(i,:);
                ARM(2,:) = ARM2(i,:);
                ARM(3,:) = ARM3(i,:);
                ARM(4,:) = ARM4(i,:);
                ARM(5,:) = ARM5(i,:);
                ARM(6,:) = ARM6(i,:);
            
                %Forearm data
                fARM(1,:) = fARM1(i,:);
                fARM(2,:) = fARM2(i,:);
                fARM(3,:) = fARM3(i,:);
                fARM(4,:) = fARM4(i,:);
                fARM(5,:) = fARM5(i,:);
                fARM(6,:) = fARM6(i,:);
            
                %Forearm data
                HAND(1,:) = HAND1(i,:);
                HAND(2,:) = HAND2(i,:);
                HAND(3,:) = HAND3(i,:);
                HAND(4,:) = HAND4(i,:); 
        
                [JOINTS,~,~,~,rotHand] = ArmReconstruction_filt(ARM, fARM, HAND,l1,l2,b3,t1);

                wrist(i,:) = JOINTS(3,:);
               
                % ANGLE BETWEEN PLANES
        
                [elbow_angle,V_plane1,V_plane2] = elbowElevationAngle(JOINTS);      
                elbow_data(i,1) = elbow_angle;
        
                % HAND 'XYZ' POSITION
        
                elbow_data(i,2:4) = JOINTS(4,:);   % Hand's XYZ position
                
                % EULER ROTATION ANGLES
        
                euler_rot_angles = rotm2eul(rotHand,"XYZ")*(180/pi);
                elbow_data(i,5:7) = euler_rot_angles;   % Euler rotational angles of the hand (Pitch-Roll-Yaw)
                
                % AXIS ROTATION ANGLE
                
                axis_rot_angle = rotm2axang(rotHand)*(180/pi)  ;                  
                elbow_data(i,8) = axis_rot_angle(4);    % Axis-Angle Rotation        
                      
            end

            %elbow_data = elbow_data(frames_window,:);

            % Determine START frame based in a wrist joint movement above 5 mm/s

            for s = 100:length(wrist)

                vel = sqrt(sum((wrist(s) - wrist(s+10)).^2,2)) / 0.1;
                if vel > 5
                    disp("start: " + s)
                    break
                end

            end

            % Determine START frame based in the frist wrist joint movement below 5 mm/s
            % found from the last frame to the start

            for f = length(wrist):-1:100

                vel = sqrt(sum((wrist(f-10) - wrist(f)).^2,2)) / 0.1;                
                if vel > 5
                    disp("end: " + f)
                    break
                end

            end

            start_frames(j,k) = s;
            final_frames(j,k) = f;

            wrist = [];
            elbow_data = elbow_data(s:f,:);            

            elbow_data(:,1) = medfilt1(elbow_data(:,1),5);
            elbow_data(:,8) = medfilt1(elbow_data(:,8),10);        
            
            elbow_data_all(j,k) = mat2cell(elbow_data,size(elbow_data,1),8);
            elbow_data = [];
        
        end
    
    end
    
% Save values 
% Uncomment lines 145-148 to create 'mat' file with computed values

% disp('Saving subject data...')
% path = ("Data\Elbow_Data\Elbow_Filtered\elbow_data_S" + Subj_name);
% save(path,'elbow_data_all','start_frames','final_frames')
% elbow_data_all = [];

end
toc

disp('Analysis completed!')




