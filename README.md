grunt-static-website
===============================

静的サイト制作用の汎用gruntタスクテンプレートです。

## インストール
```
mkdir yourProject/
cd yourProject
git clone git@github.com:takumi0125/grunt-static-website.git
cd ./grunt
npm install
```
<a href="http://sass-lang.com/" target="_blank">Sass/Scss</a>, <a href="http://compass-style.org/" target="_blank">Compass</a>がインストールされていない場合はインストールしてください。

## 概要

grunt コマンドで grunt/src/ の中身がタスクで処理され、htdocs/ に展開されます。  
grunt watcher コマンドでローカルサーバが立ち上がります。実行中は http://localhost:50000/ で展開後のページが確認できます。


### 主要タスク

grunt/src/ の中身を各種タスクで処理し、ディレクトリ構造を保ちつつ htdocs/ にコピーします。grunt init は実行されません。
```
grunt
```

bower.jsonで定義されているJSライブラリをインストール(後述)します。開発開始時に実行して下さい。
```
grunt init
```

ディレクトリを監視し、変更が会った場合適宜タスクを実行します。また、ローカルサーバを立ち上げます。
```
grunt watcher
```

### 個別タスク

```
grunt html
```
Jade のコンパイルを実行し、htdocs/ に展開します。拡張子が .html のファイルは htdocs/ にコピーされます。

```
grunt css
```
Sass/SCSS (+Compass)、Stylusのコンパイルを実行し、 htdocs/ に展開し、 autoprefixer を実行します。拡張子が .css のファイルは htdocs/ にコピーされます。

```
grunt css
```
JS 文法チェック、 CoffeeScript 文法チェック、 CoffeeScript コンパイル、TypeScript コンパイルを実行し、htdocs/ に展開します。拡張子が .js のファイルは htdocs/ にコピーされます。

```
grunt image
```
grunt-spritesmith を使用してスプライト画像を生成します。生成されたスプライト画像とSCSSファイル src/ ディレクトリに展開されます。

```
grunt image
```
JSON文法チェック後、 htdocs/ にコピーされます。




## bower

bower.json に設定を記述することにより、grunt init コマンドで src/common/js/lib/ ディレクトリに JS ライブラリが自動で配置されます。

```
{
  "name": "project libraries",
  "version": "0.0.0",
  "authors": "",
  "license": "MIT",
  "private": true,
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "test",
    "tests"
  ],
  "devDependencies": {
    "jquery": "1",
    "jquery.easing": "~1.3.1",
    "gsap": "~1.13.1",
    "EaselJS": "*",
    "PreloadJS": "*",
    "underscore": "~1.7.0",
    "swfobject": "*"
  },
  "exportsOverride": {
    "jquery": {
      "main": [
        "dist/jquery.min.js"
      ]
    },
    "jquery.easing": {
      "main": [
        "js/jquery.easing.min.js"
      ]
    },
    "gsap": {
      "main": [
        "src/minified/TweenMax.min.js"
      ]
    },
    "underscore": {
      "main": [
        "underscore-min.js"
      ]
    }
  }
}

```

テンプレートでは、exportsOverrideを指定してminifyされたファイルがインストールされるようになっています。  
ライブラリが不要であれば devDependencies から削除してください。
