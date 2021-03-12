%% Summarize Muscle activations, compare it to EMG
% Ausgust 2017, hans.kainz@kuleuven.be
% close all;clear all;clc;

%% Specify main folder and patient identifiers
PI = {'CP02','CP03','CP04','CP05','CP06','CP07'}; %participant index (intervention + number)

dir_main = 'C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\';
ScaleMethod = {'NormalScaled','BWscaled','BW_MTLscaled','DYNscaled'};
% muscle = {'REF','VAL','BIF','MEH','TIA','GAS','SOL','GLU'};
% muscle_nr = {'28','31','9','8','38','32','34','2'};
% % knee flexor muscles
% muscle = {'BIFlh','BIFsh','GASm', 'GASl','SemiMem','SemiTen','GRA','SAR'};%
% muscle_nr = {'9','10','32','33','7','8','19','11'};%
% % knee extensor muscles
% muscle = {'REF','VAL','VAM','VAI'};
% muscle_nr = {'28','31','29','30'};
% % hip flexor muscles
% muscle = {'AddBr','AddLo','GLUme1','GLUmi1', 'GRA','ILIA','PECT','PSOAS','REF','SAR','TFL'};
% muscle_nr = {'13','12','1','4','19','23','18','24','28','11','17'};
% % hip extensor muscles
% % muscle = {'AddMaf1','AddMaf2','AddMaf3','AddLo','BIF','GLUma1','GLUma2','GLUma3', 'GLUme3','GLUmi3','SemiMem','SemiTen'};
% % muscle_nr = {'14','15','16','12','9','20','21','22','3','6','7','8'};
% % hip abductor muscles
% muscle = {'GLUma1','GLUme1','GLUme2','GLUme3','GLUmi1','GLUmi2','GLUmi3','PERI', 'SAR','TFL'};
% muscle_nr = {'20','1','2','3','4','5','6','27','11','17'};
% % ankle DF muscles
% muscle = {'ExDig','ExHal','Per_tert', 'tibAnt'};%
% muscle_nr = {'42','43','41','38'};%
% % ankle PF muscles
% muscle = {'FleDig','FleHal','GASl', 'GASm','PerBre','PerLon','SOL','TIP'};%
% muscle_nr = {'36','37','33','32','39','40','34','35'};%


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
            SoAct.(PI{sub}).raw.(muscle{m}).left(:,sm) = SO_left.SOresults.(ScaleMethod{sm}).SoAct(:,mm);
            SoAct.(PI{sub}).raw.(muscle{m}).right(:,sm) = SO_right.SOresults.(ScaleMethod{sm}).SoAct(:,mm);
            % normalize to gait cycle length
            SoAct.(PI{sub}).normGC.(muscle{m}).left(:,sm) = normalizetimebase(SoAct.(PI{sub}).raw.(muscle{m}).left(:,sm));
            SoAct.(PI{sub}).normGC.(muscle{m}).right(:,sm) = normalizetimebase(SoAct.(PI{sub}).raw.(muscle{m}).right(:,sm));
%             % normalize gait cycle and max activation
%             % left
%             Data=[];
%             Data=SOact.(PI{sub}).normGC.(muscle{m}).left(:,sm);        
%             normA = Data - min(Data(:));
%             SOact.(PI{sub}).normGCnormMaxAct.(muscle{m}).left(:,sm) = normA ./ max(normA(:));
%             % right
%             Data_r=[];
%             Data_r=SOact.(PI{sub}).normGC.(muscle{m}).right(:,sm);        
%             normA_r = Data_r - min(Data_r(:));
%             SOact.(PI{sub}).normGCnormMaxAct.(muscle{m}).right(:,sm) = normA_r ./ max(normA_r(:));
        end           
    end
        
   for m=1:length(muscle)
       mm=[];
       mm=str2num(muscle_nr{m});
        for sm=1:length(ScaleMethod)                
            % normalize to gait cycle length
            SoAct.(ScaleMethod{sm}).normGC.(muscle{m}).left(:,sub) = normalizetimebase(SO_left.SOresults.(ScaleMethod{sm}).SoAct(:,mm));
            SoAct.(ScaleMethod{sm}).normGC.(muscle{m}).right(:,sub) = normalizetimebase(SO_right.SOresults.(ScaleMethod{sm}).SoAct(:,mm));            
        end           
    end
    
end
% cd('Y:\MATLABcodes\Hans_DATA\');
% fileName='SoForce_summary.mat';
% save(fileName, 'SoForce');
%% summarize muscle activation over all participants

for sm=1:length(ScaleMethod)
    for m=1:length(muscle)
        Activation_summary.All_subj.(ScaleMethod{sm}).(muscle{m}) = [SoAct.(ScaleMethod{sm}).normGC.(muscle{m}).left, SoAct.(ScaleMethod{sm}).normGC.(muscle{m}).right];
%         Force_summary.mean.(muscle{m})(:,sm) = (mean((Force_summary.All_subj.(ScaleMethod{sm}).(muscle{m})(:,[1:6 8:12]))'))';
%         Force_summary.SD.(muscle{m})(:,sm) = (std((Force_summary.All_subj.(ScaleMethod{sm}).(muscle{m})(:,[1:6 8:12]))'))';
        
    end  
end

%%%%
% change names depengind on muscle group
for sm=1:length(ScaleMethod)
    for m=1:length(muscle)
        Activation_summary.Max.All_subj.(ScaleMethod{sm}).KneeFlex(m,:)=max(Activation_summary.All_subj.(ScaleMethod{sm}).(muscle{m}));
    end
end


for sm=1:length(ScaleMethod)
    Activation_summary.Max.All_subj.KneeFlex_meanAllMuscles(sm,:)=mean(Activation_summary.Max.All_subj.(ScaleMethod{sm}).KneeFlex);
end
