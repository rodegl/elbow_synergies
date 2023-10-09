clc; clear; close all;

% WARNING: THIS SCRIPT MODIFIES THE ORIGINKA DATA. 
% ONLY USE IF DIMENSIONS DOESN'T FIT WHEN RUNNING UP_001

%%Load a sample mat data
%root1 = 'C:\Users\roder\Desktop\U_Limb_Database\UP\Data_KIN\KIN'; % Uncomment to run script

tasks = 1:30;
repetitions = 1:3;

tic

for r = 16:16

    Subj_name = int2str(r); %1,3,38 NOT AVAILABLE

for k = tasks %TASKS

    Task_id = int2str(k); 

for j = repetitions %REPETITIONS    
   
    disp("Analizing " + Subj_name + "; task: " + k + "; repetition: " + j)

    Repetition_id = int2str(j);

    trial = [root1 '/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
    
    %Load data in 'filename'
    load(trial)    

    for i =  1:length(data) %FRAME ITERATIONS

          table = cell2mat(data(i));
          table = table(1:40,:);
          data(i) = mat2cell(table,40,4);
              
    end

    path = ("C:\Users\roder\Desktop\U_Limb_Database\UP\Data_KIN\KIN\S" + Subj_name + "\S" + Subj_name + "_" + k + "_" + j);
    save(path,'data')

end
end
end
toc

disp('Analysis completed!')

%% Save values



