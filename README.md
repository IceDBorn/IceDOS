# ⚠️ ARCHIVED ⚠️
This repository became a part of [IceDOS](https://github.com/IceDOS)

# IceDOS

This is a NixOS configuration project that aims to create a highly opinionated gaming and general purpose computing experience, while still providing enough config options for my different needs.

## Caution ⚠️

- This repository is not meant to be used as a flake input, thus, such a use case is not officially supported or tested.
- Do not forget to go through [config.toml](https://github.com/IceDBorn/IceDOS/blob/main/config.toml) and set each option to your liking! Be especially careful for <b>[[[icedos.hardware.mounts]]](https://github.com/IceDBorn/IceDOS/blob/55ce606b37fc7cb1e0110d3454b2827e2b56144f/config.toml#L191)</b>, malconfigured entries can make your generation <b>un-bootable</b>!

## Install

```bash
mkdir -p ~/.config/nix
echo "experimental-features = flakes nix-command" > ~/.config/nix/nix.conf
git clone https://github.com/icedborn/icedos
cd icedos
nix-shell ./build.sh
```

## Preview

![Untitled](https://github.com/user-attachments/assets/ac03c7bd-8211-42e7-856c-f6ff03966ce6)

## Contributing

Examples of what probably will/won't be accepted:

✅ A PR that improves framerate for games in all cases or, if it's unstable, enabled through an option in `config.toml`.

✅ A PR that adds a new desktop environment option and doesn't break existing functionality.

✅ A PR that adds a package with custom overrides, as a module. It is disabled by default, and can be enabled in `config.toml`.

❌ A PR that adds a package you want to use.
