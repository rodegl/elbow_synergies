%----------------------------------------------------------------------
%DESCRIPTION: This script calculates the elevation of the elbow (swivel angle)
% given the XYZ position of the JOINTS. The swivel angle is from by two planes. 
% The first plane is created by the shoulder, the wrist, and a point along the 'Z' axis. 
% The second plane is formed by the shoulder, elbow, and wrist joints.
%----------------------------------------------------------------------

function [theta,V_plane1,V_plane2] = elbowElevationAngle(JOINTS)
        %Plane 1 - Hip-Shoulder-Wrist
        V_p1 = JOINTS(5,:);                 %Vector: Shoulder - Hip

        %Plane 2 - Shoulder-Elbow-Wrist
        V_p2 = JOINTS(2,:);                 %Vector: Shoulder - Elbow
        
        V_half = JOINTS(3,:) - JOINTS(1,:); %Vector: Shoulder - Wrist
        
        V_plane1 = cross(V_p1,V_half);      
        V_plane1_n = V_plane1/norm(V_plane1);                %Normal vector to Plane 1
        V_plane1(1,:) = (JOINTS(1,:) + JOINTS(3,:))/2;
        V_plane1(2,:) = (V_plane1_n * 100) + V_plane1(1,:);
        
        V_plane2 = cross(V_half,V_p2);                
        V_plane2_n = V_plane2/norm(V_plane2);           %Normal vector to Plane 2 (arm)
        V_plane2(1,:) = (JOINTS(1,:) + JOINTS(3,:))/2;
        V_plane2(2,:) = (V_plane2_n * 100) + V_plane2(1,:);

        % Angle between normal vectors
        theta = 180 - acosd(dot(V_plane1_n,V_plane2_n)/(norm(V_plane1_n)*norm(V_plane2_n)));   
end