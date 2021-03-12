function data = btk_c3d2grf(data)
% This function will use the information from the forceplates and the
% analog force plate data to create a GRF vector in the global coordinate
% system, sampled at the same frequency as the kinematic marker data. All
% COP's, forces and GRF moments are expressed relative to the global
% coordinate system (not the force plate system)
%
% Input - data - structure format containing data that has been loaded with
%                loadc3dfile.m 
%         a_data - structure containing the analog force plate data from 
%                the loadc3dfile.m function
%         fp_info - structure containing the coordinates of the force plate
%                corners and origin coordinates, from the loadc3dfile.m function
%         subsample - 'on' or 'off', whether to subsample forceplate data at same
%                frequency as kinematic data (default = 'on')
%       
% Output - data - structure format containing orginal data plus the new
%                force plate data in a field called Forceplate
%
% Author: Glen Lichtwark (Griffith University)
%
%%
    subsample = 'on';
    
%%

fp_num = length(data.GRF_data.Info);

if fp_num > 0 
        
        XI = data.GRF_data.Info(1).frequency/data.marker_data.Info.frequency:data.GRF_data.Info(1).frequency/data.marker_data.Info.frequency:length(data.GRF_data.GRF_data(1).P);
        data.FP_Rate = data.GRF_data.Info(1).frequency;
                   
        dt = 1/double(data.FP_Rate);
        fcut = 20;
        order = 2;
        
        a_data.Fx1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.Fx1)));
        a_data.Fy1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.Fy1)));
        a_data.Fz1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.Fz1)));
        
        a_data.Mx1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.Mx1)));
        a_data.My1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.My1)));
        a_data.Mz1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(1).channels.Mz1)));
        
        a_data.COPx1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(1).P(:,1))));
        a_data.COPy1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(1).P(:,2))));
        a_data.COPz1 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(1).P(:,3))));

        a_data.Fx2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.Fx2)));
        a_data.Fy2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.Fy2)));
        a_data.Fz2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.Fz2)));
        
        a_data.Mx2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.Mx2)));
        a_data.My2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.My2)));
        a_data.Mz2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.FP_data(2).channels.Mz2)));
        
        a_data.COPx2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(2).P(:,1))));
        a_data.COPy2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(2).P(:,2))));
        a_data.COPz2 = (matfiltfilt(dt, fcut, order, double(data.GRF_data.GRF_data(2).P(:,3))));

        h = round(length(data.marker_data.Markers.RASI)/2);
        m1 = data.marker_data.Markers.RPSI(h,2);
        m2 = data.marker_data.Markers.RASI(h,2);         
    
for i = 1:fp_num
        % first calculate the orientation of the forceplate relative to the
        % global coordinate system. This is done from knowledge of the position
        % of the corners of the forceplate

        plate_centre = round(mean([data.GRF_data.FP_data(i).corners(1,1) data.GRF_data.FP_data(i).corners(1,2) ...
            data.GRF_data.FP_data(i).corners(1,3) data.GRF_data.FP_data(i).corners(1,4);
            data.GRF_data.FP_data(i).corners(2,1) data.GRF_data.FP_data(i).corners(2,2) ...
            data.GRF_data.FP_data(i).corners(2,3) data.GRF_data.FP_data(i).corners(2,4)],2));
        alpha = atan2(round(data.GRF_data.FP_data(i).corners(1,1)) - round(data.GRF_data.FP_data(i).corners(1,4)),...
            round(data.GRF_data.FP_data(i).corners(2,1)) - round(data.GRF_data.FP_data(i).corners(2,4)));        
        
%         plate_centre = round(mean([fp_info.(['Corner1_' num2str(i)]).X fp_info.(['Corner2_' num2str(i)]).X ...
%             fp_info.(['Corner3_' num2str(i)]).X fp_info.(['Corner4_' num2str(i)]).X;
%             fp_info.(['Corner1_' num2str(i)]).Y fp_info.(['Corner2_' num2str(i)]).Y ...
%             fp_info.(['Corner3_' num2str(i)]).Y fp_info.(['Corner4_' num2str(i)]).Y],2));
%         alpha = atan2(round(fp_info.(['Corner1_' num2str(i)]).X) - round(fp_info.(['Corner4_' num2str(i)]).X),...
%             round(fp_info.(['Corner1_' num2str(i)]).Y) - round(fp_info.(['Corner4_' num2str(i)]).Y));
     
%%                    
        % now caluclate the COP position relative to the global coordinate
        % system
        
        data.ForcePlate(i).COP(:,1) = interp1(-a_data.(['COPx' num2str(i)])*cos(alpha)+... %need to flip the x-axis system to match that of the global coordinate system 
            a_data.(['COPy' num2str(i)])*sin(alpha)+plate_centre(1),XI);
        data.ForcePlate(i).COP(:,2) = interp1(a_data.(['COPy' num2str(i)])*cos(alpha)+...
            a_data.(['COPx' num2str(i)])*sin(alpha)+plate_centre(2),XI);
        data.ForcePlate(i).COP(:,3) = -interp1(a_data.(['COPz' num2str(i)]),XI)'; %need to flip the z-axis system to match that of the global coordinate system
       
        % Lowpass Filtering routine to filter GRFs in same mannor as Kinematics   
        % [result] = matfiltfilt(dt, fcut, order, data);

%         dt = 1/1000;
%         fcut = 20;
%         order = 2;
%         
%         data.ForcePlate(i).COP(:,1) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).COP(:,1)));
%         data.ForcePlate(i).COP(:,2) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).COP(:,2)));
%         data.ForcePlate(i).COP(:,3) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).COP(:,3)));
%         
%%        
        % now calculate the forces about the global coordinate
        % system
        
        data.ForcePlate(i).F(:,1) = interp1(-a_data.(['Fx' num2str(i)])*cos(alpha) + ... %need to flip the x-axis system to match that of the global coordinate system 
            a_data.(['Fy' num2str(i)])*sin(alpha),XI);
        data.ForcePlate(i).F(:,2) = interp1(a_data.(['Fy' num2str(i)])*cos(alpha) - ...
            -a_data.(['Fx' num2str(i)])*sin(alpha),XI);
        data.ForcePlate(i).F(:,3) = -interp1(a_data.(['Fz' num2str(i)]),XI)'; %need to flip the z-axis system to match that of the global coordinate system       
        
        % Lowpass Filtering routine to filter GRFs in same mannor as Kinematics   
        % [result] = matfiltfilt(dt, fcut, order, data);
       
%         data.ForcePlate(i).F(:,1) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).F(:,1)));
%         data.ForcePlate(i).F(:,2) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).F(:,2)));
%         data.ForcePlate(i).F(:,3) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).F(:,3)));
%         

        % first calculate the moment about the COP in the FoP frame of
        % reference
        
%%        
        c = -data.GRF_data.FP_data(i).origin(3)/1000;

        % Mx and My should be 0 by definition
        Mx = (interp1(a_data.(['Mx' num2str(i)]),XI)'/1000 - (c*interp1(a_data.(['Fy' num2str(i)]),XI,'spline')') ... %...
                - (interp1(a_data.(['COPy' num2str(i)])/1000,XI,'spline')'.*interp1(a_data.(['Fz' num2str(i)]),XI,'spline')'));
        My = (interp1(a_data.(['My' num2str(i)]),XI,'spline')'/1000 + (c*interp1(a_data.(['Fx' num2str(i)]),XI,'spline')') ...
                + (interp1(a_data.(['COPx' num2str(i)])/1000,XI,'spline')'.*interp1(a_data.(['Fz' num2str(i)]),XI,'spline')')); %...
        % Mz is the free torque
        Mz = (interp1(a_data.(['Mz' num2str(i)]),XI,'spline')'/1000 ...
                + (interp1(a_data.(['COPy' num2str(i)])/1000,XI,'spline')'.*interp1(a_data.(['Fx' num2str(i)]),XI,'spline')') ...
                - (interp1(a_data.(['COPx' num2str(i)])/1000,XI,'spline')'.*interp1(a_data.(['Fy' num2str(i)]),XI,'spline')'));

        % Now rotate moments to the global coordinate system like the forces    
        data.ForcePlate(i).M(:,1) = -Mx*cos(alpha) + My*sin(alpha);
        data.ForcePlate(i).M(:,2) = My*cos(alpha) - (-Mx*sin(alpha));
        data.ForcePlate(i).M(:,3) = -Mz;        
        
        % Lowpass Filtering routine to filter GRFs in same mannor as Kinematics   
        % [result] = matfiltfilt(dt, fcut, order, data);
        
%         data.ForcePlate(i).M(:,1) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).M(:,1)));
%         data.ForcePlate(i).M(:,2) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).M(:,2)));
%         data.ForcePlate(i).M(:,3) = matfiltfilt(dt, fcut, order, double(data.ForcePlateR(i).M(:,3)));        
% %%
%         % now the forceplate data needs (possibly) to be rotated if they are walking in
%         % the wrong direction in the lab, just like the markers. F, M, and COP must
%         % all be rotated for how ever many plates you have.
%         
%         % test the directionality of the pelvis markers in the lab
%         % select a hip marker, I like the hip! This is the same logic used
%         % in the c3d2trc code. - DJS June May 2012
%  
%       % Marker positions in the middle of the trial   
%       
        if m2 < m1 % logic: if the right anterior superior illiac marker has y coordinate less than the posterior superior illiac marker then the subject is facing/progressing the 'negative' lab direction in lab space
        t = pi;      
        r = [round(cos(t)), round(-sin(t)), 0; % rotation matrix about z (vertical) axis, 
                round(sin(t)), round(cos(t)), 0;
                    0, 0, 1]; 
     
            data.ForcePlate(i).M = data.ForcePlate(i).M * r;
            data.ForcePlate(i).F = data.ForcePlate(i).F * r;
            data.ForcePlate(i).COP = data.ForcePlate(i).COP * r;
            
            disp('Hip markers indicate -Y direction in lab, force plate data rotated 180 degrees')  % OpenSim requires data going in OpenSim static model's x positive direction
             
        else
            
            disp('Correct travel direction in lab, no rotation required')
        
        end  

end 
    
else
    disp('There is no force plate data in this file'); 
        
        
end
