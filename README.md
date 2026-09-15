# Agentic AI Embedded Skill Workshop

This repository contains the participant files for the one-hour Battery State-of-Charge deployment workshop. Participants use the experimental `embedded-ai-deployment` Agent Skill with MATLAB R2026a to evaluate a prepared LSTM, import and verify a PyTorch MLP, compare a projected LSTM, and generate C code. The instructor completes the final demonstration on an STMicroelectronics NUCLEO-F767ZI.

## Start here

1. Read `Workshop Instruction Embedded AI.pdf` and complete its preparation checklist.
2. Clone this repository to a short, writable local path.
3. Open `Aimbdworkshop.prj` in MATLAB R2026a.
4. Run `agentic_ai/scripts/workshopPreflight.m`.
5. Confirm that the participant result is `READY=true`.
6. Open this repository in Codex and begin with the start prompt in the PDF.

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
- Only the instructor machine requires STM32 tools and the NUCLEO-F767ZI.

## Source and license

The battery workshop materials are curated from the TechSource Ascendas MATLAB Day Singapore 2026 workshop. The applicable MathWorks license is included in `license`.
