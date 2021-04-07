function [] = plotIK(ikFile, cycle)
%RUNIK Summary of this function goes here
%   Detailed explanation goes here
    data = load_sto_file(ikFile);

    figure('left foot');
    title('left foot');
    
    [pelvis_tilt, gain] = normalizetimebase(data.pelvis_tilt(cycle.left.start : cycle.left.end));
    [pelvis_list, gain] = normalizetimebase(data.pelvis_list(cycle.left.start : cycle.left.end));
    [pelvis_rotation, gain] = normalizetimebase(data.pelvis_rotation(cycle.left.start : cycle.left.end));
    [hip_flexion, gain] = normalizetimebase(data.hip_flexion_l(cycle.left.start : cycle.left.end));
    [hip_adduction, gain] = normalizetimebase(data.hip_adduction_l(cycle.left.start : cycle.left.end));
    [hip_rotation, gain] = normalizetimebase(data.hip_rotation_l(cycle.left.start : cycle.left.end));
    [knee_angle, gain] = normalizetimebase(data.knee_angle_l(cycle.left.start : cycle.left.end));
    [ankle_angle, gain] = normalizetimebase(data.ankle_angle_l(cycle.left.start : cycle.left.end));
    
    hold on;
    subplot(3, 3, 1);
    plot( 0:100, pelvis_tilt);
    xlim([0 100]);
    title('pelvis ant/post tilt');
    
    subplot(3, 3, 2);
    plot( 0:100, pelvis_list);
    xlim([0 100]);
    title('pelvic obliquity');
    
    subplot(3, 3, 3);
    plot( 0:100, pelvis_rotation);
    xlim([0 100]);
    title('pelvic int/ext rotation');
    
    % switch for 2 sides
    
    subplot(3, 3, 4);
    plot( 0:100, hip_flexion);
    xlim([0 100]);
    title('hip flexion/extension');

    subplot(3, 3, 5);
    plot( 0:100, hip_adduction);
    xlim([0 100]);
    title('hip ad/abduction');

    subplot(3, 3, 6);
    plot( 0:100, hip_rotation);
    xlim([0 100]);
    title('hip int/ext rotation');
    
    subplot(3, 3, 7);
    plot( 0:100, knee_angle * (-1));
    xlim([0 100]);
    title('knee flexion/extension');

    subplot(3, 3, 8);
    plot( 0:100, ankle_angle);
    
    xlim([0 100]);
    title('ankle dorsi/plantarflexion');
    
    enlargeFigure;
    
    
    
    figure('right foot');
    title('right foot');
    
    [pelvis_tilt, gain] = normalizetimebase(data.pelvis_tilt(cycle.right.start : cycle.right.end));
    [pelvis_list, gain] = normalizetimebase(data.pelvis_list(cycle.right.start : cycle.right.end));
    [pelvis_rotation, gain] = normalizetimebase(data.pelvis_rotation(cycle.right.start : cycle.right.end));
    [hip_flexion, gain] = normalizetimebase(data.hip_flexion_r(cycle.right.start : cycle.right.end));
    [hip_adduction, gain] = normalizetimebase(data.hip_adduction_r(cycle.right.start : cycle.right.end));
    [hip_rotation, gain] = normalizetimebase(data.hip_rotation_r(cycle.right.start : cycle.right.end));
    [knee_angle, gain] = normalizetimebase(data.knee_angle_r(cycle.right.start : cycle.right.end));
    [ankle_angle, gain] = normalizetimebase(data.ankle_angle_r(cycle.right.start : cycle.right.end));
    hold on;
    subplot(3, 3, 1);
    plot( 0:100, pelvis_tilt);
    xlim([0 100]);
    title('pelvis ant/post tilt');
    
    subplot(3, 3, 2);
    plot( 0:100, pelvis_list);
    xlim([0 100]);
    title('pelvic obliquity');
    
    subplot(3, 3, 3);
    plot( 0:100, pelvis_rotation);
    xlim([0 100]);
    title('pelvic int/ext rotation');
    
    % switch for 2 sides
    
    subplot(3, 3, 4);
    plot( 0:100, hip_flexion);
    xlim([0 100]);
    title('hip flexion/extension');

    subplot(3, 3, 5);
    plot( 0:100, hip_adduction);
    xlim([0 100]);
    title('hip ad/abduction');

    subplot(3, 3, 6);
    plot( 0:100, hip_rotation);
    xlim([0 100]);
    title('hip int/ext rotation');
    
    subplot(3, 3, 7);
    plot( 0:100, knee_angle * (-1));
    xlim([0 100]);
    title('knee flexion/extension');

    subplot(3, 3, 8);
    plot( 0:100, ankle_angle);
    ylim([-30 30]);
    xlim([0 100]);
    title('ankle dorsi/plantarflexion');
    
    enlargeFigure;
    
end