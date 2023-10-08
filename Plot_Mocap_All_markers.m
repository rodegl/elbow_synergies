clc; clear; close all;

%%Load a sample mat data

Subj_name = 'S4';
Task_id = '28';   
Repetition_id = '1';

filename = ['Data/UP_Kinematic/KIN_Original/' Subj_name '/' Subj_name '_' Task_id '_' Repetition_id '.mat'];

%load data in 'filename'
load(filename)

table = cell2mat(data);
h = length(data);
q = length(table);
vx = [];
vy = [];
vz = [];

ix = 2:4:q-2;
iy = 3:4:q-1;
iz = 4:4:q;

view(3);
%view(-90,0)        % left (YZ)
%view(0,90)         % top (XY)
%view(0,0)          % front (XZ)

speed = 10; %Reduce the amount of frames to be plotted

for i = 1:speed:h

    vx = table(:,ix(i));
    vy = table(:,iy(i));
    vz = table(:,iz(i));
    
    win_s = 550;
    fig_1 = figure(1);
    fig_1.Position = [500 100 win_s win_s];
    %C = [0.3010 0.7450 0.9330];

    [az,el] = view;
    f = scatter3(-1*vx,vz,vy,10,'filled');
    view(az,el) %Update the view angle %Possible to move the plot during animation
    grid on
    %view(-90,0)        % left (YZ)
    %view(0,90)         % top (XY)
    %view(0,0)          % front (XZ)
    view(3)    
    axis equal
    xlabel('X [mm]')
    ylabel('Y [mm]')
    zlabel('Z [mm]')

    xlim([-inf,inf])
    ylim([-inf,inf])
    zlim([-inf,inf])

end




