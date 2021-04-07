function [] = plotID(idFile, cycle)
%RUNIK Summary of this function goes here
%   Detailed explanation goes here
    data = load_sto_file(idFile);

    figure('left side');
    title('left side');
    [hip_flexion_moment, gain] = normalizetimebase(data.hip_flexion_l_moment(cycle.left.start : cycle.left.end));
    [hip_adduction_moment, gain] = normalizetimebase(data.hip_adduction_l_moment(cycle.left.start : cycle.left.end));
    [knee_angle_moment, gain] = normalizetimebase(data.knee_angle_l_moment(cycle.left.start : cycle.left.end));
    [ankle_angle_moment, gain] = normalizetimebase(data.ankle_angle_l_moment(cycle.left.start : cycle.left.end));
    
    hold on;
    subplot(2,2, 1);
    plot( 0:100, hip_flexion_moment * (-1));
   % ylim([-20 20]);
    xlim([0 100]);
    title('hip flex/ext moment');
    
    subplot(2,2, 2);
    plot( 0:100, hip_adduction_moment * (-1));
    %ylim([-15 15]);
    xlim([0 100]);
    title('hip ad/abduction moment');
    
    subplot(2,2, 3);
    plot( 0:100, knee_angle_moment);
    %ylim([-20 20]);
    xlim([0 100]);
    title('knee flex/ext moment');
    
    subplot(2, 2, 4);
    plot( 0:100, ankle_angle_moment * (-1));
    % ylim([-20 60]);
    xlim([0 100]);
    title('ankle dorsi/plantarflex moment');

    enlargeFigure;
    
    
    figure('right side');
    title('right side');
    [hip_flexion_moment, gain] = normalizetimebase(data.hip_flexion_r_moment(cycle.right.start : cycle.right.end));
    [hip_adduction_moment, gain] = normalizetimebase(data.hip_adduction_r_moment(cycle.right.start : cycle.right.end));
    [knee_angle_moment, gain] = normalizetimebase(data.knee_angle_r_moment(cycle.right.start : cycle.right.end));
    [ankle_angle_moment, gain] = normalizetimebase(data.ankle_angle_r_moment(cycle.right.start : cycle.right.end));
    
    hold on;
    subplot(2,2, 1);
    plot( 0:100, hip_flexion_moment * (-1));
   % ylim([-20 20]);
    xlim([0 100]);
    title('hip flex/ext moment');
    
    subplot(2,2, 2);
    plot( 0:100, hip_adduction_moment * (-1));
    %ylim([-15 15]);
    xlim([0 100]);
    title('hip ad/abduction moment');
    
    subplot(2,2, 3);
    plot( 0:100, knee_angle_moment);
    %ylim([-20 20]);
    xlim([0 100]);
    title('knee flex/ext moment');
    
    subplot(2, 2, 4);
    plot( 0:100, ankle_angle_moment * (-1));
    % ylim([-20 60]);
    xlim([0 100]);
    title('ankle dorsi/plantarflex moment');

    enlargeFigure;
end