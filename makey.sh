#!/bin/sh

# Fail if we reference an undefined variable.
set -o nounset
# Fail if any command fails (doesn't include piped commands).
set -o errexit
# Fail if any piped command fails.
set -o pipefail

# rm *.html
rm CHANGELOG.md
echo "<!-- TEMPLATE START -->" >> CHANGELOG.md
curl https://raw.github.com/charlesmchen/WeView2/master/CHANGELOG.md >> CHANGELOG.md
echo "<!-- TEMPLATE END -->" >> CHANGELOG.md
python ./preprocess_markdown.py
jekyll build
# cp _site/*.html .
cp _site/home.html _site/index.html
cp _site/home.html index.html
