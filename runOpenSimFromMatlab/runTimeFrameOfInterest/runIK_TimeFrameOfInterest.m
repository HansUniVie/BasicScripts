function [resultsAreValid] = runIK_TimeFrameOfInterest(setupFile, modelFile, trcFile, startTime, endTime, outputPath)
% runIK_TimeFrameOfInterest Summary of this function goes here
%   Detailed explanation goes here
import org.opensim.modeling.*;

resultsAreValid = false;

if ~exist(outputPath, 'dir')
    mkdir(outputPath)
end

ikTool = InverseKinematicsTool(setupFile); 

osimModel = Model(modelFile);
ikTool.setModel(osimModel);
ikTool.setMarkerDataFileName(trcFile);
ikTool.setStartTime(startTime);
ikTool.setEndTime(endTime);
ikTool.setOutputMotionFileName(fullfile(outputPath, 'IK.mot'));
ikTool.print(fullfile(outputPath, 'ikSettings.xml'));
ikTool.run();

copyfile('_ik_marker_errors.sto', fullfile(outputPath, 'IK_marker_errors.sto'));
delete('_ik_marker_errors.sto');


% Check for errors!
% Add cycle to check!
%https://simtk-confluence.stanford.edu/display/OpenSim/Checklist+-+Evaluating+your+Simulation
% Is the maximum marker error less than 4 cm?
% Is the RMS error less than ~2 cm?

errors = load_sto_file(fullfile(outputPath, 'IK_marker_errors.sto'));
[maxMarkerError maxMarkerIndex] = max(errors.marker_error_max)
[maxRMSError maxRMSIndex] = max(errors.marker_error_RMS)

if (maxMarkerError <= 0.04 && maxRMSError <= 0.02)
    resultsAreValid = true;
end

fileID = fopen(fullfile(outputPath, 'marker_errors_summary.txt'),'w');
fprintf(fileID,'Maximaler Marker Error: %d\n', maxMarkerError);
fprintf(fileID,'Maximaler Marker Error at frame: %d\n', maxMarkerIndex);
fprintf(fileID,'Maximaler RMS Error: %d\n', maxRMSError);
fprintf(fileID,'Maximaler RMS Error at frame: %d\n', maxRMSIndex);
fclose(fileID);

end

