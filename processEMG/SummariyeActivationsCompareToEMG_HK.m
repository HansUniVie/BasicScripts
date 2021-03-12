%% Summarize Muscle activations, compare it to EMG
% Ausgust 2017, hans.kainz@kuleuven.be
% % close all;clear all;clc;

%% Specify main folder and patient identifiers
PI = {'CP07'}; %participant index (intervention + number)'CP02','CP03','CP04','CP05','CP06',

dir_main = 'C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\';
ScaleMethod = {'NormalScaled','BWscaled','BW_MTLscaled','DYNscaledAnkleBW'};
muscle = {'REF','VAL','BIF','MEH','TIA','GAS','SOL','GLU'};
muscle_nr = {'28','31','9','8','38','32','34','2'};

for sub=1:length(PI)
    % load SO results
    SO_left = [];
    SO_right =[];
    SO_left = load([dir_main (PI{sub}) '\CP_CapGap\SOresults_l_withDYNBWmodel.mat']);
    SO_right = load([dir_main (PI{sub}) '\CP_CapGap\SOresults_r_withDYNBWmodel.mat']);

    for sm=1:length(ScaleMethod)
        for m=1:length(muscle)
            mm=[];
            mm=str2num(muscle_nr{m});
            SOact.(PI{sub}).raw.(muscle{m}).left(:,sm) = SO_left.SOresults.(ScaleMethod{sm}).SoAct(:,mm);
            SOact.(PI{sub}).raw.(muscle{m}).right(:,sm) = SO_right.SOresults.(ScaleMethod{sm}).SoAct(:,mm);
            % normalize to gait cycle length
            SOact.(PI{sub}).normGC.(muscle{m}).left(:,sm) = normalizetimebase(SOact.(PI{sub}).raw.(muscle{m}).left(:,sm));
            SOact.(PI{sub}).normGC.(muscle{m}).right(:,sm) = normalizetimebase(SOact.(PI{sub}).raw.(muscle{m}).right(:,sm));
            % normalize gait cycle and max activation
            % left
            Data=[];
            Data=SOact.(PI{sub}).normGC.(muscle{m}).left(:,sm);        
            normA = Data - min(Data(:));
            SOact.(PI{sub}).normGCnormMaxAct.(muscle{m}).left(:,sm) = normA ./ max(normA(:));
            % right
            Data_r=[];
            Data_r=SOact.(PI{sub}).normGC.(muscle{m}).right(:,sm);        
            normA_r = Data_r - min(Data_r(:));
            SOact.(PI{sub}).normGCnormMaxAct.(muscle{m}).right(:,sm) = normA_r ./ max(normA_r(:));
        end           
    end
        
   for m=1:length(muscle)
       mm=[];
       mm=str2num(muscle_nr{m});
        for sm=1:length(ScaleMethod)                
            % normalize to gait cycle length
            SOact.(ScaleMethod{sm}).normGC.(muscle{m}).left(:,sub) = normalizetimebase(SO_left.SOresults.(ScaleMethod{sm}).SoAct(:,mm));
            SOact.(ScaleMethod{sm}).normGC.(muscle{m}).right(:,sub) = normalizetimebase(SO_right.SOresults.(ScaleMethod{sm}).SoAct(:,mm));            
        end           
    end
    
end
% % cd('Y:\MATLABcodes\Hans_DATA\');
% % fileName='SOact_summary.mat';
% % save(fileName, 'SOact');
%% summarize muscle activation over all participants

for sm=1:length(ScaleMethod)
    for m=1:length(muscle)
        Act_summary.All_subj.(ScaleMethod{sm}).(muscle{m}) = [SOact.(ScaleMethod{sm}).normGC.(muscle{m}).left, SOact.(ScaleMethod{sm}).normGC.(muscle{m}).right];
        
    end
        Act_summary.mean.VAL(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).VAL(:,[2:6 11:12]))'))';
        Act_summary.mean.BIF(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).BIF(:,[2:5 8:12]))'))';
        Act_summary.mean.REF(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).REF(:,[2:6 8:12]))'))';
        Act_summary.mean.GLU(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).GLU(:,[2:5 7:12]))'))';
        Act_summary.mean.MEH(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).MEH(:,[2:6 8:12]))'))';
        Act_summary.mean.TIA(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).TIA(:,[2:12]))'))';
        Act_summary.mean.GAS(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).GAS(:,[2:6 8:12]))'))';
        Act_summary.mean.SOL(:,sm) = (mean((Act_summary.All_subj.(ScaleMethod{sm}).SOL(:,[2:6 8:12]))'))';
        % SD
        Act_summary.SD.VAL(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).VAL(:,[2:6 11:12]))'))';
        Act_summary.SD.BIF(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).BIF(:,[2:5 8:12]))'))';
        Act_summary.SD.REF(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).REF(:,[2:6 8:12]))'))';
        Act_summary.SD.GLU(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).GLU(:,[2:5 7:12]))'))';
        Act_summary.SD.MEH(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).MEH(:,[2:6 8:12]))'))';
        Act_summary.SD.TIA(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).TIA(:,[2:12]))'))';
        Act_summary.SD.GAS(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).GAS(:,[2:6 8:12]))'))';
        Act_summary.SD.SOL(:,sm) = (std((Act_summary.All_subj.(ScaleMethod{sm}).SOL(:,[2:6 8:12]))'))';

end
cd('C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\');
fileName2='Act_summary.mat';
% save(fileName2, 'Act_summary');
%% load and summarize EMGs
for sub=1:length(PI)    
        % right
        EMGload_r=[];
        EMGload_r = load([dir_main (PI{sub}) '\EMG\_R_EMG_normalized_gaitcycle.mat']);
        EMG.(PI{sub}).r = EMGload_r.EMGcyclenorm(:,1:8);
        % left
        EMGload_l=[];
        EMGload_l = load([dir_main (PI{sub}) '\EMG\_L_EMG_normalized_gaitcycle.mat']);
        EMG.(PI{sub}).l = EMGload_l.EMGcyclenorm(:,9:16);
    for m=1:length(muscle)
        EMG_summary.All_subj_r.(muscle{m}).r(:,sub) = EMG.(PI{sub}).r(:,m);
        EMG_summary.All_subj_l.(muscle{m}).l(:,sub) = EMG.(PI{sub}).l(:,m);   
    
    end
end

for m=1:length(muscle)
        EMG_summary.All_subj.(muscle{m}) = [EMG_summary.All_subj_l.(muscle{m}).l, EMG_summary.All_subj_r.(muscle{m}).r];      
end
        EMG_summary.mean.VAL = (mean((EMG_summary.All_subj.VAL(:,[2:6 11:12]))'))';
        EMG_summary.mean.BIF = (mean((EMG_summary.All_subj.BIF(:,[2:5 8:12]))'))';
        EMG_summary.mean.REF = (mean((EMG_summary.All_subj.REF(:,[2:6 8:12]))'))';
        EMG_summary.mean.GLU = (mean((EMG_summary.All_subj.GLU(:,[2:5 7:12]))'))';
        EMG_summary.mean.MEH = (mean((EMG_summary.All_subj.MEH(:,[2:6 8:12]))'))';
        EMG_summary.mean.TIA = (mean((EMG_summary.All_subj.TIA(:,[2:12]))'))';
        EMG_summary.mean.GAS = (mean((EMG_summary.All_subj.GAS(:,[2:6 8:12]))'))';
        EMG_summary.mean.SOL = (mean((EMG_summary.All_subj.SOL(:,[2:6 8:12]))'))';
%         % SD
        EMG_summary.SD.VAL = (std((EMG_summary.All_subj.VAL(:,[2:6 11:12]))'))';
        EMG_summary.SD.BIF = (std((EMG_summary.All_subj.BIF(:,[2:5 8:12]))'))';
        EMG_summary.SD.REF = (std((EMG_summary.All_subj.REF(:,[2:6 8:12]))'))';
        EMG_summary.SD.GLU = (std((EMG_summary.All_subj.GLU(:,[2:5 7:12]))'))';
        EMG_summary.SD.MEH = (std((EMG_summary.All_subj.MEH(:,[2:6 8:12]))'))';
        EMG_summary.SD.TIA = (std((EMG_summary.All_subj.TIA(:,[2:12]))'))';
        EMG_summary.SD.GAS = (std((EMG_summary.All_subj.GAS(:,[2:6 8:12]))'))';
        EMG_summary.SD.SOL = (std((EMG_summary.All_subj.SOL(:,[2:6 8:12]))'))';
        
cd('C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\');
fileName3='EMG_summary.mat';
% save(fileName3, 'EMG_summary');

% PI = {'CP02','CP03','CP04','CP05','CP06','CP07'}; %participant index (intervention + number)
% dir_main = 'Y:\MATLABcodes\Hans_DATA\';
% ScaleMethod = {'NormalScaled','BWscaled','BW_MTLscaled','DYNscaled'};
musclePlot1 = {'REF','MEH','GLU','VAL','BIF'};
musclePlot2 = {'TIA','GAS','SOL'};

    figure()
    timebase = [0:100]';
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 25.6 12.85];
    fig.PaperPositionMode = 'manual';
    fig.Name = 'EMG_vs_Activations_meanAll_subj';
    for i = 1:length(musclePlot1);
%         ScaFact=max(Act_summary.mean.(musclePlot1{i}));
        subplot(4,2,i);
        plot(timebase,Act_summary.mean.(musclePlot1{i}),'LineWidth',1.5); hold on;
        bb=[]; cc=[]; dd=[];
        bb=max(Act_summary.mean.(musclePlot1{i}));
        cc=mean(bb);
        dd= cc/(max(EMG_summary.mean.(musclePlot1{i})));
        EMGmaxGraph.(musclePlot1{i})=dd;
        EMG_summary.mean_plot.(musclePlot1{i}) = EMG_summary.mean.(musclePlot1{i}).*dd;
        hold on;
        h=area(timebase,EMG_summary.mean_plot.(musclePlot1{i}), 'EdgeColor' ,'none');hold on;        
        child=get(h,'Children')
        set(child,'FaceAlpha',0.2) 
       
%         plot(timebase,EMG_summary.mean_plot.(musclePlot1{i}),'LineWidth',1.0, 'Color', [0.17 0.17 0.17]);hold on;
                     
        title(musclePlot1{i});
        legend('unscaled','BW scaled','BW-MTL scaled','DYN scaled', 'EMG');
        xlabel('% gait cycle');
    end
    for i = 1:length(musclePlot2);
        ii=i+5;
        subplot(4,2,ii);
        plot(timebase,Act_summary.mean.(musclePlot2{i})(:,1:3),'LineWidth',1.5); hold on;
        title(musclePlot2{i});
         bb=[]; cc=[]; dd=[];
        bb=max(Act_summary.mean.(musclePlot2{i})(:,1:3));
        cc=mean(bb);
        dd= cc/(max(EMG_summary.mean.(musclePlot2{i})));
        EMGmaxGraph.(musclePlot1{i})=dd;
        EMG_summary.mean_plot.(musclePlot2{i}) = EMG_summary.mean.(musclePlot2{i}).*dd;
        hold on;
        h=area(timebase,EMG_summary.mean_plot.(musclePlot2{i}), 'EdgeColor' ,'none');hold on;        
        child=get(h,'Children')
        set(child,'FaceAlpha',0.2)
%         legend('unscaled','BW scaled','BW-MTL scaled','DYN scaled');
        xlabel('% gait cycle');
    end


display 'Muscle Activation Analyses done'


