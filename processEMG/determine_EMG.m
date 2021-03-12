function [EMG_channel] =determine_EMG(ALabels, AnalogSignals,names_channels)

% get EMG data out of c3d file. 
% Order of Channels: first 8 channel EMG, second 16 channel EMG.
% Input: - Labels of AnalogData --> Output of readc3d-function
%        - AnalogSignals --> Output of readc3d-function
% Output: Matrix with all signals on channel 8 and a matrix with signals on
% 16-channel EMG. 
% 
% By Sam Van Rossom, December 2013. 
% Adapted by Mariska Wesseling, October 2015


% determine EMG data.
fails = 0;
tel = 1;
used = [];
for i = 1:length(names_channels)
    number = find(strcmp(names_channels(i),ALabels));
    if ~isempty(number)
        if sum(used==number(1,1))==0
            EMG_channel(:,i) = AnalogSignals(:,number(1,1));
            used(tel) = number(1,1);
        else
            EMG_channel(:,i) = AnalogSignals(:,number(1,2));
            used(tel) = number(1,2);
        end
        tel = tel+1;
    else
        warning(['Channel ' char(names_channels(i)) ' does not exist']);
    end
end    
