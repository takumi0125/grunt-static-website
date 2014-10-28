'use strict'

# Node.js モジュール読込
path = require 'path'

# LiveReload スニペット読込
lrUtils = require 'grunt-contrib-livereload/lib/utils'
lrSnippet = lrUtils.livereloadSnippet

# LiveReload 用ヘルパー関数
folderMount = (connect, point) ->
  return connect.static path.resolve(point)


#
# Grunt 主要設定
# --------------
module.exports = (grunt) ->

  #
  # Grunt 初期設定オブジェクト (`grunt.initConfig()` の引数として渡す用)
  #
  conf =

    # `package.json` を (`<%= pkg.PROP  %>` として読込)
    pkg: grunt.file.readJSON 'package.json'

    # バナー文字列 (`<%= banner %>` として読込)
    banner: """
      /*!
       * <%= pkg.title || pkg.name %>
       * v<%= pkg.version %> - <%= grunt.template.today('isoDateTime') %>
       */
      """

    # 基本パス設定 (`<%= path.PROP %>` として読込)
    path:
      source: 'src'
      publish: path.join '..', 'htdocs'


    ################
    ###   init   ###
    ################

    #
    # Bowerによるライブラリインストールタスク
    #
    # * [grunt-bower-task](https://github.com/yatskevich/grunt-bower-task)
    #
    bower:
      source:
        options:
          targetDir: '<%= path.source %>'
          layout: (type, component, source)->
            if type is 'css'
              return path.join 'common', 'css', 'lib'
            else
              return path.join 'common', 'js', 'lib'
          install: true
          verbose: true
          cleanTargetDir: false
          cleanBowerDir: false


    ################
    ###   html   ###
    ################ 
    
    #
    # Jade コンパイルタスク
    #
    # * [grunt-contrib-jade](https://github.com/gruntjs/grunt-contrib-jade)
    #
    jade:
      options:
        pretty: true
        data: ->
          return grunt.file.readJSON './src/data.json'
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: '**/!(_)*.jade'
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.html'


    ###############
    ###   css   ###
    ###############

    #
    # Sass / SassyCSS コンパイルタスク
    #
    # * [grunt-contrib-sass](https://github.com/gruntjs/grunt-contrib-sass)
    #
    sass:
      options:
        unixNewlines: true
        compass: true
        noCache: false
        sourcemap: 'none'
        style: 'expanded'
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/!(_)*.sass'
          '**/!(_)*.scss'
        ]
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.css'

    # Stylus コンパイルタスク
    #
    # * [grunt-contrib-stylus](https://github.com/gruntjs/grunt-contrib-stylus)
    #
    stylus:
      options:
        compress: false
        'include css': false
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: '**/!(_)*.styl'
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.css'
    
    #
    # CSS スプライト作成タスク
    #
    # * [grunt-spritesmith](https://github.com/Ensighten/grunt-spritesmith)
    #
    sprite:
      index:
        src: [ '<%= path.source %>/img/_sprites/*' ]
        destImg: '<%= path.source %>/img/sprites.png'
        destCSS: '<%= path.source %>/css/_sprites.scss'
        imgPath: '/img/sprites.png'
        algorithm: 'binary-tree'
        padding: 1
      common:
        src: [
          '<%= path.source %>/common/img/_sprites/*'
        ]
        destImg: '<%= path.source %>/common/img/sprites.png'
        destCSS: '<%= path.source %>/common/css/_sprites.scss'
        imgPath: '/common/img/sprites.png'
        algorithm: 'binary-tree'
        padding: 1

    #
    # autoprefixer タスク
    #
    # * [grunt-autoprefixer](https://github.com/nDmitry/grunt-autoprefixer)
    #
    autoprefixer:
      options: ''
      source:
        expand: true
        cwd: '<%= path.publish %>'
        src: '**/!(_)*.css'
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.css'


    ##############
    ###   js   ###
    ##############

    #
    # CoffeeScript 静的解析タスク
    #
    # * [grunt-coffeelint](https://github.com/vojtajina/grunt-coffeelint)
    # * [CoffeeLint options](http://www.coffeelint.org/#options)
    #
    coffeelint:
      options:
        indentation: 2
        max_line_length: 80
        camel_case_classes: true
        no_trailing_semicolons:  true
        no_implicit_braces: true
        no_implicit_parens: false
        no_empty_param_list: true
        no_tabs: true
        no_trailing_whitespace: true
        no_plusplus: false
        no_throwing_strings: true
        no_backticks: true
        line_endings: true
        no_stand_alone_at: false
      general:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*.coffee'
          '!**/lib/**/*'
        ]
        filter: 'isFile'

    #
    # CoffeeScript コンパイルタスク
    #
    # * [grunt-contrib-coffee](https://github.com/gruntjs/grunt-contrib-coffee)
    #
    coffee:
      options:
        bare: false
        sourceMap: false
      general:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*.coffee'
          '**/*.litcofee'
        ]
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.js'

    #
    # TypeScript コンパイルタスク
    #
    # * [grunt-typescript](https://github.com/k-maru/grunt-typescript)
    #
    typescript:
      options:
        sourceMap: true
        module: 'amd'
        target: 'es5'
        declaration: false
      general:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*.ts'
          '!**/*.d.ts'
        ]
        filter: 'isFile'
        dest: '<%= path.publish %>'
        ext: '.js'

    #
    # JSHint による JavaScript 静的解析タスク
    #
    # * [grunt-contrib-jshint](https://github.com/gruntjs/grunt-contrib-jshint)
    #
    jshint:
      options:
        jshintrc: '.jshintrc'
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*.js'
          '!**/lib/**/*.js'
        ]
        filter: 'isFile'


    ################
    ###   json   ###
    ################

    #
    # JSON 静的解析タスク
    #
    # * [grunt-jsonlint](https://github.com/brandonramirez/grunt-jsonlint)
    #
    jsonlint:
      source:
        src: [
          '<%= path.source %>/**/*.json'
          'package.json'
        ]
        filter: 'isFile'


    #################
    ###   clean   ###
    #################

    #
    # ファイルとディレクトリ削除タスク
    #
    # * [grunt-contrib-clean](https://github.com/gruntjs/grunt-contrib-clean)
    #
    clean:
      options:
        force: true
      general:
        src: '<%= path.publish %>'


    ###################
    ###   connect   ###
    ###################

    #
    # ローカルサーバー (Connect) と LiveReload タスク
    #
    # * [grunt-contrib-connect](https://github.com/gruntjs/grunt-contrib-connect)
    # * [grunt-contrib-livereload](https://github.com/gruntjs/grunt-contrib-livereload)
    #
    connect:
      publish:
        options:
          port: 50000
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, '../htdocs')]


    ################
    ###   copy   ###
    ################

    #
    # ファイルコピータスク
    #
    # * [grunt-contrib-copy](https://github.com/gruntjs/grunt-contrib-copy)
    #
    copy:
      general:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*'
          '!**/*.coffee'
          '!**/*.ts'
          '!**/*.jade'
          '!**/*.less'
          '!**/*.sass'
          '!**/*.scss'
          '!**/*.styl'
          '!**/_*/*'
          '!**/_*'
          '!data.json'
          '!README.md'
          '!**/.git/*'
          '!**/.gitkeep'
        ]
        filter: 'isFile'
        dest: '<%= path.publish %>'


    ##################
    ###   notify   ###
    ##################

    #
    # メッセージ通知タスク
    #
    # * [grunt-notify](https://github.com/dylang/grunt-notify)
    #
    notify:
      build:
        options:
          title: 'ビルド完了'
          message: 'タスクが正常終了しました。'
      watch:
        options:
          title: '監視開始'
          message: 'ローカルサーバーを起動しました: http://localhost:50000/'

   
    ##################
    ###   concat   ###
    ################## 

    #
    # ファイル結合タスク
    #
    # * [grunt-contrib-concat](https://github.com/gruntjs/grunt-contrib-concat)
    #
    # concat:
      # options:
        # separator: ''
      # easeljs:
        # src: []
        # dest: '<%= path.source %>/common/js/build.js'


    #################
    ###   watch   ###
    #################

    #
    # ファイル更新監視タスク
    #
    # * [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch)
    #
    watch:
      options:
        livereload: true
      image:
        files: [
          '<%= path.source %>/**/img/**/*'
        ]
        tasks: [
          'image'
          'copy'
          'notify:build'
        ]
      css:
        files: [
          '<%= path.source %>/**/*.css'
          '<%= path.source %>/**/*.sass'
          '<%= path.source %>/**/*.scss'
        ]
        tasks: [
          'css'
          'copy'
          'notify:build'
        ]
      html:
        files: [
          '<%= path.source %>/**/*.html'
          '<%= path.source %>/**/*.jade'
        ]
        tasks: [
          'html'
          'copy'
          'notify:build'
        ]
      js:
        files: [
          '<%= path.source %>/**/*.coffee'
          '<%= path.source %>/**/*.js'
        ]
        tasks: [
          'js'
          'copy'
          'notify:build'
        ]
      json:
        files: '<%= path.source %>/**/*.json'
        tasks: [
          'json'
          'html'
          'copy'
          'notify:build'
        ]

  #
  # 実行タスクの順次定義 (`grunt.registerTask tasks.TASK` として登録)
  #
  tasks =
    init: [
      'bower'
    ]
    css: [
      'sass'
      'stylus'
      'autoprefixer'
    ]
    html: [
      'jade'
    ]
    image: [
      'sprite'
    ]
    js: [
      'jshint'
      'coffeelint'
      'coffee'
      'typescript'
    ]
    json: [
      'jsonlint'
    ]
    watcher: [
      'notify:watch'
      'connect'
      'watch'
    ]
    default: [
      'clean'
      'image'
      'css'
      'html'
      'js'
      'json'
      'copy'
      'notify:build'
    ]


  # Grunt プラグイン読込
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-spritesmith'
  grunt.loadNpmTasks 'grunt-typescript'

  # 初期設定オブジェクトの登録
  grunt.initConfig conf

  # 実行タスクの登録
  grunt.registerTask 'init',    tasks.init
  grunt.registerTask 'css',     tasks.css
  grunt.registerTask 'html',    tasks.html
  grunt.registerTask 'image',   tasks.image
  grunt.registerTask 'js',      tasks.js
  grunt.registerTask 'json',    tasks.json
  grunt.registerTask 'watcher', tasks.watcher
  grunt.registerTask 'default', tasks.default
