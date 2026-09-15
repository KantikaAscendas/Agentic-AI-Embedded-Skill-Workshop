function ProjectStartUp()
%PROJECTSTARTUP Validate the environment and open workshop exercises.

[installationIsValid, failureMessage] = helper.validateInstallation();
if ~installationIsValid
    warning(failureMessage);
    return
end

if usejava("desktop")
    open("Part_3_Code_Gen/Exercise_3.m");
    open("Part_2_AI_import/Exercise_2.m");
    open("Part_1_AI_modeling/Exercise_1.m");
else
    disp("Project opened without the MATLAB desktop; exercise files were not opened.")
end
disp("You are all set")
end
