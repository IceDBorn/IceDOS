# IceDOS

This is a NixOS configuration project that aims to create a highly opinionated gaming and general purpose computing experience, while still providing enough config options for my different needs.

## Caution ⚠️

- This repository is not meant to be used as a flake input, and thus such a use case is not officially supported or tested.
- Do not forget to go through [config.toml](https://github.com/IceDBorn/IceDOS/blob/main/config.toml) and set each option to your liking!
- [hardware/mounts.nix](https://github.com/IceDBorn/IceDOS/blob/main/hardware/mounts.nix) can break your system! Be sure to edit it accordingly or [set it to false](https://github.com/IceDBorn/IceDOS/blob/a86ae01a6103cef4ac26d161cac68ac16bf0067e/config.toml#L115)!

## Install

```bash
git clone https://github.com/icedborn/icedos
cd icedos
nix-shell ./build.sh
```

## Preview

![image](https://github.com/IceDBorn/IceDOS/assets/51162078/c1f2e730-a7d7-4b8d-abce-2757551ce196)

## Contributing

Examples of what probably will/won't be accepted:

✅ A PR that improves framerate for games in all cases or, if it's unstable, enabled through an option in `config.toml`.

✅ A PR that adds a new desktop environment option and doesn't break existing functionality.

❌ A PR that adds a package you want to use.
