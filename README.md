# IceDOS

This is a NixOS project that aims to create a highly opinionated gaming and general purpose computing experience, while still providing enough configuration options for my different needs.

## Caution ⚠️

- This repository is meant to be used on a fresh install of NixOS. Using it as a flake input is not currently in my needs, and thus not something that's tested or supported.
- Do not forget to go through [config.toml](https://github.com/IceDBorn/IceDOS/blob/main/config.toml) and set each option to your liking!
- [hardware/mounts.nix](https://github.com/IceDBorn/IceDOS/blob/main/hardware/mounts.nix) can break your system! Be sure to edit it accordingly or [set it to false](https://github.com/IceDBorn/IceDOS/blob/a86ae01a6103cef4ac26d161cac68ac16bf0067e/config.toml#L115)!

## Install

```bash
git clone https://github.com/IceDBorn/IceDOS
cd IceDOS
bash scripts/install.sh
```

## Preview

![image](https://github.com/IceDBorn/IceDOS/assets/51162078/c1f2e730-a7d7-4b8d-abce-2757551ce196)

## Contributing

Since this is a NixOS configuration tailored to my needs, feature requests and PR acceptance is stricter and on a case-by-case basis. If you want to make a more specific change for your nees, you should fork this repository.

Examples of what probably will/won't be accepted:

✅ A PR that improves framerate for games in all cases or, if it's unstable, enabled through an option in `config.toml`.

❌ A PR that adds a package you want to use.
