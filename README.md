grunt-static-website
===============================

静的サイト制作用の汎用gruntタスクテンプレートです。

## インストール
```bash
mkdir yourProject/
cd yourProject
git clone git@github.com:takumi0125/grunt-static-website.git
cd grunt
npm install
```
<a href="http://sass-lang.com/" target="_blank">Sass/SCSS</a>, <a href="http://compass-style.org/" target="_blank">Compass</a>がインストールされていない場合はインストールしてください。

## 概要

基本構造は  
<a href="https://github.com/takumi0125/static-website-basic-src" target="_blank">takumi0125/static-website-basic-src</a>  
を使用しています。


`grunt` コマンドで `grunt/src/` の中身がタスクで処理され、ディレクトリ構造を保ちつつ `htdocs/` に展開されます。

`grunt watcher` コマンドでローカルサーバが立ち上がります。実行中は
```
http://localhost:50000/
```
で展開後のページが確認できます。


### 主要タスク

`grunt/src/` の中身を各種タスクで処理し `htdocs/` に展開します。`grunt init` は実行されません。
```
grunt
```

`bower.json` で定義されているJSライブラリをインストール(後述)します。開発開始時に実行して下さい。
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
Jade のコンパイルを実行し、 `htdocs/` に展開します。また、拡張子が .html のファイルは `htdocs/` 以下にコピーされます。

```
grunt css
```
Sass/SCSS (+Compass) のコンパイルを実行し、 `htdocs/` に展開されます。また、拡張子が .css のファイルは `htdocs/` 以下にコピーされます。その後、htdocs/ 内のcss に対して <a href="https://github.com/nDmitry/grunt-autoprefixer" target="_blank">grunt-autoprefixer</a> を実行します。

```
grunt js
```
CoffeeScript 文法チェック、 CoffeeScript コンパイル、TypeScript コンパイルを実行し、`htdocs/` に展開します。また、拡張子が .js のファイルは文法チェック後に `htdocs/` 以下にコピーされます。

```
grunt json
```
JSON文法チェック後、 `htdocs/` 以下にコピーされます。

```
grunt img
```
<a href="https://github.com/Ensighten/grunt-spritesmith" target="_blank">grunt-spritesmith</a> を使用してスプライト画像を生成します。生成されたスプライト画像と SCSS ファイルが `src/` 以下に展開されます。

また、 <a href="https://github.com/gruntjs/grunt-contrib-concat" target="_blank">grunt-contrib-concat</a> を使用する場合は適宜タスクを追加してください。

その他個別タスクは `Gruntfile.coffee` をご参照ください。


## スプライト生成タスク

スプライト画像を生成する場合は、スプライト画像生成タスクを追加する
```
createSpritesTasks
```
を使用してください。使用方法は `Gruntfile.coffee` の54行目以降に記載されています。呼び出す場合は conf, task が定義された後に呼び出します。サンプルでは488行目で呼び出しています。



## bower

`bower.json` に設定を記述することにより、`grunt init` コマンドで `src/common/js/lib/` に JS ライブラリが自動で配置されます。

```js
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

テンプレートでは、 exportsOverride を指定して minify されたファイルがインストールされるようになっています。ライブラリが不要であれば devDependencies から削除してください。
