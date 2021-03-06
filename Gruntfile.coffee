path = require 'path'


module.exports = (grunt) ->
  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        bare: true
      dev:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: 'app/scripts/'
          src: [ '**/*.coffee' ]
          dest: '.tmp/scripts/'
          ext: '.js'
        ]
      dist:
        options:
          sourceMap: false
        files: [
          expand: true
          cwd: 'app/scripts/'
          src: [ '**/*.coffee' ]
          dest: 'dist/scripts/'
          ext: '.js'
        ]

    jade:
      options:
        pretty: true
      dev:
        files: [
          expand: true
          cwd: 'app/'
          src: [
            '*.jade'
            'views/**/*.jade'
          ]
          dest: '.tmp/'
          ext: '.html'
        ]
      dist:
        files: [
          expand: true
          cwd: 'app/'
          src: [
            '*.jade'
            'views/**/*.jade'
          ]
          dest: 'dist/'
          ext: '.html'
        ]

    less:
      dev:
        options:
          yuicompress: false
        files: [
          expand: true
          cwd: 'app/styles/'
          src: [ '**/*.less' ]
          dest: '.tmp/styles/'
          ext: '.css'
        ]
      dist:
        options:
          yuicompress: true
        files: [
          expand: true
          cwd: 'app/styles/'
          src: [ '**/*.less' ]
          dest: 'dist/styles/'
          ext: '.css'
        ]

    copy:
      dev_html:
        files: [
          expand: true
          dot: true
          cwd: 'app'
          dest: '.tmp'
          src: [
            '*.html'
            'views/*.html'
          ]
        ]
      dev_resources:
        files: [
          expand: true
          dot: true
          cwd: 'app'
          dest: '.tmp'
          src: [
            '**/*'
            '!assets/**/*'
            '!scripts/**/*.coffee'
            '!styles/**/*.less'
            '!views/**/*.jade'
            '!*.jade'
          ]
        ]
      dist:
        files: [
          expand: true
          dot: true
          cwd: 'app'
          dest: 'dist'
          src: [
            '**/*'
            '!bower_components/**/*'
            'bower_components/bootstrap/dist/css/bootstrap.css'
            'bower_components/font-awesome/css/font-awesome.css'
            'bower_components/font-awesome/fonts/**/*'
            'bower_components/jquery/jquery.js'
            'bower_components/bootstrap/dist/js/bootstrap.js'
            'bower_components/angular/angular.js'
            'bower_components/angular-route/angular-route.js'
            'bower_components/angular-resource/angular-resource.js'
            'bower_components/soundmanager/script/soundmanager2.js'
            '!assets/**/*'
            '!scripts/**/*.coffee'
            '!styles/**/*.less'
            '!views/**/*.jade'
            '!*.jade'
          ]
        ]
      dist_font:
        files: [
          expand: true
          dot: true
          cwd: 'app/bower_components/font-awesome/font/'
          dest: 'dist/font/'
          src: [
            '**/*'
          ]
        ]
      dist_node_modules:
        files: [
          expand: true
          dot: true
          cwd: 'node_modules/'
          dest: 'dist/node_modules/'
          src: [
            'async/**/*'
            'grooveshark-streaming/**/*'
            'request/**/*'
            'ytdl/**/*'
          ]
        ]
      dist_ffmpegsumo_mac:
        files: [
          expand: true
          dot: true
          cwd: 'webkit_deps/mac/'
          dest: 'webkitbuilds/releases/howabout/mac/howabout.app/Contents/Frameworks/node-webkit Framework.framework/Libraries/'
          src: [
            'ffmpegsumo.so'
          ]
        ]
      dist_ffmpegsumo_win:
        files: [
          expand: true
          dot: true
          cwd: 'webkit_deps/win/'
          dest: 'webkitbuilds/releases/howabout/win/howabout/'
          src: [
            'ffmpegsumo.dll'
          ]
        ]

    cdnify:
      dist:
        html: [ 'dist/*.html' ]

    useminPrepare:
      html: [ 'dist/*.html' ]
      options:
        dest: 'dist/'

    usemin:
      html: [ 'dist/*.html' ]
      options:
        dirs: [ 'dist/' ]

    htmlmin:
      dist:
        options:
          removeCommentsFromCDATA: true
          # https://github.com/yeoman/grunt-usemin/issues/44
          collapseWhitespace: true
          collapseBooleanAttributes: true
          # removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true
        files: [
          expand: true
          cwd: 'dist/'
          src: [ '*.html', 'views/*.html' ]
          dest: 'dist/'
        ]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: 'app/images/'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: 'dist/images/'
        ]

    watch:
      dev_scripts:
        files: [ 'app/scripts/**/*.coffee' ]
        tasks: [ 'coffee:dev' ]
      dev_styles:
        files: [ 'app/styles/**/*.less' ]
        tasks: [ 'less:dev' ]
      dev_views:
        files: [
          'app/*.jade'
          'app/views/**/*.jade'
        ]
        tasks: [ 'jade:dev' ]
      dev_assets:
        files: [ 'app/assets/*' ]
        tasks: [ 'copy:assets' ]
      # dev_others:
      #   files: [
      #     'app/**/*'
      #     '!app/bower_components'
      #     '!app/assets/**/*'
      #     '!app/scripts/**/*.coffee'
      #     '!app/styles/**/*.less'
      #     '!app/views/**/*.jade'
      #     '!app/*.jade'
      #   ]
      #   tasks: [
      #     'copy:dev_resources'
      #   ]

    clean: 
      dev: [ '.tmp/' ]
      dist: [ 'dist/' ]
      dist_original_scripts: [
        'dist/scripts/**/*.js'
        '!dist/scripts/script.usemin.js'
      ]
      dist_original_styles: [
        'dist/styles/**/*.css'
        '!dist/styles/style.usemin.css'
      ]
      webkit_releases: [
        'webkitbuilds/releases'
      ]

    nodewebkit:
      options:
        build_dir: 'webkitbuilds'
        mac: true
        win: false
        linux32: false
        linux64: false
      src: [ 'dist/**/*' ]


  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'build', [
    'build:dev'
    'build:dist'
  ]

  grunt.registerTask 'dev', [
    'build:dev'
    'watch'
  ]

  grunt.registerTask 'build:dev', [
    'clean:dev'
    'coffee:dev'
    'jade:dev'
    'less:dev'
    'copy:dev_html'
    'copy:dev_resources'
  ]

  grunt.registerTask 'build:dist', [
    'clean:dist'
    'coffee:dist'
    'jade:dist'
    'less:dist'
    'copy:dist'
    'copy:dist_font'
    'useminPrepare'
    'concat'
    'uglify'
    'cssmin'
    'usemin'
    'htmlmin:dist'
    'cdnify'
    'imagemin:dist'
    'clean:dist_original_scripts'
    'clean:dist_original_styles'
    'copy:dist_node_modules'
  ]

  grunt.registerTask 'webkit', [
    'build:dist'
    'clean:webkit_releases'
    'nodewebkit'
    'copy:dist_ffmpegsumo_mac'
    'copy:dist_ffmpegsumo_win'
  ]
