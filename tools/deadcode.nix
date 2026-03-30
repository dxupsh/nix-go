{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "deadcode";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-A4c+/kWJQ6/3dIu8lR/NW9HUvsrIVs255lPfBYWK3tE=";
  };

  vendorHash = "sha256-+tJs+0exGSauZr7PBuXf0htoiLST5GVMiP2lEFpd4A4=";

  subPackages = [ "cmd/deadcode" ];

  meta = with lib; {
    description = "Find unreachable functions in Go programs";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/deadcode";
    license = licenses.bsd3;
    mainProgram = "deadcode";
  };
}
