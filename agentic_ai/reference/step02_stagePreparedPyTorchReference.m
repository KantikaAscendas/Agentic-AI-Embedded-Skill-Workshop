%% Part 2: stage the prepared PyTorch equivalence reference
% Use this fallback when a MATLAB-managed or external PyTorch runtime is not
% available. The reference outputs were generated from the original
% mlp_soc_model.pt2 model over 200 deterministic inputs.

clearvars

scriptPath = mfilename("fullpath");
repoRoot = fileparts(fileparts(fileparts(scriptPath)));
referenceRoot = fullfile(repoRoot, "agentic_ai", "reference_data");
resultsRoot = fullfile(repoRoot, "agentic_ai", "results");

if ~isfolder(resultsRoot)
    mkdir(resultsRoot);
end

filesToStage = [ ...
    "part2_equivalence_inputs.mat"; ...
    "part2_pytorch_reference_outputs.csv"; ...
    "part2_pytorch_reference_report.json"];

for fileIndex = 1:numel(filesToStage)
    sourcePath = fullfile(referenceRoot, filesToStage(fileIndex));
    destinationPath = fullfile(resultsRoot, filesToStage(fileIndex));
    assert(isfile(sourcePath), "Prepared reference file is missing: %s", ...
        sourcePath);
    copyfile(sourcePath, destinationPath, "f");
end

inputData = load(fullfile(resultsRoot, ...
    "part2_equivalence_inputs.mat"), "inputs", "trueSOC", "metadata");
reference = readmatrix(fullfile(resultsRoot, ...
    "part2_pytorch_reference_outputs.csv"));

assert(isequal(size(inputData.inputs), [200 5]), ...
    "Expected prepared inputs with size 200-by-5.");
assert(numel(reference) == 200, ...
    "Expected 200 prepared PyTorch reference outputs.");
assert(all(isfinite(inputData.inputs), "all") && ...
    all(isfinite(reference)), ...
    "Prepared reference data contains nonfinite values.");

fprintf("PART2_PREPARED_REFERENCE_TESTS=%d\n", numel(reference));
fprintf("PART2_PREPARED_REFERENCE_GATE=PASS\n");
