function data = BTK_aclr_pipeline(file)

% This function will create calibrated opensim models, files to run an OpenSim
% simulation sequence for gait data


%%

clc;
clear all;
close all;

%%

% Specify file path of generic OpenSim model for use.
% osim_path = 'C:\Documents and Settings\s2790936\Desktop\Modeling\EMG_driven\OSim_Models';

% Specify model name of generic model for use.
% model = 'ACLR_generic.osim';

%%

% Load specified c3d file or rely on dialog box to select file of interest
if nargin == 1
if isempty(fileparts(file))
    pname = cd;
    pname = [pname '\'];
    fname = file;
else [pname, name, ext] = fileparts(file);
    fname = [name ext];
end
else [fname, pname] = uigetfile('*.c3d', 'Select C3D file');
end

global leg

leg_test = isempty(strfind(pname,'right'))

if leg_test == 0
    leg = 'right';
else
    leg = 'left';
end


cd (pname);

%%

% load the c3d file using BTK
[marker_data,analog_data,fp_data,sub_info,angle_data] = btk_loadc3d([pname, fname], 10);

% replace line 26 with line 28 if you require 'events' to be included
% [data, a_data, fp_info, MP_info, events] = loadc3dfile(file)

% sort the C3D file so we know what is Marker data and what is calculated
% data
data = btk_sortc3d(marker_data,analog_data,fp_data,sub_info,angle_data);

%%

if isempty(strfind(lower(fname),'static')) % || isempty(strfind(lower(fname),'cal'))
    
    E = [];
    clear a
    a = [];
    
    for i = 1:length(fp_data.FP_data)
        % assign force values to test variable
        
        test = fp_data.GRF_data(i).F;
        
        b = find(test(:,3) > 10);  % find instances where Fz is greater than 15 Newtons
        % b = find(-a_data.(['Fz' num2str(i)]) < 10 & -a_data.(['Fz' num2str(i)]) >5 );    % find all instances with force greater than 10 N
        % make event 2 the last instance of 'b' plus 20 msec padding
        a = [a b'];
        a = sort(a);
    end
    
    if ~isempty(a)
            P = round((a(1)*marker_data.Info.frequency/analog_data.Info.frequency)):round((a(end)*marker_data.Info.frequency/analog_data.Info.frequency));
            E(1) = (a(1)*(marker_data.Info.frequency/analog_data.Info.frequency)) - 5; % event 1 is the first instance of 'a', multiply by the conversion factor to return the frame in the video frame rate...
            % then subtract '15 frames' from that instance
            E(2) = (a(end)*(marker_data.Info.frequency/analog_data.Info.frequency)) + 5; % find the last instance of 'b', convert, then add 10 frames
           
            % define start and end frame from the events to write the appropriate TRC
            % and MOT files for the OpenSim simulations
            data.Start_Frame = round(E(1));
            data.End_Frame = round(E(2));
        
    end
        
%%
    % calculate the force data in the global coordinate system
    data = btk_c3d2trc(marker_data,fp_data,sub_info,'off',data);
    
%%
% now establish OpenSim .xml to perform Osim operations

% need a logic check to ensure all the markers used in dynamic IK (not the
% static trial) are present. In running or cutting often you will be
% missing markers on the trailing leg or head during much of the trial. As
% a result you don't want these markers included in IK. So I think we need
% to test if they are NAN's at the begin of time (-5 frames from first
% plate strike) and at the end of time (+5 frames from last plate strike).
% If they are NANs at either instance then exclude them from the IK tasks
% for that particular trial. This was we can batch process as some trials
% will not have the same set of troublesome markers. - DJS June 6 2012

% 

% define the standard OpenSim files for IK
%    ModelFile = [data.Name '_scaled.osim'];
%    IKTasksFile = [osim_path model '_IK_Tasks.xml']; % each trial should have its own directory
% 
%     setup_IK(data,'ModelFile',ModelFile,'IKTasksFile',IKTasksFile);
%     
%     com = ['ik -S ' data.Name '_Setup_IK.xml'];
%     system(com);
%     
%     % combine the GRF data in MOT file
%     ik_mot_file = [data.C3D_Filename(1:end-4) '_ik.mot'];
%     grf_mot_file = data.GRF_Filename;
%     
%     mot_grf(ik_mot_file, grf_mot_file);
%     
%     % define the standard OpenSim files for ID   
%     MOTFile = [data.TRC_Filename(1:end-4) '_ik.mot'];
%     % GRFFile = [data.TRC_Filename(1:end-4) '_grf.mot']; % we don't need this file in OpenSim 2.4
%     
%     % define the bodies to apply forces to based on which legs hit each
%     % plate (see c3d2trc for details)
%     if isfield(data,'Body1')
%         if strcmp(data.Body1,'Right')
%             Body1 = 'calcn_r';
%         else Body1 = 'calcn_l';
%         end
%     else Body1 = 'calcn_r';
%     end
%     
%     if isfield(data,'Body2')
%         if strcmp(data.Body2,'Left')
%             Body2 = 'calcn_l';
%         else Body2 = 'calcn_r';
%         end  
%     else Body2 = 'calcn_r';
%     end
% 
%     setup_ID(data, 'ModelFile',ModelFile,'MOTFile',MOTFile,'GRFFile',GRFFile,...
%         'LowPassFilterFreq',6,'LowPassFilterFreqLoad',6,'Body1',Body1,'Body2',Body2);
% 
%     clear com
%     com = ['analyze -S ' data.Name '_Setup_ID.xml'];
%     system(com);
    


%     % redefine the GRF file to be the new xml file
%     GRFFile = [GRFFile(1:end-3) 'xml'];
%         
    % setup CMC file
%     copyfile([osim_path model '_CMC_Tasks.xml'],[pname data.Name '_CMC_Tasks.xml']);
%     CMCTaskFile = [data.Name '_CMC_Tasks.xml'];
%     copyfile([osim_path model '_CMC_Actuators.xml'],[pname data.Name '_CMC_Actuators.xml']);
%     CMCActuatorFile = [data.Name '_CMC_Actuators.xml'];
%     copyfile([osim_path model '_CMC_ControlConstraints.xml'],[pname data.Name '_CMC_ControlConstraints.xml']);
%     CMCControlFile = [data.Name '_CMC_ControlConstraints.xml'];
        
%     % make CMC setup file
%     setup_CMC(data, 'ModelFile',ModelFile,'MOTFile',MOTFile,'GRFFile',GRFFile,...
%         'CMCTaskFile',CMCTaskFile,'CMCActuatorFile',CMCActuatorFile,'CMCControlFile',CMCControlFile,...
%         'OptimMaxIter',20000,'LowPassFilterFreqLoad',10,'LowPassFilterFreq',10,...
%         'CMCTimeWindow',0.01,'OptimizerAlgorithm','ipopt');
                 
%     clear com
%     com = ['cmc -S ' data.Name '_Setup_CMC.xml'];
%     system(com);



else
 
     % if 'a' IS empty then use these defaults for the begining and end

     
     data.Start_Frame = 100;
     data.End_Frame = 150;

     % convert the static data into a TRC file for the purposes of scaling
     data = btk_c3d2trc(marker_data,fp_data,sub_info,'off',data);
     
%      % define the starndard OpenSim files for scaling
%      ModelFile = [osim_path model '.osim'];
%      % MarkerSetFile = [osim_path model '_Scale_MarkerSet.xml']; %Model already contains the marker set
%      MeasurementSetFile = [osim_path model '_Scale_Measurement_Set.xml'];
%      ScaleTasksFile = [osim_path model '_Scale_IK_Tasks.xml'];
%  
%      setup_scale(data,'ModelFile',ModelFile,'ScaleTasksFile',ScaleTasksFile,...
%          'MeasurementSetFile',MeasurementSetFile);
%      
%      com = ['scale -S ' data.Name '_Scale_Setup.xml'];
%      system(com);
end


close all

