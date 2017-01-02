#!/usr/bin/env bash


echo -e "\n\nBeginning basic react setup.\n\n"
#Install npm packages

# react dependencies
sudo npm install --save react react-dom react-addons-test-utils
sudo npm install --save object-assign
sudo npm install --save es6-promise
sudo npm install --save es6-shim

#Install bootstrap
sudo npm install --save bootstrap

# Development dependencies
sudo npm install --save-dev babelify babel-core
sudo npm install --save-dev babel-preset-react babel-preset-es2015 babel-es6-polyfill babel-preset-stage-0
sudo npm install --save-dev babel-plugin-transform-class-properties
sudo npm install --save-dev babel-plugin-transform-react-jsx

# Install live reload
sudo npm install --save-dev live-server



# "clean": "rm -f ./*.js; rm -f ./*.js.map; rm -f ./intermediates/*.js; rm -f ./intermediates/*.js.map",
# "serve": "./node_modules/.bin/live-server --host=localhost --port=8080 .",
# "go": "concurrent \"npm run serve\" "


# Install browserify
sudo npm install --save-dev browserify



# vinyl-source-stream is is a Virtual file that converts the readable
# stream you get from browserify into a vinyl stream that gulp is expecting to get.
# Gulp doesn't need to write a temporal file between different transformations.
sudo npm install --save-dev vinyl-source-stream

# Install all gulp plugins
sudo npm install --save-dev gulp gulp-load-plugins gulp-sass gulp-cssmin gulp-autoprefixer gulp-rename gulp-sourcemaps

#The below plugins are optional
#sudo npm install --save-dev gulp-uglify
#sudo npm install --save-dev gulp-concat-css
#sudo npm install --save-dev gulp-plumber


# Create the directory structure
mkdir -p ./{public,app/{components,styles}}

# Creata a template for Application.jsx
touch ./app/Application.jsx

echo -e "import React from \"react\";
import ReactDOM from \"react-dom\";
import Main from \"Main\";

ReactDOM.render(
    <Main/>,
    document.getElementById('app')
);">./app/Application.jsx


# Create a template for Main.jsx with bootstrap included
touch ./app/components/Main.jsx

echo -e "import React from \"react\";

const Main = () =>{
    return (
        <div className=\"jumbotron\">
            <h1>Hello, world!</h1>
            <p>Bootstrap is also working</p>
            <p><a className=\"btn btn-primary btn-lg\" href=\"#\" role=\"button\">Learn more</a></p>
        </div>
    );
};

export default Main;
">./app/components/Main.jsx


# Create the Gulpfile
echo -e "const gulp = require('gulp');
const browserify = require('browserify');
const source = require('vinyl-source-stream');
const plug = require('gulp-load-plugins')({lazy: true});
const sourcemaps = require('gulp-sourcemaps');


gulp.task('react', function () {
    return browserify({
        entries: ['./app/Application.jsx'],
        extensions: ['.jsx', '.js'],
        paths: ['./app/components/']
    })
        .transform('babelify', {

            //The order of this is important
            presets: [\"es2015\", \"stage-0\", \"react\"]
        })
        .bundle()
        .pipe(source('browserify.js'))
        .pipe(gulp.dest('./public/build/'))
});

gulp.task(\"sasstocss\", function () {
    gulp.src(\"./app/styles/scss/styles.scss\")
        .pipe(plug.autoprefixer({browsers: ['last 2 versions'], cascade: false}))
        .pipe(plug.sass())
        .pipe(plug.cssmin())
        .pipe(plug.rename('styles.min.css'))
        .pipe(gulp.dest(\"./app/styles/css\"));
});


gulp.task('sourcemaps', function () {
    gulp.src('public/build/*.js')
        .pipe(sourcemaps.init())
        .pipe(sourcemaps.write('../maps'))
        .pipe(gulp.dest('public/maps/'));
});

gulp.task(\"watch\", function () {
    gulp.watch(\"./app/components/**/*.jsx\", [\"react\", \"sourcemaps\"]);
    gulp.watch(\"./public/scss/**/*.scss\", [\"sasstocss\"])
});


gulp.task(\"default\", [\"react\", \"sasstocss\", \"sourcemaps\", \"watch\"]);

"> Gulpfile.js

# Create the .babelrc file
echo -e "{
  \"presets\": [\"es2015\", \"stage-0\", \"react\"]
}"> ./.babelrc

# Launch the application

echo -e "\n\nLaunching application.\n\n"
npm run serve &
gulp