%----------------------------------------------------------------------
%DESCRIPTION: This script has the purpose of visualize the rotation of a XYZ frame
%  given inital and final rotational matrices using Euler angles in degrees
%----------------------------------------------------------------------

clc; clear; close all;

% set docked figure style       
set(0,'DefaultFigureWindowStyle','normal');

% Open figures in background
set(0, 'DefaultFigureVisible', 'on');

win_s = 600; %Size of the window in pixels 

X = [0 0 0; 5 0 0];
Y = [0 0 0; 0 5 0];
Z = [0 0 0; 0 0 5];

%Roll-Pitch-Yaw rotation angles
start_pos = [0 0 0];       %Initial roational matrix
final_pos = [-90 -135 0];  %Final rotational matrix

frames = 100;

Roll = linspace(start_pos(1),final_pos(1),frames);
Pitch = linspace(start_pos(2),final_pos(2),frames);
Yaw = linspace(start_pos(3),final_pos(3),frames);

% start_pos = [-135 0 -90];
% med_pos = [-45 0 -90];
% final_pos = start_pos; 

% Roll1 = linspace(start_pos(1),med_pos(1),frames);
% Pitch1 = linspace(start_pos(2),med_pos(2),frames);
% Yaw1 = linspace(start_pos(3),med_pos(3),frames);
% 
% Roll2 = linspace(med_pos(1),final_pos(1),frames);
% Pitch2 = linspace(med_pos(2),final_pos(2),frames);
% Yaw2 = linspace(med_pos(3),final_pos(3),frames);
% 
% Roll = [Roll1 Roll2];
% Pitch = [Pitch1 Pitch2];
% Yaw = [Yaw1 Yaw2];

for i = 1:length(Roll)

    euler = [Roll(i) Pitch(i) Yaw(i)];

    rotm = eul2rotm(euler.*(pi/180),"XYZ");
    
    X2 = [0 0 0; rotm(:,1)' .* 3];
    Y2 = [0 0 0; rotm(:,2)' .* 3];
    Z2 = [0 0 0; rotm(:,3)' .* 3];

    fig_1 = figure(1);            

    if i == 1
        fig_1.Position = [win_s+100 100 win_s win_s];
    end 
    
    %World Frame
    plot3(X(:,1),X(:,2),X(:,3), Color=[1 0 0 0.3], LineWidth=2);
    hold on
    plot3(Y(:,1),Y(:,2),Y(:,3), Color=[0 1 0 0.3], LineWidth=2);
    hold on
    plot3(Z(:,1),Z(:,2),Z(:,3), Color=[0 0 1 0.3], LineWidth=2);
    
    %Rotated Frames
    hold on
    plot3(X2(:,1),X2(:,2),X2(:,3), Color=[1 0 0], LineWidth=2);
    hold on
    plot3(Y2(:,1),Y2(:,2),Y2(:,3), Color=[0 1 0], LineWidth=2);
    hold on
    plot3(Z2(:,1),Z2(:,2),Z2(:,3), Color=[0 0 1], LineWidth=2);

    hold off
    %view(-1.263621150654579e+02,32.523433242506812)
    axis equal
    xlim([-10 10])
    ylim([-10 10])
    zlim([-10 10])

    

end

%hold on