--------------------------------------
ELBOW SYNERGIES PROJECT (SWIVEL ANGLE)
--------------------------------------

Required MATLAB Add-Ons:
-Navigation Toolbox
-Robotics System Toolbox
-Simulink Real Time

INTRODUCTION

This project has the purpose of obtaining an optimmal 'elbow elevation angle' (or swivel angle) by using the kinematic
data from the University of Pisa, which is part of the U-LIMB dataset. These dataset contains kinematic data of the arm
of healty subject performing Activities of Daily Living (ADL). From this information, the arm of the subjects was
reconstructued, and then the swivel angle progression was calculted for every task and every subject to create a new dataset. 
Finally, an 'optimal' swivel angle is computed based in the similarity of the desired position and orientation  of the hand
with the data available in the generated dataset.

The root folder contains six MATLAB codes labeled 'UP_00x_NAME" where 'x' indicates the order in which the files
shoulde be runned to build up the dataset, followed by a file 'NAME' that gives a general idea of what the code does.
Inside each one of the MATLAB files is provided a general description, as well as comments to have a detailed
comprehension of the purpose of specific variables and sections of the code.

Ahead is provided a description of the main MATLAB files:

-------------- 'UP_000' -------------- 
This script filters the kinematic data using a median and a butterworth filter. Its recommendable to filter the
original data since the XYZ position of the markers present noise and they occur to be occluded in multiple occasions. 
Once the data is filtered it is saved with in 'mat' files using the orignal name file system: data is divide by 
folders named 'SX', where 'X' indicate the number of the subject, the folders goes from S2 to S42, beign the folders 
S3 and S38 nonexistant. Each subject folder contains mat files named 'SX_Y_Z', where 'X' represents the subject number, 
'Y' is the number of the task or ADL (30 in total), and 'Z' being the repetition (3 in total).

Each 'mat' file contains a cell array. Each cell has the XYZ position an specific marker, from columns 1 to 3. While
each row correspon to XYZ position of an specific frame. The cells 1 to 6, contain the data from the upper arm. 
Cells 7 to 12 contain the data from the forearm, and cell 13 to 16 the data from the hand markers.

-------------- 'UP_001' -------------- 
Once the data is filtered, the XYZ data is processed to obtain an estimated position of the elbow, wrist and center of 
the hand, as well as the orientaiton of this last one. Here the function 'ArmReconstruction_filt' plays an important role. 
The inputs for this function are the upper arm, forearm and hand's markers, and the anotomical measures from the subject 
obtained from the corresponding script 'ID_Definition_SX".

Using the markers 'XYZ' data from each section of the arm, the normal vector is computed and the multiplied by it 
corresponding anatomical length. Considering the shoulder as the origin of the world (WRD) frame, the position 
of the elbow, wrist and center of the hand is estimated.

Then, the position of these joints are used as the inputs for the function 'elbowElevationAngle' to calculate the elevation
of the elbow (swivel angle) from the subject at each frame. The swivel angle is from by two planes. The first plane is 
created by the shoulder, the wrist, and a point along the 'Z' axis. The second plane is formed by the shoulder, elbow, and
wrist joints.

The orientation of the hand is computed as follows. The orientation of the 'Y' axis is the average orientation of the markers
along the hand (from wrist to fingers). Then, the 'X' axis if obatined by the cross product between a vector along 
the plane formed by the markers of the hand and the 'Y' axis, the 'X' axis will come out from the palm of the hand. Finally,
the 'Z' axis is the cross product bewteen the 'Y' and the 'X' axis.

The orientation of these 'XYZ' vectors will conform the rotational matrix of the hand. The rotational matrix then is used
to obtain the Euler rotational angles and the axis rotation angle, with respect to the WRD frame.

This process is performed for every frame, and stored in a cell matrix, where the columns are the tasks and the rows are 
the repetitions. Each cell contains the values for each task, the data is arranged in the following format:

[ Swivel_Angle, X, Y, Z, Roll, Pitch, Yaw, Axis_Rotation_Angle ]

The XYZ values correspond to the position of the center of the hand. As well, the Roll-Pitch-Yaw Euler rotational
angles, and the Axis Rotation Angle correspond to the hand's orienation. The values are arranged in 8 columns, an each row
is the values for each frame of the task.

The cell matrix containg the data from all the tasks and repetitions of an specific subject are stored in a 'mat' file named
'elbow_data_SX' where 'X' indicates the number of the corresponding subject.

-------------- 'UP_002' -------------- 
This script allows to visualize in plots the 'swivel angle' and the 'axis rotation angle' progression from all the task and
repetitions of one subject. The plots are divided in intransitive, transitive and tool-mediated activities.

-------------- 'UP_003' --------------  
This script makes the same calculations decribed in 'UP_001'. However, the data is taken and graphed in a 3D plot frame
after frame, making an animation as a result. The 3D plot shows a box representing the torax of the subject, the subject's
anatomical measures are consired for the size of the box. Blue markers represt the shoulder, elbow, wrist, center of the hand
and hip (a point along the 'Z' axis). Blue lines are the connections between these joints, forming the arm of the subject.
The WRD frame is displayed at the shoulder joint, as the 'XYZ' is displayed at the center of the hand, according to
its current orientation.

The shoulder-wrist-hip plane is displayed in red color, as the shoulder-elbow-wrist plane in blue. When running the script
is possible to see how the arm of the subject moves. After each task is finished, the 'swivel angle' progression of the
corresponding task will be displayed in a plot on the left side.

This script has only illustration and validation purposes, no data is stored.

-------------- 'UP_004' -------------- 
In this script, given a desired position and orientation for the hand, a swivel angle is computed based is the created
database. This similarity of the desired valued and the data set is displayed in a plot, this gives as a result a 
'cloud of points'.

Before hand, in the 'subjectDataset' script, 'elbow_data_SX' files are merged in a single 'mat' file, grouped according to
the total arm length of the subjects.

The arm length of the 'subject' needs to be defined. The corresponding dataset is selected and loaded. Then, using a 
function that considers the Euclidian distance and Angular distance, the similarity between of the desired position 
and orientation of hand with the ones from the database is obtained. Different weights (together summing a total of 1) can be 
given to each one of these parameter. The "swivel angle" of every frame of the dataset will be plotted along the 'x' axis 
according to its distance value (error), where the values closer to 0 have a higher similarity with the desired 
position and orientation.

To compute an optimal "swivel angle", a gaussian distribution is obtained from the plotted data, using a standard deviation
in function of the maximum tolerated distance (0.2 for example). This gaussian will be merged with a linear distribution that
will start from the inflexion point of the gaussian distribution to the maximum tolerated distance. The values of this new 
gaussian-linear will correspond to a specific "swivel angle", representing the weigh of such value. 
Then, all angles are mutiplied by their correspondind weight and summed. Finally, this value is devided by the sum of the 
weigths, obtaining as a result an 'optimal' swivel angle for the desired position and orientation of the hand.

-------------- 'UP_005' -------------- 
This script allows to compute the 'optimal' swivel angle for a given position and orientation of the hand along a trajectory. 
The start and end positions need to be defined, creating a linear interpolation between those points.
As as result, a plot will show the progression of the swivel angle along the trajectory. Several configurations of the
gains (Euclidian distace and Angular distance) are consired. The result of configuration is showed in the same plot, 
allowing to compare the impact of each gain. 

***NOTE***
The scripts ending in '_Filtered' only works with the filtered data, since the data is arranged differently than the
orginal data.


--- MORE INFO ---

For any information, feel free to contact me through <rodericogarcia@outlook.com> or <a00821066@tec.mx>

The U-Limb publication can be found here: https://academic.oup.com/gigascience/article/10/6/giab043/6304920
The dataset can be downloaded here: https://doi.org/10.7910/DVN/FU3QZ9

