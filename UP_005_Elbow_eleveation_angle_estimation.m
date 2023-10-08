%----------------------------------------------------------------------
%DESCRIPTION: This script allows to compute the 'optimal' swivel angle 
% for a given position and orientation of the hand along a trajectory. 
% The start and end positions need to be defined, creating a linear 
% interpolation between those points. As as result, a plot will 
% show the progression of the swivel angle along the trajectory.
%----------------------------------------------------------------------

clc; clear; close all;
tic
set(0,'DefaultFigureWindowStyle','docked');
set(0, 'DefaultFigureVisible', 'on');

subj_dataset = [];
correl_data_all = [];

arm_length = 620;                       %Subject arm length (shoulder to center of hand [mm])
[sub_ids, label] = subjectsRange(arm_length); %Dataset selection based on arm length

load("Data\Datasets\subj_dataset" + label)

%% Read and analyze dataset for specific position
clc; close all;
%Position = [X, Y, Z, Roll, PItch, Yaw]

dmax = 0.2; %Maximum tolerance error

% Activity = 'Eat';
% start = [450 -150 -280, 0 0 0];
% final = [150 250 150, 45 0 70];

% Activity = 'Touch-head';
% start = [450 -150 -280, 0 0 0];
% final = [50 220 360, -90 -90 0];

% Activity = 'Touch-shoulder';
% start = [450 -150 -280, 0 0 0];
% final = [150 350 100, -90 -135 0];

% Activity = 'Left-to-right';
% start = [200 400 0, -90 -90 0];
% final = [0 -620 0, -90 -135 0];

Activity = 'L-shape-turndown';
start = [80 -250 350, -90 0 -90];
final = [350 -250 0, -90 0 0];

% Activity = 'Thumb-down';
% start = [450 -25 -280, 0 0 0];
% final = [500 250 0, -180 0 -45];

% Activity = 'Thumb-up';
% start = [450 -25 -280, 0 0 0];
% final = [500 250 0, 0 0 0];

% Activity = 'Move-to-side';
% start = [450 250 -280, -90 -45 0];
% final = [450 -450 -280, -90 45 0];

% Activity = 'Pour-water';
% start = [400 220 -150, 0 0 55];
% final = [400 220 -150, -100 -55 0];

% Activity = 'Wave-hand';
% start = [320 -250 100, -135 0 -90];
% med = [320 250 100, -45 0 -90];
% final = start;

load("trajectories.mat")

frames = 50;

X = linspace(start(1),final(1),frames);
Y = linspace(start(2),final(2),frames);
Z = linspace(start(3),final(3),frames);

Roll = linspace(start(4),final(4),frames);
Pitch = linspace(start(5),final(5),frames);
Yaw = linspace(start(6),final(6),frames);

for h = 1:length(X)
    tic

    pos = [X(h) Y(h) Z(h) Roll(h) Pitch(h) Yaw(h)];    

    gain_xyz = 0;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj(h) = elbow_angle;
    
    % g = 0.15
    gain_xyz = 0.15;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj2(h) = elbow_angle;

    % g = 0.25
    gain_xyz = 0.25;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj3(h) = elbow_angle;

    % g = 0.5
    gain_xyz = 0.5;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj4(h) = elbow_angle;

    % g = 0.75
    gain_xyz = 0.75;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj5(h) = elbow_angle;

    % g = 0.85
    gain_xyz = 0.85;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj6(h) = elbow_angle;

    % g = 1
    gain_xyz = 1;
    gain_rpy = (1-gain_xyz);
    [elbow_angle, ~, ~, ~, ~, ~, ~] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);   
    elbow_traj7(h) = elbow_angle;

    toc

end

%% Plot elbow trajectory

switch dmax
    case 0.25
        col = winter(7);
    case 0.2
        col = copper(7);
    case 0.15
        col = cool(7);
    otherwise
        col = lines(7);
end

%frames = length(X);

plot(1:frames,elbow_traj,LineWidth=2,Color=col(1,:),LineStyle="-")
hold on
plot(1:frames,elbow_traj2,LineWidth=2,Color=col(2,:),LineStyle="--")
hold on
plot(1:frames,elbow_traj3,LineWidth=2,Color=col(3,:),LineStyle=":")
hold on
plot(1:frames,elbow_traj4,LineWidth=2,Color=col(4,:),LineStyle="-")
hold on
%plot(1:frames,elbow_traj5,LineWidth=7,Color="black",LineStyle=":")
plot(1:frames,elbow_traj5,LineWidth=4,Color=col(5,:),LineStyle=":")
hold on
plot(1:frames,elbow_traj6,LineWidth=2,Color=col(6,:),LineStyle="--")
hold on
plot(1:frames,elbow_traj7,LineWidth=2,Color=col(7,:),LineStyle="-")


legend('g_{xyz} = 0    | g_{rpy} = 1', ...
       'g_{xyz} = 0.15 | g_{rpy} = 0.85', ...
       'g_{xyz} = 0.25 | g_{rpy} = 0.75', ...
       'g_{xyz} = 0.5  | g_{rpy} = 0.5', ...
       'g_{xyz} = 0.75 | g_{rpy} = 0.25', ...
       'g_{xyz} = 0.85 | g_{rpy} = 0.15', ...
       'g_{xyz} = 1    | g_{rpy} = 0','Location','best')

ylabel('Elbow Elevatiom Angle (°)')
xlabel('Frames')
title('Estimations of Elbow Elevation Angle',"FontSize",25)
subtitle("Start = [" + num2str(start) + "] ; " + "Final = [" + num2str(final) + "]; " + "d_{max} = " + dmax,"FontSize",15)

set(gca,"FontSize",20)

%% Save

filename = ("G:\Mi unidad\SMS Lab - Summer Fellowship\KIN_test\Plot_UP_data\Figures\TESTS\" + Activity + "_" + dmax + ".fig");
saveas(gcf,filename)




   