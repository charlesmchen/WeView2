cp index.prefix index.md
curl https://raw.github.com/charlesmchen/WeView2/master/README.md >> index.md
jekyll build

