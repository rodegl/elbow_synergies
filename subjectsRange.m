function [sub_ids,label] = subjectsRange(arm_length)

    if arm_length >= 670
        sub_ids= [8, 40];
        label = ("_670_inf");
    elseif arm_length >= 640
        sub_ids = [7, 37];
        label = ("_640_670");
    elseif arm_length >= 610
        sub_ids = [5, 6, 20, 21, 25, 31, 32, 33];
        label = ("_610_640");
    elseif arm_length >= 580
        sub_ids = [9, 13, 15, 16, 22, 24, 34, 35, 36, 41];
        label = ("_580_610");
    elseif arm_length >= 550
        sub_ids = [4, 11, 14, 17, 18, 30, 39];
        label = ("_550_580");
    elseif arm_length >= 520
        sub_ids = [10, 12, 26, 27, 29];
        label = ("_520_550");
    elseif arm_length >= 490
        sub_ids = [23, 28];
        label = ("_490_520");
    else
        sub_ids = 19;
        label = ("_0_490");
    end

end