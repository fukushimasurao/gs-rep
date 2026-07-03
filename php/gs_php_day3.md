# 013\_gs\_php\_day3

## PHP授業 全5日間の概要

| Day | テーマ | 学ぶこと |
|---|---|---|
| Day1 | PHP基礎 | 変数・配列・関数・ループ、フォーム操作、ファイル保存 |
| Day2 | DB入門 | DB・テーブルの概念、SQL（INSERT/SELECT）、PHPからDB操作（PDO） |
| **Day3** | **CRUD** | **詳細表示・更新（UPDATE）・削除（DELETE）、コードの関数化** |
| Day4 | ログイン機能 | セッション管理、権限による処理の分岐、パスワードのハッシュ化 |
| Day5 | DBリレーション | テーブルの設計・正規化、JOINで複数テーブルを扱う |

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

今日は、`Update（更新）`、`Delete（削除）`をやっていきます。

* `CRUD`とは？ [https://wa3.i-3-i.info/word123.html](https://wa3.i-3-i.info/word123.html)

## 本日のタイムライン

| コマ | テーマ | 内容 |
|---|---|---|
| コマ1（50分） | 復習・詳細表示 | 前回復習 → detail.php実装 |
| コマ2（50分） | 更新・削除・危険体感 | update.php/delete.php実装 → WHERE忘れ危険体感 → Slack共有 |
| コマ3（50分） | 関数化・まとめ | funcs.phpへのリファクタリング → 宿題説明 |

### AIに渡すコンテキスト定型文

AI に質問する前に、毎回以下をチャットに貼り付けてください。これを渡すことで、授業の内容に合ったコードを生成してくれます。

```
【このAIセッションのコンテキスト】
- PHPの授業でXAMPPを使っています
- フレームワークは使わず、素のPHPで書きます
- DBはMySQLで、接続にはPDOを使います
- DB名: gs_db_class3、テーブル: gs_an_table
- カラム: id(PK,AI), name(varchar64), email(varchar128), age(int), content(text), indate(datetime)
- コードはシンプルに。初学者向けで、変数名もわかりやすく
- mysql_*関数やmysqliは使わず、必ずPDO＋プレースホルダで書いてください
- DB接続などの共通処理は、すでにfuncs.phpにまとめる方針で進めています
```

---

## コマ1：復習・詳細表示

### XAMPPの起動、DB準備

XAMPPのapache,mysql serverを起動させてください。

http://localhost/phpmyadminを開いて、DBを用意しましょう。

↓を新たに作成してください。

```
データベース名：gs_db_class3
```

1. 作成ボタンをクリック 左側に`gs_db_class3`というデータベースができていると思います。 現在は空っぽです。

### SQLファイルからインポート

〇〇.sqlというSQLファイルをインポートしてデータを作成します。

1. 念の為、左側のメニューから`gs_db_class3`をクリック
2. gs\_db3を選択した状態でインポートタブをクリック
3. ファイルを選択をクリックして配布した資料内のSQLフォルダ内のphp3\_sql.sqlを選択
4. 実行してみる
5. 授業用のDBと中身を確認

### 登録処理までの確認（前回の復習）

{% hint style="success" %}
**【AI活用】Day2の4ブロック構造を思い出そう**

授業を始める前に、AIに一言で確認してもらいましょう。

【サンプルプロンプト】
```
PHPでDB操作をするとき、「DB接続」「SQL作成」「実行」「実行後の処理」の
4ブロックで書くと教わりました。それぞれのブロックが何をするものか、
1行ずつで簡潔に説明してください。
```
{% endhint %}

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

### 一覧画面（select.php）の確認

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

{% hint style="success" %}
**【AI活用】detail.phpのスケルトンをAIに渡して穴埋めしてもらおう**

以下のスケルトンをAIに渡して、`/* */`の部分を埋めてもらいましょう。埋め終わったら、授業資料の完成形と見比べて「違う部分を探して」みてください。

【サンプルプロンプト】
```
【コンテキスト】
- PHPの授業でXAMPPを使っています
- フレームワークは使わず、素のPHPで書きます
- DBはMySQLで、接続にはPDOを使います
- DB名: gs_db_class3、テーブル: gs_an_table
- カラム: id(PK,AI), name(varchar64), email(varchar128), age(int), content(text), indate(datetime)

【依頼】
以下のスケルトンの /* */ 部分を埋めてください。構造とコメントは変えないでください。
select.phpから送られてくるidを使って、そのidの1件だけをSELECTするコードです。

<?php
// select.phpから送られてくる対象のIDを取得
$id = /* GETで受け取る */;

// 1. DB接続
try {
    $pdo = new PDO(/* 接続情報 */);
} catch (PDOException $e) {
    exit('DB Connection Error:' . $e->getMessage());
}

// 2. SQL作成
// WHERE id=:idを使って1件だけ取得する
$stmt = $pdo->prepare(/* SELECT文 */);
/* bindValueを1行 */

// 3. 実行
$status = $stmt->execute();

// 4. 実行後の処理
$result = '';
if ($status === false) {
    exit('SQLError:' . print_r($stmt->errorInfo(), true));
} else {
    $result = /* 1件だけ取得するfetchの書き方 */;
}
?>
```
{% endhint %}

1. detail.phpにデータ取得処理を記述

`detail.php`の完成形（AIの出力と見比べてみよう）

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

{% hint style="success" %}
**【自分で書こう】**

コピペして動作確認したら、以下の2箇所を削除して自分で書いてみよう。

1. `prepare()`の中のSQL文（WHERE句を忘れずに）
2. `bindValue`の1行
{% endhint %}

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

---

## コマ2：更新・削除・危険体感

### UPDATE（データ更新）

**書式**

**whereを忘れないようにしましょう。**

```sql
UPDATE テーブル名 SET 更新対象1=:更新データ ,更新対象2=:更新データ2,... WHERE id = 対象ID;
```

{% hint style="success" %}
**【AI活用】update.phpを全部AIに書かせてみよう**

detail.phpと同じ4ブロック構造なので、今度はAIに丸ごと生成してもらい、資料と比較する形で進めます。

【サンプルプロンプト】
```
【コンテキスト】
- PHPの授業でXAMPPを使っています
- フレームワークは使わず、素のPHPで書きます
- DBはMySQLで、接続にはPDOを使います
- DB名: gs_db_class3、テーブル: gs_an_table
- カラム: id(PK,AI), name(varchar64), email(varchar128), age(int), content(text), indate(datetime)

【依頼】
detail.phpのフォームから送られてくるname, email, age, content, id を
POSTで受け取り、idを条件にUPDATEするupdate.phpを書いてください。
「1.DB接続」「2.SQL作成」「3.実行」「4.実行後の処理」の4ブロックのコメントを
入れてください。更新後はselect.phpにリダイレクトしてください。
```

生成されたコードと、下の完成形コードを見比べて「同じ構造になっているか」を確認しましょう。
{% endhint %}

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

### 削除処理を実装していく

PHPの基本処理、登録・表示（取得）・更新・削除の4つのうちの最後の一つです。 削除処理は削除ボタンクリック→削除処理の流れなので比較的簡単です。

### DELETE（データ削除）

**書式**

```sql
DELETE FROM テーブル名 WHERE id = :id
```

{% hint style="info" %}
WHERE句で指定しないと、全部消えるので、超注意
{% endhint %}

{% hint style="success" %}
**【AI活用】delete.phpもAIに書かせてみよう**

update.phpとの共通点・差分に注目しながら見比べてみてください。

【サンプルプロンプト】
```
【コンテキスト】
- PHPの授業でXAMPPを使っています
- DBはMySQLで、接続にはPDOを使います
- DB名: gs_db_class3、テーブル: gs_an_table

【依頼】
select.phpのフォームからPOSTで送られてくるidを受け取り、
そのidのレコードをDELETEするdelete.phpを書いてください。
update.phpと同じ4ブロック構造のコメントを入れてください。
削除後はselect.phpにリダイレクトしてください。
```

「update.phpと比べて、無くなったブロック・変わった部分はどこ？」を確認しましょう（ヒント：受け取る項目がidだけになります）。
{% endhint %}

{% hint style="success" %}
**【AI活用】なぜ削除はGETよりPOSTがいいのか、AIに聞いてみよう**

detail.phpへのリンクはGET、delete.phpへはPOSTを使っています。この違いをAIに質問して、出てきた回答を全体で共有しましょう。

【サンプルプロンプト】
```
PHPの授業でDBを学んでいます。初学者向けにわかりやすく教えてください。

【質問】
detail.phpへの遷移リンクはGET（<a href="detail.php?id=...">）で作りましたが、
delete.phpへの削除ボタンはPOST（<form method="POST">）で作るように言われました。
なぜ削除処理はGETではなくPOSTの方がいいのですか？
```

**確認してほしいポイント**
* GETリンクだと、ブラウザの先読み（プリフェッチ）機能やクローラーがリンクを開いただけで削除が実行されてしまう危険がある
* GETは「データを取得するだけで、サーバー側の状態を変えない」という前提で使うもの。DELETEのようにデータを変更する処理には向かない

AIの回答が上記のポイントと合っているか確認してみましょう。
{% endhint %}

### 削除ボタン（削除フォームを作成する）

1. select.phpのデータ表示のwhile文内のHTML生成に削除フォームを作成

```php
//POSTデータ送信フォーム作成
$view .= '<p>';
$view .= '<a href="detail.php?id=' . $result['id'] . '">';
$view .= $result["indate"] . "：" . $result["name"];
$view .= '</a>';
//追記：削除は<a>ではなく<form method="POST">で送る
$view .= '<form method="POST" action="delete.php" style="display:inline;">';
$view .= '<input type="hidden" name="id" value="' . $result['id'] . '">';
$view .= '<button type="submit">削除</button>';
$view .= '</form>';
$view .= '</p>';
```

{% hint style="info" %}
`style="display:inline;"`は、`<form>`が改行を作ってしまうため、見た目をリンクのように並べるための応急処置です。デザインをこだわりたい場合はCSSクラスを作って対応しましょう。
{% endhint %}

1. delete.phpに削除処理を作成する

(`update.php`の中身をコピぺして、不要部分を修正削除すると楽です)

```php
//1.対象のIDを取得
// POSTで取得するので、POSTに書き換え
$id   = $_POST['id'];

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

---

### WHERE忘れ危険体感

Day2ではSQLインジェクションという「悪意ある人からの攻撃」を体感しました。今回は、**自分のミスだけで全データを壊せてしまう**危険を体感します。

{% hint style="danger" %}
これから行う操作は、必ず練習用DB（`gs_db_class3`）でのみ行ってください。事前にphp3\_sql.sqlをもう一度インポートし直せる状態にしておいてください。
{% endhint %}

#### Step1. 危険なコードを試してみる

`update.php`のSQL作成ブロックを、一時的に以下のように書き換えてみましょう。

```php
// ※学習用の危険コード。WHEREを忘れています。実際のコードでは厳禁。
$stmt = $pdo->prepare('UPDATE gs_an_table SET name = :name');
$stmt->bindValue(':name', $name, PDO::PARAM_STR);
```

実行してみて、select.phpを開いてみましょう。

#### Step2. 何が起きた？

1件だけ更新するつもりが、**全件のnameが同じ値に書き換わっている**はずです。

同様に、`delete.php`側で以下を試すと、全件が削除されます（実行は講師のデモのみでもOK）。

```php
// ※学習用の危険コード。WHEREを忘れています。実際のコードでは厳禁。
$stmt = $pdo->prepare('DELETE FROM gs_an_table');
```

{% hint style="warning" %}
PHPはエラーを出しません。SQLとしては正しい文なので、「意図通りに全件処理された」だけです。
{% endhint %}

#### Step3. グループで議論してみよう

以下について、近くの人と話してみてください。

* 実務でこれをやってしまったら何が起きる？
* Day2のSQLインジェクションと、今回のWHERE忘れ。危険の種類はどう違う？
* どうすればこのミスを事前に防げそう？

#### Step4. AIで議論を要約してSlackに投稿してみよう

{% hint style="success" %}
**【AI活用】グループの議論をAIに要約してもらう**

【サンプルプロンプト】
```
【コンテキスト】
PHPの授業で、UPDATE/DELETE文のWHERE句を忘れると何が起きるかを学びました。

【依頼】
以下の議論内容を、Slackに投稿する3行以内の共有メッセージにまとめてください。
初学者にも伝わる言葉で、結論を最初に書いてください。

【議論内容】
（ここにグループで話した内容のメモを貼る）
```
{% endhint %}

まとめたメッセージを授業用のSlackチャンネルに投稿してください。投稿し終わったら、他のグループの投稿にも目を通してみましょう。同じテーマでも、まとめ方や言葉の選び方に違いがあるはずです。

#### Step5. update.php / delete.phpを元に戻す

体感が終わったら、必ず正しいWHERE句付きのコードに戻してください。

---

## コマ3：関数化・まとめ

よく使う処理は関数化するのが一般的です。 同じ処理を複数回書くのではなく関数化して再利用しましょう。

{% hint style="success" %}
**【AI活用】自分のコードをAIにリファクタリングさせよう**

insert.php・detail.php・update.php・delete.phpの「1. DB接続」ブロックは、すべて同じコードが書かれています。AIに重複を指摘・改善してもらいましょう。

【サンプルプロンプト】
```
【コンテキスト】
- PHPの授業でinsert.php, detail.php, update.php, delete.phpを作りました
- どのファイルにも同じようなDB接続処理・エラー処理・リダイレクト処理が書かれています

【依頼】
以下の重複しているコードを、funcs.phpに関数としてまとめる提案をしてください。
関数名と使い方も教えてください。

（各ファイルのDB接続〜エラー処理部分を貼る）
```

AIの提案と、下記の授業資料の関数名・設計を見比べてみましょう。「なぜこの3つの関数に分けるのか」を説明できるか確認してください。
{% endhint %}

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
        $pdo->exec('SET SQL_SAFE_UPDATES = 1'); // WHEREなしのUPDATE/DELETEをDB側で拒否させる
        // return $pdo;を忘れないように。 
        return $pdo;
    } catch (PDOException $e) {
        exit('DB Connection Error:' . $e->getMessage());
    }
}
```

{% hint style="info" %}
`SET SQL_SAFE_UPDATES = 1`は、キー列を使ったWHEREが無い（＝全件が対象になる）UPDATE/DELETEをMySQL/MariaDB側でエラーにしてくれる設定です。ここでdb_conn()に1行追加しておくだけで、insert.php・detail.php・update.php・delete.phpすべてに自動で効くようになります。

先ほど体感した「WHERE忘れ」は、これを設定しておけば未然に防げていました。
{% endhint %}

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

### SQLエラー処理とリダイレクト処理を関数化

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

---

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

{% hint style="info" %}
AIをフル活用してOKです。ただし、生成されたコードの各部分が何をしているか説明できるようにしておいてください。
{% endhint %}

---

## プラスアルファ（早く終わった人向け）

### ① WHERE忘れをコードで防ぐ工夫を考える

WHERE忘れ危険体感を踏まえて、「もしこのミスをコードレベルで未然に防ぐとしたら、どんな工夫ができそうか」をAIに相談してみましょう。

【サンプルプロンプト】
```
PHPでUPDATE/DELETE文のWHERE句を書き忘れて全件更新・全件削除してしまう事故が
授業で話題になりました。初学者でもできる、事故を未然に防ぐ工夫を教えてください。
```

### ② SELECTの応用をAIと遊ぶ

「年齢が20歳以上の人だけ取得するSQL書いて」など、要件をAIに渡してSQL生成→phpMyAdminで実際に動かしてみよう。

```sql
-- ヒント：こんな形になるはず
SELECT * FROM gs_an_table WHERE age >= 20;
```

### ③ AIにコードレビューさせてみる

自分が書いたupdate.phpやdelete.phpをAIに渡して「このコードの改善点を教えて」と聞いてみよう。AIのレビューを読んで、採用するかどうか自分で判断してみてください。
