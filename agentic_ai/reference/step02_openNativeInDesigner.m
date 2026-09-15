%% Part 2 review gate: open the verified native MLP

clearvars
scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
modelPath = fullfile(repoRoot, "agentic_ai", "results", ...
    "part2_native_mlp.mat");
assert(isfile(modelPath), "Verified Part 2 model was not found: %s", modelPath);

modelData = load(modelPath, "netNative");
netNative = modelData.netNative;
assignin("base", "netNative", netNative);
deepNetworkDesigner(netNative)
disp("PART2_NATIVE_MODEL_OPENED_IN_DEEP_NETWORK_DESIGNER")
