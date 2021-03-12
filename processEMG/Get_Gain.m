% % % Read SystemFile
function [Gain]=Get_Gain(path, channel_names)


A = xml_read(path);
I = 1; 

while ~strcmp(A.ParamDefinitionList(I).ATTRIBUTE.name,'DeviceOutputComponent::Analog EMG::Voltage');
    I = I+1;
end

EMG = A.ParamDefinitionList(I).ParamListGroup; 

for i = 1:size(EMG.ParamList,2); 
    for j = 1:size(EMG.ParamList(i).Param,2)
        if strcmp(EMG.ParamList(i).Param(j).ATTRIBUTE.name,'DeviceOutputComponentName')== 1
            compare_names = strcmp(EMG.ParamList(i).Param(j).ATTRIBUTE.value,channel_names);
            for k = 1:size(EMG.ParamList(i).Param,2)
                if strcmp(EMG.ParamList(i).Param(k).ATTRIBUTE.name,'SourceGain')== 1
                    Gain(1,compare_names) = EMG.ParamList(i).Param(k).ATTRIBUTE.value; 
                end
            end
        end
    end
end


% gain_ch8 = Gain(1,1:8);
% gain_ch16 = Gain(:,9:26);

% for j = [1:18]
%     ind = find(gain_ch16(2,:) == j);
%     gain_ch16_correct(j)= gain_ch16(1,ind);
% end
% gain_ch16_corrected = gain_ch16_correct(1:16);



