# 😁 gs\_php\_day2

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

{% embed url="https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/PHP02_haifu.zip" %}

## 前回のおさらい

- 今までの学習はクライアントサイドの学習
  - HTML : どのような文字などを出すか
  - CSS : どのなレイアウトにするか
  - JS : どのような動きをするか。

- サーバーサイド
  - クライアントから情報を受け取り、その内容をもとに処理をする。

## DBに登録する

クライアントから受け取った情報をDB(= データベース)に登録していきます。

### データベース？？？

#### ※ここでは、 リレーショナルデータベースのことをデータベースとします

#### 以下、データベースをDBと略して表記します

- 情報を記録するもの。
  - DBと
  - テーブルで構成される。
  - その中に、表形式で記録していく。

スプレッドシートでいうと、

- ファイルそのもの(XXXX.xlsx)がDB
- シートがテーブル

のイメージ。

スプレッドシートだと、画面見ながら操作できる
DBは、通常CLI（コマンドラインインターフェース） = 黒い画面に文字で操作する。

それだととっつきにくいので、CGIで操作できる`phpMyAdmin`というソフトを利用する。

## phpMyAdmin

1. `MAMP`を起動。
2. `WebStartボタン`でwelcome画面(起動時に勝手にブラウザに表示される画面)
3. welcome画面左上のメニューから、phpMyAdminをクリック
開き方は画面参照。

ブラウザのURLからは、多分 `http://localhost/phpMyAdmin5/`で行ける。

## DB作成

### 新規DB作成

1. 左メニューから[新規作成]
2. データベース名は `gs_db`
3. 照合順序は`utf8_unicode_ci`
4. 作成クリック。
5. 特にエラーの文言が出なければok

### 新規テーブル作成

1. テーブル名：`gs_an_table`
2. カラム数：5

### カラムを作成

```
`id`:    int(12) AUTO_INCREMENT PRIMARY KEY
`name`:  var_char(64)
`email`:  var_char(128)
`content`: text
`date`: datetime
```

記入したら保存

! varcharとtext違い
→メモリ容量

```text
varchar型の文字列はデータベースに直接保存されます。しかし、text型の文字列は、データベースとは別に保存され、データベースにはそのポインターのみ保存されます。そのため、短い文字列であればvarcharを使った方が、効率良く処理できます。また、longtextなども外部ファイルを使うので、1Gバイトを超えるかなり大きな文字列を扱えます。
```

id
インデックス - PRIMARY(POP UPはそのままok)
A_I（オートンクリメント） チェック

※プライマリキー データを一意に識別するために使われる項目
→他の項目は重複する場合がある。

- 値の重複がない
- データは必ず入力しなければならない。（NULL)にはならない。

オートインクリメント
→連続した数値を自動で入れてくれる。

表示で内容を確認する。

### SQL

エクセルに記入する場合は画面見ながら操作。
DBに登録や編集削除等する場合`SQL`という言語を利用します。

この章ではデータに対して

- 登録 : `INSERT`
- 取得表示 : `SELECT`
の処理を行います。

### INSERT

データを記録する際に用いる。

基本的な書き方は
`INSERT INTO テーブル名(カラム1,カラム2,カラム3・・・) VALUES (値1,値2,値3・・・);`

※ 基本的に大文字(小文字でも動作しますが慣習的に。)
基本的に行の最後は`;`をつけてあげてください。

例文

```sql
INSERT INTO gs_an_table(id,name,email,content,date)
VALUES (NULL,'福島はやと','test@test.jp','内容',sysdate());
```

**後で、データを利用するので、名前やメルアドを変えて3つ()登録してください**

### SELECT

データを取得表示する際に用いる。

1. 書式
`SELECT 表示するカラム FROM テーブル名;`

2. データ取得の基本バリエーション

```sql
SELECT * FROM gs_an_table; --全カラム指定取得
SELECT name FROM gs_an_table; --単一カラム指定取得
SELECT name,email FROM gs_an_table; --複数カラム指定取得
SELECT * FROM gs_an_table WHERE name='テスト太郎'; --WHEREを使った特定データの取得
```

3. 条件付き検索取得

```sql
--演算子を使った検索
SELECT * FROM テーブル名 WHERE id = 1;
SELECT * FROM テーブル名 WHERE id >= 3;

--AND,ORで検索条件を複数指定
SELECT * FROM テーブル名 WHERE id = 1 OR id = 2;
SELECT * FROM テーブル名 WHERE id = 1 AND id = 2;

--曖昧検索
SELECT * FROM テーブル名 WHERE date LIKE '2021-06%';
SELECT * FROM テーブル名 WHERE email LIKE '%@gmail.com';
SELECT * FROM テーブル名 WHERE email LIKE '%@%';

```

4. ソート取得と制限取得

```sql
--ソート
SELECT * FROM テーブル名 ORDER BY ソート対象カラム ソートルール;
SELECT * FROM テーブル名 ORDER BY id DESC; --降順
SELECT * FROM テーブル名 ORDER BY id ASC; --昇
--取得数制限
書式：SELECT * FROM テーブル名 LIMIT ***;

SELECT * FROM テーブル名 LIMIT 5; --最大5件取得 
SELECT * FROM テーブル名 LIMIT 3,5; --3番目のデータから最大5件取得 
```

## PHPからMySQLを操作

DBというものと、BDを操作するための`SQL`を学びました。
次にPHP内で、`SQL`を書いて`MySQL`を操作していきます。

### formを作成

`index.php`のformを修正する。

```
method：POST
action：insert.php
```

### 受け取り/登録処理を作成(INSERT)

`insert.php`を以下のように記述

```php
<?php
//1. POSTデータ取得
$name = $_POST['name'];
$email = $_POST['email'];
$content = $_POST['content'];

//2. DB接続
try {
    //Password:MAMP='root',XAMPP=''
    $pdo = new PDO('mysql:dbname=gs_db; charset=utf8; host=localhost', 'root', 'root');
} catch (PDOException $e) {
    exit('DBConnectError:' . $e->getMessage());
}

//３．データ登録SQL作成
$stmt = $pdo->prepare("INSERT INTO gs_an_table(id, name, email, content, date)
                        VALUES(NULL, :name, :email, :content, sysdate())");
$stmt->bindValue(':name', $name, PDO::PARAM_STR);  //Integer（数値の場合 PDO::PARAM_INT)
$stmt->bindValue(':email', $email, PDO::PARAM_STR);  //Integer（数値の場合 PDO::PARAM_INT)
$stmt->bindValue(':content', $content, PDO::PARAM_STR);  //Integer（数値の場合 PDO::PARAM_INT)
$status = $stmt->execute();

//４．データ登録処理後
if ($status == false) {
    //SQL実行時にエラーがある場合（エラーオブジェクト取得して表示）
    $error = $stmt->errorInfo();
    exit("ErrorMessage:" . print_r($error, true));
} else {
    header('Location: index.php');
}
```

! try-catchについて
まずtryの中身を処理。もしエラー(例外処理)をキャッチしたら、`catch`の中身が実行される。

### データの取得と表示(SELECT)

#### `selsect.php` - 1

```php
<?php

//1.  DB接続
try {
    //Password:MAMP='root',XAMPP=''
    $pdo = new PDO('mysql:dbname=gs_db;charset=utf8;host=localhost', 'root', 'root');
} catch (PDOException $e) {
    exit('DBConnectError' . $e->getMessage());
}

//２．データ取得SQL作成
$stmt = $pdo->prepare("SELECT * FROM gs_an_table");
$status = $stmt->execute();

//３．データ表示
$view = '';
if ($status === false) {
    //execute（SQL実行時にエラーがある場合）
    $error = $stmt->errorInfo();
    exit('ErrorQuery:' . $error[2]);
} else {
    // Selectデータの数だけ自動でループしてくれる
    // FETCH_ASSOC = http://php.net/manual/ja/pdostatement.fetch.php
    while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $view .= '<p>';
        $view .= $result['date'] . ':' . $result['name'] . ' ' . $result['content'] . ' ' . $result['email'];
        $view .= '</p>';
    }
}
?>
```

#### `selsect.php` - 2

- フロント表示部分

```php
    <!-- Main[Start] -->
    <div>
        <div class="container jumbotron"><?= $view ?></div>
    </div>
```

### セキュリティ対策 XSS -1

`select.php`に`funcs.php`を読み込んで作成した関数を使う

```php
<?php
//select.phpの一番上に1行追記
require_once('funcs.php');
```

### セキュリティ対策 XSS - 2

`selsect.php` の `$view`処理部分に`XSS対策`をする。

```php
$view .= '<p>';
$view .= h($result['date']).':'.h($result['name']).' '.h($result['content']).' '.h($result['email']);
$view .= '</p>';
```
