#!/usr/bin/env bash


echo -e "\n\n\t\e[1;35mBeginning basic react setup.\n\n\e[0m"
#Install npm packages

# react dependencies
sudo npm install --save react react-dom react-addons-test-utils
sudo npm install --save object-assign
sudo npm install --save es6-promise
sudo npm install --save es6-shim
sudo npm install --save whatwg-fetch
#Install bootstrap
sudo npm install --save bootstrap

# Development dependencies
sudo npm install --save-dev babelify babel-core
sudo npm install --save-dev babel-preset-react babel-preset-es2015 babel-es6-polyfill babel-preset-stage-0
sudo npm install --save-dev babel-plugin-transform-class-properties
sudo npm install --save-dev babel-plugin-transform-react-jsx

# Install live reload
sudo npm install --save-dev live-server


# Install browserify
sudo npm install --save-dev browserify



# vinyl-source-stream is is a Virtual file that converts the readable
# stream you get from browserify into a vinyl stream that gulp is expecting to get.
# Gulp doesn't need to write a temporal file between different transformations.
sudo npm install --save-dev vinyl-source-stream

# Install all gulp plugins

#Install gulp globally if not present
#sudo npm install -g gulp
sudo npm install --save-dev gulp gulp-load-plugins gulp-sass gulp-cssmin gulp-autoprefixer gulp-rename gulp-sourcemaps

#Install jsHint
sudo npm install jshint gulp-jshint --save-dev
sudo npm install --save-dev jshint-stylish

echo -e "
{
  \"node\": true,
  \"browser\": true,
  \"esnext\": true,
  \"newcap\": false,
  \"eqeqeq\": true,
  \"latedef\": false,
  \"nonbsp\": true,
  \"quotmark\": true,
  \"single\": require single quotes
  \"undef\": true,
  \"unused\": true,
}">.jshintrc

#The below plugins are optional
#sudo npm install --save-dev gulp-uglify
#sudo npm install --save-dev gulp-concat-css
#sudo npm install --save-dev gulp-plumber


# Create the directory structure
mkdir -p ./{public,src/{components,styles/{css,scss}}}
touch ./src/styles/scss/styles.scss
touch ./src/styles/css/styles.min.css

# Creata a template for Application.jsx
touch ./app/app.jsx

echo -e "import React from 'react';
import ReactDOM from 'react-dom';
import Application from 'Application';

ReactDOM.render(
    <Application/>,
    document.getElementById('app')
);">./src/app.jsx


echo -e "import React from 'react';

const Application = () =>{
    return (
        <div className=\"jumbotron\">
            <h1>Hello, world!</h1>
            <p>Bootstrap is also working</p>
            <p><a className=\"btn btn-primary btn-lg\" href=\"#\" role=\"button\">Learn more</a></p>
        </div>
    );
};

export default Application;
">./app/components/Application.jsx


# Create the Gulpfile
echo -e "const gulp = require('gulp');
const browserify = require('browserify');
const source = require('vinyl-source-stream');
const plug = require('gulp-load-plugins')({ lazy: true });
const sourcemaps = require('gulp-sourcemaps');

gulp.task('react', function () {
  return browserify({
    entries: ['./node_modules/whatwg-fetch/fetch.js', './src/app.jsx'],
    extensions: ['.jsx', '.js'],
    paths: ['./src/components/']
  })
    .transform('babelify', {
      //The order of this is important
      presets: ['es2015', 'stage-0', 'react']
    })
    .pipe(plug.jshint())
    .pipe(plug.jshint.reporter('stylish', { verbose: true }))
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest('./public/build/'))
});

gulp.task('sasstocss', function () {
  gulp.src('./src/styles/scss/styles.scss')
    .pipe(plug.autoprefixer({ browsers: ['last 2 versions'], cascade: false }))
    .pipe(plug.sass())
    .pipe(plug.cssmin())
    .pipe(plug.rename('styles.min.css'))
    .pipe(gulp.dest('./src/styles/css'));
});


gulp.task('sourcemaps', function () {
  gulp.src('public/build/*.js')
    .pipe(sourcemaps.init())
    .pipe(sourcemaps.write('../maps'))
    .pipe(gulp.dest('public/maps/'));
});

gulp.task('watch', function () {
  gulp.watch('./src/components/**/*.jsx', ['react', 'sourcemaps']);
  gulp.watch('./src/styles/scss/**/*.scss', ['sasstocss'])
});


gulp.task('default', ['react', 'sasstocss', 'sourcemaps', 'watch']);"> Gulpfile.js

# Create the .babelrc file
echo -e "{
  \"presets\": [\"es2015\", \"stage-0\", \"react\"]
}"> ./.babelrc


echo -e "<!doctype html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\"
          content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
    <link rel=\"stylesheet\" href=\"node_modules/bootstrap/dist/css/bootstrap.min.css\">
    <link rel=\"stylesheet\" href=\"app/styles/css/styles.min.css\">
    <title>React Basic Setup</title>
</head>
<body>
<div id=\"app\"></div>
<script src=\"public/build/app.js\"></script>
</body>
</html>">index.html

# Launch the application

sed -i '/"test":/i \\t"clean": "rm -f ./*.js; rm -f .\/*.js.map; rm -f .\/intermediates\/*.js; rm -f .\/intermediates\/*.js.map",' package.json
sed -i '/"clean":/a \\t"serve": ".\/node_modules\/.bin\/live-server --host=localhost --port=8080 .",' package.json
sed -i '/"serve":/i \\t"go": "concurrent \\"npm run serve\\" ",' package.json

echo -e "\n\n\t\e[1;32mLaunching application.\n\n\e[0m"
npm run serve &
gulp
