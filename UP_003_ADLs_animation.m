%----------------------------------------------------------------------
%NOTE:This script only works with original data located in 'Data/UP_Kinematic/KIN_Original'
%----------------------------------------------------------------------
%DESCRIPTION: This script makes the same calculations decribed in 'UP_001'. 
% However, the data is taken and graphed in a 3D plot frame after frame, 
% making an animation as a result.
% This script has only illustration and validation purposes, no data is stored.
%----------------------------------------------------------------------

clc; clear; close all;

set(0,'DefaultFigureWindowStyle','normal');

speed = 10; %Increase the speed of the animation
start_frame = 380;
end_frame = 1400;

win_s = 600; % Window size in pixels 

tasks = 1:30;
repetitions = 1:1;

tic

%%'FOR' LOOP TO CREATE ANIMATION
for i = 12 % Subject's data to be processed [1,3,38] NOT AVAILABLE, up to 42
    Subj_name = int2str(i); %1,3,38 NOT AVAILABLE

    sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];
    run(sub_markers_id) %Load marker IDs of the subject

for k = tasks %TASKS
    Task_id = int2str(k); 

    col = hsv(30);
    color_i = randi(30);

for j = repetitions %REPETITIONS
    
    disp("Analizing " + Subj_name + "; task: " + k + "; repetition: " + j)
    Repetition_id = int2str(j);
    trial = ['Data/UP_Kinematic/KIN_Original/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
    
    %load data in 'filename'
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

        [JOINTS,Vx,Vy,Vz,rotHand] = ArmReconstruction(trial_data,ArmIDS, ForearmIDS, HandIDS,l1,l2,b3,t1);

        %% ANGLE BETWEEN PLANES

        [theta,V_plane1,V_plane2] = elbowElevationAngle(JOINTS);
      
        elbow_angles(i) = theta;

            %% PLOTTING
            
            fig_1 = figure(1);            

            if i == start_frame
                fig_1.Position = [win_s+100 100 win_s win_s];
            end           
                                
            %%Plot arm joints and links
            blue = [0 0.4470 0.7410];
            orng = [0.8500 0.3250 0.0980];
            green = [0.4660 0.6740 0.1880];
            scatter3(JOINTS(:,1), JOINTS(:,2), JOINTS(:,3), 40, blue,'filled')                              %Arm joints            
            hold on
            plot3(JOINTS(1:4,1), JOINTS(1:4,2), JOINTS(1:4,3), Color=green,LineWidth=2)                      %Arm links       
            
            %%Plot XYZ axes on the center of the hand
            hold on
            plot3(Vx(:,1),Vx(:,2),Vx(:,3),LineStyle='-',LineWidth=2,Color='red')                            %'X' axis            
            hold on
            plot3(Vy(:,1),Vy(:,2),Vy(:,3),LineStyle='-',LineWidth=2,Color='green')                          %'Y' axis            
            hold on
            plot3(Vz(:,1),Vz(:,2),Vz(:,3),LineStyle='-',LineWidth=2,Color='blue')                           %'Z' axis 
            
            %Plot WORLD reference frame
            hold on
            plot3([0 60],[0 0],[0 0],LineStyle='-',LineWidth=2,Color='red')                            %'X' axis
            hold on
            plot3([0 0],[0 60],[0 0],LineStyle='-',LineWidth=2,Color='gree')                            %'X' axis
            hold on
            plot3([0 0],[0 0],[0 60],LineStyle='-',LineWidth=2,Color='blue')                            %'X' axis            
            
            %%Plot box (body of the subject)
            Xmin = 0;
            Xmax= -t3;
            Ymin = 0;
            Ymax = t2*2;
            Zmin = 0;
            Zmax = -t1*2;
            idx = [4 8 5 1 4; 1 5 6 2 1; 2 6 7 3 2; 3 7 8 4 3; 5 8 7 6 5; 1 4 3 2 1]';
            xc = [Xmin Xmax Xmax Xmin Xmin Xmax Xmax Xmin]';
            yc = [Ymin Ymin Ymax Ymax Ymin Ymin Ymax Ymax]';
            zc = [Zmin Zmin Zmin Zmin Zmax Zmax Zmax Zmax]';
            
            %%Plot planes
            hold on
            elb = patch('Faces',1:3,'Vertices',[JOINTS(1,:);JOINTS(2,:);JOINTS(3,:)]);                      %Shoulder-Elbow-Wrist plane
            set(elb,'FaceColor',blue,'EdgeColor','none','LineWidth',1,'FaceAlpha',0.5)             
            hold on
            body = patch('Faces',1:3,'Vertices',[JOINTS(1,:);JOINTS(3,:);JOINTS(5,:)]);                     %Shoulder-Wrist-Hip plane
            set(body,'FaceColor',orng,'EdgeColor','k','LineWidth',1,'FaceAlpha',0.5)             
            hold on
            patch(xc(idx), yc(idx), zc(idx), 'blue', 'FaceAlpha', 0.3,'EdgeAlpha',0.5,'LineWidth',1.5);     %Plot box
            
            %%Plot normal vector from planes
            hold on
            plot3(V_plane1(:,1),V_plane1(:,2),V_plane1(:,3),LineStyle='-',LineWidth=1.5,Color=orng)        %Vector normal to plane 1            
            hold on
            plot3(V_plane2(:,1),V_plane2(:,2),V_plane2(:,3),LineStyle='-',LineWidth=1.5,Color='k')        %Vector normal to plane 2
            
            hold off %Turn 'on' to plot all the frames in the same figure
            
            grid on
            axis equal
            xlabel('X [mm]')
            ylabel('Y [mm]')
            zlabel('Z [mm]')
            
            title('Arm reconstruction','FontSize',15)
            subtitle("Subject: " + Subj_name + ", Task: " + k + ", Repetition: " + j,'FontSize',15)
            
            view(45,30)
            %view(90,0)        % front (YZ)
            %view(0,90)         % top (XY)
            %view(0,0)          % left (XZ)
            %view(3)
            sub_limits = t3+b1+b2+b3+200;
            xlim([-t3-10, sub_limits])
            ylim([-sub_limits, sub_limits])
            zlim([-sub_limits, sub_limits])

       
    
    end

    % Plot elbow angles along frames
    elbow_angles = elbow_angles(frames_window);
    elbow_angles_all(j,k) = mat2cell(elbow_angles,1,length(elbow_angles));
    
    time = speed*(linspace(0,length(elbow_angles),length(elbow_angles)))/(100);

    fig_2 = figure(2);
    fig_2.Position = [70 100 win_s win_s];
  
    if (k<=10)
        subplot(3,1,1)
        title('Intransitive A.D.L','FontSize',15)
    elseif (k<=20)
        subplot(3,1,2)
        title('Transitive A.D.L','FontSize',15)
        ylabel('Elevation Angle (°)','FontSize',15)
    else
        subplot(3,1,3)
        title('Tool-Mediated A.D.L','FontSize',15)
        xlabel('Time (s)')
    end

    if j==repetitions(1)            
        c = plot(time,elbow_angles,'LineWidth',1);
        ADL_color =  c.Color;
    else 
        plot(time,elbow_angles,'LineWidth',1,'Color',ADL_color);
    end

    grid on
    sgtitle("Elbow elevation angle w.r.t. vertical plane: S" + Subj_name,'FontSize',20)
    elbow_angles = [];
    hold all
    
  
end
end
end
toc

disp('Analysis completed!')





