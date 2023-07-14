# 014\_gs\_php\_day5

## 資料

[資料](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/PHP05.zip)

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

コードの修正等を行うので、プロダクトは有りません。

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

実際に見てみましょう。
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
* index.phpのPHPコード部分の一番下に、`require_once 'templates/list.php';`を記入
  * phpの閉じタグは不要なので消してしまってください。

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

具体的には、

* title
* body

部分は分離させます。
項目によってこの部分が変わるからです。
一方で、どのページでも変わらない部分をベースにします。

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

2. list.phpの中身を全部layout.phpにまるっとコピーしてください。
(この時点で、list.phpの中身とlayout.phpは同じです)

3. layout.phpの<title>と<body>部分を以下のように変更

```php
<!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= $title ?></title>   // ← ここ変更
    <link rel="stylesheet" href="css/range.css">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        div {
            padding: 10px;
            font-size: 16px;
        }
    </style>
</head>

<body id="main">
    <?= $content ?>   // ← ここ変更
</body>
</html>
```

4. `list.php`の中身を以下のように変更

```php
<?php $title = 'フリーアンケート表示'; ?>

<?php ob_start() ?>
<body id="main">
    <header>
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                </div>
            </div>
        </nav>
    </header>
    <div>
        <div class="container jumbotron">
            <a href="detail.php"></a>
            <?= $view ?>
        </div>
    </div>
</body>
<?php $content = ob_get_clean() ?>

<?php require_once 'layout.php' ?>
```

※ ob_start()...そこ以降の部分が内部のバッファに保存されます。
どこまでかというとob_get_clean()までです。

つまり、ob_start()とob_get_clean()で囲った部分が、内部に保存されて、その中身を$contentに入れているということです。

5. detailページも変更しよう！

detailも修正していきます。
detail.phpでやっていることは、

* DBに接続
* 指定のデータを一つだけ抜き出す
* それを表示

という内容です。

select.phpと少しだけ違うので、その部分を意識して書き直しましょう。

#### modelへ継ぎ足し

model部分に、select文の部分を追加しましょう。
（DB接続はすでにあるの不要です。）
※引数とreturn 忘れないでね！

```php
function get_post_by_id($pdo, $id)
{
    //３．データ登録SQL作成
    $stmt = $pdo->prepare('SELECT * FROM gs_an_table WHERE id = :id;');
    $stmt->bindValue(':id', $id, PDO::PARAM_INT); //PARAM_INTなので注意
    $status = $stmt->execute(); //実行

    $result = '';
    if ($status === false) {
        $error = $stmt->errorInfo();
        exit('SQLError:' . print_r($error, true));
    } else {
        $result = $stmt->fetch();
        return $result; // return忘れない！
    }
}
```

#### detail.phpの修正

ファイルの上から、

* `require_once 'model.php';`の追記

* `DB接続`ブロックは不要なので消す
* データを抜き出している部分も消す。modelに書いたので。
* modelから、db_connect()を読びつつ、get_post_by_id()で１つだけユーザーを取得する。

#### detail.phpの作成

* templatesの中に、`detail.php`を作成

```bash
(他のファイルは省略)
index.php
funcs.php
detail.php
model.php
templates
┗━list.php
┗━layout.php
┗━detail.php( ← NEW!!)
```

##### detail.phpにviewの中身を作成

`list.php`のように、`templates/detail.php`を以下のように書き換える。
<title>と<body>の中身を入れればok

最後に、`<?php require_once 'layout.php' ?>`を忘れない。

```php
<?php $title = 'データ編集' ?>

<?php ob_start() ?>
    <form method="POST" action="update.php">
        <div class="jumbotron">
            <fieldset>
                <legend>フリーアンケート</legend>
                <label>名前：<input type="text" name="name" value="<?= h($result['name']) ?>"></label><br>
                <label>Email：<input type="text" name="email" value="<?= $result['email'] ?>"></label><br>
                <label>年齢：<input type="text" name="age" value="<?= $result['age'] ?>"></label><br>
                <label><textarea name="content" rows="4" cols="40"> <?= $result['content'] ?> </textarea></label><br>
                <input type="hidden" name="id" value="<?= $result['id'] ?>">
                <input type="submit" value="更新">
            </fieldset>
        </div>
    </form>
<?php $content = ob_get_clean() ?>

<?php require_once 'layout.php' ?>
```

##### detail.phpの中身を作成

`templates/detail.php`の中に、view部分を書いたので、`detail.php`にviewを呼び出す。
最終的なファイルは以下の通り。

```php
require_once 'model.php';

$id = $_GET['id'];
$db_connect = db_connect();
$result = get_post_by_id($db_connect,$id);

require_once 'templates/detail.php';
```

detail.phpに関して言うと、

* View:detail.php
* Controller:detail.php
* Model:model.php

のような関係になっています。

#### 今後処理を追加する場合

あとの流れは一緒です。

* Viewを作成する
* Controllerを作成剃る
* Modelに必要あれば追記する

という流れになります。

### Laravelの中身を見てみよう

例えば`controller`

```php
class ArticleController extends Controller
{
    public function index()
    {
        $articles = Article::all();
        $data = ['articles' => $articles];
        return view('articles.index', $data);
    }

    public function store(Request $request)
    {
        $this->validate($request, [
            'title' => 'required|max:255',
            'body' => 'required'
        ]);
        $article = new Article();
        $article->title = $request->title;
        $article->body = $request->body;
        $article->save();

        return redirect(route('articles.index'));
    }

}
```

* `class`ってなんやろ
* `public`ってなんやろ
* `->`ってなんやろ

### Classをほんのちょっぴり触ろう

Laravelでは、(というか、WEB系のフレームワーク全般では)Classが必須です。
そこで、Classについて少しだけ学んで、Laravelの学習にスムーズに入れるようにしましょう。

#### Classとは？

Classとは何でしょうか？

基本的な説明はたいてい「ものごとを作るための設計図」とか言われます。

ただ、ここでは「変数と関数をまとめたもの」としましょう。

* 変数 ... 文字列や数字を格納するもの
* 関数 ... 機能をひとまとめにしたもの
* Class ... 変数や関数をひとまとめにしたもの！

#### Classを作る

classの使い方は、

1. クラスの定義を書く
2. クラスを利用する際に呼び出す

という流れです。**関数と同じ**です。
作っただけではだめです。必ず呼び出してあげましょう。

ただし呼び出すときは、

1. `new`とつけてあげます。
2. 作成したものを適当な変数に入れてあげます。

このクラスを呼び出すことを`インスタンス化`と言います。

代入したもの(↑だと、`$mini`)を`インスタンス`と言います。

このようにクラスは、インスタンス化して利用するという流れになります。

#### インスタンスを作る

実際にやってみましょう。
以下のように記述します。

```php
class Person {
}

// インスタンス化
$person = new Person();
```

※ class名は大文字にしてください。大文字が絶対です。
（大文字にしなくてもエラーはでませんが。）
先頭が大文字なのは、Pascal記法と言います。

※ インスタンス化するときは()をつけて上げてください。

この段階で、特にエラーが出なければokです。

#### プロパティ、メソッドを作って使う　その１

では、次にclassの中に変数・関数を格納していきましょう。

以下のように記載します。

```php
class Person {
    // public変数(プロパティ)
    public $firstName = 'fukushima';

    // publicメソッド
    public function sayHello() {
        echo  "こんにちは。私の名前は" . $this->firstName;
    }
}

// インスタンス化
$person = new Person();

// sayHelloメソッドを使用
$person->sayHello();
```

※ ちょっと面倒なんですが、`$this`は必要です。その英語の通り、「このクラス内のプロパティです」と明示してあげる必要があります。
（より正確にいうと、現在のインスタンスを指す。）
作成したインスタンスのプロパティに値を設定することもできます。

```php
class Person {
    // public変数(プロパティ)
    
    public $firstName;
    public $lastName;

    // publicメソッド
    public function sayHello() {
        // ※$this->firstNameは現在のインスタンスのプロパティを指す。
        echo  "こんにちは。私の名前は" . $this->firstName . $this->lastName;
    }
}

// インスタンス化
$person = new Person();
$person->firstName = 'ハヤト'
$person->lastName = 'ふくしま'
// sayHelloメソッドを使用
$person->sayHello();
```

#### コンストラクタ

インスタンスにしたあと、プロパティに設定するのが少し面倒なので、「インスタンス生成したときにもっと手早くプロパティとか設定したい」場合、
コンストラクタを利用します。

コンストラクタは、インスタンス化のタイミングで実行されます。

```php
class Person {
    // public変数(プロパティ)
    public $firstName;
    public $lastName;

    public function __construct($firstName, $lastName) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
    }

    // publicメソッド
    public function sayHello() {
        echo  "こんにちは。私の名前は" . $this->firstName . $this->lastName;
    }
}

// インスタンス化するとき、引数で与えて上げる。
$person = new Person('hayato', 'fukushima');
$person->sayHello();
```

※ __constructの頭についているのは、アンダーバー２個です。

コンストラクタのお陰で、以下のような記述をしなくても良くなります。

```php
$person = new Person();
$person->firstName = 'ハヤト'
$person->lastName = 'ふくしま'
```

#### 使用例を見る

さて、上記のように、
`$person = new Person('hayato', 'fukushima');`
としましたが、実は今までこのようにクラスを生成して利用したことがあります。

それがこれです。

<https://www.php.net/manual/ja/class.pdo.php>

```php
try {
    $pdo = new PDO('mysql:dbname=gs_db; charset=utf8; host=localhost', 'root', 'root');
} catch (PDOException $e) {
    exit('DBConnectError:' . $e->getMessage());
}

$pdo = new PDO('mysql:dbname=gs_db; charset=utf8; host=localhost', 'root', 'root');
$stmt = $pdo->prepare("INSERT INTO gs_an_table(id, name, email, content, date)VALUES(NULL, :name, :email, :content, sysdate())");
$stmt->bindValue(':name', $name, PDO::PARAM_STR);
$stmt->bindValue(':email', $email, PDO::PARAM_STR);
$stmt->bindValue(':content', $content, PDO::PARAM_STR);
$status = $stmt->execute();
```

`new PDO`で、インスタンスを生成していますね！
他にも、`$pdo->prepare(...)`とメソッドを利用しています！

#### プロパティ、メソッドを作って使う　その2

インスタンスは、２つ以上作成できます。

```php
class Person {
    // public変数(プロパティ)
    public $firstName;
    public $lastName;

    public function __construct($firstName, $lastName) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
    }

    // publicメソッド
    public function sayHello() {
        echo "こんにちは。私の名前は" . $this->firstName . $this->lastName;
    }
}

// インスタンス化するとき、引数で与えて上げる。
$person = new Person('hayato', 'fukushima');
$person->sayHello();
$person2 = new Person('長尾', '景虎');
$person2->sayHello();
```

このとき、`$person`と`$person2`は`Person`クラスから生成された別のものになります。

#### インスタンスメソッドを作って使ってみる

さて、次に`staticメソッド`について確認します。

上記の例では、まず`new Class名`でインスタンスを生成して、メソッドを呼び出していました。

`static`を利用すると、インスタンスを生成せずにメソッドを利用することができます。

```php
class Math {
    public static function square($num) {
        return $num * $num;
    }
}

// 静的メソッドの使用
echo Math::square(4);
```

※ static プロパティもあります。
※ 動的メソッドはインスタンスを作成してそのインスタンスごとに動作を与えます。staticは、インスタンスを作成するしないに関わらず利用できます。

では、改めてlaravelに出てくるコードを見てみましょう。

```php
class ArticleController extends Controller
{
    public function index()
    {
        $articles = Article::all();
        $data = ['articles' => $articles];
        return view('articles.index', $data);
    }

    public function store(Request $request)
    {
        $this->validate($request, [
            'title' => 'required|max:255',
            'body' => 'required'
        ]);
        $article = new Article();
        $article->title = $request->title;
        $article->body = $request->body;
        $article->save();

        return redirect(route('articles.index'));
    }

}
```

#### namespace、useについて

#### 【課題】 自由

自由にやっちゃってください。
