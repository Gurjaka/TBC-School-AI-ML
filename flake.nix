{
  description = "Development environment for Introduction-to-AI course";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = function:
      nixpkgs.lib.genAttrs supportedSystems (
        system: function nixpkgs.legacyPackages.${system}
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    devShells = forAllSystems (
      pkgs: let
        python-deps = ps:
          with ps; [
            pip
            manim
            matplotlib
            numpy
            pandas
            seaborn
          ];
      in {
        default =
          pkgs.mkShell
          {
            packages = with pkgs; [
              (python3.withPackages python-deps)
              black
              zsh
            ];
          };
      }
    );
  };
}
