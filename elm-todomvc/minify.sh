set -e

elm make Todo.elm --output main.js

# prepack
sed -e "5445,5449d" -i.bak main.js # fix: remove duplicated badIndex function declaration
prepack main.js --out main.prepacked.js
sed -e "s/Elm =/this['Elm'] =/" -i.bak main.prepacked.js # fix: reexport Elm to be available on window

# closure compiler
java -jar ../node_modules/google-closure-compiler/compiler.jar --js main.prepacked.js --compilation_level SIMPLE --js_output_file main.prepacked.closured.js

# uglify
uglifyjs --compress unused,dead_code main.prepacked.js > main.prepacked.uglified.js

gzip --stdout main.prepacked.closured.js > main.prepacked.closured.js.gz
gzip --stdout main.prepacked.uglified.js > main.prepacked.uglified.js.gz

echo "Todo MVC results"
du -h main*
