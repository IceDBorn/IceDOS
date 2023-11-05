{ ... }:

{
  imports = [
    ./global.nix # Packages installed globally
    ./main.nix # Packages installed for main user
    ./work.nix # Packages installed for work user
    # Home manager specific stuff
    ./home/main.nix
    ./home/work.nix
  ];

  nix = {
    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # Enable flakes
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary packages
    permittedInsecurePackages = [ "electron-24.8.6" ];
  };
}
