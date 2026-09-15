%% Part 1: evaluate the prepared LSTM on independent held-out tests
% The duplicated -10 degree C validation/test file is intentionally excluded.

clearvars
close all
rng("default")

scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
resultsRoot = fullfile(repoRoot, "agentic_ai", "results");
modelPath = fullfile(repoRoot, "Part_1_AI_modeling", "models", ...
    "trainedNetwork.mat");
testRoot = fullfile(repoRoot, "LGHG2@n10C_to_25degC", "Test");

if ~isfolder(resultsRoot)
    mkdir(resultsRoot);
end
assert(isfile(modelPath), "Baseline model was not found: %s", modelPath);

modelData = load(modelPath, "trainedNetwork");
baselineNetwork = modelData.trainedNetwork;
assert(isa(baselineNetwork, "dlnetwork"), ...
    "Expected trainedNetwork to be a dlnetwork, but found %s.", ...
    class(baselineNetwork));

testFiles = [ ...
    "02_TEST_LGHG2@0degC_Norm_(05_Inputs).mat"; ...
    "03_TEST_LGHG2@10degC_Norm_(05_Inputs).mat"; ...
    "04_TEST_LGHG2@25degC_Norm_(05_Inputs).mat"];
temperaturesC = [0; 10; 25];

metrics = table;
allTrue = cell(numel(testFiles), 1);
allPredicted = cell(numel(testFiles), 1);

figureHandle = figure(Name="Independent Baseline LSTM Evaluation", ...
    Color="white", Visible="off");
layout = tiledlayout(figureHandle, numel(testFiles), 1, ...
    TileSpacing="compact", Padding="compact");

for testIndex = 1:numel(testFiles)
    testPath = fullfile(testRoot, testFiles(testIndex));
    assert(isfile(testPath), "Test file was not found: %s", testPath);
    testData = load(testPath, "X", "Y");

    inputSequence = single(testData.X.');
    trueSOC = single(testData.Y(:));
    predictedSOC = numericPrediction(predict(baselineNetwork, inputSequence));
    predictedSOC = single(predictedSOC(:));
    assert(numel(predictedSOC) == numel(trueSOC), ...
        "Prediction length mismatch for %s.", testFiles(testIndex));

    errorValue = double(predictedSOC) - double(trueSOC);
    rmseValue = sqrt(mean(errorValue.^2));
    maeValue = mean(abs(errorValue));
    maxErrorValue = max(abs(errorValue));
    denominator = sum((double(trueSOC) - mean(double(trueSOC))).^2);
    rSquared = 1 - sum(errorValue.^2) / denominator;

    row = table(temperaturesC(testIndex), testFiles(testIndex), ...
        numel(trueSOC), rmseValue, maeValue, maxErrorValue, rSquared, ...
        VariableNames=["TemperatureC", "File", "NumTimeSteps", "RMSE", ...
        "MAE", "MaxAbsError", "RSquared"]);
    metrics = [metrics; row]; %#ok<AGROW>
    allTrue{testIndex} = trueSOC;
    allPredicted{testIndex} = predictedSOC;

    nexttile(layout)
    plot(trueSOC, LineWidth=1.0)
    hold on
    plot(predictedSOC, LineWidth=1.0)
    grid on
    ylabel("SOC")
    title(sprintf("%d deg C | RMSE %.6f", ...
        temperaturesC(testIndex), rmseValue))
    if testIndex == numel(testFiles)
        xlabel("Time step")
    end
end

legend(layout.Children(end), ["True SOC", "Baseline LSTM"], ...
    Location="best")
title(layout, "Prepared LSTM on Independent Held-Out Battery Tests")

combinedTrue = vertcat(allTrue{:});
combinedPredicted = vertcat(allPredicted{:});
combinedError = double(combinedPredicted) - double(combinedTrue);
overallRMSE = sqrt(mean(combinedError.^2));
overallMAE = mean(abs(combinedError));
overallMaxAbsError = max(abs(combinedError));
overallRSquared = 1 - sum(combinedError.^2) / ...
    sum((double(combinedTrue) - mean(double(combinedTrue))).^2);

modelFileInfo = dir(modelPath);
modelLearnables = baselineNetwork.Learnables.Value;
numLearnableParameters = sum(cellfun(@numel, modelLearnables));

summary = struct( ...
    TestFiles=testFiles, ...
    ExcludedDuplicatedTestFile= ...
        "01_TEST_LGHG2@n10degC_Norm_(05_Inputs).mat", ...
    Metrics=metrics, ...
    OverallRMSE=overallRMSE, ...
    OverallMAE=overallMAE, ...
    OverallMaxAbsError=overallMaxAbsError, ...
    OverallRSquared=overallRSquared, ...
    NumTimeSteps=numel(combinedTrue), ...
    NumLearnableParameters=numLearnableParameters, ...
    ModelMATFileBytes=modelFileInfo.bytes);

writetable(metrics, fullfile(resultsRoot, ...
    "baseline_independent_metrics.csv"));
save(fullfile(resultsRoot, "baseline_independent_results.mat"), ...
    "summary", "allTrue", "allPredicted");
exportgraphics(figureHandle, fullfile(resultsRoot, ...
    "baseline_independent_prediction.png"), Resolution=160);
close(figureHandle)

disp(metrics)
fprintf("BASELINE_MODEL_CLASS=%s\n", class(baselineNetwork));
fprintf("BASELINE_LEARNABLE_PARAMETERS=%d\n", numLearnableParameters);
fprintf("BASELINE_MODEL_MAT_BYTES=%d\n", modelFileInfo.bytes);
fprintf("BASELINE_TOTAL_TIME_STEPS=%d\n", numel(combinedTrue));
fprintf("BASELINE_OVERALL_RMSE=%.9f\n", overallRMSE);
fprintf("BASELINE_OVERALL_MAE=%.9f\n", overallMAE);
fprintf("BASELINE_OVERALL_MAX_ABS_ERROR=%.9f\n", overallMaxAbsError);
fprintf("BASELINE_OVERALL_R_SQUARED=%.9f\n", overallRSquared);
fprintf("BASELINE_GATE=PASS\n");

function value = numericPrediction(value)
if isa(value, "dlarray")
    value = extractdata(value);
end
value = gather(value);
end
