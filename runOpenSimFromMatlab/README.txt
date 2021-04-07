Requirements:
    OSIM-Model:
    In the same folder of the "*.osim" model there needs to be the "*_actuators.xml" file to run Static Optimization.
    It has to have the same filename without ".osim" but "_actuators.xml".
    E.g.:
        gait2392.osim
        gait2392_actuartors.xml

    C3D files must have been processed with "process_C3D"
    There must be a folder with the same name as the *.c3d - file containing
        - settings.mat
        - c3dfile.c3d
        - marker-experimental.trc
        - grf.mot
        - GRF.xml

    SetupFiles
        Put your desired setup options in this files.
        e.g. markers used for inverse kinematics, ... 
        Best is to set the options in OpenSim GUI and then "Save" the settings to an xml file.


Simulation and Plot options:
From line 10 to 18 options can be checked if this simulation should be run. --> they are dependent of each other, so you cannot run JRL only for example...
Plot functions are not nice, but they can give a quick overview if simulation worked as expected.

Scripts of folder "runFullTrial" run the simulations of the full trial timerange.

Scripts of folder "runTimeFrameOfInterest" run the simulations from variable "cycle".
    startTime = double(min(cycle.left.start, cycle.right.start)) / 100;
    endTime = double(max(cycle.left.footOff, cycle.right.footOff)) / 100;


OUTPUT
    at the selected output folder a new folder with the model name is created. 
    This contains another folder for each trial processed.
    Every simulation (IK, ID, SO, JRL) which was run has a seperate folder containing
        - the specific setupFile.xml --> you can load this in the OpenSim GUI to check if everything was set as expected
        - the output of the simulation --> for example for IK: marker_errors_summary.txt, IK.mot (and IK_marker_errors.sto)