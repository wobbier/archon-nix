{
    description = "Flake for the Archon app";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs";
    outputs = { self, nixpkgs }:
    let
        eachSystem = systems: f:
        nixpkgs.lib.genAttrs systems (system:
        f {
            inherit system;
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
        });
        supportedSystems = [ "x86_64-linux" ];
    in
    {
        packages = eachSystem supportedSystems ({ pkgs, system }: {
            default = pkgs.callPackage ./pkgs/archon/default.nix {};
            archon = pkgs.callPackage ./pkgs/archon/default.nix {};
        });
    };
}