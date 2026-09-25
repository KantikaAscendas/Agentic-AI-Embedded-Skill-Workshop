# Part 2 Prepared PyTorch Reference

This folder supports the workshop when a participant does not have a usable
Python and PyTorch runtime. The files were generated from the original
`Part_2_AI_import/models/mlp_soc_model.pt2` model and 200 deterministic test
inputs: 50 observations from each of the -10, 0, 10, and 25 degree Celsius
test files.

Files:

- `part2_equivalence_inputs.mat` contains the 200-by-5 single-precision input
  matrix, true State-of-Charge values, and source metadata.
- `part2_pytorch_reference_outputs.csv` contains one original PyTorch output
  for each input row.
- `part2_pytorch_reference_report.json` records the PyTorch version, shapes,
  test count, and accuracy summary used when the reference was generated.

Run `agentic_ai/reference/step02_stagePreparedPyTorchReference.m` to copy the
prepared files into `agentic_ai/results` before running the native MATLAB
equivalence script.

The prepared reference is a workshop fallback. If the MATLAB-managed PyTorch
runtime is available, participants may regenerate the reference from the
original `.pt2` model instead.
