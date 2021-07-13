import org.opensim.modeling.*;
[modelFileName, path] = uigetfile('*.osim');
osimBaseModel = Model(fullfile(path, modelFileName));

% Adjust muscle force depending on bodymass
state = osimBaseModel.initSystem();
model_mass = osimBaseModel.getTotalMass(state);
scaled_mass = model_mass;
% scaled_mass = model_mass / 0.545553977461274; % use this when you do not
% have a torso
generic_mass = 75.1646;
scale_factor = (scaled_mass / generic_mass) ^ (2 / 3);
[~, fileName, ~] = fileparts(modelFileName);
newModelName = fullfile(path, [fileName '_final.osim']);
strengthScaler(scale_factor, osimBaseModel, newModelName);

% Adjust Actuators to mass center of pelvis
actuatorfile = fullfile(pwd, 'gait2392_SO_Actuators.xml');
osimModel = Model(newModelName);
pelvis = osimModel.getBodySet().get("pelvis");
massCenter = pelvis.getMassCenter();
forceset = ForceSet(actuatorfile);
for j = 0 : 2
    pointActuator = PointActuator.safeDownCast(forceset.get(j));
    pointActuator.set_point(massCenter);
end
forceset.print(fullfile(path, [fileName '_final_actuators.xml']));
