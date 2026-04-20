{ lib, stdenv, fetchurl }:

let
  version = "1.26.2";

  platform = "${stdenv.hostPlatform.go.GOOS}-${stdenv.hostPlatform.go.GOARCH}";

  hashes = {
    "darwin-arm64" = "32af1522bf3e3ff3975864780a429cc0b41d190ec7bf90faa661d6d64566e7af";
    "darwin-amd64" = "bc3f1500d9968c36d705442d90ba91addf9271665033748b82532682e90a7966";
    "linux-amd64"  = "990e6b4bbba816dc3ee129eaeaf4b42f17c2800b88a2166c265ac1a200262282";
    "linux-arm64"  = "c958a1fe1b361391db163a485e21f5f228142d6f8b584f6bef89b26f66dc5b23";
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
