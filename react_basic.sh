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
sudo npm install --save-dev browser-sync

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


#The below plugins are optional
#sudo npm install --save-dev gulp-uglify
#sudo npm install --save-dev gulp-concat-css
sudo npm install --save-dev gulp-imagemin
sudo npm install --save-dev gulp-plumber


# Create the directory structure
mkdir -p ./{public/{css,js},src/{components,styles/scss}}
touch ./src/styles/scss/styles.scss
touch ./src/styles/css/styles.min.css


echo -e "import React from 'react';
import ReactDOM from 'react-dom';
import Application from 'Application';

ReactDOM.render(
    <Application/>,
    document.getElementById('root')
);">./src/index.js


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
">./src/components/Application.jsx


# Create the Gulpfile
echo -e "const gulp = require('gulp');
const browserify = require('browserify');
const source = require('vinyl-source-stream');
const browserSync = require('browser-sync').create();
const plug = require('gulp-load-plugins')({ lazy: true });


gulp.task('browser-sync', ['react', 'sasstocss', 'sourcemaps'], () => {
  browserSync.init({
    server: {
      baseDir: './public/',
      files: ['./public/css/*.css', './public/js/*.js'],
    },
  });
  gulp.watch('./src/components/**/*.jsx', ['react', 'lint', 'sourcemaps']);
  gulp.watch('./src/styles/scss/**/*.scss', ['sasstocss']);
});

gulp.task('react', () => {
  return browserify({
    entries: [
      './node_modules/whatwg-fetch/fetch.js',
      './src/index.js',
    ],
    extensions: ['.jsx', '.js'],
    paths: ['./src/components/'],
  })
    .transform('babelify', {
      presets: ['es2015', 'stage-0', 'react'],
    })
    .bundle()
    .pipe(plug.plumber())
    .pipe(source('app.js'))
    .pipe(gulp.dest('./public/js/'))
    .pipe(browserSync.stream());
});



gulp.task('sasstocss', () => {
  gulp.src('./src/styles/scss/styles.scss')
    .pipe(plug.plumber())
    .pipe(plug.autoprefixer({ browsers: ['last 2 versions'], cascade: false }))
    .pipe(plug.sass())
    .pipe(plug.cssmin())
    .pipe(plug.rename('styles.min.css'))
    .pipe(gulp.dest('./public/css/'))
    .pipe(browserSync.stream());
});

gulp.task('compress-images', () => {
   gulp.src('./src/styles/scss/styles.scss')
     .pipe(plug.imagemin())
     .pipe(gulp.dest('public/assets/img/'))
}

gulp.task('sourcemaps', () => {
  gulp.src('./public/js/*.js')
    .pipe(plug.plumber())
    .pipe(plug.sourcemaps.init())
    .pipe(plug.sourcemaps.write('../maps'))
    .pipe(gulp.dest('public/maps/'))
    .pipe(browserSync.stream());
});

gulp.task('watch', () => {
  gulp.watch('./src/components/**/*.jsx', ['react', 'lint', 'sourcemaps']);
  gulp.watch('./src/styles/scss/**/*.scss', ['sasstocss']);
});

gulp.task('default', ['browser-sync']);
"> Gulpfile.js

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
<div id=\"root\"></div>
<script src=\"js/app.js\"></script>
</body>
</html>">./public/index.html

# Launch the application

sed -i '/"test":/i \\t"clean": "rm -f ./public/maps/*.js",' package.json

echo -e "\n\n\t\e[1;32mLaunching application.\n\n\e[0m"

gulp
