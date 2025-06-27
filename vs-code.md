---
description: VS code 関連
---

# VS code関連

## phpのvar\_dumpについて(書き途中)

PHPのデバックでよく利用する`var_dump`ですが、以下のように`<pre>`で挟んで記述すると整形された形に出力されるので、おすすめです。

```php
echo '<pre>';
var_dump($xxx);
echo '</pre>';
```

もし上記が気に入った場合、VS codeのスニペット登録もおすすめです。

スニペットはユーザー辞書機能と思ってください。

### スニペットの登録方法

* Windows
  * メニュー > 「ファイル」>「ユーザー設定」>「ユーザースニペット」を選択します。
* Mac
  * 「Code」から「Preferences（環境設定）」と進み、「User Snippets（ユーザースニペット）」を選択します。

上部に入力欄が出てくるので、`php`と入力。候補に`php.json`が出てくるのでそれを選択

以下のように記述

```json
    "var_dump見やすく": {
        "prefix": "var",
        "body": [
            "echo '<pre>';",
            "var_dump(\\$${1:xxx});",
            "echo '</pre>';"
        ],
        "description": "var_dump見やすくするやつ"
    },
```

_**(保存後、もしかしたらvs code再起動したほうが良いかも。)**_

設定完了後、PHPファイルで`var`と入力するたびに、候補に上記設定した候補が出てきます。

## おすすめ拡張機能

* Japanese Language Pack for Visual Studio Code download: 140万
  * 日本語化
* Code Spell Checker download: 150万
  * 英単語のスペルミスを修正してくれる。
  * 短縮単語（例えば、ボタンをbtnと書いたり）も引っかかるので、その場合は任意の単語を登録してあげる必要有り
* PHP Intelephense
  * PHPの総合補助ツール。
  * 個人的には、`php intellisense`よりこっちおすすめ。必要な設定がいらない（少ないし。）
* Material Icon Theme download: 470万
  * アイコンのテーマ関係は他にもあるので、自分で好きなものを。有ったほうがわかりやすいしかっこいい。
* indent-rainbow download: 98万
  * インデントの背景色を変えてくれる。
  * ちゃんとインデントが揃っているかが目でわかる。

他にもたくさん有るので\[php vscode 拡張機能]とかでググってください。
