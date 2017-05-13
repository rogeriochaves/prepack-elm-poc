set -e

elm make Main.elm --output main.js

# prepack
sed -e "5248,5252d" -i.bak main.js # fix: remove duplicated badIndex function declaration
prepack main.js --out main.prepacked.js
sed -e "s/Elm =/this['Elm'] =/" -i.bak main.prepacked.js # fix: reexport Elm to be available on window

# advanced closure compiler
sed -e "s/return main//" -i.bak main.prepacked.js # fix: remove undeclared main
sed -e 's/_elm_lang\$core\$Set\$toList/void/g' -i.bak main.prepacked.js # fix: remove undeclared functions being used
sed -e "s/Main:/'Main':/" -i.bak main.prepacked.js # prevent Main from being mashed when calling Elm.Main
sed -e "s/embed:/'embed':/" -i.bak main.prepacked.js # prevent embed from being mashed when calling Elm.Main.embed
sed -e "s/fullscreen:/'fullscreen':/" -i.bak main.prepacked.js # prevent embed from being mashed when calling Elm.Main.fullscreen
java -jar ../node_modules/google-closure-compiler/compiler.jar --js main.prepacked.js --compilation_level ADVANCED --js_output_file main.prepacked.closured.js

# uglify
uglifyjs --compress unused,dead_code main.prepacked.js > main.prepacked.uglified.js

gzip --stdout main.prepacked.closured.js > main.prepacked.closured.js.gz
gzip --stdout main.prepacked.uglified.js > main.prepacked.uglified.js.gz
du -h main*
