%----------------------------------------------------------------------
%DESCRIPTION: This script filters the kinematic data using a median and a butterworth filter. 
% Its recommendable to filter the original data since the XYZ position of the markers present noise 
% and they occur to be occluded in multiple occasions. 
%----------------------------------------------------------------------

clc; clear; close all;

root = "Data\UP_Kinematic"; %Directory to store the generated 'mat' files

speed = 1; %Amount of frames to skip from the original data

subjects = [2,4:37,39:42];  % Subject's data to be processed [1,3,38] NOT AVAILABLE, up to 42
tasks = 1:10;               % Selection of ADL
repetitions = 1:1;          % Number of repetitions 

%Butterworth filter design
fc = 3;
fs = 100;
n_order = 5;
[b,a] = butter(n_order,fc/(fs/2));

tic

for r = subjects %SUBJECTS

    Subj_name = int2str(r); 

    sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];
    run(sub_markers_id) %Load marker IDs of the subject

    for k = tasks %TASKS
        Task_id = int2str(k); 
    
        for j = repetitions %REPETITIONS    
           
            disp("Filtering data from: S" + Subj_name + "; task: " + k + "; repetition: " + j)
        
            Repetition_id = int2str(j);
            trial = ['Data/UP_Kinematic/KIN_Original/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
            
            %Load data in 'filename'
            load(trial)
            table = cell2mat(data);
            frames = length(data); 

            frames_window = 1:speed:frames;
        
            for i = frames_window %FRAME ITERATIONS

                %Reorient markers to ANYexo WRD frame                

                trial_data = cell2mat(data(i)); % Load data for 'i' frame
                [trial_data] = rearrangeData(trial_data);
                trial_data(:,2:4) = trial_data(:,2:4);                
                
                A_L1(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(2)),2:4); %Left
                A_L2(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(4)),2:4);
                A_L3(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(6)),2:4);
                A_R1(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(1)),2:4); %Right
                A_R2(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(3)),2:4);
                A_R3(i,:) = trial_data(ismember(trial_data(:,1),ArmIDS(5)),2:4);

                F_L1(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(2)),2:4); %Left
                F_L2(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(4)),2:4);
                F_L3(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(6)),2:4);
                F_R1(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(1)),2:4); %Right
                F_R2(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(3)),2:4);
                F_R3(i,:) = trial_data(ismember(trial_data(:,1),ForearmIDS(5)),2:4);

                H_L1(i,:) = trial_data(ismember(trial_data(:,1),HandIDS(2)),2:4); %Left
                H_L2(i,:) = trial_data(ismember(trial_data(:,1),HandIDS(4)),2:4);
                H_R1(i,:) = trial_data(ismember(trial_data(:,1),HandIDS(1)),2:4); %Right
                H_R2(i,:) = trial_data(ismember(trial_data(:,1),HandIDS(3)),2:4);    


            end


            %ARM left
            A_L1 = A_L1(frames_window,:);
            A_L1 = medfilt1(A_L1,4);            
            A_L1 = filtfilt(b,a,A_L1);            
            trial_filt(1) = mat2cell(A_L1,length(frames_window),3);
            A_L1 = [];

            A_L2 = A_L2(frames_window,:);
            A_L2 = medfilt1(A_L2,4);
            A_L2 = filtfilt(b,a,A_L2);
            trial_filt(2) = mat2cell(A_L2,length(frames_window),3);
            A_L2 = [];

            A_L3 = A_L3(frames_window,:);
            A_L3 = medfilt1(A_L3,4);
            A_L3 = filtfilt(b,a,A_L3);
            trial_filt(3) = mat2cell(A_L3,length(frames_window),3);
            A_L3 = [];

            %ARM rigth
            A_R1 = A_R1(frames_window,:);
            A_R1 = medfilt1(A_R1,4);
            A_R1 = filtfilt(b,a,A_R1);
            trial_filt(4) = mat2cell(A_R1,length(frames_window),3);
            A_R1 = [];

            A_R2 = A_R2(frames_window,:);
            A_R2 = medfilt1(A_R2,4);
            A_R2 = filtfilt(b,a,A_R2);
            trial_filt(5) = mat2cell(A_R2,length(frames_window),3);
            A_R2 = [];

            A_R3 = A_R3(frames_window,:);
            A_R3 = medfilt1(A_R3,4);
            A_R3 = filtfilt(b,a,A_R3);
            trial_filt(6) = mat2cell(A_R3,length(frames_window),3);
            A_R3 = [];

            %FOREARM left
            F_L1 = F_L1(frames_window,:);
            F_L1 = medfilt1(F_L1,4);
            F_L1 = filtfilt(b,a,F_L1);
            trial_filt(7) = mat2cell(F_L1,length(frames_window),3);
            F_L1 = [];

            F_L2 = F_L2(frames_window,:);
            F_L2 = medfilt1(F_L2,4);
            F_L2 = filtfilt(b,a,F_L2);
            trial_filt(8) = mat2cell(F_L2,length(frames_window),3);
            F_L2 = [];
            
            F_L3 = F_L3(frames_window,:);
            F_L3 = medfilt1(F_L3,4);
            F_L3 = filtfilt(b,a,F_L3);
            trial_filt(9) = mat2cell(F_L3,length(frames_window),3);
            F_L3 = [];

            %FOREARM rigth
            F_R1 = F_R1(frames_window,:);
            F_R1 = medfilt1(F_R1,4);
            F_R1 = filtfilt(b,a,F_R1);
            trial_filt(10) = mat2cell(F_R1,length(frames_window),3);
            F_R1 = [];

            F_R2 = F_R2(frames_window,:);
            F_R2 = medfilt1(F_R2,4);
            F_R2 = filtfilt(b,a,F_R2);
            trial_filt(11) = mat2cell(F_R2,length(frames_window),3);
            F_R2 = [];

            F_R3 = F_R3(frames_window,:);
            F_R3 = medfilt1(F_R3,4);
            F_R3 = filtfilt(b,a,F_R3);
            trial_filt(12) = mat2cell(F_R3,length(frames_window),3);
            F_R3 = [];

            %HAND left
            H_L1 = H_L1(frames_window,:);
            H_L1 = medfilt1(H_L1,4);
            H_L1 = filtfilt(b,a,H_L1);
            trial_filt(13) = mat2cell(H_L1,length(frames_window),3);
            H_L1 = [];

            H_L2 = H_L2(frames_window,:);
            H_L2 = medfilt1(H_L2,4);
            H_L2 = filtfilt(b,a,H_L2);
            trial_filt(14) = mat2cell(H_L2,length(frames_window),3);
            H_L2 = [];
            
            %HAND right
            H_R1 = H_R1(frames_window,:);
            H_R1 = medfilt1(H_R1,4);
            H_R1 = filtfilt(b,a,H_R1);
            trial_filt(15) = mat2cell(H_R1,length(frames_window),3);
            H_R1 = [];
           
            H_R2 = H_R2(frames_window,:);
            H_R2 = medfilt1(H_R2,4);
            H_R2 = filtfilt(b,a,H_R2);
            trial_filt(16) = mat2cell(H_R2,length(frames_window),3);
            H_R2 = []; 

            % Save values
            %folder = ("S" + Subj_name);
            folder = (root + "\S" +  Subj_name);
            [status,~,~] = mkdir([folder]);

            
            path = (folder + "\S" + Subj_name + "_" + k + "_" + j);
            save(path,'trial_filt')
        
        end
    
    end      

%elbow_data_all = [];
disp("Data from subject " + Subj_name + " has been filtered!")

end
toc

disp('The data has been filtered!')




