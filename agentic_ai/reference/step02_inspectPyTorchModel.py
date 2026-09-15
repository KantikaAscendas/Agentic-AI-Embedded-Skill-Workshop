"""Inspect the exported PyTorch MLP before MATLAB import."""

from __future__ import annotations

import json
import sys
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve()
REPO_ROOT = SCRIPT_PATH.parents[2]
RESULTS_ROOT = REPO_ROOT / "agentic_ai" / "results"
MODEL_PATH = REPO_ROOT / "Part_2_AI_import" / "models" / "mlp_soc_model.pt2"

# MATLAB R2026a's converter ships tested PyTorch dependencies separately from
# its managed Python runtime. Add that managed package directory when needed.
MATLAB_TORCH_ROOT = Path(
    r"C:\ProgramData\MATLAB\SupportPackages\R2026a\3P.instrset"
    r"\pytorchconverter.instrset\win64"
)
if MATLAB_TORCH_ROOT.is_dir():
    sys.path.insert(0, str(MATLAB_TORCH_ROOT))

import numpy as np  # noqa: E402
import torch  # noqa: E402


def main() -> None:
    RESULTS_ROOT.mkdir(parents=True, exist_ok=True)
    if not MODEL_PATH.is_file():
        raise FileNotFoundError(f"PyTorch model not found: {MODEL_PATH}")

    exported_program = torch.export.load(str(MODEL_PATH))
    model = exported_program.module()

    # The exported program has a fixed single-observation input shape [5].
    example_input = torch.zeros((5,), dtype=torch.float32)
    with torch.no_grad():
        example_output = model(example_input)

    if isinstance(example_output, (tuple, list)):
        output_tensor = example_output[0]
    else:
        output_tensor = example_output

    state_shapes = {
        name: list(tensor.shape)
        for name, tensor in model.state_dict().items()
    }
    report = {
        "python": sys.version.split()[0],
        "numpy": np.__version__,
        "torch": torch.__version__,
        "model_path": str(MODEL_PATH),
        "model_bytes": MODEL_PATH.stat().st_size,
        "input_specs": str(exported_program.graph_signature.input_specs),
        "range_constraints": str(exported_program.range_constraints),
        "example_input_shape": list(example_input.shape),
        "example_output_shape": list(output_tensor.shape),
        "example_output": output_tensor.detach().cpu().reshape(-1).tolist(),
        "state_dict_shapes": state_shapes,
        "module": str(model),
    }

    output_path = RESULTS_ROOT / "pytorch_model_inspection.json"
    output_path.write_text(json.dumps(report, indent=2), encoding="utf-8")

    print(f"PYTHON={report['python']}")
    print(f"NUMPY={report['numpy']}")
    print(f"TORCH={report['torch']}")
    print(f"MODEL_BYTES={report['model_bytes']}")
    print(f"INPUT_SHAPE={report['example_input_shape']}")
    print(f"OUTPUT_SHAPE={report['example_output_shape']}")
    print(f"STATE_DICT_SHAPES={state_shapes}")
    print(f"MODULE={model}")
    print("PYTORCH_INSPECTION_GATE=PASS")


if __name__ == "__main__":
    main()
