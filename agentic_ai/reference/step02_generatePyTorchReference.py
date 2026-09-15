"""Generate reference outputs from the original exported PyTorch model."""

from __future__ import annotations

import json
import sys
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve()
REPO_ROOT = SCRIPT_PATH.parents[2]
RESULTS_ROOT = REPO_ROOT / "agentic_ai" / "results"
MODEL_PATH = REPO_ROOT / "Part_2_AI_import" / "models" / "mlp_soc_model.pt2"
MATLAB_TORCH_ROOT = Path(
    r"C:\ProgramData\MATLAB\SupportPackages\R2026a\3P.instrset"
    r"\pytorchconverter.instrset\win64"
)
if MATLAB_TORCH_ROOT.is_dir():
    sys.path.insert(0, str(MATLAB_TORCH_ROOT))

import numpy as np  # noqa: E402
import torch  # noqa: E402


def main() -> None:
    input_path = RESULTS_ROOT / "part2_equivalence_inputs.csv"
    truth_path = RESULTS_ROOT / "part2_equivalence_true_soc.csv"
    if not input_path.is_file():
        raise FileNotFoundError(f"Equivalence inputs not found: {input_path}")

    inputs = np.loadtxt(input_path, delimiter=",", dtype=np.float32)
    true_soc = np.loadtxt(truth_path, delimiter=",", dtype=np.float32).reshape(-1)
    if inputs.shape != (200, 5):
        raise ValueError(f"Expected inputs with shape (200, 5), got {inputs.shape}")

    exported_program = torch.export.load(str(MODEL_PATH))
    model = exported_program.module()
    outputs = np.empty((inputs.shape[0],), dtype=np.float32)

    with torch.no_grad():
        for index, row in enumerate(inputs):
            prediction = model(torch.from_numpy(row.copy()))
            outputs[index] = prediction.detach().cpu().reshape(-1)[0].item()

    rmse = float(np.sqrt(np.mean((outputs.astype(np.float64) - true_soc) ** 2)))
    mae = float(np.mean(np.abs(outputs.astype(np.float64) - true_soc)))

    output_path = RESULTS_ROOT / "part2_pytorch_reference_outputs.csv"
    np.savetxt(output_path, outputs, delimiter=",", fmt="%.9g")
    report = {
        "tests": int(inputs.shape[0]),
        "input_shape_per_test": [5],
        "output_shape_per_test": [1],
        "torch_version": torch.__version__,
        "soc_rmse_on_selected_inputs": rmse,
        "soc_mae_on_selected_inputs": mae,
    }
    (RESULTS_ROOT / "part2_pytorch_reference_report.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )

    print(f"PYTORCH_REFERENCE_TESTS={inputs.shape[0]}")
    print(f"PYTORCH_REFERENCE_SOC_RMSE={rmse:.9f}")
    print(f"PYTORCH_REFERENCE_SOC_MAE={mae:.9f}")
    print("PYTORCH_REFERENCE_GATE=PASS")


if __name__ == "__main__":
    main()
