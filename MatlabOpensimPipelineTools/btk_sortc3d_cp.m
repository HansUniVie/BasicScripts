function data_out = btk_sortc3d_cp(marker_data,analog_data,sub_info,angle_data)

% function data_out = btk_sortc3d(varargin)
% function data_out  = btk_sortc3d(data)
%
% Function to sort data loaded from C3D file with loadc3dfile.m so that
% data is appropriately labelled as a marker, angle, moment etc. This is
% necessary when data is processed using the PiG model, where extra marker
% data representing joint moments, centre etc are made and we want to be
% able to distinguish which is which.
%
% INPUT -
%           marker_data - structure containing data from C3d file (generated using
%               btk_loadc3d.m)
%           marker_names - a cell array of strings containing the marker
%               names that are to taken from the c3d file and placed into a a
%               marker structure (all other 3Dtargets will be placed in another
%               structure variable called Other_markers) - with exception of
%               anything containing the Angle, Force, Moment, Powe, GRF, Mass
%               which are stored as individual structure variables OPTIONAL
%               - if this is not given then all 3D data will be used
%           calc_markers - cell array of any additional markers want to placed
%               somewhere special (e.g. calculated markers of joint
%               centres) OPTIONAL
%
% OUTPUT - data_out - new structure which has data sorted into new fields
%           depending on whether it is Marker data, Angle data, Moment data
%           etc. eg. data.Marker.ASIS rather than data.ASIS
%
%   e.g. 
%
%   [marker_data, analog_data, fp_data, sub_info] = btk_loadc3d('input.c3d');
%
%   marker_list = {'LASI'; 'RASI'; 'LPSI'; 'RPSI'; 'LTHI'; 'LKNE'; 'LTIB'; 'LANK'; 'LHEE';...
%     'LTOE'; 'RTHI'; 'RKNE'; 'RTIB'; 'RANK'; 'RHEE'; 'RTOE'};
%                     
%   calc_marker_list = {'LTIO'; 'LFEO'; 'LFEP'; 'RFEP'; 'RFEO'; 'RTIO'};
%
%   marker_data = sort_c3d(data,marker_list,calc_marker_list);
%
% Written by Glen Lichtwark (The University of Queensland)
% Updated: Sept, 2012

%%
% if nargin < 2
    marker_names = fieldnames(marker_data.Markers);
% end

if nargin<3
    calc_markers = [];
end

%%
% marker field names
names = fieldnames(marker_data.Markers);

% go through each field name and determine if it is something which can be
% sorted into a specific field reference
for i = 1:length(names)
    
    a = marker_data.Markers.(names{i}); % load the data in the field
        
    % if the field name is in the marker cell array then add it to the Marker structure
    if ~isempty(strmatch(names{i},marker_names)) && size(a,2) == 3        
        continue
    end
    
    if ~isempty(calc_markers)
        % if the field name is in the marker cell array then add it to the Marker structure
        if ~isempty(strmatch(names{i},calc_markers))
            calc_markers.(names{i}) = a;
             data.Markers = rmfield(marker_data.Markers,names{i});
            continue
        end
    end
end

%%
% angle fieldnames
angles = fieldnames(angle_data.angles);

for i = 1:length(angles)

    b = angle_data.angles.(angles{i});
    if ~isempty(strfind(angles{i},'Offset')) % find offsets (the static pose joint angles from BB scripts)
        data.OffsetAngles.(angles{i}) = angle_data.angles.(angles{i});
    end
    
end
%%

% angle fieldnames
osim_local_markers = fieldnames(marker_data.Markers);

for i = 1:length(osim_local_markers)

    b = marker_data.Markers.(osim_local_markers{i});
    if ~isempty(strfind(osim_local_markers{i},'avg_o_')) % find offsets (the static pose joint angles from BB scripts)
        data.local_osim_markers.(osim_local_markers{i}) = marker_data.Markers.(osim_local_markers{i});
    end
    
end
%%
% %%
% for i = 1:length(fp_data.Info)
%        
%     % Compiled force plate data
%     data.ForcePlate(i).F(:,:) = fp_data.GRF_data(i).F;
%     data.ForcePlate(i).M(:,:) = fp_data.GRF_data(i).M;
%     data.ForcePlate(i).COP(:,:) = fp_data.GRF_data(i).P;
%         
%     % Raw force plate data
%     % Force channels
%     data.ForcePlate(i).FxChannel(:,:) = fp_data.FP_data(i).channels.(['Fx' num2str(i)]);
%     data.ForcePlate(i).FyChannel(:,:) = fp_data.FP_data(i).channels.(['Fy' num2str(i)]);
%     data.ForcePlate(i).FzChannel(:,:) = fp_data.FP_data(i).channels.(['Fz' num2str(i)]);
%         
%     % Moment channels
%     data.ForcePlate(i).MxChannel(:,:) = fp_data.FP_data(i).channels.(['Mx' num2str(i)]);
%     data.ForcePlate(i).MyChannel(:,:) = fp_data.FP_data(i).channels.(['My' num2str(i)]);
%     data.ForcePlate(i).MzChannel(:,:) = fp_data.FP_data(i).channels.(['Mz' num2str(i)]);
%     
%     % Force plate corners
%     data.ForcePlate(i).Corner1(:,:) = fp_data.FP_data(i).corners(:,1);
%     data.ForcePlate(i).Corner2(:,:) = fp_data.FP_data(i).corners(:,2);
%     data.ForcePlate(i).Corner3(:,:) = fp_data.FP_data(i).corners(:,3);
%     data.ForcePlate(i).Corner4(:,:) = fp_data.FP_data(i).corners(:,4);
%     
%     % Force plate origin
%     data.ForcePlate(i).FPOrigin(:,:) = fp_data.FP_data(i).origin;      
% end    

%%

%     if ~isempty(strfind(names{i},'Force')) % find forces
%         marker_data.Force.(names{i}) = a;
%         marker_data.Markers = rmfield(marker_data.Markers,names{i});
%         continue
%     end
%     if ~isempty(strfind(names{i},'Moment')) % find moments
%         marker_data.Moment.(names{i}) = a;
%         marker_data.Markers = rmfield(marker_data.Markers,names{i});
%         continue
%     end
%     
%     if ~isempty(strfind(names{i},'Power')) % find powers
%         marker_data.Power.(names{i}) = a;
%         marker_data.Markers = rmfield(marker_data.Markers,names{i});
%         continue
%     end
%     
%     if ~isempty(strfind(names{i},'GRF')) % find GRFs
%         marker_data.GRF.(names{i}) = a;
%         marker_data.Markers = rmfield(marker_data.Markers,names{i});
%         continue
%     end
%     
%     if ~isempty(strfind(names{i},'Mass')) % find centre of mass fields
%         marker_data.COM.(names{i}) = a;
%         marker_data.Markers = rmfield(marker_data.Markers,names{i});
%         continue
%     end
    
    marker_data.Other_Markers.(names{i}) = a;
    marker_data.Markers = rmfield(marker_data.Markers,names{i});
    

% output data
data_out = data;     
    
        