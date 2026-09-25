# Workshop Prompts

Use this page to copy prompts during the Agentic AI Embedded Skill Workshop. Run the prompts in order and wait for the agent to finish each phase before continuing.

## Before sending the first prompt

1. Open `Aimbdworkshop.prj` in MATLAB R2026a.
2. Initialize the Simulink Agentic Toolkit in the current MATLAB session.

```matlab
if ispc
    homeFolder = getenv("USERPROFILE");
else
    homeFolder = getenv("HOME");
end
addpath(fullfile(homeFolder, ".matlab", "agentic-toolkits", "simulink"))
satk_initialize
```

3. Open this repository in Codex.
4. Send the preflight prompt below.

## Phase 0 Environment preflight

```text
Use embedded-ai-deployment. Perform a read-only workshop preflight only. Do not inspect project data or models and do not modify files. Verify that the skill is available, a live MATLAB MCP session is connected, the exact release is MATLAB R2026a, required products and support packages are present, Simulink Agentic Toolkit tools are available, and agentic_ai/scripts/workshopPreflight.m passes. Detect the host operating system and processor architecture. On macOS, confirm Apple silicon and a selected Xcode 16 or Xcode 26 C and C++ compiler. Report Python separately as managed runtime available, external Python available, or unavailable. Confirm that agentic_ai/generated and agentic_ai/results are writable. If the compiler is missing but the other requirements pass, return READY WITH FALLBACK and state that desktop MEX compilation will use instructor-prepared evidence. Return a concise PASS, WARNING, or FAIL table and finish with READY, READY WITH FALLBACK, or NOT READY. Stop and wait for approval.
```

Continue when the result is `READY` or `READY WITH FALLBACK`. Ask the instructor for help if the result is `NOT READY`.

## Phase 1 Project discovery

```text
Use embedded-ai-deployment. Work with this battery State-of-Charge repository in the connected MATLAB R2026a session. Preserve Exercise_1.m, Exercise_2.m, and Exercise_3.m. Create executable .m scripts under agentic_ai/generated and results under agentic_ai/results; also maintain a participant-facing Live Script summary when supported. Work one phase at a time, explain the evidence, and pause for approval. The participant workflow ends after host verification and C-code inspection. Begin with project discovery and a concise project summary only.
```

Review the project summary, then continue with the Phase 2 prompt.

## Phase 2 Baseline MATLAB LSTM

```text
Proceed with the prepared data split and baseline MATLAB-native LSTM evaluation. Do not retrain. Use the existing checkpoint and a representative subset of held-out test data. Report the test count and RMSE, save a prediction plot, then pause.
```

Check the reported sample count, RMSE, and prediction plot, then continue with the Phase 3 prompt.

## Phase 3 PyTorch import and equivalence

```text
Proceed with Part 2 using Part_2_AI_import/models/mlp_soc_model.pt2. Import it with the modern R2026a workflow and rebuild it as a MATLAB-native dlnetwork. Use the MATLAB-managed PyTorch runtime to generate original reference outputs when available. If Python or PyTorch is unavailable, do not install packages; use the prepared PyTorch reference inputs and outputs in the repository. Run the approved equivalence tests, report MAE, RMSE, and maximum absolute error, open the native network in Deep Network Designer, then pause. Do not treat this MLP as the final embedded model.
```

Confirm that the imported MATLAB network agrees with the PyTorch reference, then continue with the Phase 4 prompt.

## Phase 4 MATLAB and Simulink comparison

```text
Proceed with the prepared MATLAB-native AI Simulink model. Use the same single-precision inputs for MATLAB prediction and Simulink Normal Simulation. Report input size, datatype, sample time, RMSE, and maximum absolute error. If a direct PyTorch Simulink block fails size or datatype propagation, record an optional-path warning and continue with the MATLAB-native Simulink model without modifying the original exercise files. Save the comparison evidence, then pause.
```

Review the MATLAB and Simulink output agreement, then continue with the Phase 5 prompt.

## Phase 5 Compression and C code generation

```text
Proceed with Part 3. The primary goal is minimum flash and model size for a Cortex-M deployment pattern. Single-precision floating point is acceptable. Use the prepared projected and fine-tuned LSTM checkpoint rather than running the long compression sweep or full training. Compare it with the baseline on the same samples and report learnables, estimated parameter bytes, RMSE, and RMSE delta. If a supported host compiler is configured, generate and validate a desktop MEX implementation before generating library-free C code and opening the code-generation report. If no compiler is configured, report a warning, use the instructor-prepared MEX evidence, and continue with C-source and report inspection without claiming a full local MEX pass. Then pause.
```

The participant workflow is complete after reviewing the model comparison, MEX evidence, generated C source, and code-generation report.

## Setup recovery prompts

### Check the MATLAB connection and installed tools

```text
Perform a read-only connection check. Confirm that MATLAB R2026a is connected through MCP, list the required installed products and add-ons, confirm that Simulink Agentic Toolkit tools are available, and confirm that embedded-ai-deployment is installed. Do not modify any files. Finish with READY, READY WITH FALLBACK, or NOT READY.
```

### Resume from existing workshop evidence

```text
Use embedded-ai-deployment. Inspect the existing scripts under agentic_ai/generated and evidence under agentic_ai/results. Summarize which workshop phases are complete and which phase should run next. Do not repeat completed phases and do not modify the original Exercise_1.m, Exercise_2.m, or Exercise_3.m files. Stop and wait for approval.
```

## Workshop boundaries

- Do not modify `Exercise_1.m`, `Exercise_2.m`, or `Exercise_3.m`.
- Do not install Python packages during the one-hour workshop.
- Do not run full retraining or a long compression sweep.
- Use the prepared checkpoints and deterministic test selections.
- Participants stop after host verification and C-code inspection.
- STM32 NUCLEO-F767ZI deployment and PIL execution are instructor demonstrations.
