#!/usr/bin/env bash
# Creates GitHub Releases v1.0.0 and v1.1.0 for image2pdf.
#
# Requirements:
#   - gh CLI installed and authenticated:  gh auth login
#   - Push access to origin (alkiory/imageToPdf)
#
# Usage:
#   bash scripts/create-releases.sh
set -euo pipefail

REPO="alkiory/imageToPdf"
REMOTE="origin"

# 1) Commit pending changes (changelog, version badge, release notes…)
if [[ -n "$(git status --porcelain)" ]]; then
  echo ">> Committing pending changes…"
  git add -A
  git commit -m "$(cat <<'EOF'
Add changelog, version badge and release automation

🤖 Generated with Codebuff
Co-Authored-By: Codebuff <noreply@codebuff.com>
EOF
)"
fi

# 2) Push main so the tags land on the latest commit
echo ">> Pushing ${REMOTE} main…"
git push "${REMOTE}" main

# 3) Create tags and releases from the drafted notes
echo ">> Creating tag v1.0.0 on the initial SPA commit…"
git tag -f v1.0.0 c549104

echo ">> Creating tag v1.1.0 on HEAD…"
git tag -f v1.1.0

git push "${REMOTE}" --force --tags

echo ">> Publishing GitHub Releases…"
gh release create v1.0.0 \
  --repo "${REPO}" \
  --title "image2pdf v1.0.0 — Initial Release" \
  --notes-file .github/releases/v1.0.0.md

gh release create v1.1.0 \
  --repo "${REPO}" \
  --title "image2pdf v1.1.0 — Security Texture, Live Preview & Dark Mode" \
  --latest \
  --notes-file .github/releases/v1.1.0.md

echo ">> Done! https://github.com/${REPO}/releases"
