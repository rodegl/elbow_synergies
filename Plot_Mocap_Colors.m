clc; clear; close all;

set(0,'DefaultFigureWindowStyle','normal');

Subj_name = '5'; %1,3,38 NOT AVAILABLE
Task_id = '28';   
Repetition_id = '1';

trial = ['Data/UP_Kinematic/KIN_Filtered/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];

load(trial) %load trial data from subject
run(sub_markers_id) %Load marker IDs of the subject

speed = 10;

final = length(cell2mat(trial_filt(1)));

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


for i= 1:speed:final   
    
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
    
    win_s = 550;
    fig_1 = figure(1);
    fig_1.Position = [500 100 win_s win_s];    

    blue = [0 0.4470 0.7410];
    scatter3(ARM(:,1),ARM(:,2),ARM(:,3), 20, blue,'filled');         %Plot arm markers
    hold on
    scatter3(fARM(:,1),fARM(:,2),fARM(:,3), 20, 'red','filled');     %Plot forearm markers
    hold on
    green = [0.4660 0.6740 0.1880];
    scatter3(HAND(:,1),HAND(:,2),HAND(:,3), 20, green,'filled');     %Plot hand markers
    
    hold off  %Comment to display all frames in the same plot
    grid on
    %view(-90,0)        % left (YZ)
    %view(0,90)         % top (XY)
    %view(0,0)          % front (XZ)
    %view(3)
    axis equal
    xlim([-inf inf])
    ylim([-inf inf])
    zlim([-inf inf])
    xlabel('X [mm]')
    ylabel('Y [mm]')
    zlabel('Z [mm]')

end







