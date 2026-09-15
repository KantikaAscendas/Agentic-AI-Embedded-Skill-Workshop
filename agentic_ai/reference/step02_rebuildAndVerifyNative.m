%% Part 2: rebuild a MATLAB-native MLP and verify against PyTorch
% The imported network supplies weights only. The reference outputs come
% from the original exported PyTorch program over 200 deterministic tests.

clearvars
rng("default")

scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
resultsRoot = fullfile(repoRoot, "agentic_ai", "results");

importedPath = fullfile(resultsRoot, "part2_imported_network.mat");
inputsPath = fullfile(resultsRoot, "part2_equivalence_inputs.mat");
referencePath = fullfile(resultsRoot, ...
    "part2_pytorch_reference_outputs.csv");
assert(isfile(importedPath), "Imported network artifact is missing.");
assert(isfile(inputsPath), "Equivalence input artifact is missing.");
assert(isfile(referencePath), "PyTorch reference output is missing.");

importedData = load(importedPath, "netImport");
inputData = load(inputsPath, "inputs", "trueSOC", "metadata");
netImport = importedData.netImport;
inputs = single(inputData.inputs);
trueSOC = single(inputData.trueSOC(:));
reference = single(readmatrix(referencePath));
reference = reference(:);

assert(isequal(size(inputs), [200 5]), "Expected 200-by-5 inputs.");
assert(numel(reference) == 200, "Expected 200 PyTorch outputs.");

fc1 = fullyConnectedLayer(128, Name="fc1");
fc1.Weights = importedValue(netImport, "MLP:fc1", "Weights");
fc1.Bias = importedValue(netImport, "MLP:fc1", "Bias");
fc2 = fullyConnectedLayer(64, Name="fc2");
fc2.Weights = importedValue(netImport, "MLP:fc2", "Weights");
fc2.Bias = importedValue(netImport, "MLP:fc2", "Bias");
fc3 = fullyConnectedLayer(1, Name="fc3");
fc3.Weights = importedValue(netImport, "MLP:fc3", "Weights");
fc3.Bias = importedValue(netImport, "MLP:fc3", "Bias");

nativeLayers = [
    featureInputLayer(5, Normalization="none", Name="input")
    fc1
    reluLayer(Name="relu1")
    fc2
    reluLayer(Name="relu2")
    fc3];
netNative = dlnetwork(nativeLayers);

dlX = dlarray(inputs.', "CB");
nativeOutput = single(gather(extractdata(predict(netNative, dlX))));
nativeOutput = nativeOutput(:);
importedOutput = single(gather(extractdata(predict(netImport, dlX))));
importedOutput = importedOutput(:);

nativeError = double(nativeOutput) - double(reference);
importedError = double(importedOutput) - double(reference);
nativeMAE = mean(abs(nativeError));
nativeRMSE = sqrt(mean(nativeError.^2));
nativeMaxAbsError = max(abs(nativeError));
nativeCosineSimilarity = dot(double(nativeOutput), double(reference)) / ...
    (norm(double(nativeOutput)) * norm(double(reference)));
importedMaxAbsError = max(abs(importedError));

socError = double(nativeOutput) - double(trueSOC);
socMAE = mean(abs(socError));
socRMSE = sqrt(mean(socError.^2));
parameterCount = sum(cellfun(@numel, netNative.Learnables.Value));
threshold = 1e-5;
gatePassed = nativeMaxAbsError < threshold;

metrics = table(200, parameterCount, nativeMAE, nativeRMSE, ...
    nativeMaxAbsError, nativeCosineSimilarity, importedMaxAbsError, ...
    socMAE, socRMSE, threshold, gatePassed, ...
    VariableNames=["TestCount", "ParameterCount", "MAEvsPyTorch", ...
    "RMSEvsPyTorch", "MaxAbsErrorVsPyTorch", "CosineSimilarity", ...
    "ImportedMaxAbsErrorVsPyTorch", "MAEvsTrueSOC", "RMSEvsTrueSOC", ...
    "MaxAbsErrorThreshold", "GatePassed"]);

comparison = table((1:200).', double(reference), double(nativeOutput), ...
    nativeError, abs(nativeError), inputData.metadata.TemperatureC, ...
    VariableNames=["TestId", "PyTorchOutput", "MATLABNativeOutput", ...
    "Error", "AbsoluteError", "TemperatureC"]);

writetable(metrics, fullfile(resultsRoot, ...
    "part2_native_equivalence_metrics.csv"));
writetable(comparison, fullfile(resultsRoot, ...
    "part2_native_equivalence_comparison.csv"));
save(fullfile(resultsRoot, "part2_native_mlp.mat"), "netNative", ...
    "metrics", "comparison");

figureHandle = figure(Visible="off", Color="white");
tiledlayout(2, 1, TileSpacing="compact");
nexttile
plot(reference, "LineWidth", 1.2, DisplayName="PyTorch reference")
hold on
plot(nativeOutput, "--", LineWidth=1.0, ...
    DisplayName="MATLAB native")
grid on
ylabel("Estimated SOC")
legend(Location="best")
title("Part 2: 200-test output equivalence")
nexttile
stem(abs(nativeError), Marker="none")
grid on
xlabel("Test ID")
ylabel("Absolute error")
exportgraphics(figureHandle, fullfile(resultsRoot, ...
    "part2_native_equivalence.png"), Resolution=160);
close(figureHandle)

disp(metrics)
fprintf("PART2_TEST_COUNT=%d\n", 200);
fprintf("PART2_NATIVE_PARAMETER_COUNT=%d\n", parameterCount);
fprintf("PART2_NATIVE_MAE_VS_PYTORCH=%.12g\n", nativeMAE);
fprintf("PART2_NATIVE_RMSE_VS_PYTORCH=%.12g\n", nativeRMSE);
fprintf("PART2_NATIVE_MAX_ABS_ERROR_VS_PYTORCH=%.12g\n", ...
    nativeMaxAbsError);
fprintf("PART2_NATIVE_COSINE_SIMILARITY=%.12g\n", ...
    nativeCosineSimilarity);
fprintf("PART2_NATIVE_RMSE_VS_TRUE_SOC=%.12g\n", socRMSE);
assert(gatePassed, ...
    "Native rebuild failed equivalence: max error %.12g >= %.12g.", ...
    nativeMaxAbsError, threshold);
fprintf("PART2_NATIVE_EQUIVALENCE_GATE=PASS\n");

function value = importedValue(net, layerName, parameterName)
row = string(net.Learnables.Layer) == layerName & ...
    string(net.Learnables.Parameter) == parameterName;
assert(nnz(row) == 1, ...
    "Expected exactly one learnable %s/%s.", layerName, parameterName);
value = single(gather(extractdata(net.Learnables.Value{row})));
end
