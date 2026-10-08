#!/usr/bin/env bash
# Publishes a GitHub Release for image2pdf (commit → push main → tag → release).
#
# Usage:
#   bash scripts/create-releases.sh            # releases APP_VERSION from index.html
#   bash scripts/create-releases.sh v1.2.0     # releases an explicit vX.Y.Z
#
# Requirements:
#   - Push access to origin (alkiory/imageToPdf)
#   - gh CLI authenticated:  gh auth login
#   - Release notes at .github/releases/<version>.md
#
# Idempotent: an existing tag or GitHub Release is never overwritten.
set -euo pipefail

REPO="alkiory/imageToPdf"
REMOTE="origin"

# 1) Resolve the version (argument > APP_VERSION constant in index.html)
VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  VERSION="v$(grep -oE "const APP_VERSION = '[^']+'" index.html | head -1 | sed -E "s/.*'([^']+)'.*/\1/")"
fi
if ! [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "!! Invalid version '$VERSION' (expected vX.Y.Z)" >&2
  exit 1
fi

NOTES=".github/releases/${VERSION}.md"
if [[ ! -f "$NOTES" ]]; then
  echo "!! Missing release notes: ${NOTES}" >&2
  exit 1
fi

# 2) Commit pending changes (changelog, version badge, notes…)
if [[ -n "$(git status --porcelain)" ]]; then
  echo ">> Committing pending changes…"
  git add -A
  git commit -m "$(cat <<EOF
Release ${VERSION}

🤖 Generated with Codebuff
Co-Authored-By: Codebuff <noreply@codebuff.com>
EOF
)"
fi

# 3) Push main
echo ">> Pushing ${REMOTE} main…"
git push "${REMOTE}" main

# 4) Tag (created once, never moved)
if git rev-parse -q --verify "refs/tags/${VERSION}" >/dev/null; then
  echo ">> Tag ${VERSION} already exists at $(git rev-parse --short "refs/tags/${VERSION}") — keeping it."
else
  echo ">> Creating tag ${VERSION} on HEAD…"
  git tag "${VERSION}"
fi
git push "${REMOTE}" "refs/tags/${VERSION}"

# 5) GitHub Release
if gh release view "${VERSION}" --repo "${REPO}" >/dev/null 2>&1; then
  echo ">> Release ${VERSION} already exists — skipping creation."
else
  echo ">> Publishing GitHub Release ${VERSION}…"
  gh release create "${VERSION}" \
    --repo "${REPO}" \
    --title "$(head -n1 "${NOTES}" | sed 's/^# //')" \
    --notes-file "${NOTES}" \
    --latest
fi

echo ">> Done! https://github.com/${REPO}/releases/tag/${VERSION}"
