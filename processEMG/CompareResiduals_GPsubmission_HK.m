%% Summarize Muscle activations, compare it to EMG
% November 2017, hans.kainz@kuleuven.be
close all;clear all;clc;

%% Specify main folder and patient identifiers
PI = {'CP02','CP03','CP04','CP05','CP06','CP07'}; %participant index (intervention + number)

dir_main = 'C:\Users\u0113767\Documents\WORK_KULeuven\ClinicalMuscleForce_project\Data_PellenbergStrenghProject\CP\';
ScaleMethod = {'NormalScaled','BWscaled','BW_MTLscaled','DYNscaled'};

for sub=1:length(PI)
    % load SO results
    SO_left = [];
    SO_right =[];
    SO_left = load([dir_main (PI{sub}) '\CP_CapGap\SOresults_l_withDYNBWmodel.mat']);
    SO_right = load([dir_main (PI{sub}) '\CP_CapGap\SOresults_r_withDYNBWmodel.mat']);

    for sm=1:length(ScaleMethod)

            Residuals.(PI{sub}).left(:,sm) = SO_left.SOresults.ResidualsPercentage(:,sm);
            Residuals.(PI{sub}).right(:,sm) = SO_right.SOresults.ResidualsPercentage(:,sm);        
    end
            Residuals.DYN_allSub.left(sub,:) = SO_left.SOresults.ResidualsPercentage(4,:);
            Residuals.DYN_allSub.right(sub,:) = SO_right.SOresults.ResidualsPercentage(4,:);
            
            Residuals.unscaled_allSub.left(sub,:) = SO_left.SOresults.ResidualsPercentage(1,:);
            Residuals.unscaled_allSub.right(sub,:) = SO_right.SOresults.ResidualsPercentage(1,:);
            
            Residuals.BW_allSub.left(sub,:) = SO_left.SOresults.ResidualsPercentage(2,:);
            Residuals.BW_allSub.right(sub,:) = SO_right.SOresults.ResidualsPercentage(2,:);
            
            Residuals.BWMTL_allSub.left(sub,:) = SO_left.SOresults.ResidualsPercentage(3,:);
            Residuals.BWMTL_allSub.right(sub,:) = SO_right.SOresults.ResidualsPercentage(3,:);
end

Residuals.DYN_allSub.LR = [Residuals.DYN_allSub.left; Residuals.DYN_allSub.right];
Residuals.unscaled_allSub.LR = [Residuals.unscaled_allSub.left; Residuals.unscaled_allSub.right];
Residuals.BW_allSub.LR = [Residuals.BW_allSub.left; Residuals.BW_allSub.right];
Residuals.BWMTL_allSub.LR = [Residuals.BWMTL_allSub.left; Residuals.BWMTL_allSub.right];

