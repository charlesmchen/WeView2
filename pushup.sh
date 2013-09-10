jekyll build
cp _site/index_temp.html index.html
git add .
git commit -m "Update pages."
git push
