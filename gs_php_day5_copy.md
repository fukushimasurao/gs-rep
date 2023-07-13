# 014\_gs\_php\_day5

## 前回のおさらい

* sessionを学んで、ログインをした。

## 今回やること

もうphpで大体のことができるようになりました。
わからないことはググればわかると思います。
さて、次回からLaravelの実習に入ります。

そこで、Laravelで使われている技術に触れて、少しでもLaravelと相思相愛になれるようにしましょう。

## MAMPの起動、DB準備

1. MAMPを起動
2. WebStartボタンから起動トップページを表示
3. ページの真ん中MySQLのタブからphpMyAdminのリンクをクリック
4. 起動した画面がMySQLを管理するphpMyAdminの画面が表示されます。
5. データベースタブをクリック
6. データベースを作成から以下の名前で作成

```
データベース名：gs_db5
```

1. 作成ボタンをクリック 左側に`gs_db5`というデータベースができていると思います。 現在は空っぽです。

## SQLファイルからインポート

〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db5`をクリック
2. `gs_db5`を選択した状態でインポートタブをクリック
3. sqlファイルをインポート
4. 実行してみる
5. 授業用のDBと中身を確認

\*\*DBの中身も確認しておいてください。\*\*

## 今日のやることのイメージ

(授業で見せます)

## 今日のゴール

* フレームワークを知る
* MVCモデルを知る
* Classに入門する

### フレームワークとは？

開発が簡単になるように色々な機能がパッケージ化されているもの。
必要に応じて、機能を追加していく。

厳密な比較は難しいですが。

* ライブラリ ... とある１部品の機能をまとめたもの。
* フレームワーク ... さまざまな部品をまとめたもの。

というイメージです。

### Laravelとは？

PHP用のフレームワークです。
WEB開発がスムーズにいくように、さまざまな機能が備わっています。

例えばログイン機能も、コマンド一つで簡単に実装できます。

### Laravelでログイン機能を実装してみる

(授業でやります)

### Laravelで採用されているMVCとは？

それぞれ、

* M ... Model
* V ... View
* C ... Controller

の頭文字です。

### MVCのそれぞれを知る

たくさんあるファイルを

* view : 画面(UI)を表示するファイル
* model : DBに接続したりDBの操作をすファイル
* controller : 画面から来たデータを処理したり、モデルに送ったりするファイル

のような役割に分けよう、ということです。

データの管理、UIの設計、それらの間のコントロールが分離/独立して開発・保守・再利用が可能になります。
これによりコードの可読性やメンテナンス性が向上するのです！

### MVCモデルを作って感じ取ろう

では、実際に作ってみましょう。

#### viewの分離

現状では、index.phpの中身は、

1. DB接続してデータを取得
2. 取得した内容をHTMLに渡す

という作業を一つのファイルで行っています。
これを変更しましょう。

* `htdocs/gs_code/php05/templates/list.php`を作成

この時点で、以下のようなファイルの形になります。

```bash
(他のファイルは省略)
index.php
funcs.php
detail.php
templates
┗━list.php
```

* index.phpのHTML部分すべてを`list.php`にコピペ
* index.phpのPHPコード部分の一番下に、`require 'templates/list.php';`を記入

これで`View`の分離ができました。

#### modelの分離

次に、modelを作成して、

* view
* controller
* model
の分離をしましょう。

このように分離すると、コントローラーはアプリケーションのモデルからデータを取得し、そのデータをレンダリングするテンプレート(=view)を呼び出すだけになります。

1. model.phpを作成してください。

この時点で、以下のようなファイルの形になります。

```bash
(他のファイルは省略)
index.php
funcs.php
detail.php
model.php( ← NEW!!)
templates
┗━list.php
```

2. index.phpのrequiewの ***１行以外全て***をmodel.phpに切り貼り

model.phpの中身を関数でまとめる。

(returnとか書き忘れ注意)

```php

<?php
function db_connect()
{
    try {
        $db_name = 'gs_db3'; //データベース名
        $db_id   = 'root'; //アカウント名
        $db_pw   = ''; //パスワード：MAMPは'root'
        $db_host = 'localhost'; //DBホスト
        $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
        return $pdo;
    } catch (PDOException $e) {
        exit('DB Connection Error:' . $e->getMessage());
    }
}

function get_all_posts($pdo)
{
    //２．データ登録SQL作成
    $stmt = $pdo->prepare('SELECT * FROM gs_an_table;');
    $status = $stmt->execute();

    //３．データ表示
    $view = '';
    if ($status === false) {
        $error = $stmt->errorInfo();
        exit('SQLError:' . print_r($error, true));
    } else {
        while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
            //GETデータ送信リンク作成
            // <a>で囲う。
            $view .= '<p>';
            $view .= '<a href="detail.php?id=' . $result['id'] . '">';
            $view .= $result['indate'] . '：' . $result['name'];
            $view .= '</a>';
            $view .= '<a href="delete.php?id=' . $result['id'] . '">';
            $view .= ' [削除] ';
            $view .= '</a>';
            $view .= '</p>';
        }
        return $view;
    }
}
```

※ `get_all_posts`の中でhtml書くのは嫌なんですが一旦これで。本当はここは修正するべきです。

3. `index.php`の修正

以下のように、modelをrequireして、DB接続と記事取得を行いましょう。

```php
<?php

require_once 'model.php';

$pdo = db_connect();
$view = get_all_posts($pdo);

require_once 'templates/list.php';

```

コレで、`MVC`の分離ができました。
どれがM/V/Cかわかりますか？

`list.php`が`view`, `index.php`が`controller`, `model.php`がモデルになります。

4. viewの分離

view部分に何か変更が入った場合を考えて、拡張性を高くします。

1. templates配下に、layout.phpを作成します。

```bash
(他のファイルは省略)
index.php
funcs.php
detail.php
model.php
templates
┗━list.php
┗━layout.php( ← NEW!!)
```

### Laravelの中身を見てみよう

### Classをほんのちょっぴり触ろう

#### Classを作る

#### インスタンスを作る

#### プロパティ、メソッドを作る

#### プロパティ、メソッド使ってみる

#### インスタンスメソッドを作って使ってみる
