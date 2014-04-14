rm CHANGELOG.md
echo "<!-- TEMPLATE START -->" >> CHANGELOG.md
curl https://raw.github.com/charlesmchen/WeView2/master/CHANGELOG.md >> CHANGELOG.md
echo "<!-- TEMPLATE END -->" >> CHANGELOG.md
python ./config_md.py 
jekyll build
cp _site/*.html .
cp _site/home.html _site/index.html
cp _site/home.html index.html
