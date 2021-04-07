function [] = runID(setupFile, actuatorfile, modelFile, motionFile, grfFile, duration, outputPath)
% runID Summary of this function goes here
% Detailed explanation goes here
import org.opensim.modeling.*;

if ~exist(outputPath, 'dir')
    mkdir(outputPath)
end


soTool = AnalyzeTool(setupFile, false);
soTool.setModelFilename(modelFile);
soTool.setResultsDir(outputPath);
soTool.setInitialTime(0);
soTool.setFinalTime(duration);
soTool.setExternalLoadsFileName(grfFile);
soTool.setCoordinatesFileName(motionFile);
soTool.setLowpassCutoffFrequency(6);
actuatorFilesArray = ArrayStr();
actuatorFilesArray.append(actuatorfile);
soTool.setForceSetFiles(actuatorFilesArray);

analysisSet = soTool.getAnalysisSet();
static_optimization = StaticOptimization.safeDownCast(analysisSet.get(0));
static_optimization.setStartTime(0);
static_optimization.setEndTime(duration);
soTool.print(fullfile(outputPath, 'soSettings.xml'));

runTool = AnalyzeTool(fullfile(outputPath, 'soSettings.xml'));
runTool.run();


end

