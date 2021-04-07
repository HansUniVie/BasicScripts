function [] = runID(setupFile, actuatorfile, modelFile, motionFile, grfFile, so_forcesFile, duration, outputPath)
%runID Summary of this function goes here
%   Detailed explanation goes here
import org.opensim.modeling.*;

if ~exist(outputPath, 'dir')
    mkdir(outputPath)
end

jrlTool = AnalyzeTool(setupFile, false);
jrlTool.setModelFilename(modelFile);
jrlTool.setResultsDir(outputPath);
jrlTool.setInitialTime(0);
jrlTool.setFinalTime(duration);
jrlTool.setExternalLoadsFileName(grfFile);
jrlTool.setCoordinatesFileName(motionFile);
jrlTool.setLowpassCutoffFrequency(6);
actuatorFilesArray = ArrayStr();
actuatorFilesArray.append(actuatorfile);
jrlTool.setForceSetFiles(actuatorFilesArray);

analysisSet = jrlTool.getAnalysisSet();
joint_reaction = JointReaction.safeDownCast(analysisSet.get(0));
joint_reaction.setStartTime(0);
joint_reaction.setEndTime(duration);
joint_reaction.setForcesFileName(so_forcesFile);
jrlTool.print(fullfile(outputPath, 'jrlSettings.xml'));


runTool = AnalyzeTool(fullfile(outputPath, 'jrlSettings.xml'));
runTool.run();

end

