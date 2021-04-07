Preparations:
    Edit "GRF_file_all.xml" to fit your measurement setup. This file has to contain all different options, e.g. right foot at FP1 and right foot at FP2, left foot at force plate 1, left foot at FP2
    Starting with all options for right leg following the options for the left leg!
    "a_generateGRF_XML.m" must be edited (offset to index in line 53)
    Events (foot strike, foot off) must be set in C3D - file

    If you have something different to gait trials, code needs to be adjusted.


Run Script:
    At 'Invert walking direction?' the answer is most-likely "No".
    Select the correct and valid foot strikes (foot must be on the force plate)
    Select the correct force plates for each foot. This sets the proper GRF.xml

OUTPUT:
    Creates a folder with the same name as the *.c3d - file containing
        - settings.mat --> contains frequency, cycle, duration, ...
        - c3dfile.c3d --> copy of the original c3d-file
        - marker-experimental.trc --> marker trajectories
        - grf.mot --> ground reaction forces
        - GRF.xml --> assignment of ground reaction forces


Further processing with OpenSim can be done with the scripts from "runOpenSimFromMatlab"