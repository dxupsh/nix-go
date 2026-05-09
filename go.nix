{ lib, stdenv, fetchurl }:

let
  version = "1.26.3";

  platform = "${stdenv.hostPlatform.go.GOOS}-${stdenv.hostPlatform.go.GOARCH}";

  hashes = {
    "darwin-arm64" = "875cf54a15311eee2c99b9dd67c68c4a49351d489ab622bf2cfd28c8f2078d3c";
    "darwin-amd64" = "278d580b32e299fe4a9c990fcf2d02acfe538c7e551a6ee18f9c7164573d2c63";
    "linux-amd64"  = "2b2cfc7148493da5e73981bffbf3353af381d5f93e789c82c79aff64962eb556";
    "linux-arm64"  = "9d89a3ea57d141c2b22d70083f2c8459ba3890f2d9e818e7e933b75614936565";
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
