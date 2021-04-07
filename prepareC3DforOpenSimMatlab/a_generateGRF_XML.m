if ~exist('grfFileName', 'var')
    [filename, path] = uigetfile('grf.mot', 'MultiSelect', 'off');
    [folder, baseFileNameNoExt, extension] = fileparts(fullfile(path, filename));
    grfFileName = fullfile(path, filename);
else
    [folder, baseFileNameNoExt, extension] = fileparts(grfFileName);
end

grforces = xml_read(fullfile('DefaultSetupFiles', 'GRF_file_all.xml'));
grforces_generated = xml_read(fullfile('DefaultSetupFiles', 'GRF_file_empty.xml'));

ForceList = {'1', '2', '3'};
[index, tf] = listdlg('PromptString', 'right foot force plates', 'SelectionMode', 'multiple', 'ListString', ForceList);

counter = 1;

if(tf == 0)
    disp('no grf used for left foot');

else
    for i = 1 : size(index, 2)
        
        if size(index, 2) == 1
            ind = index;
        else
            ind = index(i);
        end
        
        % grforces.ExternalLoads.objects.ExternalForce(1) = [];
        ind = str2num(ForceList{ind});
        
        grforces_generated.ExternalLoads.objects.ExternalForce(counter) = grforces.ExternalLoads.objects.ExternalForce(ind);
        counter = counter + 1;
    end
end

ForceList = {'1', '2', '3'};
[index, tf] = listdlg('PromptString', 'left foot force plates', 'SelectionMode', 'multiple', 'ListString', ForceList);

if(tf == 0)
    disp('no grf used for left foot');

else
    for i = 1 : size(index, 2)
        
        if size(index, 2) == 1
            ind = index;
        else
            ind = index(i);
        end
        
        ind = str2num(ForceList{ind}) + 3;
        
        grforces_generated.ExternalLoads.objects.ExternalForce(counter) = grforces.ExternalLoads.objects.ExternalForce(ind);
        counter = counter + 1;
    end
end
Pref = struct;
Pref.StructItem = false;

grforces_generated.ExternalLoads.datafile = grfFileName;
xml_write(fullfile(folder, 'GRF.xml'), grforces_generated, 'OpenSimDocument', Pref);
