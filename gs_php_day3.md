# 😚 gs\_php\_day3

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

[https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/php03\_haifu.zip](https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/php03\_haifu.zip)

## 前回のおさらい

- DBを利用した
- `PhpMyAdmin`を利用してDBを操作した。
- `SQL`の`INSERT`を書いた
- `SQL`の`SELECT`を書いた
- PHPのフロント画面から、フォームを使ってDBに登録した。

## MAMPの起動、DB準備

1. MAMPを起動
2. WebStartボタンから起動トップページを表示
3. ページの真ん中MySQLのタブからphpMyAdminのリンクをクリック
4. 起動した画面がMySQLを管理するphpMyAdminの画面が表示されます。
5. データベースタブをクリック
6. データベースを作成から以下の名前で作成

```text
データベース名：gs_db3
照合順序：utf8_unicode_ci
```

7. 作成ボタンをクリック
左側に`gs_db3`というデータベースができていると思います。
現在は空っぽです。


## SQLファイルからインポート
〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db3`をクリック
2. gs_db3を選択した状態でインポートタブをクリック
3. ファイルを選択をクリックして配布した資料内のSQLフォルダ内のphp3_sql.sqlを選択
4. 実行してみる
5. 授業用のDBと中身を確認


## 関数化&呼び出し
よく使う処理は関数化するのが一般的です。
同じ処理を複数回書くのではなく関数化して再利用しましょう。

1. funcs.phpにDB接続関数を作成する

```php
function db_conn()
{
    try {
        $db_name = "gs_db3";
        $db_id   = "root";
        $db_pw   = "root";
        $db_host = "localhost";
        $pdo = new PDO('mysql:dbname=' . $db_name . ';charset=utf8;host=' . $db_host, $db_id, $db_pw);
        return $pdo;
    } catch (PDOException $e) {
        exit('DB Connection Error:' . $e->getMessage());
    }
}
```

2. 利用箇所で、関数を呼び出す。

```php
// 関数を使いたいファイルの一番上に以下記入
<?php
require_once('funcs.php');
$pdo = db_conn();
```

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

2. 利用箇所で、関数を呼び出す。

```php
if ($status === false) {
    sql_error($stmt);
} else {
    redirect('index.php');
}
```
