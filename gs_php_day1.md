---
description: php 第１日目
---

# 😀 gs\_php\_day1

### 授業資料 <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

{% embed url="https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/php01_haifu.zip" %}

![](<.gitbook/assets/スクリーンショット 2022-01-09 2.30.21.png>)

## 基礎文法

### _000-1helloworld.php_

```php
<?php

echo 'hello world';

// コメントアウトは、 スラッシュ２個

?>
```

{% hint style="info" %}
終了タグ ?> は省略可能

本当は省略が推奨だが、授業の最初は丁寧に?>を記述していきます。
{% endhint %}

ブラウザの URLに localhost/000-1helloworld.phpと記入して出力を確認してみましょう。

{% hint style="danger" %}
mampの設定によっては、localhost:8888/000-1helloworld.php
{% endhint %}

{% hint style="danger" %}
エラーの場合は以下を確認してみてください。

・開始タグ・終了タグに間違いが無いか。

・書き間違いが無いか。

・文の最後に ; が抜けていないか。

・全角スペースを記入していないか。
{% endhint %}

### 000-2helloworld.php

phpはHTMLと合わせて記述することが可能です。

```php
<!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <p>こんにちは。<?php echo '福島'; ?>です。</p>
</body>

</html>
```

{% hint style="info" %}
PHP部分は改行せずに、１行で記述しよう。
{% endhint %}

{% hint style="info" %}
記述して保存したら、localhost/000-2helloworld.php をブラウザで確認してみてください。
{% endhint %}

{% hint style="danger" %}
表示がされない場合、

1\. 保存

2\. ブラウザ更新

3\. 画面の確認

の３点を行ったか確認してみださい。
この３つが基本の動作です。
{% endhint %}

### 001hensu.php

```php
    <?php
    echo 'Hello world';
    echo 'ふくしま'; // string型(文字列型)
    echo 90; // int型（整数）
    echo '<h1>タイトル</h1>';

    $myouji = 'ふくしま';
    $namae = 'はやと';

    // JavaScriptの + は PHPではドット . となる。
    echo $myouji . $namae;
    echo $name . 'test';

    // 出力内容の詳細・データを知りたい場合はvar_dumpを利用
    var_dump($name);
    ?>
```

{% hint style="info" %}
ドット.で結合する際は、ドットの左右に半角スペースを入れると読みやすいです。

`△ echo $myouji.$namae;`

`◎ echo $myouji . $namae;`
{% endhint %}

### 002array.php

```php
    <?php
    
    $ary = ['東京', 'oosaka', '愛知'];
    // echo $ary;
    var_dump($ary);
    var_dump($ary[0]);

    // 配列に追加
    $ary[] = '福岡';
    var_dump($ary);
    echo $ary[0];

    $loveFoods = ['寿司', 'ラーメン二郎', 'ピザ'];
    echo $loveFoods[1];

    ?>
```

{% hint style="info" %}
配列への要素の追加方法は他にもたくさんあります。
また、配列の種類（例えば連想配列、多次元配列など）もたくさんあるので調べてみてください。
{% endhint %}

### 003kansu.php

ここでは代表的な組み込み関数の対応を行います。

単純に「こういう関数有るんだ〜」という確認程度の内容です。

```php
    <?php
    
    // 日付表示
    // ※　アルファベット大文字小文字を間違えないでください。
    $today = date('Y/m/d H:i');
    $today2 = date('Y年m月d日 H時');

    echo $today;
    echo '<br>';
    echo $today2;
    echo '<br>';

    // 文字長さ
    $string = 'abcde';
    $length = strlen($string);
    echo $string . 'の文字数は' . $length . '文字';
    echo "<br>";
    // 正確には、strlen() が返すのはバイト数であり、 文字数ではありません。
    // 日本語文字数の場合は、https://www.flatflag.nir87.com/strlen-671

    // trim
    // ※trim...全角スペースは取り除かない。取り除くものは↓
    // https://www.php.net/manual/ja/function.trim.php
    // 全角対応は、str_replaceを利用する。
    $string2 = ' 前後にわざと空白を入れる ';
    echo $string2;
    echo '<br>';
    echo trim($string2);

    // ランダムな数字を表示する(rand)
    // 第1引数は最小の数、第2は最大の数
    $rand = rand(1, 10);
    echo '<pre>';
    var_dump($rand);
    echo '</pre>';

    // おみくじ
    echo '<br>';
    if ($rand === 1) {
        echo '大吉';
    } else {
        echo '大凶';
    }
    ?>
```

{% hint style="info" %}
date()の引数はたくさん種類あります。

公式サイト参照してください。

[https://www.php.net/manual/ja/function.date.php](https://www.php.net/manual/ja/function.date.php)
{% endhint %}

### phpとJS/CSSの動きを確認

```php
<html>
<head>
    <meta charset="utf-8">
    <style>
        .menu {
            background-color: #2FA6E9;
        }
        .red {
            color: red;
        }
    </style>
</head>

<body>
    <div class="menu">
        <h3>menu</h3>
        <ul>
            <li>PHPファイルとJS/CSSの動きを知る。</li>
        </ul>
    </div>
    <?php
    echo '<p class="red">css test</p>';
    echo '<p id="test">console test</p>';
    ?>
    <script>
        let test = document.getElementById('test');
        console.log(test);
    </script>
</body>

</html>

```

### foreachで配列を一つ一つ表示する

繰り返しの処理としてforeachというものがあります。

{% hint style="info" %}
当然、for文もあります。
が、ここでは割愛。

```
for ($i = 0; $i < ; $i++) {
    # code...
}
```

{% endhint %}

```php
<html>
<head>
    <meta charset="utf-8">
    <style>
        .menu {
            background-color: #2FA6E9;
        }
        .red {
            color: red;
        }
    </style>
</head>

<body>
    <div class="menu">
        <h3>menu</h3>
        <ul>
            <li>PHPファイルとJS/CSSの動きを知る。</li>
        </ul>
    </div>
    <?php
        // 配列を作成する
        $lang = ['PHP', 'JS', 'Python', 'Ruby'];

        // foreachで一つ一つ表示する
        foreach ($lang as $val) {
            echo $val."<br>";
        }
    ?>
</body>
</html>
```

{% hint style="info" %}
foreachにkeyを与えて

```
foreach ($variable as $key => $value) {
    echo $key;
    echo $value;
}
```

という書き方もできる。
{% endhint %}

### while文に触れる

foreachは、回数が決まっているものに対して繰り返しをおこなります。

一方で、回数が決まっていない・条件がある限り繰り返しには、`while文`があります。

```php
    // 初期値を決める
    $money = 10000;

    // whileのカッコの中に継続条件を書く
    while ($money >= 0) {
        echo $money."<br>";
        $money = $money - 3350;
    }
```

{% hint style="info" %}
継続条件を間違えると、処理が永遠に終わらない可能性あるので注意です。
{% endhint %}

### Form操作

Formを利用して、データの送信・受け取り方法を知る。

{% hint style="info" %}
Formで大事な項目は３つ。

1. _actionで、送信先を設定_
2. _methodで送信メソッドを設定_
3. _inputタグ内のnameでそれぞれ送る情報に名前をつける。_
{% endhint %}

_get.php （送信側）_

```php
    <form action="get_confirm.php" method="get">
        お名前: <input type="text" name="name">
        EMAIL: <input type="text" name="mail">
        <input type="submit" value="送信">
    </form>
```

get\_confirm.php _（受け取り側）_

```php
<?php
// GETで送られてきた名前とアドレスのデータを受け取る
// まずは、var_dump($_GET);で見てみる。
echo '<pre>';
var_dump($_GET);
echo '</pre>';

// $_GETの中身を変数に移動
$name = $_GET['name'];
$mail = $_GET['mail'];
?>

<html>

<head>
    <meta charset="utf-8">
    <title>GET練習（受信）</title>
</head>

<body>
　   
    <p>お名前：<?= $name ?></p>
    <p>Mail：<?= $mail ?> </p>
    <ul>
        <li><a href="index.php">index.php</a></li>
    </ul>
</body>

</html>

```

{% hint style="info" %}
var\_dumpは\<pre>で囲ってあげると、整形されて見やすいです。

```php
// ↓ こんな感じ
echo '<pre>';
var_dump($_GET);
echo '</pre>';
```

{% endhint %}

{% hint style="info" %}
HTML内では、echoは以下のように省略した記述が可能です。

```php
<?php echo $name ?>
// ↓
<?= $name ?>
```

{% endhint %}

{% hint style="success" %}
フォームに新しいinput要素(例えば、年齢や性別など)を加えて、それを受け取ってみましょう。
{% endhint %}

_post.php(送信側)_

```php
    <form action="post_confirm.php" method="post">
        お名前: <input type="text" name="name">
        EMAIL: <input type="text" name="mail">
        パスワード:<input type="text" name="password">
        <input type="submit" value="送信">
    </form>
```

{% hint style="info" %}
_getとpostはmethodを変えるだけです。_
{% endhint %}

_post\_confirm.php(受け取り側)_

```php
<?php
// POSTを受け取る
$name = $_POST['name'];
$mail = $_POST['mail'];
$password = $_POST['password'];
?>

<html>

<head>
    <meta charset="utf-8">
    <title>POST（受信）</title>
</head>

<body>
    お名前：<?= ($name) ?>
    EMAIL：<?= ($mail) ?>
    パスワード：<?= ($password)  ?>
    <ul>
        <li><a href="index.php">index.php</a></li>
    </ul>
</body>

</html>

```

### セキュリティ / XSS(クロスサイトスクリプティング)

post.phpのフォームに以下のスクリプトを記入して送信して、動きを確認してください。

```javascript
<script>alert("ok");</script>
```

{% hint style="danger" %}
不特定多数の人間が記入できるFormは、悪意を持った人にスクリプトを埋め込まれる可能性があります。
※WEB上には悪いことをする人がかならずいる、という前提でプロダクト制作をしてください。
{% endhint %}

{% hint style="danger" %}
GETやPOSTで受け取ったデータを出力する場合は必ず以下の処理を行ってください。
{% endhint %}

`htmlspecialchars(変数,ENT_QUOTES);`

```php
// XSS対策関数
function h($val){

   return htmlspecialchars($val,ENT_QUOTES);

}
```

_呼び出し方_\
`<?php echo h(変数); ?>`

post\_comfirm.phpをを以下のように変更してください。

```php
<body>

    お名前：<?= h($name) ?>
    EMAIL：<?= h($mail) ?>
    パスワード：<?= h($password)  ?>

    <ul>
        <li><a href="index.php">index.php</a></li>
    </ul>
</body>

```

### ファイル保存・読み込み <a href="#fairu" id="fairu"></a>

{% hint style="info" %}
データベースを利用した保存方法を行いたいところですが時間的に厳しいので、ファイルへの保存方法を学びます。
{% endhint %}

#### write.php

```php
<?php
// ファイルに書き込む内容を用意。まずは日付を保存する。
$time = date("Y-m-d H:i:s");

// aモードでファイルをオーブン
$file = fopen('data/data.txt', 'a');

//ファイルへの書き込み
fwrite($file, $time."\n");

//ファイルを閉じる
fclose($file);
?>
```

- fopenの引数について
fopenの第２引数(openモード)には以下のような種類があります。
方法によって使い分けてください。

間違えると、中身を削除してしまうので、ご利用は慎重に。

```
r 読み込みのみでオープンします。
r+ 読み込み/書込み用にオープンします。

w 書込みのみでオープンします。内容をまず削除、ファイルがなければ作成
w+ 読み込み/書込み用でオープンします。内容をまず削除、ファイルがなければ作成

a 追加書込み用のみでオープンします。ファイルがなければ作成
a+ 読み込み/追加書込み用でオープンします。ファイルがなければ作成
```

{% hint style="info" %}
ファイル操作の基本は、

open

処理

close の３つがセットです。
{% endhint %}

#### read.php

```php
<?php
// ファイルを開く
$openFile = fopen('./data/data.txt', 'r');

// ファイル内容を1行ずつ読み込んで出力
while ($str = fgets($openFile)) {
    echo nl2br($str);
};

fclose($openFile);

```

### `inpute.php`から`write.php`に内容を送ってみよう

#### input.php

```
$name = $_POST['name'];
$birthPlace = $_POST['birthPlace'];

// 変数を用意
$time = date("Y-m-d H:i:s");
$str = $time . ' / ' . $name . ' /' .  $mail . ' ' . $birthPlace;

// ファイルに書き込み
$file = fopen('data/data.txt', 'a');
fwrite($file, $str . "\n");
fclose($file);
```
