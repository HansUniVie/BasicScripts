function [] = plotJRL(jrlFile, cycle)
%RUNIK Summary of this function goes here
%   Detailed explanation goes here
    data = load_sto_file(jrlFile);

    figure('left side');
    title('left side');
    
    [hip_joint_force_superior, gain] = normalizetimebase(data.hip_l_on_femur_l_in_femur_l_fy(cycle.left.start : cycle.left.end));
    [hip_joint_force_anterior, gain] = normalizetimebase(data.hip_l_on_femur_l_in_femur_l_fx(cycle.left.start : cycle.left.end));
    [hip_joint_force_lateral, gain] = normalizetimebase(data.hip_l_on_femur_l_in_femur_l_fz(cycle.left.start : cycle.left.end));
    hip_joint_force_resultant_total = sqrt(data.hip_l_on_femur_l_in_femur_l_fx.^2 + data.hip_l_on_femur_l_in_femur_l_fy.^2 + data.hip_l_on_femur_l_in_femur_l_fz.^2);
    [hip_joint_force_resultant, gain] = normalizetimebase(hip_joint_force_resultant_total(cycle.left.start : cycle.left.end));
    
    hold on;
    subplot(2,2, 1);
    plot( 0:100, hip_joint_force_anterior);
   % ylim([-20 20]);
    xlim([0 100]);
    title('hjc anterior/posterior');
    
    subplot(2,2, 2);
    plot( 0:100, hip_joint_force_superior);
    %ylim([-15 15]);
    xlim([0 100]);
    title('hjc superior/inferior');
    
    subplot(2,2, 3);
    plot( 0:100, hip_joint_force_lateral);
    %ylim([-20 20]);
    xlim([0 100]);
    title('hjc lateral/medial');
    
    subplot(2, 2, 4);
    plot( 0:100, hip_joint_force_resultant);
    %ylim([-20 60]);
    xlim([0 100]);
    title('hjc resultant');

    enlargeFigure;
    
    
    figure('right side');
    title('right side');
    
    [hip_joint_force_superior, gain] = normalizetimebase(data.hip_r_on_femur_r_in_femur_r_fy(cycle.right.start : cycle.right.end));
    [hip_joint_force_anterior, gain] = normalizetimebase(data.hip_r_on_femur_r_in_femur_r_fx(cycle.right.start : cycle.right.end));
    [hip_joint_force_lateral, gain] = normalizetimebase(data.hip_r_on_femur_r_in_femur_r_fz(cycle.right.start : cycle.right.end));
    hip_joint_force_resultant_total = sqrt(data.hip_r_on_femur_r_in_femur_r_fx.^2 + data.hip_r_on_femur_r_in_femur_r_fy.^2 + data.hip_r_on_femur_r_in_femur_r_fz.^2);
    [hip_joint_force_resultant, gain] = normalizetimebase(hip_joint_force_resultant_total(cycle.right.start : cycle.right.end));

    hold on;
    subplot(2,2, 1);
    plot( 0:100, hip_joint_force_anterior);
   % ylim([-20 20]);
    xlim([0 100]);
    title('hjc anterior/posterior');
    
    subplot(2,2, 2);
    plot( 0:100, hip_joint_force_superior);
    %ylim([-15 15]);
    xlim([0 100]);
    title('hjc superior/inferior');
    
    subplot(2,2, 3);
    plot( 0:100, hip_joint_force_lateral);
    %ylim([-20 20]);
    xlim([0 100]);
    title('hjc lateral/medial');
    
    subplot(2, 2, 4);
    plot( 0:100, hip_joint_force_resultant);
    %ylim([-20 60]);
    xlim([0 100]);
    title('hjc resultant');

    enlargeFigure;
end