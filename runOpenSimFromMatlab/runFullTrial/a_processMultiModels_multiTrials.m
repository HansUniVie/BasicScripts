clear;
import org.opensim.modeling.*;


setupIKfile = fullfile(pwd, '..', filesep, 'SetupFiles', 'Settings_IK.xml');
setupIDfile = fullfile(pwd, '..', filesep, 'SetupFiles', 'Settings_ID.xml');
setupSOfile = fullfile(pwd, '..', filesep, 'SetupFiles', 'Settings_SO.xml');
setupJRLfile = fullfile(pwd, '..', filesep, 'SetupFiles', 'Settings_JRL.xml');

% Options for steps which should be run
b_runIK = 1;
b_plotIK = 0;
b_runID = 1;
b_plotID = 0;
b_runSO = 1;
b_plotSO = 0;
b_runJRL = 1;
b_plotJRL = 0;

disp('Select models to run the pipeline');
[scaledModelsFileNames, scaledModelsFolder] = uigetfile('*.osim', 'Multiselect', 'on', 'Select models to run the pipeline');

if(~iscell(scaledModelsFileNames))
    scaledModelsFileNames = cellstr(scaledModelsFileNames);
end



disp('Select trials to run the pipeline. Files must have been processed with a_process_C3D to create corresponding folder!');
[trialsFileNames, trialsFolder] = uigetfile('*.c3d', 'Multiselect', 'on', 'Select trials to run the pipeline. Files must have been processed with a_process_C3D to create corresponding folder!');
if(~iscell(trialsFileNames))
    trialsFileNames = cellstr(trialsFileNames);
end


disp('Select the root output folder');
rootOutput = uigetdir(pwd, 'Select the root output folder');

%% run simulations
import org.opensim.modeling.*;

for trialIndex = 1 : size(trialsFileNames, 2)
    
    [folderTemp, trialNameNoExt, extension] = fileparts(fullfile(trialsFolder, char(trialsFileNames(trialIndex))));
    
    folder = fullfile(folderTemp, trialNameNoExt);
    trialName = trialNameNoExt;
       
    c3dFile = fullfile(folder, 'c3dfile.c3d');
    trcFile = fullfile(folder, 'marker_experimental.trc');
    grfSetupFile = fullfile(folder, 'GRF.xml');
    load(fullfile(folder, 'settings.mat'));
    
    for modelIndex = 1 : size(scaledModelsFileNames, 2)
        try
            [tempFolder, modelFileNameNoExt, extension] = fileparts(fullfile(scaledModelsFolder, char(scaledModelsFileNames(modelIndex))));
            
            outputPath = fullfile(rootOutput, modelFileNameNoExt, trialName, 'Output');
            if ~exist(outputPath, 'dir')
                mkdir(outputPath)
            end
            
            modelFile = fullfile(scaledModelsFolder, char(scaledModelsFileNames(modelIndex)));
            actuatorfile = fullfile(scaledModelsFolder, strcat(modelFileNameNoExt, '_actuators.xml'));
            motionFile = fullfile(outputPath, 'IK', 'IK.mot');
            
            osimModel = Model(modelFile);
            state = osimModel.initSystem();
            model_mass = osimModel.getTotalMass(state);
            save(fullfile(rootOutput, modelFileNameNoExt, trialName, 'settings.mat'), 'cycle', 'firstFrame', 'frequency', 'duration', 'model_mass', '-mat');
            
            
            if(b_runIK == 1)
                resultsAreValid = runIK(setupIKfile, modelFile, trcFile, duration, fullfile(outputPath, 'IK'));
                if(~resultsAreValid)
                    disp('Maker Error too big for inverse Kinematics!');
                end
            end
            
            if(b_plotIK == 1)
                plotIK(motionFile, cycle);
            end
            
            if(b_runID == 1)
                runID(setupIDfile, modelFile, motionFile, grfSetupFile, duration, fullfile(outputPath, 'ID'));
            end
            
            if(b_plotID == 1)
                inverse_dynamicsFile = fullfile(outputPath, 'ID', 'inverse_dynamics.sto');
                plotID(inverse_dynamicsFile, cycle);
            end
            
            if(b_runSO == 1)
                runSO(setupSOfile, actuatorfile, modelFile, motionFile, grfSetupFile, duration, fullfile(outputPath, 'SO'));
            end
            
            if(b_plotSO == 1)
                soActivationFile = fullfile(outputPath, 'SO', '_StaticOptimization_activation.sto');
                plotSO(soActivationFile, cycle);
            end
            
            if(b_runJRL == 1)
                so_forcesFile = fullfile(outputPath, 'SO', '_StaticOptimization_force.sto');
                runJRL(setupJRLfile, actuatorfile, modelFile, motionFile, grfSetupFile, so_forcesFile, duration, fullfile(outputPath, 'JRL'));
            end
            
            if(b_plotJRL == 1)
                plotJRL(fullfile(outputPath, 'JRL', '_JointReaction_ReactionLoads.sto'), cycle);
            end
            
        catch e
            fileID = fopen(fullfile(rootOutput, modelFileNameNoExt, trialName, 'fehler.txt'),'w');
            fprintf(fileID,'Es ist ein Fehler aufgetreten!\nFehlermeldung:\n%s',e.message);
            fclose(fileID);
        end
    end
    
end