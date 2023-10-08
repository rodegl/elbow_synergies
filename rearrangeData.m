function [table_out] = rearrangeData(table_in)

%Reorient markers to ANYexo WRD frame
table_in(:,[3,4]) = table_in(:,[4,3]); %Swap Y and Z columns
table_in(:,[3,2]) = table_in(:,[2,3]); %Swap Y and X columns
table_in(:,3) =  -1*table_in(:,3); %Change sign of Y column
table_in(:,2) =  -1*table_in(:,2); %Change sign of X column

table_out = table_in;

end
