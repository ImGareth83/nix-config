{
  description = "Gareth's nix-darwin";

  # ============================================================================
  # Flake Inputs
  # ============================================================================
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    secrets = {
      url = "path:./secrets";
      flake = false;

    };

  };

  # ============================================================================
  # Flake Outputs
  # ============================================================================
  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    username = "gareth";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

  in {
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
      # Import Homebrew configuration from separate module
      ./homebrew.nix
      {
       # ========================================================================
       # Nix Configuration
       # ========================================================================
       nixpkgs.hostPlatform = system;
       nixpkgs.config.allowUnfree = true;
       nix.settings = {
         experimental-features = "nix-command flakes";
       };
       
       # Automatic store optimization
       nix.optimise.automatic = true;
       
       # Automatic garbage collection
       nix.gc = {
         automatic = true;
         interval = { Hour = 3; Minute = 15; }; # Run daily at 3:15 AM
         options = "--delete-older-than 30d";
       };
       
       # ========================================================================
       # System Configuration
       # ========================================================================
       system.stateVersion = 6;
       system.primaryUser = "gareth";
       system.configurationRevision = self.rev or self.dirtyRev or null;

       environment.systemPackages = with pkgs; [ mkalias ];
      }
      
      # ========================================================================
      # Home Manager Integration
      # ========================================================================
      home-manager.darwinModules.home-manager
      {
       home-manager.useGlobalPkgs = true;
       home-manager.useUserPackages = true;
       home-manager.users.gareth = { pkgs, lib, ... }@args: import ./home.nix (args // { inherit inputs; });
       users.users.${username} = {
        name = username;
        home = "/Users/${username}";
       };

      }
      ];

      specialArgs = { inherit username; };
   
   };
  };
}
