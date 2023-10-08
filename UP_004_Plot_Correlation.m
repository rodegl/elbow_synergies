%----------------------------------------------------------------------
%DESCRIPTION: In this script, given a desired position and orientation 
% for the hand, a swivel angle is computed based is the created database. 
% This similarity of the desired valued and the data set is displayed in a plot, 
% this gives as a result a 'cloud of points'.
%----------------------------------------------------------------------

clc; clear; close all;

% Desired hand's position & orientation
% Format pos = [X, Y, Z, Pitch, Roll, Yaw]

%pos = [558.0185 -111.5529 -180.0575  -69.1400   12.7001   -1.6779];
%pos = [586.773092060799	139.615795792250	35.6991020924020	-152.897522015211	-22.9398711247208	-22.2903825517907];
%pos = [450 -25 -280, 0 0 0];
pos = [500 250 0, -180 0 -45];

tic

%%Create and hide figures

% set docked figure style       
set(0,'DefaultFigureWindowStyle','docked');

% Open figures in background
set(0, 'DefaultFigureVisible', 'off');

fig1 = figure(1);
fig2 = figure(2);
fig3 = figure(3);

colors = lines(30);
markers(1:10,1) = {'o','+','*','.','x','s','d','^','v','>'};
markers = [markers; markers; markers];
 
arm_length = 620;                               %Subject arm length (shoulder to center of hand [mm])
[sub_ids, label] = subjectsRange(arm_length);   %Dataset selection based on arm length

load("Data\Datasets\subj_dataset" + label)

dmax = 0.2;
gain_xyz = 0.5;
gain_rpy = (1-gain_xyz);

[elbow_angle, weights, y_gauss, y_linear, x_linear, pointsAll, point, ADLs] = elbowEstimation(subj_dataset, arm_length, pos, gain_xyz, gain_rpy, dmax);

%% Plot elbow data 

%%%ELBOW DATA WITH IT'S CORRESPONDING MARKER
set(0, 'CurrentFigure', fig1)
for p = 1:length(ADLs)

    label_id = ADLs(p);       
    
    plotting_id = find(ismember(int64(pointsAll(:,3)),label_id)); %Identify 
    plotting_data = pointsAll(plotting_id,:);    

    scatter(plotting_data(:,1),plotting_data(:,2),15,colors(label_id,:),cell2mat(markers(label_id,1)))    
    
    hold all

end

%disp("Estimated elbow elevation angle: " + elb + "°")

% Labels
[~,b] = xlsread('Labels.csv'); %Extract labels from excel file
b = b(ADLs);

title("Elbow data per ADL",'FontSize',25)
ylabel('Elbow elevation angle w.r.t. horizontal plane','FontSize',15)
xlabel('Distance','FontSize',15)
axis([0 dmax -inf inf])
legend(b,'Location','best')
grid on

%%%ALL DATA POINTS WITH GAUSSIAN DISTRIBUTION
set(0, 'CurrentFigure', fig2)

plot(pointsAll(:,1),y_gauss,LineWidth=2)

hold on
scatter(dmax/2,point,50,"black","filled")

hold on
plot(x_linear,y_linear,LineWidth=3,Color="magenta")
ylabel('Weight')

yyaxis right
scatter(pointsAll(:,1),pointsAll(:,2),3,"red","filled",MarkerFaceAlpha=0.2)
xaxis([0 inf])
title("Gaussian Distribution",'FontSize',25)
legend('Gaussian Distribution','Inflexion Point','Linear Dist at Inflexion Point','Elbow Data')
ylabel('Elbow Elevation Angle')
xlabel('Distance')

%set(gca,"FontSize",20)

%%GAUSSIAN-LINEAR CURVE AND DATA BELOW MAX TOLERATED DISTANCE
set(0, 'CurrentFigure', fig3)

plot(pointsAll(1:length(weights),1),weights,LineWidth=3,Color="blue")
ylabel('Weight')

yyaxis right
scatter(pointsAll(:,1),pointsAll(:,2),5,"red","filled",MarkerFaceAlpha=1)
xaxis([0 dmax])
title("Gaussian-Linear Distribution",'FontSize',25)
legend('Gaussian-Linear curve','Elbow elevation angle (°)')
ylabel('Elbow Elevation Angle')
xlabel('Distance')

%set(gca,"FontSize",20)

disp("Estimated elbow elevantion angle: " + elbow_angle + "(°)")

%% Display figures on command

prompt = '\nPress <ENTER> to plot figures! \n(<n> + <Enter> to avoid plotting)\n';
resp = input(prompt,'s');
if ~strcmp(resp,'n') && ~strcmp(resp,'N')
    set(0,'DefaultFigureVisible','on');
    for m = 1:3
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
% end
% 
% disp("Figure saved successfully!")

   