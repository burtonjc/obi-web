gulp = require 'gulp'
gutil = require 'gulp-util'

gulp.task 'default', ['less', 'jade', 'coffee', 'copy']

gulp.task 'clean', ->
  gulp.src 'client/dist', read: false
    .pipe require('gulp-clean')()

gulp.task 'copy', ->
  gulp.src 'client/vendor/**/*'
    .pipe gulp.dest 'client/dist/vendor'

gulp.task 'coffee', ->
  sourcemaps = require 'gulp-sourcemaps'
  gulp.src 'client/src/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe require('gulp-coffee')().on 'error', gutil.log
    .pipe sourcemaps.write '.'
    .pipe gulp.dest 'client/dist/js/'

gulp.task 'test', ->
  gulp.src ['spec/spec-helper.coffee', 'spec/**/*spec.coffee']
    .pipe require('gulp-mocha') reporter: 'dot'

gulp.task 'less', ->
  gulp.src 'client/styles/application/**/*.less'
    .pipe require('gulp-less') compress: true
    .pipe require('gulp-minify-css') keepBreaks: false
    .pipe require('gulp-concat') 'application.css', newLine: ' '
    .pipe gulp.dest 'client/dist/css'
  gulp.src 'client/styles/marketing/**/*.less'
    .pipe require('gulp-less') compress: true
    .pipe require('gulp-minify-css') keepBreaks: false
    .pipe require('gulp-concat') 'marketing.css', newLine: ' '
    .pipe gulp.dest 'client/dist/css'

gulp.task 'jade', ->
  gulp.src 'client/partials/**/*.jade'
    .pipe require('gulp-jade')()
    .pipe gulp.dest 'client/dist/partials'

gulp.task 'watch', ['default'], ->
  gulp.watch ['client/styles/**/*.less'], ['less']
  gulp.watch ['client/partials/**/*.jade'], ['jade']
  gulp.watch ['client/src/**/*.coffee'], ['coffee']
  gulp.watch ['client/vendor/**/*'], ['copy']

gulp.task 'watch:test', ['test'], ->
  gulp.watch ['src/**/*.coffee', 'spec/**/*.coffee'], ['test']

gulp.task 'start', ->
  {spawn} = require 'child_process'
  bunyan = spawn 'node', [], stdio: ['pipe', process.stdout, process.stderr]
  nodemon = require 'nodemon'
  S = require 'string'
  require 'colors'

  nodemon
    script: "#{__dirname}/server/server.coffee"
    ext: 'coffee'
    execMap:
      'coffee': 'coffee --nodejs --harmony'
    ignore: [
      'node_modules/'
      'spec/'
      'gulpfile.coffee'
    ]
    stdout: false
  .on 'restart', (file) ->
    file = S(file).chompLeft "#{__dirname}/"
    console.log "\nChange in #{file}. Restarting...\n".grey
  .on 'readable', ->
    bunyan?.kill()

    bunyan = spawn "#{__dirname}/node_modules/.bin/bunyan", ['--color']

    bunyan.stdout.pipe process.stdout
    bunyan.stderr.pipe process.stderr

    this.stdout.pipe bunyan.stdin
    this.stderr.pipe bunyan.stdin
