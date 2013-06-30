# target: all - Default target. Minify JavaScript and CSS.
all: clean build-js build-css

# target: check - Run tests.
check:
	@echo "Tests can only be run from the browser because there is no IndexedDB support elsewhere. To run tests, go to http://BASKETBALL-GM-URL/test in your web browser."

# target: docs - Regenerate documentation from source code using jsdoc-toolkit.
docs:
	rm -rf docs
	jsdoc -d=docs -s js js/core js/util js/views

# target: lint - Run jslint on all source files except third-party libraries.
lint:
	jslint --nomen --plusplus --predef requirejs --predef require --predef define --predef mocha --predef describe --predef it --predef should --predef window --predef document --predef console --predef alert --predef location --predef setTimeout --predef localStorage --predef indexedDB --predef IDBKeyRange --predef IDBTransaction --predef IDBObjectStore --predef before --predef beforeEach --predef after --predef afterEach js/core/*.js js/test/*.js js/test/core/*.js js/util/*.js js/views/*.js js/*.js js/lib/IndexedDB-getAll-shim.js js/lib/boxPlot.js js/lib/jquery.barGraph.js js/lib/faces.js js/lib/jquery.dataTables.bbgmSorting.js js/lib/jquery.tabSlideOut.js



### Targets below here are generally just called from the targets above.

# target: build-css - Concatenate main CSS files and run YUI compressor.
build-css:
	cat css/bootstrap.css css/bbgm-responsive.css css/bbgm.css css/DT_bootstrap.css | yui-compressor --type css -o gen/bbgm.css

# target: build-js - Run the RequireJS optimizer to concatenate and minify all JavaScript files.
build-js:
	r.js -o baseUrl=js paths.requireLib=lib/require optimize=uglify preserveLicenseComments=false name=app include=requireLib mainConfigFile=js/app.js out=gen/app.js

# target: clean - Delete files generated by `make all`.
clean:
	rm -f gen/app.js
	rm -f gen/bbgm.css



###

.PHONY: all check docs lint build-css build-js clean