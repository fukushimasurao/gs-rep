# 001\_4\_Laravel-MVCの流れ

【PHPの場合】

localhost/select.phpにアクセス select.phpが上から実行される。 基本的にファイルは1個で完結する。 (もちろん他のファイルを参照したり分割したりもできるが、基本は1ファイル)

<コード上部: PHPの部分> SELECT \* FROM gs\_an\_table; $row に取得した情報を格納

<コード下部: HTMLの部分> PHPで取得した情報をHTMLの部分で描写

```php
<?php
// データベース接続
$pdo = new PDO('mysql:dbname=test;host=localhost', 'root', '');

// データ取得
$stmt = $pdo->query("SELECT * FROM gs_an_table");
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<body>
    <?php foreach($rows as $row): ?>
        <p><?= $row['name'] ?></p>
    <?php endforeach; ?>
</body>
</html>
```

【Laravelの場合】 例えば、localhost/userにアクセス

\<route ... web.php> URLに沿って「ここに処理が書いてあるからそっち参照して」と指示。 例えば今回の場合は、 「userにアクセス(GET)されたら、UserControllerのindexメソッドを確認してー」 と記載されているとする。

```php
// === routes/web.php ===
Route::get('/user', [UserController::class, 'index']);
// 「/userにGETでアクセスされたら、UserControllerのindexメソッドを実行して」
```

なお、「/userにGETでアクセス」というのは、 ブラウザで「http://localhost/user」にアクセスしたときのこと。 (リンクをクリックしたり、アドレスバーに直接入力したりする通常のアクセス = GET)

\<Controller ... UserController> 上記routeから指定されたメソッドが実行される。 今回で言えば、「userの一覧を取得して画面へ渡す」 ただしこのときDBへのアクセスが必要な場合はを通して中身が取得される。 また、画面の描写はファイルが行うので、ControllerからViewにデータが渡される。

```php
// === app/Http/Controllers/UserController.php ===
public function index()
{
    // Modelを通してデータ取得
    $users = User::all();
    
    // Viewにデータを渡す
    return view('user.index', ['users' => $users]);
}
```

\<Model ... UserModel> Laravelでは基本的に、DB操作する際はModelファイルを通して処理がされる。 基本1テーブルにつき1 Modelファイル存在する。 例えば

* Userテーブルの情報を取得したい場合: User Modelから情報を取得する処理をする
* Userテーブルへinsertしたい場合: User Modelに対してinsertする処理をする イメージ。

```php
// === app/Models/User.php ===
class User extends Model
{
    protected $table = 'users';
    // このModelはusersテーブルと紐づいている
}
```

\<View ... 画面に表示するファイル> 授業ではbladeファイル = XXXX.blade.phpを利用。 画面に描写したい内容をこのbladeファイルに記載する。 当然、controllerから渡された内容 + アルファをこの該当Viewに記載し、描写する。

```php
// === resources/views/user/index.blade.php ===
@foreach($users as $user)
    <p>{{ $user->name }}</p>
@endforeach
```

【違いの整理】

```
PHP(1ファイル)              Laravel(役割分担)
─────────────────────────────────────────
select.php                  ├ routes/web.php (交通整理)
├ DB接続・データ取得          ├ Controller (処理の指示)
├ HTML描写                  ├ Model (DB専門)
                           └ View (画面専門)

→ Laravelは「誰が何をするか」が明確に分かれている
```

【流れを覚えよう】

route > controller > (modelは無いこともあり) > view
