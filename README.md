# genelab-assets

Asset blobs (MJCF / URDF) for [GeneLab](https://github.com/KraHsu/GeneLab) built-in
robots. The Python package keeps configuration code in-tree and references these blobs
via md5-verified downloads, so the runtime install stays lean.

## Layout

```
<robot-name>/
    <robot-name>.xml          # MJCF entry point
    [meshes/, textures/, ...]  # optional dependencies
```

Each robot directory matches the `AssetSpec.name` declared in
`genelab.asset_zoo.<robot>.py`. The corresponding entry in `genelab.asset_zoo` pins:

- `url` — absolute `raw.githubusercontent.com/.../main/<path>` URL
- `md5` — md5 digest of the MJCF blob; bumping this invalidates downstream caches
- `filename` — final basename under the cache directory

## Available robots

| Robot | MJCF | Source |
|---|---|---|
| Cartpole | [`cartpole/cartpole.xml`](cartpole/cartpole.xml) | Cart-on-rail + hinged pole; designed for GeneLab's `CartpoleCfg`. |
| Franka Emika Panda | [`franka/franka.xml`](franka/franka.xml) | Minimal kinematic stub with joint names aligned to MuJoCo Menagerie. Replace with the full Menagerie model + meshes for visual fidelity. |

## Updating an asset

1. Edit the MJCF (or replace with a higher-fidelity model).
2. Compute the new md5: `md5sum cartpole/cartpole.xml`.
3. Commit and push to `main`.
4. Update the `md5` field in the matching `genelab.asset_zoo.<robot>.py` module so the
   downstream cache invalidates cleanly.

## License

Files in this repository are provided for use with GeneLab. Robot models derived from
third-party sources (e.g. MuJoCo Menagerie) carry their upstream licenses; see the
relevant subdirectories for attribution when applicable.
