%----------------------------------------------------------------------
%NOTE:This script only works with filtered data located in 'Data/UP_Kinematic/KIN_Filtered'
%----------------------------------------------------------------------
%DESCRIPTION: This script makes the same calculations decribed in 'UP_001'. 
% However, the data is taken and graphed in a 3D plot frame after frame, 
% making an animation as a result.
% This script has only illustration and validation purposes, no data is stored.
%----------------------------------------------------------------------

lc; clear; close all;

set(0,'DefaultFigureWindowStyle','normal');

win_s = 600;

tasks = 1:30;
repetitions = 1:1;

%%'FOR' LOOP TO CREATE ANIMATION
for i = 12 % Subject's data to be processed [1,3,38] NOT AVAILABLE, up to 42
    Subj_name = int2str(i); 

    sub_markers_id = ['Data/IDs_Definitions/IDs_Definition_S' Subj_name '.m'];
    run(sub_markers_id) %Load marker IDs of the subject

    load("Data\Elbow_data\Elbow_filtered\elbow_data_S" + Subj_name)
    

for k = tasks %TASKS
    Task_id = int2str(k); 

    col = hsv(30);
    color_i = randi(30);

for j = repetitions %REPETITIONS
    
    disp("Analizing " + Subj_name + "; task: " + k + "; repetition: " + j)
    Repetition_id = int2str(j);
    trial = ['Data/UP_Kinematic/KIN_Filtered/S' Subj_name '/S' Subj_name '_' Task_id '_' Repetition_id '.mat'];
    
    %Load data in 'filename'
    load(trial)    
    
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

    
    speed = 10; %Increase the speed of the animation

    frames_window = start_frames(j,k):speed:final_frames(j,k);

    for i =  frames_window %FRAME ITERATIONS 

        
  
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

        [JOINTS,Vx,Vy,Vz,rotHand] = ArmReconstruction_filt(ARM, fARM, HAND,l1,l2,b3,t1);        

        %% ANGLE BETWEEN PLANES        

        [theta,V_plane1,V_plane2] = elbowElevationAngle(JOINTS);
      
        elbow_angles(i) = theta;     

            %% PLOTTING
            
            fig_1 = figure(1);            

            if i == start_frames(j,k)
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
%             hold on
%             plot3(V_plane1(:,1),V_plane1(:,2),V_plane1(:,3),LineStyle='-',LineWidth=1.5,Color=orng)        %Vector normal to plane 1            
%             hold on
%             plot3(V_plane2(:,1),V_plane2(:,2),V_plane2(:,3),LineStyle='-',LineWidth=1.5,Color='k')        %Vector normal to plane 2
            
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
        ylabel('Elbow Elevation Angle (deg)','FontSize',15)
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

disp('Analysis completed!')





