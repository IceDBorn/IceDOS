# Caution ⚠️

- Do not forget to go through [.nix](https://github.com/IceDBorn/IceDOS/blob/main/.nix), [configuration.nix](https://github.com/IceDBorn/IceDOS/blob/main/configuration.nix) and edit and comment out (#) anything you don't want to setup!
- [hardware/mounts.nix](https://github.com/IceDBorn/IceDOS/blob/main/hardware/mounts.nix) can break your system! Be sure to edit it accordingly or [disable it](https://github.com/IceDBorn/IceDOS/blob/087d7884d501f5660e8368ed349561c2d83ddf04/.nix#L310)!

# Install

```bash
git clone https://github.com/IceDBorn/IceDOS
cd IceDOS
bash install.sh
```

# Known Issues

### error: Entry '.configuration-location' not uptodate. Cannot merge.

Solution:

```
git rm --cached --sparse .configuration-location
```

# Preview

![image](https://github.com/IceDBorn/IceDOS/assets/51162078/f13ef5d0-a318-455b-90c7-f8817bcdb72a)
