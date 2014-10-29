'use strict'

SRC_DIR = './src'
PUBLISH_DIR = '../htdocs'
DATA_JSON = "_data.json"

BOWER_INSTALL_DIR_BASE = '/common' # '/common' or ''

paths =
  html: '**/*.html'
  jade: '**/*.jade'
  css: '**/*.css'
  sass: [
    '**/*.sass'
    '**/*.scss'
  ]
  js: '**/*.js'
  json: '**/*.json'
  coffee: '**/*.coffee'
  img: '**/img/**/*'
  others: [
    '**/*'

    '!**/*.html'
    '!**/*.jade'
    '!**/*.css'
    '!**/*.sass'
    '!**/*.scss'
    '!**/*.js'
    '!**/*.json'
    '!**/*.coffee'
    '!**/img/**/*'
    '!**/*.md'
    '!**/.git/**/*'
    '!**/.gitkeep'
    
    '!_*'
    '!**/_*/**/*'
  ]

#
# Grunt 主要設定
# --------------
module.exports = (grunt) ->
  # 頭に SRC_DIR/ をつけて返す
  addSrcPath = (path)-> "#{SRC_DIR}/#{path}"


  #「_」が先頭のファイル、ディレクトリを除外するように src 用の配列を生成
  createSrcArr = (name) ->
    ret = [].concat paths[name], '!_*', '!**/_*/**/*'

  #
  # spritesmith のタスクを生成
  # 
  # @param {string} taskName          タスクを識別するための名前 スプライトタスクが複数ある場合はユニークにする
  # @param {string} outputFileName    出力されるスプライト画像 / CSS (SCSS) の名前
  # @param {string} dirBase           コンテンツディレクトリのパス (SRC_DIRからの相対パス)
  # @param {string} outputImgPathType CSSに記述される画像パスのタイプ (absolute | relative)
  # @param {string} imgDir            dirBaseから画像ディレクトリへのパス
  # @param {string} cssDir            dirBaseからCSSディレクトリへのパス
  #
  # #{SRC_DIR}#{dirBase}#{imgDir}/_#{outputFileName}/
  # 以下にソース画像を格納せしておくと
  # #{SRC_DIR}#{dirBase}#{cssDir}/_#{outputFileName}.scss と
  # #{SRC_DIR}#{dirBase}#{imgDir}/#{outputFileName}.png が生成される
  # かつ watch タスクの監視も追加
  #
  #
  # CSS スプライト作成タスク
  #
  # * [grunt-spritesmith](https://github.com/Ensighten/grunt-spritesmith)
  #
  createSpritesTask = (taskName, dirBase, outputFileName = 'sprites', outputImgPathType = 'absolute', imgDir = '/img', cssDir = '/css') ->
    if !conf.hasOwnProperty('sprite') then conf.sprite = {}
    
    srcImgFiles = "#{SRC_DIR}#{dirBase}#{imgDir}/_#{outputFileName}/*"
    conf.sprite[taskName] =
      src:   [ srcImgFiles ]
      destImg: "#{SRC_DIR}#{dirBase}#{imgDir}/#{outputFileName}.png"
      destCSS: "#{SRC_DIR}#{dirBase}#{cssDir}/_#{outputFileName}.scss"
      algorithm: 'binary-tree'
      padding: 1
    if outputImgPathType is 'absolute'
      conf.sprite[taskName].imgPath = "#{dirBase}#{imgDir}/#{outputFileName}.png"

    if conf.watch.hasOwnProperty('sprite')
      conf.watch.sprite.files.push srcImgFiles
    else
      conf.watch.sprite =
        files: [ srcImgFiles ]
        tasks: [
          'sprite'
          'notify:build'
        ]
    conf.watch.img.files.push "!#{srcImgFiles}"


  #
  # Grunt 初期設定オブジェクト (`grunt.initConfig()` の引数として渡す用)
  #
  conf =

    # 各種パス設定 (`<%= path.PROP %>` として読込)
    path:
      source: './src'
      publish: '../htdocs'


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
          targetDir: "#{SRC_DIR}#{BOWER_INSTALL_DIR_BASE}"
          layout: (type, component, source)->
            if source.match /(.*)\.css/ then return 'css/lib'
            if source.match /(.*)\.js/ then return 'js/lib'
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
          return grunt.file.readJSON addSrcPath DATA_JSON
      source:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'jade'
        filter: 'isFile'
        dest: PUBLISH_DIR
        ext: '.html'


    ###############
    ###   css   ###
    ###############

    #
    # Sass/SCSS コンパイルタスク
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
        cwd: SRC_DIR
        src: createSrcArr 'sass'
        filter: 'isFile'
        dest: PUBLISH_DIR
        ext: '.css'

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
        cwd: SRC_DIR
        src: paths.coffee
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
        cwd: SRC_DIR
        src: createSrcArr 'coffee'
        filter: 'isFile'
        dest: PUBLISH_DIR
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
        cwd: SRC_DIR
        src: [
          paths.js
          '!**/lib/**/*.js' #ライブラリは除外
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
        expand: true
        cwd: SRC_DIR
        src: paths.json
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
        src: PUBLISH_DIR


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
          hostname: '*'
          base: PUBLISH_DIR
          livereload: true


    ################
    ###   copy   ###
    ################

    #
    # ファイルコピータスク
    #
    # * [grunt-contrib-copy](https://github.com/gruntjs/grunt-contrib-copy)
    #
    copy:
      html:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'html'
        filter: 'isFile'
        dest: PUBLISH_DIR
        
      css:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'css'
        filter: 'isFile'
        dest: PUBLISH_DIR

      js:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'js'
        filter: 'isFile'
        dest: PUBLISH_DIR

      json:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'json'
        filter: 'isFile'
        dest: PUBLISH_DIR

      img:
        expand: true
        cwd: SRC_DIR
        src: createSrcArr 'img'
        filter: 'isFile'
        dest: PUBLISH_DIR

      others:
        expand: true
        cwd: SRC_DIR
        src: paths.others
        filter: 'isFile'
        dest: PUBLISH_DIR


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
    concat:
      options:
        separator: ''
      easeljs:
        src: []
        dest: "#{SRC_DIR}/common/js/build.js"


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
      
      html:
        files: addSrcPath paths.html
        tasks: [
          'copy:html'
          'notify:build'
        ]
      
      jade:
        files: addSrcPath paths.jade
        tasks: [
          'jade'
          'notify:build'
        ]
      
      css:
        files: addSrcPath paths.css
        tasks: [
          'copy:css'
          'autoprefixer'
          'notify:build'
        ]
      
      sass:
        files: addSrcPath paths.sass
        tasks: [
          'sass'
          'notify:build'
        ]
      
      js:
        files: addSrcPath paths.js
        tasks: [
          'jshint'
          'js'
          'copy:js'
          'notify:build'
        ]
      
      json:
        files: addSrcPath paths.json
        tasks: [
          'jsonlint'
          'copy:json'
          'notify:build'
        ]
      
      coffee:
        files: addSrcPath paths.coffee
        tasks: [
          'coffeelint'
          'coffee'
          'notify:build'
        ]
      
      img:
        files: [ addSrcPath paths.img ]
        tasks: [
          'copy:img'
          'notify:build'
        ]

      others:
        files: addSrcPath paths.others
        tasks: [
          'copy:others'
          'notify:build'
        ]
      
      
  # spritesタスクを生成
  createSpritesTask 'common', '/common'
  createSpritesTask 'index', ''

  #
  # 実行タスクの順次定義 (`grunt.registerTask tasks.TASK` として登録)
  #
  tasks =
    init: [
      'bower'
    ]
    css: [
      'sass'
      'copy:css'
      'autoprefixer'
    ]
    html: [
      'jade'
      'copy:html'
    ]
    img: [
      'sprite'
      'copy:img'
    ]
    js: [
      'coffeelint'
      'coffee'
      'jshint'
      'copy:js'
    ]
    json: [
      'jsonlint'
      'copy:json'
    ]
    watcher: [
      'notify:watch'
      'connect'
      'watch'
    ]
    default: [
      'clean'
      'js'
      'json'
      'img'
      'css'
      'html'
      'copy:others'
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
  grunt.registerTask 'img',     tasks.img
  grunt.registerTask 'js',      tasks.js
  grunt.registerTask 'json',    tasks.json
  grunt.registerTask 'watcher', tasks.watcher
  grunt.registerTask 'default', tasks.default
