# genelab-assets

Asset blobs (MJCF / URDF) for [GeneLab](https://github.com/KraHsu/GeneLab) built-in
robots. The Python package keeps configuration code in-tree and references these blobs
via md5-verified downloads, so the runtime install stays lean.

## Two delivery formats

GeneLab's `fetch_asset` helper accepts both single-file and archive entries:

```
<robot-name>/
    <robot-name>.xml          # single-file mode: MJCF only
```

or, when meshes / textures are needed:

```
<robot-name>/
    <robot-name>.tar.gz       # archive mode: full Menagerie-style folder
```

The matching `AssetSpec` in `genelab.asset_zoo.<robot>.py` pins:

- `url` — absolute `raw.githubusercontent.com/.../main/<path>` URL
- `md5` — md5 digest of the file or archive blob; bumping it invalidates the cache
- `filename` — basename under the cache directory
- `archive_member` *(archive mode only)* — relative path to the entry MJCF inside the
  extracted tree

## Available robots

| Robot | Asset | Mode | Source |
|---|---|---|---|
| Cartpole | [`cartpole/cartpole.xml`](cartpole/cartpole.xml) | single-file | Cart-on-rail + hinged pole; designed for GeneLab's `CartpoleCfg`. |
| Franka Emika Panda | `franka_emika_panda/franka_emika_panda.tar.gz` | archive | 7-DoF arm + parallel gripper mirrored from [MuJoCo Menagerie](https://github.com/google-deepmind/mujoco_menagerie/tree/main/franka_emika_panda) (Apache-2.0). |
| Unitree G1 | `unitree_g1/unitree_g1.tar.gz` | archive | 29-DoF humanoid mirrored from [MuJoCo Menagerie](https://github.com/google-deepmind/mujoco_menagerie/tree/main/unitree_g1) (BSD-3-Clause). |
| Unitree Go1 | `unitree_go1/unitree_go1.tar.gz` | archive | 12-DoF quadruped mirrored from [MuJoCo Menagerie](https://github.com/google-deepmind/mujoco_menagerie/tree/main/unitree_go1) (BSD-3-Clause). |
| ANYbotics Anymal C | `anybotics_anymal_c/anybotics_anymal_c.tar.gz` | archive | 12-DoF quadruped mirrored from [MuJoCo Menagerie](https://github.com/google-deepmind/mujoco_menagerie/tree/main/anybotics_anymal_c) (BSD-3-Clause). |
| WUJI Hand | `wuji_hand/wuji_hand.tar.gz` | archive | 20-DoF dexterous hand (left + right) description from [WUJI Technology](https://github.com/wuji-technology/wuji-description). |
| WUJI Hand (reorient) | `wuji_hand_reorient/wuji_hand_reorient.tar.gz` | archive (meshes only) | Right-hand collision/soft-pad meshes (incl. `_simplified` / `_softbody`) for the in-hand reorientation task; paired with the in-tree `right_mjlab.xml`. |

## Motion clips

| Robot | Asset | Notes |
|---|---|---|
| Unitree G1 | [`unitree_g1/motions/dance1_subject2.npz`](unitree_g1/motions/dance1_subject2.npz) | LAFAN1 retargeted dance clip (CC BY-NC-ND 4.0); see [`unitree_g1/motions/README.md`](unitree_g1/motions/README.md). |

## Updating an asset

1. Edit the MJCF, or regenerate the tar.gz from a fresh Menagerie pull.
2. Compute the new md5: `md5sum <robot>/<robot>.xml` (or `.tar.gz`).
3. Commit and push to `main`.
4. Update the `md5` field in the matching `genelab.asset_zoo.<robot>.py` module so the
   downstream cache invalidates cleanly.

## License

Original GeneLab assets (cartpole, franka stub) are released for use with GeneLab. Each
Menagerie-derived archive bundles its upstream `LICENSE` and `README.md` so the BSD-3
attribution travels with the model. Redistributing the contents of those archives must
preserve the included notice.
