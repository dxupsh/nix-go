{ lib, stdenv, fetchurl }:

let
  version = "1.26.1";

  platform = "${stdenv.hostPlatform.go.GOOS}-${stdenv.hostPlatform.go.GOARCH}";

  hashes = {
    "darwin-arm64" = "353df43a7811ce284c8938b5f3c7df40b7bfb6f56cb165b150bc40b5e2dd541f";
    "darwin-amd64" = "65773dab2f8cc4cd23d93ba6d0a805de150ca0b78378879292be0b903b8cdd08";
    "linux-amd64"  = "031f088e5d955bab8657ede27ad4e3bc5b7c1ba281f05f245bcc304f327c987a";
    "linux-arm64"  = "a290581cfe4fe28ddd737dde3095f3dbeb7f2e4065cab4eae44dfc53b760c2f7";
  };
in
stdenv.mkDerivation {
  pname = "go";
  inherit version;

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "nix-go: unsupported platform ${platform}");
  };

  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/go $out/bin
    cp -r . $out/share/go
    ln -s $out/share/go/bin/go $out/bin/go
    ln -s $out/share/go/bin/gofmt $out/bin/gofmt
    runHook postInstall
  '';

  passthru = {
    CGO_ENABLED = "1";
    GOOS = stdenv.hostPlatform.go.GOOS;
    GOARCH = stdenv.hostPlatform.go.GOARCH;
    GOROOT = placeholder "out" + "/share/go";
  };

  meta = {
    description = "Go programming language (binary distribution)";
    homepage = "https://go.dev/";
    license = lib.licenses.bsd3;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "go";
  };
}
