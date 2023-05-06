{
  description = "Vscode extension for the strictly language";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
            package = builtins.fromJSON (builtins.readFile ./package.json);
            app = pkgs.vscode-utils.buildVscodeExtension {
              name = "${package.name}";
              src = ./.;
              nativeBuildInputs = [ pkgs.nodejs pkgs.vsce ];
              preInstall = ''
                vsce package
              '';
              vscodeExtPublisher = "${package.name}";
              vscodeExtName = "${package.name}";
              vscodeExtUniqueId = "${package.name}.${package.publisher}";
            };
        in {
          packages.${package.name} = app;
          defaultPackage = self.packages.${system}.${package.name};
        }
      );
}
