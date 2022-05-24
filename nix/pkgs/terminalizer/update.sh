#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl rsync nodePackages.node2nix
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

user="faressoft"
repo="terminalizer"

source ../lib.sh
tagrev="$(get_latest_Version_from_github_tags $user $repo)"
tag="$(printf '%s' "$tagrev" | head -n1)"
rev="$(printf '%s' "$tagrev" | tail -n1)"
version="$(printf '%s' "$tag" | cut -c 2-)"

prefetch="$(prefetch_from_github $user $repo $rev)"
sha="$(printf '%s' "$prefetch" | head -n1)"
store="$(printf '%s' "$prefetch" | tail -n1)"

cat >metadata.nix <<EOF
{
  pname = "$repo";
  version = "$version";
  fetch = {
    owner = "$user";
    repo = "$repo";
    rev = "$rev";
    sha256 = "$sha";
  };
}
EOF

echo "Generating node-packages.nix" >&2
tmp="$(mktemp -d)"

cleanup() {
  echo "Removing $tmp" >&2
  rm -rf "$tmp"
}

trap cleanup EXIT

rsync -a --chmod=ugo=rwX "$store/" "$tmp"

pushd "$tmp"
node2nix \
  --input package.json \
  --lock package-lock.json \
  --development \
  --input ./package.json \
  --lock ./package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix
popd

cp -f "$tmp/node-env.nix" ./node-env.nix
cp -f "$tmp/node-packages.nix" ./node-packages.nix
cp -f "$tmp/node-composition.nix" ./node-composition.nix
cp -f "$tmp/package.json" ./package.json
