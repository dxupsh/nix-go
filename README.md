# nix-go

Pinned Go toolchain as a Nix flake, independent of nixpkgs version updates.

## Usage

Add as a flake input in your project:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    go.url = "github:dxupsh/nix-go";
  };

  outputs = { nixpkgs, go, ... }:
    let
      system = "aarch64-darwin"; # change to your system
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ go.packages.${system}.default ];
      };
    };
}
```

Then run:

```bash
nix develop
go version
```

## Supported platforms

- `aarch64-darwin` (macOS Apple Silicon)
- `x86_64-darwin` (macOS Intel)
- `x86_64-linux`
- `aarch64-linux`

## Updating Go version

When a new Go version is released:

1. **Get the new hashes:**

```bash
curl -s 'https://go.dev/dl/?mode=json' | \
  jq -r '.[0] | .version, (.files[] |
    select(.kind == "archive") |
    select(.os == "darwin" or .os == "linux") |
    select(.arch == "amd64" or .arch == "arm64") |
    "\(.os)-\(.arch) = \"\(.sha256)\";")'
```

2. **Edit `go.nix`:** Update the `version` string and replace all 4 hashes.

3. **Test locally:**

```bash
nix build .
./result/bin/go version
```

4. **Commit and push** to `github.com/dxupsh/nix-go`.

5. **Update in your project:**

```bash
nix flake update go
```

## Updating deadcode version

`deadcode` ships from `golang.org/x/tools`, built with the pinned Go above.
When a new `x/tools` release lands:

1. **Find the latest tag:**

```bash
curl -s 'https://api.github.com/repos/golang/tools/tags?per_page=1' | jq -r '.[0].name'
```

2. **Edit `tools/deadcode.nix`:** Update the `version` string, then set both
   `hash` and `vendorHash` to a placeholder so Nix reports the real values:

```nix
hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
```

3. **Get the real hashes:** build twice, each run fails with a `got:` line
   holding the correct hash. Copy `hash` first, rebuild, then copy `vendorHash`.

```bash
nix build .#deadcode
```

4. **Test locally:**

```bash
nix build .#deadcode
./result/bin/deadcode -help
```

5. **Commit and push** to `github.com/dxupsh/nix-go`.

6. **Update in your project:**

```bash
nix flake update go
```
