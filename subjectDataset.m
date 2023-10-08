%----------------------------------------------------------------------
%DESCRIPTION: This script merges 'elbow_data_SX' files in a single 
% 'mat' file, grouped according to the total arm length of the subjects.
%----------------------------------------------------------------------

clc; clear; close all;

%Data selection based on arm length
for h = [450,500,530,600,620,650,680]

    tic
    arm_length = h;                       %Subject arm length (shoulder to center of hand [mm])
    [sub_ids,label] = subjectsRange(arm_length);
    
    subj_dataset = [];
    
    for i = sub_ids                      
        Subj_name = int2str(i); 
    
        %Load elbow data of the subject
        root = 'G:\Mi unidad\SMS Lab - Summer Fellowship\KIN_test\Plot_UP_data\Data\Elbow_data\Filtered';
        elbow_data = [root '/elbow_data_S'  Subj_name  '.mat'];
        load(elbow_data) 

        tasks = 1:30;
        repetitions = 1:3;
    
        for k = tasks              
            for j = repetitions
    
                trial_data = cell2mat(elbow_data_all(j,k));  
    
            
                trial_data(:,end+1) = k;               %ADL number
     
                subj_dataset = [subj_dataset; trial_data]; 
                trial_data = [];
        
            end       
        end  
    end

path = ("G:\Mi unidad\SMS Lab - Summer Fellowship\KIN_test\Plot_UP_data\Data\Datasets\subj_dataset" + label);
save(path,'subj_dataset')

disp("Subject dataset is READY!")

toc
end