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
            packageName = "strictly";
            app = pkgs.vscode-utils.buildVscodeExtension {
              name = "${packageName}";
              src = ./.;
              nativeBuildInputs = [ pkgs.nodejs pkgs.vsce ];
              preInstall = ''
                vsce package
              '';
              vscodeExtPublisher = "${packageName}";
              vscodeExtName = "${packageName}";
              vscodeExtUniqueId = "${packageName}.${packageName}";
            };
        in {
          packages.${packageName} = app;
          defaultPackage = self.packages.${system}.${packageName};
        }
      );
}
