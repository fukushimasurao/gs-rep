# 🤡 015\_gs\_php\_day5

#### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

[https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/PHP05.zip](https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/PHP05.zip)

{% hint style="info" %}
Macの人は、配布ファイルのimagesフォルダの権限を変えてください。
フォルダの上で右クリック→情報を見る→一番下の「共有とアクセス権」から、全て「読み書き」にしてください
{% endhint %}



### 前回までのおさらい

* `SQL`の`UPDATE`を書いた
* `SQL`の`DELETE`を書いた
* CRUDのC,R,U,D全部触った
* SESSIONを利用してログイン機能を作った

### 今回やること

今までの内容まとめ、応用

* 共通しているパーツをまとめて一つにしましょう（リファクタリング）
* 記事投稿時に、確認画面がないので、確認画面を追加しましょう。
* 記事投稿時に、画像投稿ができないので、機能を追加しましょう。

### MAMPの起動、DB準備

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

### SQLファイルからインポート

〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db5`をクリック
2. `gs_db5`を選択した状態でインポートタブをクリック
3. ファイルを選択をクリックして配布した資料内のSQLフォルダ内の`gs_content_table.sql`を選択
4. 実行してみる
5. ファイルを選択をクリックして配布した資料内のSQLフォルダ内の`gs_user_table.sql`を選択 **今日のテーブルは2つあります。**
6. 実行してみる
7. 授業用のDBと中身を確認

### まずは中身を確認してみてください

* index.php
  * 投稿した内容の一覧が表示されます。左下から管理画面にログインしてください

ID, PWは以下の通り。

```
ID:test1
PW:test2
```

* ログイン後、記事を作成できる。
* ログイン後、記事を修正できる。
* ログアウトできる,,,など。
* コードは、管理者画面については、`admin`ディレクトリに入っていることを確認してください。

### 共通部分をまとめる

#### `<head>`の中身

今回はどのページにも共通している内容を、まとめます。

例えば、以下のページにある、`<head>`の中身です。

* index.php
* admin/index.php
* admin/confirm.php
* admin/detail.php
* admin/login.php
* admin/post.php

```html
<!-- 共通している事項 -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<title>{タイトル}</title>
```

関数の共通化のように、一つパーツを作った後、必要なページで呼び出してあげます。

{% hint style="info" %}
`<head>`の中に記載されている`bootstrap`とは、フロントエンド向けのライブラリです。 例えば、特定の位置の文字を赤くしたい場合、通常は`class+css`を記述して対応します。 一方`bootstrap`を導入している場合`class`に`text-danger`と記載するだけで文字が赤くなります。

https://getbootstrap.jp/
{% endhint %}

1. ファイル作成...`common/head_parts.php`
2. `common/head_parts.php`に以下のように記述

```php
<?php
function head_parts($title)
{
    return <<<EOM
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<title>$title</title>
EOM;
}

```

1. 利用したいページで、

* 以下ページには、 `require_once('common/head_parts.php');`
  * index.php
* 以下ページには、 `require_once('../common/head_parts.php');`
  * admin/index.php
  * admin/confirm.php
  * admin/detail.php
  * admin/login.php
  * admin/post.php

を記述　※ファイルPATHは階層によって異なるので注意

1. `<head>`タグ内で、`<?= head_parts({<headの中に記述したい文言>}) ?>`と記述し呼び出してあげる。

{% hint style="info" %}
```
$var = <<<{任意の文字}
....
{任意の文字};
```

この書き方は、`ヒアドキュメント`と言います、 地味にルールが多いので、公式サイト参照推奨 [https://www.php.net/manual/ja/language.types.string.php#language.types.string.syntax.heredoc](https://www.php.net/manual/ja/language.types.string.php#language.types.string.syntax.heredoc)
{% endhint %}

#### (余力有ったらこれもやりましょう)`<nav>`の中身

以下ページにある、`<nav>`タグも共通化しましょう。

* admin/confirm.php
* admin/detail.php
* admin/index.php
* admin/post.php

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

1. ファイル作成...`common/header_nav.php`
2. `common/header_nav.php`に以下のように記述
3. 利用したいページで、`require_once('../common/header_nav.php');`を記述　※ファイルPATHは環境によって異なるので注意
4. `<body>`の直下あたりで、`<?= $header_nav ?>`と記述し呼び出してあげる。

```php
<?php
$header_nav = <<<EOM
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

### 投稿にバリデーションをつける

現状、投稿する際に、空欄があっても投稿できるようになっています。
投稿内容が空白の場合に、登録できないようにする。

* `register.php`にバリデーションをつける。

{% hint style="info" %}
バリデーションとは、入力規則のことです。 製作者側が期待している内容とは異なる内容がform等で送信された場合に 弾くようにします。

例えば、

* 電話番号の入力欄に、数字以外の入力がされていないか。
* メール入力欄に、メール形式以外の文字列（例えば日本語）の入力がされてないか。
* 男性か女性かその他かを選ばせる箇所で、それ以外の`value`がPOST/GETされていないか。

などです。
{% endhint %}

以下のようにif文を作成。 （`$content = $_POST['content'];`の下辺り。）

```php
// register.php
$title = $_POST['title'];
$content  = $_POST['content'];

// もし、どちらかが空白だったらredirect関数でindexに戻す。その際、URLパラメーターでerrorを渡す。
if (trim($title) === '' || trim($content) === '') {
  redirect('post.php?error=1');
}
```

* `post.php`の`<form>`の上辺りに、以下追加

```php
// post.php

// もしURLパラメータがある場合
<?php if (isset($_GET['error'])): ?>
    <p class="text-danger">記入内容を確認してください</p>
<?php endif ?>
<form method="POST" action="register.php">
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
本来、バリデーションは、各項目ごとに記述を変えてあげたほうが親切です。 例えば、

* 名前の文字数が多い場合
* メールアドレスの文字列が多い場合
* メールアドレスの形式がおかしい（例えば@が入っていない）場合
* 数字で記入するべきところを数字で記載しない場合

などです。 それぞれに適したバリデーションメッセージを表示させるようにしましょう。
{% endhint %}

### 投稿に確認画面をつける - 1

現状は`post.php`で投稿すると、すぐに登録されます。

そこで、

* `post.php`にて、フォームを作成、
* `confirm.php`にて、フォームから送られてきた内容をブラウザにて確認画面とし表示、
* 確認が問題なければ`register.php`にて確認した内容を保存

という流れにします。

1. `post.php`のフォームの`action`を`confirm.php`に変更しましょう。
2. `confirm.php`にバリデーション追加

```php
if (trim($title) === '' || trim($content)  === '') {
    redirect('post.php?error=1');
}
```

1. フォーム部分`hidden`等を確認しつつブラウザで動作確認。

### 投稿に確認画面をつける - 2

戻るボタンが押されたときに、記入した文字がすべて消えてしまうので、 入力内容がそのまま残るようにしましょう。

1. `confirm.php`に以下のコードを追記しましょう。

{% hint style="info" %}
`form`から`post`で遷移した後、もう一度`form`に戻ると、記入した内容が消えてしまいます。 一度記入した内容を記録しておきたいので、`SESSION`を利用します。
{% endhint %}

```php
// postされたら、セッションに保存
$title = $_SESSION['post']['title'] = $_POST['title'];
$content = $_SESSION['post']['content'] = $_POST['content'];
```

{% hint style="info" %}
```php
$a = 'string';
$b = 'string';
```

と、

```php
$a = $b = 'string';
```

は同じです。
{% endhint %}

1. `postphp`に以下追加

`post.php`のphp部分↓

```php
<?php
session_start();
require_once('../funcs.php');
loginCheck();

// ↓↓↓↓↓ここから追加↓↓↓↓
// 前に戻るボタン用に、sessionを用意しておく。
$title = '';
$content = '';

if (isset($_SESSION['post']['title'])) {
    $title = $_SESSION['post']['title'];
}
if (isset($_SESSION['post']['content'])) {
    $content = $_SESSION['post']['content'];
}

?>
```

`post.php`のform部分。↓

```php
<form method="POST" action="confirm.php">
    <div class="mb-3">
        <label for="title" class="form-label">タイトル</label>
        <input type="text" class="form-control" name="title" id="title" aria-describedby="title" value="<?= $title ?>">　// ← value追加
        <div id="emailHelp" class="form-text">※入力必須</div>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">記事内容</label>
        <textArea type="text" class="form-control" name="content" id="content" aria-describedby="content" rows="4" cols="40"><?= $content ?></textArea> // ← <?= $content ?>追加
        <div id="emailHelp" class="form-text">※入力必須</div>
    </div>
    <button type="submit" class="btn btn-primary">投稿する</button>
</form>
```

1. ブラウザで動作確認

### 投稿に画像投稿も追加する

1. `POST.php`のフォームに以下追加

`enctype="multipart/form-data"`を忘れがちなので注意


```php
<form method="POST" action="confirm.php" enctype="multipart/form-data"> // enctype="multipart/form-data"を追加
    <div class="mb-3">
        <label for="title" class="form-label">タイトル</label>
        <input type="text" class="form-control" name="title" id="title" aria-describedby="title" value="<?= $title ?>">
        <div id="emailHelp" class="form-text">※入力必須</div>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">記事内容</label>
        <textArea type="text" class="form-control" name="content" id="content" aria-describedby="content" rows="4" cols="40"><?= $content ?></textArea>
        <div id="emailHelp" class="form-text">※入力必須</div>
    </div>

    // ↓↓↓↓↓↓↓↓↓以下追加↓↓↓↓↓↓↓↓↓
    <div class="mb-3">
        <label for="img" class="form-label">画像投稿</label>
        <input type="file" name="img">
    </div>
    // ↑↑↑↑↑↑↑↑ここまで追加↑↑↑↑↑↑↑↑↑
    <button type="submit" class="btn btn-primary">確認する</button>
</form>
```

1. `confirm.php`のPHP部分に以下追加



{% hint style="info" %}
$_FILESの中には、以下が格納されている。

$_FILES['inputで指定したname']['name']:ファイル名
$_FILES['inputで指定したname']['type']:ファイルのMIMEタイプ
$_FILES['inputで指定したname']['tmp_name']:サーバー上で一時的に保存されるテンポラリファイル名
$_FILES['inputで指定したname']['error']:アップロード時のエラーコード
$_FILES['inputで指定したname']['size']:ファイルサイズ（バイト単位）

参考　https://wepicks.net/phpref-files/
{% endhint %}

```php
<?php
session_start();
require_once('../funcs.php');
loginCheck();

// postされたら、セッションに保存
$title = $_SESSION['post']['title'] = $_POST['title'];
$content = $_SESSION['post']['content'] = $_POST['content'];

// $_FILESの中に、投稿画像のデータが入っている。
// echo '<pre>';
// var_dump($_FILES);
// echo '</pre>';

// ↓↓↓↓↓ここから追加↓↓↓↓
// imgがある場合
if (isset($_FILES['img']['name'])) {
    $file_name = $_SESSION['post']['file_name']= $_FILES['img']['name'];
    // 一時保存されているファイル内容を取得して、セッションに格納
    $image_data = $_SESSION['post']['image_data'] = file_get_contents($_FILES['img']['tmp_name']);

    // 一時保存されているファイルの種類を確認して、セッションにその種類に当てはまる特定のintを格納
    $image_type = $_SESSION['post']['image_type'] = exif_imagetype($_FILES['img']['tmp_name']);
} else {
    $image_data = $_SESSION['post']['image_data'] = '';
    $image_type = $_SESSION['post']['image_type'] = '';
}
// ↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑

if (trim($title) === '' || trim($content) === '') {
   redirect('post.php?error=1');
}

// ↓↓↓↓↓ここから追加↓↓↓↓
//写真は拡張子をチェック
if (!empty($file_name)) {
    $extension = substr($file_name, -3);
    if ($extension != 'jpg' && $extension != 'gif' && $extension != 'png') {
       redirect('post.php?error=1');
    }
}
// ↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑

?>
```

1. `confirm.php`の`form`部分に以下追加

```php
<form method="POST" action="register.php" enctype="multipart/form-data" class="mb-3">
    <div class="mb-3">
        <label for="title" class="form-label">タイトル</label>
        <input type="hidden"name="title" value="<?= $title ?>">
        <p><?= $title ?></p>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">記事内容</label>
        <input type="hidden"name="content" value="<?= $content ?>">
        <div><?= nl2br($content) ?></div>
    </div>

    // ↓↓↓↓↓↓↓↓↓↓↓↓追加↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    <?php if ($image_data): ?>
    <div class="mb-3">
        <img src="image.php">
    </div>
    <?php endif; ?>
    //↑↑↑↑↑↑↑↑↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    <button type="submit" class="btn btn-primary">投稿</button>
</form>
```

1. 戻るボタン押したときに、画像表示するため、`post.php`以下追加

* php部分

```php
$title = '';
$content = '';
// $image_data = ''; ←追加

if (isset($_SESSION['post']['title'])) {
    $title = $_SESSION['post']['title'];
}
if (isset($_SESSION['post']['content'])) {
    $content = $_SESSION['post']['content'];
}

// ↓追加
if (isset($_SESSION['post']['image_data'])) {
    $image_data = $_SESSION['post']['image_data'];
}
```

* form部分

```php
↓この３行追加↓
<?php if ($image_data): ?>
<img src="image.php">
<?php endif;?>

<div class="mb-3">
    <label for="img" class="form-label">画像投稿</label>
    <input type="file" name="img">
</div>
```

1. `register.php`に以下追記

```php
<?php
session_start();
require_once('../funcs.php');
loginCheck();

$title = $_POST['title'];
$content  = $_POST['content'];

// imgがある場合
if (isset($_SESSION['post']['image_data'])) {
    // ファイル名に今日の日付をくっつける。
    $img = date('YmdHis') . '_' . $_SESSION['post']['file_name'];
}
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// 簡単なバリデーション処理。
if (trim($title) === '' || trim($content)  === '') {
    redirect('post.php?error=1');
}


// ↓↓↓↓↓↓↓↓↓↓↓↓追加↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
if (!empty($img)) {
    // 写真が添付されている場合、拡張子を確認。変な拡張子であればバリデーションつける。
    $check =  substr($img, -3);
    if ($check != 'jpg' && $check != 'gif' && $check != 'png') {
        $err[] = '写真の内容を確認してください。';
    }
}
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// ↓↓↓↓↓↓↓↓↓↓↓↓追加↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
if (isset($_SESSION['post']['image_data'])) {
    file_put_contents('../images/' . $img, $_SESSION['post']['image_data']);
}
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑ここまで↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
```

1. `admin/index.php`, `index.php`に以下追加して、もし画像がある場合、それを表示させるようにする。

* `admin/index.php` (srcの階層注意)

```php
<?php foreach ($contents as $content): ?>
    <div class="col">
        <div class="card shadow-sm">
        <?php if ($content['img']): ?>
            <img src="../images/<?=$content['img']?>" alt="" class="bd-placeholder-img card-img-top" >
        <?php else: ?>
            <img src="../images/default_image/no_image_logo.png" alt="" class="bd-placeholder-img card-img-top" >
        <?php endif ?>
        <div class="card-body">
        // 以下省略
```

* `index.php` (srcの階層注意)

```php
<?php foreach ($contents as $content): ?>
    <div class="col">
        <div class="card shadow-sm">
        <?php if ($content['img'] !== ''): ?>
            <img src="images/<?=$content['img']?>" alt="" class="bd-placeholder-img card-img-top" >
        <?php else: ?>
            <img src="images/default_image/no_image_logo.png" alt="" class="bd-placeholder-img card-img-top" >
        <?php endif ?>
        <div class="card-body">
        // 以下省略
```

***

_以下余力あれば_

{% hint style="info" %}
投稿修正画面にも確認画面を追加してみましょう。
{% endhint %}

### 【課題】 PHPでプロダクト

1. まず、以下の通りDBとテーブルを作成

* DB名:自由 ※授業のDB名とかぶらないようにしてください。
* table名:自由

1. 前回の課題に、
   * 画像投稿機能
   * 投稿確認画面 など、授業で扱った内容を加えてください。

※すでにこれらの機能が備わっている場合は、自由にプロダクトしてください。

1. 課題を提出するときは、必ずsqlファイルも提出。 ファイルの用意の仕方は[ここを参照](https://gitlab.com/gs\_hayato/gs-php-01/-/blob/master/%E3%81%9D%E3%81%AE%E4%BB%96/howToExportSql.md)
