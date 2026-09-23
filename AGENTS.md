# Agentic AI Workshop Instructions

When the user asks to run this workshop:

- Use the `embedded-ai-deployment` skill and Pattern 1.
- Use MATLAB R2026a and create visible MATLAB scripts for every executed step.
- Use the prepared train, validation, and test data. Do not create a new data split.
- Use `Part_1_AI_modeling/models/trainedNetwork.mat` as the baseline LSTM.
- Use `Part_2_AI_import/models/mlp_soc_model.pt2` for the PyTorch import and equivalence exercise. The imported network is a weight source only; reference outputs must come from the original PyTorch model.
- Use 200 deterministic Part 2 equivalence tests: 50 samples from each temperature file.
- Use `Part_3_Code_Gen/models/dlnetFineTuned.mat` as the prepared projected and fine-tuned LSTM. Do not run the long compression sweep or full training.
- The compression objective is smaller flash/model size. Use single-precision floating point for the one-hour path.
- Generate and validate desktop MEX before target code generation.
- Participants stop after host verification and code inspection.
- The instructor may continue to the connected NUCLEO-F767ZI using the same verified compressed LSTM.
- Do not modify the original `Exercise_1.m`, `Exercise_2.m`, or `Exercise_3.m` files.
- Put agent-created scripts under `agentic_ai/generated`, results under `agentic_ai/results`, and generated code under `agentic_ai/build`.
- Derive absolute paths from each script location; never depend on the current working directory.
- Work one phase at a time and pause for approval at every phase boundary.

## MATLAB script authoring

- Create each participant-facing MATLAB workflow step as a plain-text `.m` live script under `agentic_ai/generated`.
- Use MATLAB Live Editor rich-text syntax (`%[text]` and `%%`) so the objective, inputs, actions, evidence, and conclusion are displayed alongside the executable MATLAB code.
- Do not create binary `.mlx` files. The `.m` files must remain readable, reviewable, and version-control friendly on GitHub.
- Every phase live script must include:
  1. Purpose.
  2. Required inputs.
  3. Deployment constraints.
  4. Executable MATLAB code.
  5. Saved evidence and result paths.
  6. Result summary.
  7. Approval gate for the next phase.
- Keep code-generation entry-point functions and reusable helper functions as standard MATLAB `.m` function files. Do not convert these functions into live scripts.
- Save plots, tables, and validation evidence under `agentic_ai/results`. Inline Live Editor outputs may be used for presentation, but the saved result files remain the authoritative evidence.

The participant guide is `Workshop Instruction Embedded AI.pdf`.
