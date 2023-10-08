%----------------------------------------------------------------------
%DESCRIPTION: This script allows to visualize in plots the 'swivel angle' 
% and the 'axis rotation angle' progression from all the task and 
% repetitions of one subject. The plots are divided in intransitive, 
% transitive and tool-mediated activities.
% Filtered and Original data can be plotted
%----------------------------------------------------------------------

clc; clear; close all;

subject = 9;
tasks = 1:30;
repetitions = 1:3;

tic

% set docked figure style       
set(0,'DefaultFigureWindowStyle','docked');

% Open figures in background
set(0, 'DefaultFigureVisible', 'off');

fig1 = figure(1);
fig2 = figure(2);
fig3 = figure(3);
fig4 = figure(4);
fig5 = figure(5);
fig6 = figure(6);

colors = lines(30);

%% Read data and plot data
for i = subject                       %S1,S3,S38 NOT AVAILABLE

    Subj_name = int2str(i); 

    %Load elbow data of the subject
    elbow_data = ['Data/Elbow_data/Elbow_Filtered/elbow_data_S'  Subj_name  '.mat'];
    %elbow_data = ['Data/Elbow_data/Elbow_Original/elbow_data_S'  Subj_name  '.mat'];
    load(elbow_data)

    for k = tasks

        ADL_color = colors(k,:);
        
        for j = repetitions
            
            trial_data = cell2mat(elbow_data_all(j,k));
           
            %% Plot elbow angles   
            elbow_angles = trial_data(:,1);

            [row, ~] = find(isnan(elbow_angles));
            elbow_angles(row) = 0;   %Turn 0 every NaN value               
    
            if (k<=10)
                set(0, 'CurrentFigure', fig1)
                subtitle('Intransitive A.D.L','FontSize',15)              
            elseif (k<=20)
                set(0, 'CurrentFigure', fig2)
                subtitle('Transitive A.D.L','FontSize',15)                
            else
                set(0, 'CurrentFigure', fig3)
                subtitle('Tool-Mediated A.D.L','FontSize',15)                
            end
    
            plot(elbow_angles,'LineWidth',1,'Color',ADL_color);
            title('Elbow Elevation Angle (deg)','FontSize',20)   
            ylabel('Elbow Elevation Angle (deg)','FontSize',15)
            xlabel('Frames','FontSize',15)
            ylim([-0 180])            
            xlim([-inf inf])
            grid on
            hold all
    
            %% Plot rot Angles
            rot_angles = trial_data(:,8);

            if (k<=10)
                set(0, 'CurrentFigure', fig4)
                subtitle('Intransitive A.D.L','FontSize',15)              
            elseif (k<=20)
                set(0, 'CurrentFigure', fig5)
                subtitle('Transitive A.D.L','FontSize',15)                
            else
                set(0, 'CurrentFigure', fig6)
                subtitle('Tool-Mediated A.D.L','FontSize',15)                
            end

            plot(rot_angles,'LineWidth',1,'Color',ADL_color)
            title('Axis rotational angle','FontSize',20)  
            ylabel('Axis Rotational angle (deg)','FontSize',15)
            xlabel('Frames','FontSize',15)            
            ylim([-inf 180])            
            xlim([-inf inf])
            grid on
            hold on
    
        end       
    end
end

toc

% Labels
[~,b] = xlsread('Labels2.csv');
%Intransitive data
set(0, 'CurrentFigure', fig1)
legend(b(1:30),"FontSize",10,Location="best")
set(0, 'CurrentFigure', fig4)
legend(b(1:30),"FontSize",10,Location="best")
%Transitive data
set(0, 'CurrentFigure', fig2)
legend(b(31:60),"FontSize",10,Location="best")
set(0, 'CurrentFigure', fig5)
legend(b(31:60),"FontSize",10,Location="best")
%Tool-mediated data
set(0, 'CurrentFigure', fig3)
legend(b(61:88),"FontSize",10,Location="best")
set(0, 'CurrentFigure', fig6)
legend(b(61:88),"FontSize",10,Location="best")

%% Display figures on command

prompt = '\nPress <ENTER> to plot figures! \n(<n> + <Enter> to avoid plotting)\n';
resp = input(prompt,'s');
if ~strcmp(resp,'n') && ~strcmp(resp,'N')
    set(0,'DefaultFigureVisible','on');
    for m = 1:6
        figure(m);
    end
end

%% Save figure

% current_time = clock; % get date/time
% dir = num2str(current_time(1));
% for i = 2:5
%   dir = strcat(dir,'_',num2str(current_time(i))); 
% end
% 
% prompt = '\nPress <ENTER> to save the figure! \n(<n> + <Enter> to avoid saving)\n';
% resp = input(prompt,'s');
% if ~strcmp(resp,'n') && ~strcmp(resp,'N')
%     path = ("G:\Mi unidad\SMS Lab - Summer Fellowship\KIN_test\Plot_UP_data\Figures\Elbow_hand_correlation_" + dir + ".jpeg");
%     exportgraphics(fig1,path,'Resolution',600)
%     disp("Figure saved successfully!")
% end




   