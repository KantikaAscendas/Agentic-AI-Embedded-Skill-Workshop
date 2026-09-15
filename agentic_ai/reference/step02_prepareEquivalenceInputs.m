%% Part 2: prepare 200 deterministic equivalence inputs
% Fifty evenly spaced observations are selected from each temperature file.

clearvars
rng("default")

scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
testRoot = fullfile(repoRoot, "LGHG2@n10C_to_25degC", "Test");
resultsRoot = fullfile(repoRoot, "agentic_ai", "results");
if ~isfolder(resultsRoot)
    mkdir(resultsRoot);
end

testFiles = [ ...
    "01_TEST_LGHG2@n10degC_Norm_(05_Inputs).mat"; ...
    "02_TEST_LGHG2@0degC_Norm_(05_Inputs).mat"; ...
    "03_TEST_LGHG2@10degC_Norm_(05_Inputs).mat"; ...
    "04_TEST_LGHG2@25degC_Norm_(05_Inputs).mat"];
temperaturesC = [-10; 0; 10; 25];
testsPerTemperature = 50;

inputs = zeros(numel(testFiles) * testsPerTemperature, 5, "single");
trueSOC = zeros(numel(testFiles) * testsPerTemperature, 1, "single");
temperature = zeros(numel(testFiles) * testsPerTemperature, 1);
sourceIndex = zeros(numel(testFiles) * testsPerTemperature, 1);
sourceFile = strings(numel(testFiles) * testsPerTemperature, 1);

outputRow = 1;
for fileIndex = 1:numel(testFiles)
    testPath = fullfile(testRoot, testFiles(fileIndex));
    testData = load(testPath, "X", "Y");
    selectedIndices = unique(round(linspace(1, size(testData.X, 2), ...
        testsPerTemperature)), "stable");
    assert(numel(selectedIndices) == testsPerTemperature, ...
        "Expected %d unique samples in %s.", ...
        testsPerTemperature, testFiles(fileIndex));

    rows = outputRow:(outputRow + testsPerTemperature - 1);
    inputs(rows, :) = single(testData.X(:, selectedIndices).');
    trueSOC(rows) = single(testData.Y(selectedIndices));
    temperature(rows) = temperaturesC(fileIndex);
    sourceIndex(rows) = selectedIndices(:);
    sourceFile(rows) = testFiles(fileIndex);
    outputRow = outputRow + testsPerTemperature;
end

assert(size(inputs, 1) == 200 && size(inputs, 2) == 5, ...
    "Expected a 200-by-5 input matrix.");
assert(all(isfinite(inputs), "all") && all(isfinite(trueSOC)), ...
    "Equivalence inputs contain nonfinite values.");

metadata = table((1:size(inputs, 1)).', temperature, sourceFile, ...
    sourceIndex, trueSOC, VariableNames=["TestId", "TemperatureC", ...
    "SourceFile", "SourceIndex", "TrueSOC"]);

writematrix(inputs, fullfile(resultsRoot, "part2_equivalence_inputs.csv"));
writematrix(trueSOC, fullfile(resultsRoot, "part2_equivalence_true_soc.csv"));
writetable(metadata, fullfile(resultsRoot, "part2_equivalence_metadata.csv"));
save(fullfile(resultsRoot, "part2_equivalence_inputs.mat"), ...
    "inputs", "trueSOC", "metadata");

fprintf("PART2_INPUT_TESTS=%d\n", size(inputs, 1));
fprintf("PART2_INPUT_FEATURES=%d\n", size(inputs, 2));
fprintf("PART2_TESTS_PER_TEMPERATURE=%d\n", testsPerTemperature);
fprintf("PART2_INPUT_PREPARATION_GATE=PASS\n");
