{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.27.1";

  platform = "${stdenv.hostPlatform.go.GOOS}-${stdenv.hostPlatform.go.GOARCH}";

  hashes = {
    darwin-amd64 = "8f8f52c6649542cf027bbc9b9c68d1ec042f9f34808a40413f0b8b3f66f3caa4";
    darwin-arm64 = "ee215d57e0ec269c60cc9ceca68e6bda321ba9ee5afe24f4b0988703c2d87d12";
    linux-amd64 = "63d339f0da5ab53635a56f2490a7984dfe12dfcff22ad749f63edaf590168445";
    linux-arm64 = "3450b45a3f9ee8568792736a5c5e70a1f2e9b36c35a8f74958c03e51d7d92bec";
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
