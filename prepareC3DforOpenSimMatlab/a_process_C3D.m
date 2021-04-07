clear;
disp('Select C3D file of trial');

[modelFileName, path] = uigetfile('*.c3d', 'MultiSelect', 'off', 'Select C3D file of trial');
acq = btkReadAcquisition(fullfile(path, modelFileName));
[folder, baseFileNameNoExt, extension] = fileparts(fullfile(path, modelFileName));
output_folder = fullfile(folder, baseFileNameNoExt);

if ~exist(output_folder, 'dir')
    mkdir(output_folder)
end

% rotate data and create .trc and .mot
c3dpath = fullfile(path, modelFileName);
c3d = osimC3D(c3dpath, 1);
c3d.rotateData('x', -90)

b_invert_x = questdlg('Invert walking direction?','Invert walking direction?', 'Yes', 'No', 'No');
if strcmp(b_invert_x, 'Yes')
    c3d.rotateData('y', 90)
else
    c3d.rotateData('y', -90)
end

c3d.convertMillimeters2Meters();
nTrajectories = c3d.getNumTrajectories();

if (nTrajectories ~= 0)
    c3d.writeTRC(fullfile(output_folder, 'marker_experimental.trc'));
end

nForces = c3d.getNumForces();

if (nForces ~= 0)
    grfFileName = fullfile(output_folder, 'grf.mot');
    c3d.writeMOT(grfFileName);

end

c3devents = btkGetEvents(acq);
frequency = btkGetPointFrequency(acq);
firstFrame = btkGetFirstFrame(acq);
duration = (btkGetPointFrameNumber(acq) - 1) / frequency;
cycle = struct;
cycle.left = struct;
cycle.right = struct;

rightFootStrikeList = sprintfc('%d', c3devents.Right_Foot_Strike);
[index, tf] = listdlg('PromptString', 'Choose the time of the right foot strike', 'SelectionMode', 'single', 'ListString', rightFootStrikeList);

if (tf == 0)
    disp('No Cycle for right foot selected');
else
    % check if cycle is complete
    rightFootOff = [];
    if ( size(c3devents.Right_Foot_Strike, 2) > index)
        rightFootStrike = c3devents.Right_Foot_Strike(index);
        rightFootEnd = c3devents.Right_Foot_Strike(index + 1);
        rightFootOff = c3devents.Right_Foot_Off(find(c3devents.Right_Foot_Off > rightFootStrike, 1));
    end
    if (isempty(rightFootOff) || isempty(rightFootEnd))
        disp('There is no valid foot off for this cycle. Run again and choose another one');
    else
        rightFootStrike = rightFootStrike * frequency - firstFrame;
        rightFootOff = rightFootOff * frequency - firstFrame;
        rightFootEnd = rightFootEnd * frequency - firstFrame;
        cycle.right.start = uint8(rightFootStrike);
        cycle.right.footOff = uint8(rightFootOff);
        cycle.right.end = uint8(rightFootEnd);
    end
end

leftFootStrikeList = sprintfc('%d', c3devents.Left_Foot_Strike);
[index, tf] = listdlg('PromptString', 'Choose the time of the left foot strike', 'SelectionMode', 'single', 'ListString', leftFootStrikeList);

if (tf == 0)
    disp('No Cycle for left foot selected');
else
    % check if cycle is complete
    leftFootOff = [];
    if ( size(c3devents.Left_Foot_Strike, 2) > index)
        leftFootStrike = c3devents.Left_Foot_Strike(index);
        leftFootEnd = c3devents.Left_Foot_Strike(index + 1);
        leftFootOff = c3devents.Left_Foot_Off(find(c3devents.Left_Foot_Off > leftFootStrike, 1));
    end
    if (isempty(leftFootOff) || isempty(leftFootEnd))
        disp('There is no valid foot off for this cycle. Run again and choose another one');
    else
        leftFootStrike = leftFootStrike * frequency - firstFrame;
        leftFootOff = leftFootOff * frequency - firstFrame;
        leftFootEnd = leftFootEnd * frequency - firstFrame;
        cycle.left.start = uint8(leftFootStrike);
        cycle.left.footOff = uint8(leftFootOff);
        cycle.left.end = uint8(leftFootEnd);
    end
end

save(fullfile(output_folder, 'settings.mat'), 'cycle', 'firstFrame', 'frequency', 'duration', '-mat');
copyfile(c3dpath, fullfile(output_folder, 'c3dfile.c3d'));

b_generateGRF = questdlg('Create GRF.XML ?','Ground Reaction Forces', 'Yes', 'No', 'Yes');
if strcmp(b_generateGRF, 'Yes')
    a_generateGRF_XML;
end
