# 😚 gs\_php\_day3

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

[https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/php03\_haifu.zip](https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/php03\_haifu.zip)

## 前回のおさらい

- DBを利用した
- `PhpMyAdmin`を利用してDBを操作した。
- `SQL`の`INSERT`を書いた
- `SQL`の`SELECT`を書いた
- PHPのフロント画面から、フォームを使ってDBに登録した。

## 今回やること

前回は、CRUD機能の`Create（生成）`、`Read（読み取り）`を行いました。

今日は、`update（更新）`、`Delete（削除）`をやっていきます。

- `CRUD`とは？ <https://wa3.i-3-i.info/word123.html>

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
        $db_name = 'gs_db3';
        $db_id   = 'root';
        $db_pw   = 'root';
        $db_host = 'localhost';
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

## 更新処理を実装

更新処理は

1. 更新画面(詳細画面)の作成
2. 更新処理 → リダイレクトの流れです。

### UPDATE（データ更新）

**書式**

```sql
UPDATE テーブル名 SET 更新対象1=:更新データ ,更新対象2=:更新データ2,... WHERE id = 対象ID;
```

## まず更新画面を表示する為のリンクを作成する

1. `select.php`のデータ表示の`while`文内の`HTML`生成にリンクを作成(`GETデータ送信リンク`)

```php
//GETデータ送信リンク作成
// <a>で囲う。
$view .= '<p>';
$view .= '<a href="detail.php?id=' . $result['id'] . '">';
$view .= $result['indate'] . '：' . $result['name'];
$view .= '</a>';
$view .= '</p>';

```

2. select.php内のDB接続・SQLエラー・リダイレクト処理を外部関数から呼び出しに変更する
3. ブラウザの検証ツールからaタグのリンクの飛び先(`detail.php`)をチェック

## 更新画面を作成する

1. detail.phpにデータ取得処理を記述

```php
<?php
require_once('funcs.php');
$pdo = db_conn();

//2.select.phpから送られてくる対象のIDを取得
$id = $_GET['id'];

//3．データ登録SQL作成
$stmt = $pdo->prepare('SELECT * FROM gs_an_table WHERE id=:id;');
$stmt->bindValue(':id',$id,PDO::PARAM_INT);
$status = $stmt->execute();

//4．データ表示
$view = '';
if ($status === false) {
    sql_error($status);
} else {
    $result = $stmt->fetch();
}
?>
```

2. detail.phpに更新画面用のHTMLを記述

`index.php`のコードをまるっとコピーして貼り付け！

3. detail.phpのHTML内formのaction先をupdate.phpに変更する

```php
<form method="POST" action="update.php">
 .....省略
</form>
```

4. detail.phpのHTML内formの送信ボタン直上に以下を追記

```php
 <!-- ↓追加 -->
<input type="hidden" name="id" value="<?= $result['id'] ?>">
<input type="submit" value="送信">
```

## 更新処理の中身を作成する

1. update.phpに更新処理を追記

```php
//1. POSTデータ取得
$name   = $_POST['name'];
$email  = $_POST['email'];
$age    = $_POST['age'];
$content = $_POST['content'];
$id = $_POST['id'];

//2. DB接続します
require_once('funcs.php');
$pdo = db_conn();

//３．データ登録SQL作成
$stmt = $pdo->prepare( 'UPDATE gs_an_table SET name = :name, email = :email, age = :age, content = :content, indate = sysdate() WHERE id = :id;' );

$stmt->bindValue(':name', $name, PDO::PARAM_STR);/// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':email', $email, PDO::PARAM_STR);// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':age', $age, PDO::PARAM_INT);// 数値の場合 PDO::PARAM_INT
$stmt->bindValue(':content', $content, PDO::PARAM_STR);// 文字の場合 PDO::PARAM_STR
$stmt->bindValue(':id', $id, PDO::PARAM_INT);// 数値の場合 PDO::PARAM_INT
$status = $stmt->execute(); //実行

//４．データ登録処理後
if ($status === false) {
    sql_error($stmt);
} else {
    redirect('select.php');
}

```

## 削除処理を実装していく

PHPの基本処理、登録・表示（取得）・更新・削除の4つのうちの最後の一つです。
削除処理は削除ボタンクリック→削除処理の流れなので比較的簡単です。

### DELETE（データ削除）

**書式**

```sql
UPDATE テーブル名 SET 更新対象1=:更新データ ,更新対象2=:更新データ2,... WHERE id = 対象ID;
```

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

2. delete.phpに削除処理を作成する

```php
//1.対象のIDを取得
$id   = $_GET['id'];

//2.DB接続します
require_once('funcs.php');
$pdo = db_conn();

//3.削除SQLを作成
$stmt = $pdo->prepare('DELETE FROM gs_an_table WHERE id = :id');
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$status = $stmt->execute(); //実行


//４．データ登録処理後
if ($status === false) {
    sql_error($stmt);
} else {
    redirect('select.php');
}

```

#### 【課題】 ブックマークアプリ その２

1. まず、以下の通りDBとテーブルを作成

- DB名:自由
- table名:`gs_bm_table2`

1. 授業でやったように、

- 登録画面
- 登録処理画面
- 登録内容確認画面

に加えて

- データ更新できるような画面
- データ削除ができるような画面
を作成してください。

1. 課題を提出するときは、必ずsqlファイルも提出。
ファイルの用意の仕方は[ここを参照](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/%E3%81%9D%E3%81%AE%E4%BB%96/howToExportSql.md)
