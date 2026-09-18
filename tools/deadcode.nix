{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "deadcode";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-lly/LbIt9u+aQpnymLLidu8SNH631z+8GcMRR7+daZI=";
  };

  vendorHash = "sha256-Mxxl+D31WjPVU8EsI3N+sy7T62UksEzL/8OzdJYRkes=";

  subPackages = [ "cmd/deadcode" ];

  meta = with lib; {
    description = "Find unreachable functions in Go programs";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/deadcode";
    license = licenses.bsd3;
    mainProgram = "deadcode";
  };
}
