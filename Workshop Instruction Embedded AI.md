# Battery State of Charge Agentic AI Workshop

## Participant Preparation and Hands On Guide

This guide prepares you for a one-hour MATLAB R2026a workshop on a supported Windows computer or Apple-silicon Mac. The workflow begins with a read-only environment preflight, uses prepared PyTorch reference data when Python is unavailable, validates a MATLAB-native network in Simulink, and ends with host MEX verification and generated C-code inspection. Participants without a configured compiler can complete the modeling workflow using the prepared MEX evidence.

For a shorter page containing only the prompts, see [`WORKSHOP_PROMPTS.md`](WORKSHOP_PROMPTS.md).

## Workshop outcome

By the end of the workshop, you will:

- Verify MATLAB, MCP connectivity, required products, and the embedded AI skill.
- Evaluate a prepared MATLAB-native LSTM State-of-Charge estimator.
- Import the PyTorch MLP as a MATLAB-native `dlnetwork` and validate it against original or prepared PyTorch reference outputs.
- Compare the baseline LSTM with the projected and fine-tuned LSTM checkpoint.
- Compare MATLAB, Simulink Normal Simulation, desktop MEX, and generated C-code evidence in gated phases.

## Model path through the workshop

| Part | Participant activity | Model used | Result |
|---|---|---|---|
| 1 | Evaluate the prepared MATLAB model | MATLAB-native LSTM | Baseline SOC accuracy |
| 2 | Import and verify a PyTorch model | PyTorch MLP rebuilt as `dlnetwork` | Framework equivalence |
| 3 | Validate system integration | MATLAB-native AI Simulink model | MATLAB versus Simulink evidence |
| 4 | Compare compression and generate code | Projected and fine-tuned LSTM | MEX and C-code evidence |

## Complete before the event

Complete this checklist before arriving. Installation during the workshop is a recovery option and may be blocked by company policy.

- [ ] Bring a supported Windows laptop or Apple-silicon Mac and its charger. MATLAB R2026a is not available for Intel-based Macs.
- [ ] Confirm internet access to GitHub, MathWorks, and ChatGPT resources. Windows participants may also need Microsoft Store access; macOS participants may need Apple App Store access for Xcode.
- [ ] Confirm that you can sign in to MATLAB and the ChatGPT desktop app or Codex CLI. A ChatGPT Free account can be used, subject to its available usage allowance.
- [ ] Obtain IT approval for local software, PowerShell or Terminal commands, Git, MATLAB Add-Ons, and a supported C/C++ compiler.
- [ ] Install MATLAB R2026a and the required products below.
- [ ] Install the ChatGPT desktop app with Codex, or prepare the Codex CLI fallback.
- [ ] Download or clone the workshop repository. You can also do this with the instructor during the workshop.
- [ ] Open `Aimbdworkshop.prj` once before the event. You can also do this with the instructor during the workshop.

## Required MATLAB products

| Type | Required item | Used for |
|---|---|---|
| Release | MATLAB R2026a | Agent Skill workflow |
| Product | Simulink | System integration |
| Product | Deep Learning Toolbox | LSTM and imported network |
| Product | Statistics and Machine Learning Toolbox | Project workflow dependency |
| Product | MATLAB Coder | Host MEX and C code |
| Product | Simulink Coder | Simulink code generation |
| Product | Embedded Coder | Embedded C code and reports |
| Product | Fixed-Point Designer | Embedded numeric workflows |
| Add-On | Deep Learning Toolbox Model Compression Library | Network projection |
| Add-On | MATLAB Coder Interface for Deep Learning | Code generation from `dlnetwork` |
| Add-On | Deep Learning Toolbox Converter for PyTorch Models | Part 2 model import |
| Compiler | Windows: MinGW-w64 or supported Microsoft compiler | Desktop MEX verification |
| Compiler | macOS: Xcode 16 or Xcode 26 | Desktop MEX verification |

For detailed installation steps, read [`MATLAB Desktop Setup Instruction - Agentic AI Embedded Skill Workshop.pdf`](MATLAB%20Desktop%20Setup%20Instruction%20-%20Agentic%20AI%20Embedded%20Skill%20Workshop.pdf).

## Python and PyTorch

External Python and PyTorch are optional. The Deep Learning Toolbox Converter for PyTorch Models add-on is required for Part 2 import. If the MATLAB-managed PyTorch runtime is unavailable, use the prepared PyTorch reference inputs and outputs supplied with the workshop instead of installing Python packages during the session.

## Install ChatGPT or Codex

### ChatGPT Desktop App for Windows and macOS

Install the ChatGPT desktop app for your operating system from [chatgpt.com/download](https://chatgpt.com/download). Windows participants may use the Microsoft Store or the following Windows Package Manager command when company policy permits it.

```powershell
winget install --id 9PLM9XGG6VKS -s msstore
```

### ChatGPT account and Codex usage

A ChatGPT Free account can be used for the guided exercises, and a paid plan is not required to attend. Codex usage varies with model choice, task complexity, context length, reasoning, and tool calls. A long end-to-end task can use more allowance than several short gated tasks.

Before the event, sign in and run one short Codex test. Check the usage indicator in Codex or use `/status` in Codex CLI when available. If a limit is reached, continue with the instructor-prepared scripts and results. Do not share account credentials. An OpenAI API key is not required for this workshop.

Exact token totals are not a workshop requirement and may not be shown for a ChatGPT-plan Codex session. The workshop uses short phase prompts, approval gates, and prepared fallback evidence.

### Codex CLI fallback on Windows

The PowerShell installer below is a Windows fallback. On macOS, use the ChatGPT desktop app for this workshop unless your IT team has approved a separate Codex CLI installation.

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://chatgpt.com/codex/install.ps1 | iex"
```

Start Codex from a new PowerShell window:

```powershell
codex
```

At first launch, select **Sign in with ChatGPT** and complete authentication. `ExecutionPolicy Bypass` applies only to that PowerShell process and does not override company security controls.

## Download the lab files

Clone the repository before the event when possible.

```shell
git clone https://github.com/KantikaAscendas/Agentic-AI-Embedded-Skill-Workshop.git
cd Agentic-AI-Embedded-Skill-Workshop
```

If Git is unavailable, select **Code > Download ZIP** on GitHub. Extract the ZIP to a short, writable local path and do not work directly inside the ZIP file.

Suggested locations:

- Windows: `C:\Workshop\Agentic-AI-Embedded-Skill-Workshop`
- macOS: `~/Workshop/Agentic-AI-Embedded-Skill-Workshop`

Avoid network drives and cloud-synchronised folders such as OneDrive or iCloud Drive because code generation creates many files.

## Install the MATLAB Agentic Toolkit

1. Open the [MATLAB Agentic Toolkit repository](https://github.com/matlab/matlab-agentic-toolkit) and download `agenticToolkitInstaller.mltbx`.
2. Open the downloaded MLTBX file with MATLAB and approve the add-on installation.
3. Run this command in MATLAB:

```matlab
setupAgenticToolkit("install")
```

4. Select the groups needed for this workshop: MATLAB Core, AI and Statistics, and Code Generation. Include the Simulink Agentic Toolkit because the workshop uses Simulink models.
5. For every new MATLAB session, initialize the Simulink Agentic Toolkit:

```matlab
if ispc
    homeFolder = getenv("USERPROFILE");
else
    homeFolder = getenv("HOME");
end
addpath(fullfile(homeFolder, ".matlab", "agentic-toolkits", "simulink"))
satk_initialize
```

The `satk_initialize` command adds the Simulink tools, validates the installation, and shares the current MATLAB session with the MCP server. You do not need to run `shareMATLABSession` separately after successful initialization.

## Install the embedded AI skill

Open Codex in the workshop repository and send this prompt. Review and approve the requested installation. Start a new Codex task after installation so the skill becomes available.

```text
Install the embedded-ai-deployment skill from https://github.com/matlab/agent-skills-playground/tree/main/skills/embedded-ai-deployment
```

## Verify the setup

1. Open MATLAB R2026a and `Aimbdworkshop.prj`.
2. Run the operating-system-neutral `addpath` and `satk_initialize` commands shown above.
3. Run the preflight script:

```matlab
run("agentic_ai/scripts/workshopPreflight.m")
```

4. Open Codex in the workshop repository and send the read-only preflight prompt:

```text
Use embedded-ai-deployment. Perform a read-only workshop preflight only. Do not inspect project data or models and do not modify files. Verify that the skill is available, a live MATLAB MCP session is connected, the exact release is MATLAB R2026a, required products and support packages are present, Simulink Agentic Toolkit tools are available, and agentic_ai/scripts/workshopPreflight.m passes. Detect the host operating system and processor architecture. On macOS, confirm Apple silicon and a selected Xcode 16 or Xcode 26 C and C++ compiler. Report Python separately as managed runtime available, external Python available, or unavailable. Confirm that agentic_ai/generated and agentic_ai/results are writable. If the compiler is missing but the other requirements pass, return READY WITH FALLBACK and state that desktop MEX compilation will use instructor-prepared evidence. Return a concise PASS, WARNING, or FAIL table and finish with READY, READY WITH FALLBACK, or NOT READY. Stop and wait for approval.
```

Continue when the result is `READY` or `READY WITH FALLBACK`. Ask the instructor for help if it reports `NOT READY`.

## Workshop workflow

| Time | Activity | Participant evidence |
|---|---|---|
| 0 to 8 minutes | Initialize MATLAB and run the read-only preflight | Readiness table |
| 8 to 18 minutes | Part 1 baseline LSTM evaluation | SOC prediction and RMSE |
| 18 to 32 minutes | Part 2 PyTorch MLP import and equivalence | Native `dlnetwork` and reference comparison |
| 32 to 42 minutes | MATLAB versus Simulink comparison | Normal Simulation equivalence |
| 42 to 55 minutes | Part 3 compression and host code verification | Size, RMSE delta, MEX result, and C report |
| 55 to 60 minutes | Review and questions | Evidence summary and next steps |

### Start prompt

```text
Use embedded-ai-deployment. Work with this battery State-of-Charge repository in the connected MATLAB R2026a session. Preserve Exercise_1.m, Exercise_2.m, and Exercise_3.m. Create executable .m scripts under agentic_ai/generated and results under agentic_ai/results; also maintain a participant-facing Live Script summary when supported. Work one phase at a time, explain the evidence, and pause for approval. The participant workflow ends after host verification and C-code inspection. Begin with project discovery and a concise project summary only.
```

### Part 1 prompt

```text
Proceed with the prepared data split and baseline MATLAB-native LSTM evaluation. Do not retrain. Use the existing checkpoint and a representative subset of held-out test data. Report the test count and RMSE, save a prediction plot, then pause.
```

### Part 2 prompt

```text
Proceed with Part 2 using Part_2_AI_import/models/mlp_soc_model.pt2. Import it with the modern R2026a workflow and rebuild it as a MATLAB-native dlnetwork. Use the MATLAB-managed PyTorch runtime to generate original reference outputs when available. If Python or PyTorch is unavailable, do not install packages; use the prepared PyTorch reference inputs and outputs in the repository. Run the approved equivalence tests, report MAE, RMSE, and maximum absolute error, open the native network in Deep Network Designer, then pause. Do not treat this MLP as the final embedded model.
```

### Why Simulink comparison

Simulink validates system-level integration before code generation, including signal dimensions, single-precision datatypes, sample time, and output agreement. The required comparison uses the prepared MATLAB-native network. A masked direct-PyTorch Predict or S-function block is optional because R2026a size or datatype propagation can fail even when the imported network is numerically correct.

### Simulink comparison prompt

```text
Proceed with the prepared MATLAB-native AI Simulink model. Use the same single-precision inputs for MATLAB prediction and Simulink Normal Simulation. Report input size, datatype, sample time, RMSE, and maximum absolute error. If a direct PyTorch Simulink block fails size or datatype propagation, record an optional-path warning and continue with the MATLAB-native Simulink model without modifying the original exercise files. Save the comparison evidence, then pause.
```

### Part 3 prompt

```text
Proceed with Part 3. The primary goal is minimum flash and model size for a Cortex-M deployment pattern. Single-precision floating point is acceptable. Use the prepared projected and fine-tuned LSTM checkpoint rather than running the long compression sweep or full training. Compare it with the baseline on the same samples and report learnables, estimated parameter bytes, RMSE, and RMSE delta. If a supported host compiler is configured, generate and validate a desktop MEX implementation before generating library-free C code and opening the code-generation report. If no compiler is configured, report a warning, use the instructor-prepared MEX evidence, and continue with C-source and report inspection without claiming a full local MEX pass. Then pause.
```

The participant workflow ends after host verification and C-code inspection. STM32 NUCLEO-F767ZI deployment and PIL execution are instructor demonstrations.

## Troubleshooting

| Issue | Action |
|---|---|
| Company policy blocks installation | Do not bypass policy. Pair with a prepared participant or follow the instructor. |
| Codex cannot see MATLAB | Run the operating-system-neutral `addpath` command and `satk_initialize` in the MATLAB session you want Codex to use. |
| Skill is not available | Start a new Codex task after installation and explicitly say `Use embedded-ai-deployment`. |
| Preflight reports a missing item | Install the named MATLAB product or add-on before continuing. |
| MEX compiler is missing | Windows: configure MinGW-w64 or a supported Microsoft compiler. macOS: install Xcode 16 or 26, accept its license, then run `mex -setup C` and `mex -setup C++`. Continue as `READY WITH FALLBACK` if installation is blocked. |
| Build takes too long | Use the prepared checkpoint and instructor-generated artifacts. Do not retrain. |
| OneDrive, iCloud, or antivirus slows builds | Use a short local writable project path for the workshop copy. |
| Python or PyTorch is unavailable | Use the prepared Part 2 PyTorch reference data. Do not install Python packages during the workshop. |
| Direct PyTorch Simulink block fails | Record an optional-path warning and continue with the prepared MATLAB-native Simulink model. |
| Codex usage limit is reached | Continue with the generated scripts, prepared results, and instructor demonstration. Do not share credentials. |

## Reference links

- [Workshop repository](https://github.com/KantikaAscendas/Agentic-AI-Embedded-Skill-Workshop)
- [MATLAB Agentic Toolkit](https://github.com/matlab/matlab-agentic-toolkit)
- [Agent Skills Playground](https://github.com/matlab/agent-skills-playground)
- [Codex CLI guide](https://developers.openai.com/codex/cli)
- [ChatGPT desktop app](https://chatgpt.com/download)
- [Official Codex pricing and usage guidance](https://learn.chatgpt.com/docs/pricing)
- [MATLAB R2026a macOS system requirements](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2026a-macintosh.pdf)
- [MATLAB R2026a supported compilers](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2026a-supported-compilers.pdf)
