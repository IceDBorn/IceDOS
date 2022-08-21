{
    imports = [
        # Packages installed for all users
        ./global.nix
        # Packages installed for main user
        ./main.nix
        # Packages installed for work user
        ./work.nix
    ];
}