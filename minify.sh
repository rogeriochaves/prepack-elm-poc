set -e

elm make Main.elm --output main.js
sed -e "5248,5252d" -i.bak main.js # remove duplicated badIndex
prepack main.js --out main.prepacked.js
uglifyjs --compress unused,dead_code main.prepacked.js > main.prepacked.min.js
gzip --stdout main.prepacked.min.js > main.prepacked.min.gz
du -h main*
