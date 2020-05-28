elm make ../src/Main.elm --optimize --output=main.js
uglifyjs main.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=uglify.min.js
npx google-closure-compiler --js=main.js --js_output_file=gcc.min.js --compilation_level=ADVANCED
gzip gcc.min.js -y
gzip uglify.min.js -y