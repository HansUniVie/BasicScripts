clc; clear all;close all;
% add path 
addpath([ pwd '\MatlabOpensimPipelineTools\']);
addpath([pwd '\processEMG']);
addpath([pwd '\plot_figure']);

 subject_folder = [pwd '\exampleData\'];
 
 %% load files
 OS_results.IK = load_sto_file([subject_folder 'gait3_kinematics.mot']);  % joint kinematics
 OS_results.ID = load_sto_file([subject_folder 'gait3_inverse_dynamics.sto']); % joint moments
 OS_results.MF = load_sto_file([subject_folder 'gait3_StaticOptimization_force.sto']); % muscle forces
 OS_results.Act = load_sto_file([subject_folder 'gait3_StaticOptimization_activation.sto']); % muscle activations
 OS_results.JCF = load_sto_file([subject_folder 'gait3_JointReaction_ReactionLoads.sto']); % joint contact forces

%% normalize to 100 % of gait cycle  
% joint angles example
angleSet = fieldnames(OS_results.IK);
for a = 1:length(angleSet)
    OS_results.normalized.IK.(angleSet{a}) = normalizetimebase(OS_results.IK.(angleSet{a}));           
end          
            
%% create figure 
% example kinematics right leg
figure
angleSet={'lower_torso_RZ','lower_torso_RX','lower_torso_RY','hip_flex_r','hip_add_r','hip_rot_r','knee_flex_r','knee_flex_r','knee_flex_r','ankle_flex_r','subt_angle_r'};
x=0:1:100;
for p=1:length(angleSet)
   subplot(4,3,p) 
   set(findall(gcf,'-property','FontSize'),'FontSize',16)
   plot(x, OS_results.normalized.IK.(angleSet{p}), 'LineWidth',2,'Color','r');
   hold on
   SD = ones(101,1) + 7; % create fake standard deviation just to show you how you can plot mean +/- SD
    lb = (OS_results.normalized.IK.(angleSet{p}) - SD);
    ub = (OS_results.normalized.IK.(angleSet{p}) + SD);
   [ph,msg]=jbfill(x,lb',ub',[1 0 0],[1 0 0],'add',.1)  
   hold on
   title(char((angleSet{p})))
   grid on   
end