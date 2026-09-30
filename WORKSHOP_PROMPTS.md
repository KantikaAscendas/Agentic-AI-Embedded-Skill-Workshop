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
Use embedded-ai-deployment. If that skill is unavailable but matlab-deploy-embedded-ai is installed, use matlab-deploy-embedded-ai instead. Perform a read-only workshop preflight only. Do not inspect project data or models and do not modify files. Verify that a compatible embedded AI deployment skill is available, a live MATLAB MCP session is connected, the exact release is MATLAB R2026a, required products and support packages are present, Simulink Agentic Toolkit tools are available, and agentic_ai/scripts/workshopPreflight.m passes. Report the exact ACTIVE_SKILL printed by the script. Detect the host operating system and processor architecture. On macOS, confirm Apple silicon and a selected Xcode 16 or Xcode 26 C and C++ compiler. Report Python separately as managed runtime available, external Python available, or unavailable. Confirm that agentic_ai/generated and agentic_ai/results are writable. If the compiler is missing but the other requirements pass, return READY WITH FALLBACK and state that desktop MEX compilation will use instructor-prepared evidence. Return a concise PASS, WARNING, or FAIL table and finish with READY, READY WITH FALLBACK, or NOT READY. Stop and wait for approval.
```

Continue when the result is `READY` or `READY WITH FALLBACK`. Ask the instructor for help if the result is `NOT READY`.

## Phase 1 Project discovery

```text
Use the ACTIVE_SKILL reported by agentic_ai/scripts/workshopPreflight.m: embedded-ai-deployment for the validated demo package, or matlab-deploy-embedded-ai when only the official MATLAB Agentic Toolkit skill is installed. Work with this battery State-of-Charge repository in the connected MATLAB R2026a session. Preserve Exercise_1.m, Exercise_2.m, and Exercise_3.m. Create executable .m scripts under agentic_ai/generated and results under agentic_ai/results; also maintain a participant-facing Live Script summary when supported. Work one phase at a time, explain the evidence, and pause for approval. The participant workflow ends after host verification and C-code inspection. Begin with project discovery and a concise project summary only.
```

Review the project summary, then continue with the Phase 2 prompt.

## Phase 2 Baseline MATLAB LSTM

```text
Proceed with the prepared data split and baseline MATLAB-native LSTM evaluation. Do not retrain. Use the existing checkpoint and a representative subset of held-out test data. Report the test count and RMSE, save a prediction plot, then pause.
```

Check the reported sample count, RMSE, and prediction plot, then continue with the Phase 3 prompt.

## Phase 3 PyTorch import and equivalence

```text
Proceed with Part 2 using Part_2_AI_import/models/mlp_soc_model.pt2. Import it with the modern MATLAB R2026a workflow and rebuild it as a MATLAB-native dlnetwork suitable for the Cortex-M deployment pattern. Do not create or configure an external Python environment. Use the prepared inputs and agentic_ai/reference_data/part2_pytorch_reference_outputs.csv as the original PyTorch reference, and keep the prepared sample order unchanged. Before equivalence testing, propose 20 representative cases, using five evenly spaced samples from each of the four temperature groups, and wait for approval. After approval, report MAE, RMSE, maximum absolute error, and cosine similarity. Open the native network in Deep Network Designer, run the existing Simulink integration model, save the comparison evidence, then pause. Do not treat this MLP as the final embedded model.
```

After the agent proposes the test set, send:

```text
Approved. Proceed with the 20-case equivalence test and Simulink integration.
```

Confirm that the imported MATLAB network agrees with the PyTorch reference. In the validated reference run, the 20 cases produced MAE `6.26e-8`, RMSE `1.05e-7`, maximum absolute error `2.38e-7`, and cosine similarity `1.0`; small last-digit differences are acceptable. Then continue with the Phase 4 prompt if a separate Simulink review is needed.

## Phase 4 MATLAB and Simulink comparison

```text
Proceed with the prepared MATLAB-native AI Simulink model. Use the same single-precision inputs for MATLAB prediction and Simulink Normal Simulation. Report input size, datatype, sample time, RMSE, and maximum absolute error. If a direct PyTorch Simulink block fails size or datatype propagation, record an optional-path warning and continue with the MATLAB-native Simulink model without modifying the original exercise files. Save the comparison evidence, then pause.
```

Review the MATLAB and Simulink output agreement, then continue with the Phase 5 prompt.

## Phase 5 Live projection and prepared fine-tuned comparison

```text
Proceed with Part 3 using the embedded AI Pattern 1 workflow. The workshop compression decision is approved: the target is an ARM Cortex-M7 with Simulink, the primary goal is smaller flash and model size, single-precision floating point is acceptable, and no live retraining will be performed.

Create and execute a visible MATLAB script under agentic_ai/generated. Load the baseline LSTM from Part_1_AI_modeling/models/trainedNetwork.mat. Use the same representative training/calibration selection defined in Part_3_Code_Gen/Exercise_3.m to calculate neuron PCA. Call compressNetworkUsingProjection once with LearnablesReductionGoal=0.95 to create one live projected candidate. Check the installed MATLAB R2026a help for the exact function signature before calling it. Do not run a compression sweep, do not call trainnet, do not modify the original exercise files, and do not overwrite Part_3_Code_Gen/models/dlnetFineTuned.mat.

Evaluate three networks: the baseline LSTM, the newly projected candidate before fine-tuning, and the prepared projected and fine-tuned checkpoint from Part_3_Code_Gen/models/dlnetFineTuned.mat. Run all three on exactly the same independent held-out test sequences used in Part 1, with the same sample order, sample count, and single-precision inputs. Report learnables, estimated parameter bytes, actual memory reduction, RMSE, MAE, maximum absolute error, and each error delta from the baseline. Save the live projected candidate, metrics table, and comparison plots under agentic_ai/results.

Explain explicitly that the projected candidate was compressed live by the Agent, while the prepared checkpoint is loaded only to demonstrate the accuracy recovery obtained previously through fine-tuning. Verify that the live projected candidate and prepared checkpoint have compatible projected architecture and learnable counts before describing them as before- and after-fine-tuning versions. If they differ, report the difference and treat them as separate compressed candidates.

After presenting the accuracy-memory trade-off, pause for approval before desktop MEX generation. Do not proceed to C code in this step.
```

After reviewing and approving the accuracy-memory evidence, continue with the instructor-led desktop MEX and library-free C prompts. The participant workflow is complete after reviewing the model comparison, MEX evidence, generated C source, and code-generation report.

## Setup recovery prompts

### Check the MATLAB connection and installed tools

```text
Perform a read-only connection check. Confirm that MATLAB R2026a is connected through MCP, list the required installed products and add-ons, confirm that Simulink Agentic Toolkit tools are available, and confirm that either embedded-ai-deployment or matlab-deploy-embedded-ai is installed. Report the exact ACTIVE_SKILL. Do not modify any files. Finish with READY, READY WITH FALLBACK, or NOT READY.
```

### Resume from existing workshop evidence

```text
Use the ACTIVE_SKILL reported by workshopPreflight.m. Inspect the existing scripts under agentic_ai/generated and evidence under agentic_ai/results. Summarize which workshop phases are complete and which phase should run next. Do not repeat completed phases and do not modify the original Exercise_1.m, Exercise_2.m, or Exercise_3.m files. Stop and wait for approval.
```

## Workshop boundaries

- Do not modify `Exercise_1.m`, `Exercise_2.m`, or `Exercise_3.m`.
- Do not create or configure an external Python environment during the one-hour workshop. Part 2 uses the prepared 200-row PyTorch reference CSV paired with the prepared inputs.
- Run exactly one live projection candidate; do not run full retraining or a compression sweep.
- Use the prepared checkpoints and deterministic test selections.
- Participants stop after host verification and C-code inspection.
- STM32 NUCLEO-F767ZI deployment and PIL execution are instructor demonstrations.
