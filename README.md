grunt-static-website
===============================

静的サイト制作用の汎用gruntタスクテンプレートです。

# インストール
```
mkdir yourProject/
cd yourProject
git clone git@github.com:takumi0125/grunt-static-website.git
cd ./grunt
npm install
```
<a href="http://sass-lang.com/" target="_blank">sass/scss</a>, <a href="http://compass-style.org/" target="_blank">compass</a>がインストールされていない場合はインストールしてください。

# タスク一覧

bower.jsonで定義されているJSライブラリをインストール (後述)
```
grunt init
```

bower.jsonで定義されているJSライブラリをインストール (後述)
```
grunt init
```


# bawer

bower.jsonに設定を記述することにより、grunt init コマンドで
```
src/common/js/lib/
```
ディレクトリにJSライブラリが自動で配置されます。

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
