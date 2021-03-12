%% EMG processing
% March 31, 2016 TH
close all;clear all;clc;

%% Specify main folder and patient identifiers

PI = 'CP03'; %participant index (intervention + number)
TI = 'no';    %treatment index (pre or post)

dir_main = 'C:\Users\u0113767\Documents\WORK_KULeuven\MATLABcodes\OpenSimWorkflow_KUleuven\';

% dir_vicon_main = 'C:\Users\u0101091\Documents\Data\Nexus\BOTOX_POST\BOTOX_POST\';
dir_vicon_main = 'C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\';
% dir_vicon_main = 'C:\Users\u0101091\Documents\Data\Nexus\SDR_POST\SDR_POST\';
% dir_vicon_main = 'C:\Users\u0101091\Documents\Data\Nexus\SEMLS_PRE\SEMLS_PRE\';

% Define EMG filter properties
order = 4;
cutoff_band = [20 400];
cutoff_low = 10;

% EMG standard protocol PLB (check channels!)
% RREF = EMG.data(:,2)
% RVAL = EMG.data(:,3)
% RBIF = EMG.data(:,4)
% RMEH = EMG.data(:,5)
% RTIA = EMG.data(:,6)
% RGAS = EMG.data(:,7)
% RSOL = EMG.data(:,8)
% RGLU = EMG.data(:,9)
% LREF = EMG.data(:,10)
% LVAL = EMG.data(:,11)
% LBIF = EMG.data(:,12)
% LMEH = EMG.data(:,13)
% LTIA = EMG.data(:,14)
% LGAS = EMG.data(:,15)
% LSOL = EMG.data(:,16)
% LGLU = EMG.data(:,17)


%% Load directories
% dir_out_kin = strcat(dir_main,PI,'\OpenSim\InverseKinematics\');
% dir_out_dyn = strcat(dir_main,PI,'\OpenSim\InverseDynamics\');
% dir_out_so = strcat(dir_main,PI,'\OpenSim\StaticOptimization\');
% dir_out_ma = strcat(dir_main,PI,'\OpenSim\MuscleAnalysis\');

%Read conditions file
[times,text, raw] = xlsread(strcat(dir_main, 'Subjects_', PI, '.xlsx'));

dir_vicon = char(strcat(dir_vicon_main,PI,'\c3d\',text{2, 10} ));
mkdir(char(strcat(dir_vicon_main,PI,'\EMG')));
dir_emg = strcat(dir_vicon_main,PI,'\EMG\');

mkdir(char(strcat(dir_main,PI,'\Graphs\CheckEMG')));
dir_save_emg = strcat(dir_main,PI,'\Graphs\CheckEMG\');


%% Check SO
perc_toe_off = zeros(size(times,1)-1,1);
perc_toe_off_session = zeros(size(times,1)-1,1);


for ntrial = 1:size(text,1)-1;

%         perc_toe_off(ntrial,:) = ((times(ntrial,6)-times(ntrial,3))/(times(ntrial,7)-times(ntrial,3)))*100;
%         perc_toe_off_session(ntrial,:) = perc_toe_off(ntrial,1);
ntrial1 = ntrial +1;

        trialname = char(text(ntrial1,3));

    %     %Load data
    %     OSkinematics = importdata(char(strcat(dir_out_kin,'IK_',PI,'_',TI,'_',trialname,'.mot')));
    %     OSkinetics = importdata(char(strcat(dir_out_dyn,PI,'_',TI,'_',trialname,'.sto')));
    %     OSstaticACT = importdata(char(strcat(dir_out_so,PI,'_',TI,'_',trialname,'_StaticOptimization_activation.sto')));
    %     OSstaticFORC = importdata(char(strcat(dir_out_so,PI,'_',TI,'_',trialname,'_StaticOptimization_force.sto')));
    %     EMGprocessed = importdata(char(strcat(dir_emg,PI,'_',TI,'_',text(ntrial,1),'_EMG.mot')));

        %Define gait cycle
        IC1 = times(ntrial,5);
        IC2 = times(ntrial,6);


    %% Vicon data
    %Read c3d-file per trial
    [Markers,MLabels,VideoFrameRate,AnalogSignals,ALabels, AUnits, AnalogFrameRate,Event,ParameterGroup,CameraInfo]...
        = readC3D(char(strcat(dir_vicon,trialname,'.c3d'))); % text{2,3}, '.c3d' 

    names_channels = ALabels(1,13:end);

    [EMGraw] = determine_EMG(ALabels, AnalogSignals, names_channels);  

    [nAnalogFrames, nChannels] = size(EMGraw);
systemfile = 'C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\050709g022_Van_Roy_Silke\20130129_050709g022\b_20130129_050709g022\b_20130129_050709g022_06.system';
%     systemfile = char(strcat(dir_vicon,text(end,3),trialname(6:end),'.system'));
    [gain] = Get_Gain(systemfile,names_channels);

    for n = 1:nChannels;
        EMGraw(:,n) = EMGraw(:,n) ./ gain(n);
    end
    time = [[0:1:length(EMGraw)-1]./AnalogFrameRate]';
    
    
%     %Remove bad EMG-channels
%         if ntrial==1 || ntrial==2; %if EMG-channel is empty
%             badsignal = find(strcmp('RMEH',names_channels));
%             names_channels{badsignal} = 'empty';
%             EMGraw(:,badsignal) = NaN;
% 
%         else %if EMG-electrode is repositioned
%             replace = find(strcmp('RMEH',names_channels));
%             nosignal = find(strcmp('RGLU',names_channels));
%             
%             EMGraw(:,replace) = EMGraw(:,nosignal);
%             names_channels{nosignal} = 'empty';
%             EMGraw(:,nosignal) = NaN;
%         end

%     %Remove bad EMG-channels
%         if ntrial==1; %if EMG-channel is empty
%             badsignal = find(strcmp('RMEH',names_channels));
%             names_channels{badsignal} = 'empty';
%             EMGraw(:,badsignal) = NaN;
%         end
%         if ntrial==3; %if EMG-channel is empty
%             badsignal = find(strcmp('RBIF',names_channels));
%             names_channels{badsignal} = 'empty';
%             EMGraw(:,badsignal) = NaN;
%         end
%         if ntrial==2;
%             nosignal = find(strcmp('AFWEZIG',names_channels));
%             names_channels{nosignal} = 'empty';
%             EMGraw(:,nosignal) = NaN;
%         end 
%         
%         %if EMG-electrode is repositioned
%         if ntrial==4;
%             replace = find(strcmp('RBIF',names_channels));
%             nosignal = find(strcmp('AFWEZIG',names_channels));
%             
%             EMGraw(:,nosignal) = EMGraw(:,replace);
%             names_channels{nosignal} = 'RBIF';
%             names_channels{replace} = 'empty';
%             EMGraw(:,replace) = NaN;
%         end 
%         if ntrial==5;
%             replace = find(strcmp('RBIF',names_channels));
%             nosignal = find(strcmp('RGLU',names_channels));
%             
%             EMGraw(:,replace) = EMGraw(:,nosignal);
%             names_channels{nosignal} = 'empty';
%             EMGraw(:,nosignal) = NaN;            
%         end
%         if ntrial==6;
%             replace = find(strcmp('RBIF',names_channels));
%             nosignal = find(strcmp('RGLU',names_channels));
%             
%             EMGraw(:,replace) = EMGraw(:,nosignal);
%             names_channels{nosignal} = 'empty';
%             EMGraw(:,nosignal) = NaN;            
%          end

%             badsignal = find(strcmp('LREF',names_channels));
%             names_channels{badsignal} = 'empty';
%             EMGraw(:,badsignal) = NaN;    
%             
%             badsignal2 = find(strcmp('RREF',names_channels));
%             names_channels{badsignal2} = 'empty';
%             EMGraw(:,badsignal2) = NaN;  
%             
%             badsignal3 = find(strcmp('LVAL',names_channels));
%             names_channels{badsignal3} = 'empty';
%             EMGraw(:,badsignal3) = NaN;    
%             
%             badsignal4 = find(strcmp('RVAL',names_channels));
%             names_channels{badsignal4} = 'empty';
%             EMGraw(:,badsignal4) = NaN;   

%             replace = find(strcmp('RVAL',names_channels));
%             nosignal = find(strcmp('AFWEZIG',names_channels));
%             
%             EMGraw(:,nosignal) = EMGraw(:,replace);
%             names_channels{nosignal} = 'RVAL';
%             names_channels{replace} = 'empty';
%             EMGraw(:,replace) = NaN; 


%             switched1 = find(strcmp('LTIA',names_channels));
%             switched2 = find(strcmp('LGAS',names_channels));
%             
%             switchEMG1 = EMGraw(:,switched1);
%             switchEMG2 = EMGraw(:,switched2);
%                         
%             EMGraw(:,switched1) = switchEMG2;
%             EMGraw(:,switched2) = switchEMG1;
%             
%             switched3 = find(strcmp('RTIA',names_channels));
%             switched4 = find(strcmp('RGAS',names_channels));
%             
%             switchEMG3 = EMGraw(:,switched3);
%             switchEMG4 = EMGraw(:,switched4);
%                         
%             EMGraw(:,switched3) = switchEMG4;
%             EMGraw(:,switched4) = switchEMG3;
  
    eval(['save ', dir_emg,'/',trialname, '_EMG_raw time EMGraw names_channels'])

    
    
    %% Plot raw EMG
    figure(1)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['Raw_EMG_',PI,'_',TI,'_',trialname,'_right'];
    for i = 1:8;
        subplot(4,2,i);
        plot(time,EMGraw(:,i)); hold on;
        title(names_channels{i});
        legend('raw EMG');
        xlabel('time [s]')
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        
    figure(2)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['Raw_EMG_',PI,'_',TI,'_',trialname,'_left'];
    j = 1;
    for i = 9:16;
        subplot(4,2,j);
        plot(time,EMGraw(:,i));hold on;
        title(names_channels{i});
        legend('raw EMG')
        xlabel('time [s]')
        j = j+1;
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        

    %% Filter EMG
    % Band pass filter
    [a,b] = butter(order/2,cutoff_band./(0.5*AnalogFrameRate),'bandpass');
    EMGband = filtfilt(a,b,EMGraw);
    clear a b

    % Rectify the band pass filtered signal
    EMGrect = abs(EMGband);

    % Low pass filter the rectified signal
    [a,b] = butter(order/2,cutoff_low./(0.5*AnalogFrameRate),'low');
    EMGlow = filtfilt(a,b,EMGrect);

    time = [[0:1:length(EMGlow)-1]./AnalogFrameRate]';
    eval(['save ', dir_emg,'/',trialname, '_EMG_filtered time EMGlow names_channels'])
    
    figure(1)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['Processed_EMG_',PI,'_',TI,'_',trialname,'_right'];
    for i = 1:8;
        subplot(4,2,i);
        plot(time,EMGlow(:,i),'LineWidth',2); hold on;
        title(names_channels{i});
        legend('raw EMG','processed EMG');
        xlabel('time [s]')
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        
    figure(2)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['Processed_EMG_',PI,'_',TI,'_',trialname,'_left'];
    j = 1;
    for i = 9:16;
        subplot(4,2,j);
        plot(time,EMGlow(:,i),'LineWidth',2);hold on;
        title(names_channels{i});
        legend('raw EMG','processed EMG')
        xlabel('time [s]')
        j = j+1;
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        

    %% Normalize EMG to maximum within whole trial
    nMinSamples = round(0.01 * nAnalogFrames); 
    onesMat = ones(nAnalogFrames,1);
    sortEMG = sort(EMGlow);
    minEMG = mean(sortEMG(1:nMinSamples,:));
    EMGnorm = (EMGlow - onesMat(:,:)*minEMG)./ (onesMat(:,:)*(max(EMGlow) - minEMG));

%     nRows = length(EMGnorm);
%     time = round([0:1/AnalogFrameRate:(nRows/AnalogFrameRate)]'*1000)/1000;
    time = [[0:1:length(EMGnorm)-1]./AnalogFrameRate]';    
    eval(['save ', dir_emg,'/',trialname, '_EMG_normalized_maxwithintrial time EMGnorm names_channels'])
    
    figure()
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['EMG_normalized_maxwithintrial_right',PI,'_',TI,'_',trialname];
    for i = 1:8;
        subplot(4,2,i);
        plot(time,EMGnorm(:,i),'LineWidth',1.5); hold on;
        title(names_channels{i});
        legend('processed EMG');
        xlabel('time [s]')
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        
    figure()
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['EMG_normalized_maxwithintrial_left',PI,'_',TI,'_',trialname];
    j = 1;
    for i = 9:16;
        subplot(4,2,j);
        plot(time,EMGnorm(:,i),'LineWidth',1.5);hold on;
        title(names_channels{i});
        legend('processed EMG')
        xlabel('time [s]')
        j = j+1;
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        

  

    %% Create MOT-file of normalized EMG to maximum within whole trial
    %for a structure for writing to file derived from convertC3DtoTRCandMOT
    emg.data = [time, EMGnorm];
	emg.labels = {'time', names_channels{1,:}};

    emgFile = [PI,'_',TI,'_',trialname,'_EMG.mot'];

    write_motionFile(emg, strcat(dir_emg,emgFile));
    
    

    %% Normalize EMG to max gait cycle
%     begin_EMG_i = find(IC1==time);
%     end_EMG_i = find(IC2==time);

    begin_EMG_i_temp = find(time<=IC1);
    begin_EMG_i = begin_EMG_i_temp(end);
    end_EMG_i_temp = find(time<=IC2);
    end_EMG_i = end_EMG_i_temp(end);
    
    EMGlow = EMGlow(begin_EMG_i:end_EMG_i,:);

    for k = 1:nChannels;
        if all(isnan(EMGlow(:,k)))==1; %check for empty channels
            EMGcycle(:,k) = nan(101,1);
        else
        EMGcycle(:,k) = normalizetimebase(EMGlow(:,k));
        end
    end

    nMinSamples = round(0.01 * nAnalogFrames); 
    onesMat = ones(nAnalogFrames,1);
    sortEMG = sort(EMGlow);
    minEMG = mean(sortEMG(1:nMinSamples,:));
    normEMG = (EMGlow - onesMat(begin_EMG_i:end_EMG_i,:)*minEMG)./ (onesMat(begin_EMG_i:end_EMG_i,:)*(max(EMGlow) - minEMG));

    for k = 1:nChannels;
        if all(isnan(normEMG(:,k)))==1; %check for empty channels
            EMGcyclenorm(:,k) = nan(101,1);
        else
        EMGcyclenorm(:,k) = normalizetimebase(normEMG(:,k));
        end
    end
    
    timebase = [0:100]';
    time = timebase;
    eval(['save ', dir_emg,'/',trialname, '_EMG_normalized_gaitcycle time EMGcyclenorm names_channels'])
    
    figure()
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['EMG_normalized_gaitcycle_right',PI,'_',TI,'_',trialname];
    for i = 1:8;
        subplot(4,2,i);
        plot(timebase,EMGcyclenorm(:,i),'LineWidth',1.5); hold on;
        title(names_channels{i});
        legend('normalized EMG');
        xlabel('% gait cycle');
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
        
    figure()
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = ['EMG_normalized_gaitcycle_left',PI,'_',TI,'_',trialname];
    j = 1;
    for i = 9:16;
        subplot(4,2,j);
        plot(timebase,EMGcyclenorm(:,i),'LineWidth',1.5);hold on;
        title(names_channels{i});
        legend('normalized EMG')
        xlabel('% gait cycle')
        j = j+1;
    end
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.png'))); 
        saveas(gcf, char(strcat(dir_save_emg,fig.Name,'.fig')));
   
%     close all
    
end

display 'EMG is processed'


