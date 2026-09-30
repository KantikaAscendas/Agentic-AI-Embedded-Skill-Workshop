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
experimentalSkillLocations = [
    fullfile(userProfile,".codex","skills","embedded-ai-deployment","SKILL.md")
    fullfile(userProfile,".agents","skills","embedded-ai-deployment","SKILL.md")
];
officialSkillLocations = [
    fullfile(userProfile,".codex","skills","matlab-deploy-embedded-ai","SKILL.md")
    fullfile(userProfile,".agents","skills","matlab-deploy-embedded-ai","SKILL.md")
];
hasExperimentalSkill = any(isfile(experimentalSkillLocations));
hasOfficialSkill = any(isfile(officialSkillLocations));
hasAgentSkill = hasExperimentalSkill || hasOfficialSkill;

% Prefer the demo-bundled skill because this workshop was validated with it.
% The official MATLAB Agentic Toolkit skill is accepted as a compatible
% alternative and is reported explicitly so the prompt can use its real name.
if hasExperimentalSkill
    activeSkillName = "embedded-ai-deployment";
elseif hasOfficialSkill
    activeSkillName = "matlab-deploy-embedded-ai";
else
    activeSkillName = "NONE";
end

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
fprintf("Demo skill embedded-ai-deployment installed: %s\n", ...
    yesNo(hasExperimentalSkill));
fprintf("Official skill matlab-deploy-embedded-ai installed: %s\n", ...
    yesNo(hasOfficialSkill));
fprintf("Compatible embedded AI deployment skill: %s\n", ...
    yesNo(hasAgentSkill));
fprintf("ACTIVE_SKILL=%s\n",activeSkillName);
fprintf("READY=%s\n",lower(string(participantReady)));

requirements = ["MATLAB release"; requiredProducts; ...
    "Model Compression Library"; ...
    "MATLAB Coder Interface for Deep Learning"; ...
    "PyTorch Model Converter"; "C++ MEX compiler"; ...
    "Demo skill embedded-ai-deployment"; ...
    "Official skill matlab-deploy-embedded-ai"; ...
    "Compatible embedded AI deployment skill"];
available = [releaseOK; productInstalled; hasCompressionLibrary; ...
    hasDeepLearningCodegen; hasPyTorchConverter; hasCompiler; ...
    hasExperimentalSkill; hasOfficialSkill; hasAgentSkill];
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
