# Unitree G1 motion clips

NPZ motion clips for the motion-imitation task in
[GeneLab](https://github.com/KraHsu/GeneLab)'s `examples/unitree` extension.
Each `.npz` follows the schema consumed by
`genelab.mdp.commands.motion_command.MotionLoader`:

| Key | Shape | Notes |
|---|---|---|
| `joint_pos`      | `(T, 29)` `float32` | G1 actuated joints, mjlab MJCF DFS order |
| `joint_vel`      | `(T, 29)` `float32` | |
| `body_pos_w`     | `(T, 30, 3)` `float32` | World-frame body positions, mjlab MJCF DFS order (excluding `world`) |
| `body_quat_w`    | `(T, 30, 4)` `float32` | wxyz |
| `body_lin_vel_w` | `(T, 30, 3)` `float32` | |
| `body_ang_vel_w` | `(T, 30, 3)` `float32` | rad/s |
| `fps`            | `(1,)` | Output framerate (typically `50`) |

GeneLab's `MotionCommandCfg.motion_body_order` / `motion_joint_order` accept the
two reference orderings as `tuple[str, ...]` so the runtime robot's axis order
can differ from this file's. For G1, the canonical orderings are exported as
`G1_MJLAB_BODY_NAMES` and `G1_MJLAB_JOINT_NAMES` in
`genelab.asset_zoo.unitree_g1_motions`.

## Layout

```
unitree_g1/motions/
├── README.md
├── LICENSE.NOTICE                  # CC BY-NC-ND 4.0 + Apache-2.0 attribution
├── dance1_subject2.npz             # ~131s LAFAN1 dance clip (output @ 50 fps)
└── scripts/
    ├── csv_to_npz.upstream.py      # verbatim mjlab copy (Apache-2.0)
    └── convert.sh                  # end-to-end CSV→NPZ recipe
```

## Bundled clips

| File | md5 | Source CSV | Length | License |
|---|---|---|---|---|
| `dance1_subject2.npz` | `844731ab25e33ccd67798d4e22067ff9` | [`lvhaidong/LAFAN1_Retargeting_Dataset` → `g1/dance1_subject2.csv`](https://huggingface.co/datasets/lvhaidong/LAFAN1_Retargeting_Dataset) | ~131 s @ 30 fps → ~131 s @ 50 fps (6574 frames) | CC BY-NC-ND 4.0 |

The md5 is pinned by GeneLab's `genelab.asset_zoo.unitree_g1_motions.g1_lafan1_dance1_subject2`
`AssetSpec`; bump it there together with this entry when re-publishing the blob.

## Regenerating an NPZ

`scripts/convert.sh` runs the mjlab forward-kinematics replay against a CSV.

```bash
# from anywhere
bash unitree_g1/motions/scripts/convert.sh g1/dance1_subject2.csv dance1_subject2
```

Requires:

- A CUDA-capable GPU (mjlab's converter defaults to `cuda:0`).
- `uv` + a clone of [mjlab](https://github.com/Mujoco-Lab/mjlab) checked out
  next to this repo, or `uv pip install mjlab` in any sibling venv.

See `LICENSE.NOTICE` for distribution conditions.
