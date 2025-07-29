{
  description = "elm-color nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  outputs =
    { self, ... }@inputs:
    with inputs;
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {
      nixosConfigurations = { };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Elm
              elmPackages.elm
              elmPackages.elm-format
              elmPackages.elm-test
              elmPackages.elm-review
            ];

            shellHook = ''
              echo "
                  elm-color dev shell
                  "
            '';
          };
        }
      );

    };
}
