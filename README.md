# Agentic AI Embedded Skill Workshop

This repository contains the participant files for the one-hour Battery State-of-Charge deployment workshop. Participants use the experimental `embedded-ai-deployment` Agent Skill with MATLAB R2026a to evaluate a prepared LSTM, import and verify a PyTorch MLP, compare a projected LSTM, and generate C code. The instructor completes the final demonstration on an STMicroelectronics NUCLEO-F767ZI.

## Start here

1. Read `MATLAB Desktop Setup Instruction - Agentic AI Embedded Skill Workshop.pdf` and install MATLAB R2026a, the required add-ons, and the compiler for your operating system.
2. Read `Workshop Instruction Embedded AI.pdf` and complete its preparation checklist.
3. Clone this repository to a short, writable local path.
4. Open `Aimbdworkshop.prj` in MATLAB R2026a.
5. Run `agentic_ai/scripts/workshopPreflight.m`.
6. Confirm `READY=true`. If only the desktop compiler is unavailable, continue as `READY WITH FALLBACK` and use the instructor-prepared MEX evidence.
7. Open this repository in Codex and begin with the start prompt in the workshop PDF.

For a Thai explanation of every distributed file and folder, read [`REPOSITORY_GUIDE_TH.md`](REPOSITORY_GUIDE_TH.md).

## Codex account for the workshop

- A ChatGPT Free account can be used for the guided exercises; a paid plan is not required to attend.
- Free-plan Codex usage is limited and can vary with the model, task complexity, context, reasoning, and tool use.
- Sign in and run a short Codex test before the event. If a limit is reached during the workshop, pair with another participant and use the verified fallback scripts in `agentic_ai/reference`.
- An OpenAI API key is not required for this workshop.
- See the [official Codex pricing and usage guidance](https://learn.chatgpt.com/docs/pricing) for current plan information.

## Repository contents

- `LGHG2@n10C_to_25degC`: prepared train, validation, and test data used by the workshop.
- `Part_1_AI_modeling`: the original Part 1 source and prepared MATLAB-native LSTM.
- `Part_2_AI_import`: the original Part 2 source, PyTorch model, imported checkpoint, and Simulink integration models.
- `Part_3_Code_Gen`: the original Part 3 source and only the checkpoints and Simulink model used by this event.
- `agentic_ai/scripts`: the participant installation preflight.
- `agentic_ai/reference`: verified Part 1 and Part 2 instructor fallback scripts.
- `agentic_ai/generated`: agents add visible, reproducible MATLAB scripts here.
- `agentic_ai/results` and `agentic_ai/build`: generated locally and excluded from Git.

## Workshop boundaries

- Do not retrain the networks during the one-hour session.
- Do not modify `Exercise_1.m`, `Exercise_2.m`, or `Exercise_3.m`.
- Use the prepared checkpoints and deterministic test selections.
- Participants perform host verification and inspect generated C code.
- Windows participants can use MinGW-w64 or another supported compiler. Apple-silicon macOS participants use Xcode 16 or Xcode 26 for desktop MEX verification.
- Only the instructor machine requires STM32 tools and the NUCLEO-F767ZI.

## Source and license

This workshop includes adapted MathWorks battery State-of-Charge example materials. The applicable copyright notice and license are included in `license`.
