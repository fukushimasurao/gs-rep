# 013\_gs\_php\_day3

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

[資料はこちら](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/php03.zip)

## 前回のおさらい

* DBを利用した
* `PhpMyAdmin`を利用してDBを操作した。
* `SQL`の`INSERT`を書いた
* `SQL`の`SELECT`を書いた
* PHPのフロント画面から、フォームを使ってDBに登録した。

## 今回やること

* 各ファイルにある同じような作業を一つにまとめます。(require)

前回は、CRUD機能の`Create（生成）`、`Read（読み取り）`を行いました。

今日は、`update（更新）`、`Delete（削除）`をやっていきます。

* `CRUD`とは？ [https://wa3.i-3-i.info/word123.html](https://wa3.i-3-i.info/word123.html)

## XAMPPの起動、DB準備

XAMPPのapache,mysql serverを起動させてください。

http://localhost/phpmyadminを開いて、DBを用意しましょう。

↓を新たに作成してください。

```
データベース名：gs_db_class3
```

1. 作成ボタンをクリック 左側に`gs_db_class3`というデータベースができていると思います。 現在は空っぽです。

## SQLファイルからインポート

〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db_class3`をクリック
2. gs\_db3を選択した状態でインポートタブをクリック
3. ファイルを選択をクリックして配布した資料内のSQLフォルダ内のphp3\_sql.sqlを選択
4. 実行してみる
5. 授業用のDBと中身を確認

## 登録処理までの確認（前回の復習）

### 登録処理の修正をしましょう。(index.php → insert.php)

### `index.php`の中身確認

まずは、`index.php`を確認してみましょう。

`form`の設置と`insert.php`へ`post`で送る処理が確認できます。

```html
<form method="POST" action="insert.php">
```

### `insert.php`の中身確認、修正

* `$db_name`の内容が問題ないか確認しましょう。
* insert処理部分が`*******`になっているので修正しましょう。

<details>

<summary>答え</summary>

```php

// idは抜かしても問題ない(自動連番 / default値があれば自動挿入される)ので省略します。
$stmt = $pdo->prepare('INSERT INTO gs_an_table(name, email, age, content, indate)
                        VALUES(:name, :email, :age, :content, sysdate())');

$stmt->bindValue(':name', $name, PDO::PARAM_STR);
$stmt->bindValue(':email', $email, PDO::PARAM_STR);
$stmt->bindValue(':age', $age, PDO::PARAM_INT); //Integer（数値の場合 PDO::PARAM_INT)
$stmt->bindValue(':content', $content, PDO::PARAM_STR);
```

</details>

ここまで確認できたら、登録処理ができるかどうかの確認をしましょう。

## 一覧画面（select.php）の確認

すでにコードは書いてあるので、どのようなSQLが記載されているか等を確認してください。

\-----（ここまでは、day2の復習）-----

## 詳細画面を実装

各項目の詳細画面を作成するために、

1. `select.php`から、更新したい項目の`id`を`detail.php`に送る。
2. `detail.php`にて、受け取った`id`を元に、その`id`の情報を表示する

の流れを作ります。

## まず更新画面にidを送る為のリンクを作成する

`select.php`の各項目をクリックしたら、その項目の詳細画面に遷移する様にします。 よって、`detail.php`に`id`を送るために、urlに`パラメータ(URLパラメータ)`を追加して遷移させてあげます。

{% hint style="info" %}
`パラメータ(URLパラメータ)`って何だっけ？

例えば、`https://eow.alc.co.jp/search?q=english`の`q=english`の部分です。
{% endhint %}

1. `select.php`のデータ表示の`while`文内の`HTML`生成にリンクを作成(`GETデータ送信リンク`)

※表示されるイメージは、

```html
<p>
    <a href="detail.php?id=XXX">2022-09-22 16:06:42 : 徳川家康</a>
</p>
```

としたい。

```php
//GETデータ送信リンク作成
// <a>で囲う。
$view .= '<p>';
$view .= '<a href="detail.php?id=' . $result['id'] . '">';
$view .= "{$result['indate']} : {$result['name']}"; // 文字列は、ダブルクオーテーション利用すると変数展開可能
$view .= '</a>';
$view .= '</p>';
```

{% hint style="info" %}
文字列をダブルクオーテーションで囲んであげると、 その中で変数展開が可能になります。

```php
$modifier = 'good';

echo "I am $modifier_man!!" // これだと、一見してどこまで変数か分かりづらいので、{}で囲ってあげることも可能。
echo "I am {$modifier}_man!!"  // ${modifier} でもok
```

なお、ダブルクオーテーションの中で、ダブルクオーテーションは利用できないので気をつけましょう。

❌ `$str="He is "GREAT" teacher.";` ◎　`$str='He is "GREAT" teacher.';`
{% endhint %}

{% hint style="info" %}
`htmlspecialchars()`の利用は後でやるので、ここでは一旦省略します。
{% endhint %}

書けたら、ブラウザの検証ツールからaタグのリンクの飛び先(`detail.php`)をチェック

もしくは、リンクをクリックして、

http://localhost/test/detail.php?id=XXX

に遷移するか確認する。

## 更新画面(detail.php)を作成する

1. detail.phpにデータ取得処理を記述

```php
<?php
//select.phpから送られてくる対象のIDを取得
$id = $_GET['id'];

// DB接続(insert.phpとかから持ってきてください)
try {
    $db_name = 'gs_db_class3';    //データベース名
    $db_id   = 'root';      //アカウント名
    $db_pw   = '';      //パスワード：MAMPは'root'
    $db_host = 'localhost'; //DBホスト
    $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
} catch (PDOException $e) {
    exit('DB Connection Error:' . $e->getMessage());
}

//3．データ登録SQL作成
// WHERE id=:idを利用して、１つだけ情報を取得してください。
$stmt = $pdo->prepare('SELECT * FROM gs_an_table WHERE id=:id;');
$stmt->bindValue(':id',$id,PDO::PARAM_INT);
$status = $stmt->execute();

//4．データ表示
$result = '';
if ($status === false) {
    //*** function化する！******\
    $error = $stmt->errorInfo();
    exit('SQLError:' . print_r($error, true));
} else {
    $result = $stmt->fetch();
}
?>
```

1. detail.phpに更新画面用のHTMLを記述

`index.php`のコードをまるっとコピーして貼り付け！

1. detail.phpのHTML内formのaction先をupdate.phpに変更する

```php
<form method="POST" action="update.php">
 .....省略
</form>
```

1. フォーム `input`に初期値を設定

```html
<label>名前：<input type="text" name="name" value="<?= $result['name'] ?>"></label><br>
<label>Email：<input type="text" name="email" value="<?= $result['email'] ?>"></label><br>
<label>年齢：<input type="text" name="age" value="<?= $result['age'] ?>"></label><br>
<label><textarea name="content" rows="4" cols="40"><?= $result['content'] ?></textarea></label>

```

1. detail.phpのHTML内formの送信ボタン直上に以下を追記

```php
 <!-- ↓追加 -->
<input type="hidden" name="id" value="<?= $result['id'] ?>">

 <!-- ↓「送信」も「更新」に直しちゃいましょう -->
<input type="submit" value="更新">
```

書き終わったら、ブラウザのdev toolsで、idが送れる状態になっているか確認しましょう。

## 更新処理の中身を作成する

### UPDATE（データ更新）

**書式**

**whereを忘れないようにしましょう。**

```sql
UPDATE テーブル名 SET 更新対象1=:更新データ ,更新対象2=:更新データ2,... WHERE id = 対象ID;
```

1. update.phpに更新処理を追記

```php
//1. POSTデータ取得
$name   = $_POST['name'];
$email  = $_POST['email'];
$age    = $_POST['age'];
$content = $_POST['content'];
$id = $_POST['id']; // ←追加

//2. DB接続します
try {
    $db_name = 'gs_db_class3';    //データベース名
    $db_id   = 'root';      //アカウント名
    $db_pw   = '';      //パスワード：XAMPPはパスワード無しに修正してください。
    $db_host = 'localhost'; //DBホスト
    $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
} catch (PDOException $e) {
    exit('DB Connection Error:' . $e->getMessage());
}

//３．データ登録SQL作成

// UPDATE文にする
$stmt = $pdo->prepare( 'UPDATE gs_an_table SET name = :name, email = :email, age = :age, content = :content, indate = sysdate() WHERE id = :id;' );

$stmt->bindValue(':name', $name, PDO::PARAM_STR);/// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':email', $email, PDO::PARAM_STR);// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':age', $age, PDO::PARAM_INT);// 数値の場合 PDO::PARAM_INT
$stmt->bindValue(':content', $content, PDO::PARAM_STR);// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':id', $id, PDO::PARAM_INT);// 数値の場合 PDO::PARAM_INT
$status = $stmt->execute(); //実行

//４．データ登録処理後
if ($status === false) {
    //*** function化する！******\
    $error = $stmt->errorInfo();
    exit('SQLError:' . print_r($error, true));
} else {
    //*** function化する！*****************
    header('Location: select.php');
    exit();
}
```

{% hint style="info" %}
`UPDATE`文は、,`WHERE`を忘れない様に注意
{% endhint %}

## 削除処理を実装していく

PHPの基本処理、登録・表示（取得）・更新・削除の4つのうちの最後の一つです。 削除処理は削除ボタンクリック→削除処理の流れなので比較的簡単です。

### DELETE（データ削除）

**書式**

```sql
DELETE FROM テーブル名 WHERE id = :id
```

{% hint style="info" %}
WHERE句で指定しないと、全部消えるので、超注意
{% endhint %}

### 削除ボタン（削除リンクを作成する）

1. select.phpのデータ表示のwhile文内のHTML生成に削除リンクを作成

```php
//GETデータ送信リンク作成
// <a>で囲う。
$view .= '<p>';
$view .= '<a href="detail.php?id=' . $result['id'] . '">';
$view .= $result["indate"] . "：" . $result["name"];
$view .= '</a>';
$view .= '<a href="delete.php?id=' . $result['id'] . '">';//追記
$view .= '  [削除]';//追記
$view .= '</a>';//追記
$view .= '</p>';
```

1. delete.phpに削除処理を作成する

(`update.php`の中身をコピぺして、不要部分を修正削除すると楽です)

```php
//1.対象のIDを取得
// GETで取得するので、GETに書き換え
$id   = $_GET['id'];

//2.DB接続します
try {
    $db_name = 'gs_db_class3'; //データベース名
    $db_id   = 'root'; //アカウント名
    $db_pw   = ''; //パスワード：MAMPは'root'
    $db_host = 'localhost'; //DBホスト
    $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
} catch (PDOException $e) {
    exit('DB Connection Error:' . $e->getMessage());
}


//3.削除SQLを作成
$stmt = $pdo->prepare('DELETE FROM gs_an_table WHERE id = :id');
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$status = $stmt->execute(); //実行


//４．データ登録処理後
if ($status === false) {
    //*** function化する！******\
    $error = $stmt->errorInfo();
    exit('SQLError:' . print_r($error, true));
} else {
    //*** function化する！*****************
    header('Location: select.php');
    exit();
}

```

## コードをリファクタリング。関数化&呼び出し

よく使う処理は関数化するのが一般的です。 同じ処理を複数回書くのではなく関数化して再利用しましょう。

1. funcs.phpにDB接続関数を作成する

※ 以下、順番に書き換えて動作を確認しましょう。

* `insert.php`
* `detail.php`
* `update.php`
* `delete.php`

```php
function db_conn()
{
    try {
        $db_name = 'gs_db_class3';
        $db_id   = 'root';
        $db_pw   = ''; // MAMPは'root'
        $db_host = 'localhost';
        $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
        // return $pdo;を忘れないように。 
        return $pdo;
    } catch (PDOException $e) {
        exit('DB Connection Error:' . $e->getMessage());
    }
}
```

1. 利用箇所で、関数を呼び出す。

```php
// 関数を使いたいファイルの一番上に以下記入
<?php
require_once('funcs.php');
$pdo = db_conn();
```

{% hint style="info" %}
prepare, bindValue

[require, require\_once, include, include\_once の違い](https://qiita.com/awesam86/items/3fa28e23c95ca74caddc)
{% endhint %}

## SQLエラー処理とリダイレクト処理を関数化

1. `funcs.php`にSQLエラー関数とリダイレクト処理を作成する

```php
//SQLエラー関数：sql_error($stmt)
function sql_error($stmt)
{
    $error = $stmt->errorInfo();
    exit('SQLError:' . print_r($error, true));
}

//リダイレクト関数: redirect($file_name)
function redirect($file_name)
{
    header('Location: ' . $file_name );
    exit();
}
```

1. 利用箇所で、関数を呼び出す。

```php
if ($status === false) {
    sql_error($stmt);
} else {
    redirect('index.php');
}
```

1. すでに`funcs.php`の中に、`h()`関数が用意されています。

データを出力表示している箇所を`h()`で囲ってあげましょう。

※ 以下、順番に書き換えて動作を確認しましょう。

* `select.php`
* `detail.php`

## 【課題】 ブックマークアプリ その２

1. まず、以下の通りDBとテーブルを作成

* DB名:自由 ※授業のDB名とかぶらないようにしてください。
* table名:自由

1. 授業でやったように、

* 登録画面
* 登録処理画面
* 登録内容確認画面

に加えて

* データ更新できるような画面
* データ削除ができるような画面 を作成してください。

前回の課題に更新・削除機能を追加して提出していただいてもいいですし、 新たに課題作成して頂いてもokです。

1. 課題を提出するときは、必ずsqlファイルも提出。 ファイルの用意の仕方は[ここを参照](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/%E3%81%9D%E3%81%AE%E4%BB%96/howToExportSql.md)
