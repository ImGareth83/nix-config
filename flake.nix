{
  description = "Gareth's nix-darwin";

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

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    username = "gareth";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

  in {
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
      {
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
       
       system.stateVersion = 6;
       system.primaryUser = "gareth";
       system.configurationRevision = self.rev or self.dirtyRev or null;

       environment.systemPackages = with pkgs; [ mkalias ];

       # Homebrew module
       homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;

       masApps = {
        "Amphetamine" = 937984704;
        "Whatsapp" = 310633997;
        "Wechat" = 836500024;
        "Telegram" = 747648890;
        "moomoo" = 1482713641;
        "Slack" = 803453959;
        "Magnet" = 441258766;
       };

    	brews = [
         "watch"
         "openssl"
         "mas"
         "bitwarden-cli"
      ];
      
      casks = [
        "brave-browser"
        "chatgpt"
        "itsycal"
        "drawio"
        "maccy"
      ];
        
	#taps = [
        # "homebrew/cask-fonts"
        #];
        
       };
      }
      
      # Enable Home Manager as a module
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
