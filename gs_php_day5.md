# 🤩 014\_gs\_php\_day4

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

[https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/PHP04\_haifu.zip](https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/PHP04\_haifu.zip)

# まだ書き途中です

## 前回までのおさらい

* `SQL`の`UPDATE`を書いた
* `SQL`の`DELETE`を書いた
* CRUDのC,R,U,D全部触った
* SESSIONを利用してログイン機能を作った

## 今回やること

今までの内容まとめ、応用

## MAMPの起動、DB準備

1. MAMPを起動
2. WebStartボタンから起動トップページを表示
3. ページの真ん中MySQLのタブからphpMyAdminのリンクをクリック
4. 起動した画面がMySQLを管理するphpMyAdminの画面が表示されます。
5. データベースタブをクリック
6. データベースを作成から以下の名前で作成

```
データベース名：gs_db5
照合順序：utf8_unicode_ci
```

1. 作成ボタンをクリック 左側に`gs_db5`というデータベースができていると思います。 現在は空っぽです。

## SQLファイルからインポート

〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db4`をクリック
2. `gs_db4`を選択した状態でインポートタブをクリック
3. ファイルを選択をクリックして配布した資料内のSQLフォルダ内の`gs_content_table.sql`を選択
4. 実行してみる
5. ファイルを選択をクリックして配布した資料内のSQLフォルダ内の`gs_user_table.sql`を選択 **今日のテーブルは2つあります。**
6. 実行してみる
7. 授業用のDBと中身を確認

## まずは中身を確認してみてください。

- index.php
  - 投稿した内容の一覧が表示されます。左下から管理画面にログインしてください

ID, PWは以下の通り。

```
ID:test1
PW:test2
```

- ログイン後、記事を作成できる。
- ログイン後、記事を修正できる。
- ログアウトできる,,,など。

- コードは、管理者画面については、`admin`ディレクトリに入っていることを確認してください。
## 共通部分をまとめる。

### `<head>`の中身

今回はどのページにも共通している内容を、まとめます。

例えば、以下のページにある、`<head>`の中身です。

- index.php
- admin/index.php
- admin/confirm.php
- admin/detail.php
- admin/login.php
- admin/post.php

```html
<!-- 共通している事項 -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
```

関数の共通化のように、一つパーツを作った後、必要なページで呼び出してあげます。

1. ファイル作成...`common/head.php`
2. `common/head.php`に以下のように記述

```php
<?php
$head = <<<EOM
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
EOM;
```

3. 利用したいページで、`require_once('../common/head.php');`を記述　※ファイルPATHは環境によって異なるので注意
4. `<head>`タグ内で、`<?= $head ?>`と記述し呼び出してあげる。

{% hint style="info" %}

```
$var = <<<EOM
....
EOM;
```

この書き方は、`ヒアドキュメント`と言います、
地味にルールが多いので、公式サイト参照推奨
https://www.php.net/manual/ja/language.types.string.php#language.types.string.syntax.heredoc
{% endhint %}


### (余力有ったらこれもやりましょう)`<nav>`の中身

以下ページにある、`<nav>`タグも共通化しましょう。

- admin/confirm.php
- admin/detail.php
- admin/index.php
- admin/post.php

共通化している項目

```html
  <header>
      <nav class="navbar navbar-expand-lg navbar-light bg-info">
          <div class="container-fluid">
              <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                  <li class="nav-item">
                  <a class="nav-link active" aria-current="page" href="../index.php">ブログ画面へ</a>
                  </li>
                  <li class="nav-item">
                  <a class="nav-link active" aria-current="page" href="post.php">投稿する</a>
                  </li>
                  <li class="nav-item">
                  <a class="nav-link active" aria-current="page" href="index.php">投稿一覧</a>
                  </li>
                  <li class="nav-item">
                  <a class="nav-link active" aria-current="page" href="logout.php">ログアウト</a>
                  </li>
              </ul>
          </div>
      </nav>
  </header>
```

1. ファイル作成...`common/header.php`
2. `common/header.php`に以下のように記述
3. 利用したいページで、`require_once('../common/header.php');`を記述　※ファイルPATHは環境によって異なるので注意
4. `<body>`の直下あたりで、`<?= $header ?>`と記述し呼び出してあげる。

```php
<?php
$header = <<<EOM
<header>
    <nav class="navbar navbar-expand-lg navbar-light bg-info">
        <div class="container-fluid">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="../index.php">ブログ画面へ</a>
                </li>
                <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="post.php">投稿する</a>
                </li>
                <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="index.php">投稿一覧</a>
                </li>
                <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="logout.php">ログアウト</a>
                </li>
            </ul>
        </div>
    </nav>
</header>
EOM;
```

## 投稿にバリデーションをつける。

投稿内容が空白の場合に、登録できないようにする。

- `resister.php`にバリデーションをつける。
  
以下のようにif文を作成。
（`$content  = $_POST['content'];`の下辺り。）

```php
// resister.php
$title = $_POST['title'];
$content  = $_POST['content'];


$error = false;
// もし、どちらかが空白だったらredirect関数でindexに戻す。その際、URLパラメーターでerrorを渡す。
if (trim($title) === '' || trim($$content) === '') {
    redirect('post.php?error=1');
}
```

- `post.php`の`<form>`の上辺りに、以下追加

```php
// post.php

// もしURLパラメータがある場合
<?php if (isset($_GET['error'])): ?>
    <p class="text-danger">記入内容を確認してください</p>
<?php endif ?>
<form method="POST" action="resister.php" enctype="multipart/form-data">
```

HTMLブロック内にてPHPを記述する際、if文やfor文を利用する際は、以下のように記述できます。

```php

// 普通に書く場合
<?php
if ($a > $b)
  echo "aはbより大きい";
  echo "<h1>test</h1>";
?>

// 下のように書くと、echoを書かなくて良い。
<?php if ($a > $b): ?>
    <p>aはbより大きい</p>
    <h1>test</h1>
<?php endif ?>
```

{% hint style="info" %}
本来、バリデーションは、各項目ごとに記述を変えてあげたほうが親切です。
例えば、

- 名前の文字数が多い場合
- メールアドレスの文字列が多い場合
- メールアドレスの形式がおかしい（例えば@が入っていない）場合
- 数字で記入するべきところを数字で記載しない場合

などです。
それぞれに適したバリデーションメッセージを表示させるようにしましょう。
{% endhint %}


## 投稿に確認画面をつける。


## 投稿に画像投稿も追加する。



## 【課題】 PHPでプロダクト

1. まず、以下の通りDBとテーブルを作成

* DB名:自由 ※授業のDB名とかぶらないようにしてください。
* table名:自由

2. 前回の課題に、
   - 画像投稿機能
   - 投稿確認画面
など、授業で扱った内容を加えてください。

※すでにこれらの機能が備わっている場合は、自由にプロダクトしてください。

3. 課題を提出するときは、必ずsqlファイルも提出。
ファイルの用意の仕方は[ここを参照](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/%E3%81%9D%E3%81%AE%E4%BB%96/howToExportSql.md)
