function [limb,left_v,right_v] = getMarkers(data,markersIDs,n)
for i = 1:n
    if n == 6
        j = [2 4 6 1 3 5]; %Markers order for upper arm and forearm 
    elseif n == 4
        j = [2 4 1 3];     %Markers order for hand
    end
 
    index = find(ismember(data(:,1),markersIDs(j(i))));
    limb(i,:) = data(index,2:4);    
end

    if n == 6
        left_v = limb(1:3,:);
        right_v = limb(4:6,:);
    elseif n == 4
        left_v = limb(1:2,:);
        right_v = limb(3:4,:);
    end
    

end