% Check readiness for the one-hour Agentic AI Embedded Skill workshop.
clearvars

scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
resultsFolder = fullfile(repoRoot,"agentic_ai","results");
if ~isfolder(resultsFolder)
    mkdir(resultsFolder);
end

releaseInfo = matlabRelease();
releaseName = string(releaseInfo.Release);
releaseParts = regexp(releaseName,"^R(\d{4})([ab])$","tokens","once");
if isempty(releaseParts)
    releaseOK = false;
else
    releaseKey = 2 * str2double(releaseParts{1}) + ...
        double(releaseParts{2} == "b");
    releaseOK = releaseKey >= (2 * 2026);
end

requiredProducts = [
    "Simulink"
    "Deep Learning Toolbox"
    "Statistics and Machine Learning Toolbox"
    "MATLAB Coder"
    "Simulink Coder"
    "Embedded Coder"
    "Fixed-Point Designer"
];
installedProductInfo = ver;
installedProducts = string({installedProductInfo.Name});
productInstalled = ismember(requiredProducts,installedProducts);

installedAddOns = matlab.addons.installedAddons;
addOnNames = string(installedAddOns.Name);
hasCompressionLibrary = any(contains(addOnNames, ...
    "Deep Learning Toolbox Model Compression Library"));
hasDeepLearningCodegen = any(contains(addOnNames, ...
    "MATLAB Coder Interface for Deep Learning"));
hasPyTorchConverter = any(contains(addOnNames, ...
    "Deep Learning Toolbox Converter for PyTorch"));

compilerConfigurations = mex.getCompilerConfigurations("C++");
hasCompiler = ~isempty(compilerConfigurations);

userProfile = string(getenv("USERPROFILE"));
skillLocations = [
    fullfile(userProfile,".codex","skills","embedded-ai-deployment","SKILL.md")
    fullfile(userProfile,".agents","skills","embedded-ai-deployment","SKILL.md")
];
hasAgentSkill = any(isfile(skillLocations));

participantReady = releaseOK && all(productInstalled) && ...
    hasCompressionLibrary && hasDeepLearningCodegen && ...
    hasPyTorchConverter && hasCompiler && hasAgentSkill;

fprintf("MATLAB release: %s\n",releaseName);
fprintf("Release R2026a or newer: %s\n",yesNo(releaseOK));
for idx = 1:numel(requiredProducts)
    fprintf("Product %-45s %s\n",requiredProducts(idx), ...
        yesNo(productInstalled(idx)));
end
fprintf("Add-on %-46s %s\n", ...
    "Model Compression Library",yesNo(hasCompressionLibrary));
fprintf("Add-on %-46s %s\n", ...
    "MATLAB Coder Interface for Deep Learning", ...
    yesNo(hasDeepLearningCodegen));
fprintf("Add-on %-46s %s\n", ...
    "PyTorch Model Converter",yesNo(hasPyTorchConverter));
fprintf("C++ MEX compiler configured: %s\n",yesNo(hasCompiler));
fprintf("embedded-ai-deployment installed: %s\n",yesNo(hasAgentSkill));
fprintf("READY=%s\n",lower(string(participantReady)));

requirements = ["MATLAB release"; requiredProducts; ...
    "Model Compression Library"; ...
    "MATLAB Coder Interface for Deep Learning"; ...
    "PyTorch Model Converter"; "C++ MEX compiler"; ...
    "embedded-ai-deployment skill"];
available = [releaseOK; productInstalled; hasCompressionLibrary; ...
    hasDeepLearningCodegen; hasPyTorchConverter; hasCompiler; hasAgentSkill];
preflight = table(requirements,available, ...
    VariableNames=["Requirement","Available"]);
writetable(preflight,fullfile(resultsFolder,"preflight.csv"));

function value = yesNo(condition)
if condition
    value = "OK";
else
    value = "MISSING";
end
end
