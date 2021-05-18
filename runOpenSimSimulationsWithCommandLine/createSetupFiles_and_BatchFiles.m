%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% example code to create batch files which can by copied to the command
%%% window to run the OpenSim simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;

dataFolder = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimFromMatlab\ExampleData\';
ModelFile = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimFromMatlab\ExampleData\model\model.osim';
homeTemplates = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimFromMatlab\SetupFiles\';
resultsDirectory2 = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimSimulationsWithCommandLine\output\';
homeSetUpFiles = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimSimulationsWithCommandLine\setupFiles\';
root_batches_all = 'C:\Users\Hans\Documents\GitHub\BasicScripts\runOpenSimSimulationsWithCommandLine\batch_template.cmd';

trial_set = {'Gait01' 'Gait02' 'Gait03' 'Gait04' 'Gait05'}
     
for t=1:length(trial_set)
        %% create IK setup files
              IKin = [homeTemplates 'Settings_IK.xml']; % Generic input file              
              MarkerFile = [dataFolder 'trials\' (trial_set{t}) '\marker_experimental.trc'];     
              temp_name = char((trial_set{t}));
              
              load([dataFolder 'trials\' (trial_set{t}) '\settings.mat']);               
              TimeRange = [num2str((cycle.right.start-1)/100) ' ' num2str((cycle.right.end-1)/100)];
                  if exist([resultsDirectory2 'IK\'])==0
                    ResultsDirectory = mkdir([resultsDirectory2 'IK\']);
                  else
                    ResultsDirectory = ([resultsDirectory2 'IK\']);
                  end
              OutputMotionFile = [ResultsDirectory temp_name '_IK.mot'];
              IKsetup = xml_read(IKin);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','ATTRIBUTE','name',temp_name);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','model_file',ModelFile);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','marker_file',MarkerFile);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','time_range',TimeRange);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','output_motion_file',OutputMotionFile);
              IKsetup = setfield(IKsetup,'InverseKinematicsTool','results_directory',ResultsDirectory);
              
              outputIK = [homeSetUpFiles temp_name '_IK.xml'];
              xml_writeOSIM(outputIK,IKsetup,'OpenSimDocument');    
     
         
              %% create batch files
% IK batch
                    fid = fopen (root_batches_all ,'r+','n');
                    fseek(fid, 0, 'eof');
                    strfile = strrep(['%%OSbin%%opensim-cmd run-tool ' outputIK '>' ResultsDirectory temp_name '_IK.log'],'\','/');
                    fprintf(fid, [strfile ' \n']);
              
 
end
