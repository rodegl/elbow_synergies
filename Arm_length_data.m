clc; clear; close all;
set(0,'DefaultFigureWindowStyle','docked');
set(0, 'DefaultFigureVisible', 'on');

%%Load subject data

arm_length_data = [];

for i = [2,4:37, 39,40,41]

    Subj_name = int2str(i); %1,3,38 NOT AVAILABLE

    sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];
    run(sub_markers_id) %Load marker IDs of the subject

    arm_length_sub(1) = i; %ID
    arm_length_sub(2) = b3; %Hand
    arm_length_sub(3) = l1; %Arm
    arm_length_sub(4) = l2; %Forearm
    arm_length_sub(5) = b3 + l1 + l2; %Forearm
    arm_length_data = [ arm_length_data; arm_length_sub];

end
%toc

disp('Analysis completed!')

%% Plot data

hand = arm_length_data(:,2);
arm = arm_length_data(:,3);
forearm = arm_length_data(:,4);
full = arm_length_data(:,5);

group = [    ones(size(hand));
         2 * ones(size(arm));
         3 * ones(size(forearm));
         4 * ones(size(full));];

figure(1)
boxplot([hand; arm; forearm; full],group)
title('Arm length per section')
ylabel('Length(mm)')
xlabel('Limb')
set(gca,'XTickLabel',{'Hand','Arm','Forearm','Full arm'})

figure(2)
boxplot(full)
title('Total arm length')
ylabel('Total arm length(mm)')
xlabel('Population')

figure(3)
h = histogram(full,8);

title('Arm lengths distribution')
ylabel('Frequency')
xlabel('Length(mm)')

%% Save values
%path = ("G:\Mi unidad\SMS Lab - Summer Fellowship\KIN_test\Plot_UP_data\Data\arm_length_data");
%save(path,'arm_length_data')