    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example for paired and independent t-test using SPM
% for more information cheack out https://spm1d.org/References.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;  clc; close all;
home = pwd;
folder=[home '\spm1dmatlab-master'];
addpath(genpath(folder));
load([home '\exampleData\DataExample.mat'])

cond_set={'preSDR' , 'postSDR'};%'badGrowth','goodGrowth' 'preBTX','postBTX','preSDR','postSDR'
angle_set_R = {'lower_torso_RZ','lower_torso_RX','lower_torso_RY','hip_flex_r','hip_add_r','hip_rot_r','knee_flex_r','ankle_flex_r'};% files = dir([kine_folder '*R.mot']); 

for a=1:length(angle_set_R)       
       YA = Group.(cond_set{1}).OSoutput.IK.(angle_set_R{a})';
       YB = Group.(cond_set{2}).OSoutput.IK.(angle_set_R{a})'; 
       
% % %        % t-test    
% % %     %(1) Conduct SPM analysis:
% % %     spm       = spm1d.stats.ttest2(YA, YB);
% % %     spmi      = spm.inference(0.05, 'two_tailed',true, 'interp',true);
% % %     disp(spmi)
% % % 
% % %     %(2) Plot:
% % %     subplot(3,3,a)
% % %     spmi.plot();
% % %     spmi.plot_threshold_label();
% % %     spmi.plot_p_values();

       %% paired t-test
        spm       = spm1d.stats.ttest_paired(YA, YB);
        spmi      = spm.inference(0.05, 'two_tailed', false, 'interp',true);
        disp(spmi)
        %(2) Plot:
        %%% plot mean and SD:        
        subplot(6,3,a)
        spm1d.plot.plot_meanSD(YA, 'color','k');
        hold on
        spm1d.plot.plot_meanSD(YB, 'color','r');
        title('Mean and SD')
        %%% plot SPM results:
        aa = a + 9;
        subplot(6,3,aa)
        spmi.plot();
        spmi.plot_threshold_label();
        spmi.plot_p_values();
        title('Hypothesis test')        
end








