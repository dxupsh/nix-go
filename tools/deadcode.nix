{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "deadcode";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-F9DyZAZdrKCrCIB6FZP0KrOwPNRLk0ZQoNMHGMHd0UY=";
  };

  vendorHash = "sha256-HpWkPsRJ0vCqJi9LoZcVbzeoPQ2B9ftZwuS1r47W7Sc=";

  subPackages = [ "cmd/deadcode" ];

  meta = with lib; {
    description = "Find unreachable functions in Go programs";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/deadcode";
    license = licenses.bsd3;
    mainProgram = "deadcode";
  };
}
