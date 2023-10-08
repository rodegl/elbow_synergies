%----------------------------------------------------------------------
%NOTE:This script only works with original data located in 'Data/UP_Kinematic/KIN_Original'
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

speed = 1; %Reduces amoun of frames to be processed
start_frame = 380;
end_frame = 1400;

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
            trial = ['Data/UP_Kinematic/KIN_Original/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
            
            %Load data in 'filename'
            load(trial)
            table = cell2mat(data);
            frames = length(data);

            if frames<end_frame
                final_frame = frames;
            else
                final_frame = end_frame;
            end
        
            frames_window = start_frame:speed:final_frame;
        
            for i = frames_window %FRAME ITERATIONS
                trial_data = cell2mat(data(i)); % Load data for 'i' frame
        
                [JOINTS,~,~,~,rotHand] = ArmReconstruction(trial_data,ArmIDS, ForearmIDS, HandIDS,l1,l2,b3,t1);
               
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
        
            elbow_data = elbow_data(frames_window,:);
            elbow_data_all(j,k) = mat2cell(elbow_data,size(elbow_data,1),8);
            %elbow_data = [];
        
        end
    
    end
    
    
% Save values
disp('Saving subject data...')
path = ("Data\Elbow_data\Elbow_Original\elbow_data_S" + Subj_name);
save(path,'elbow_data_all','tasks','repetitions','speed')

%elbow_data_all = [];

end
toc

disp('Analysis completed!')




