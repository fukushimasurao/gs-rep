# 🐡 003\_Modelとテーブルの用意

## 今回やること

* 実際にコードを書き、動くものを作る。

## モデルとテーブルの作成

* Tweet のデータを扱うモデルを作成する
  * モデルに関連するマイグレーションファイル，コントローラ，ファクトリも合わせて作成する．
* Laratter アプリケーションで使用するテーブルを用意する．

## テーブルの用意

Laravel でテーブルを作成する場合は`マイグレーションファイル`を作成しコマンドでマイグレーションファイルを動かすことにより作成されます。

&#x20;Laravel 側からテーブルを操作（CRUD 処理など）を行うためには`モデル`のファイルが必要となるため同時に作成します。

<figure><img src="../.gitbook/assets/modelとtable.jpg" alt=""><figcaption><p>Laravelでは、直接DBを触らない。</p></figcaption></figure>

{% hint style="info" %}
基本的には`テーブルに対して一つのモデルファイル`を作成するよ
{% endhint %}

{% hint style="info" %}
通常マイグレーションファイルは、`/database/migrations`の中に作成されるよ。
{% endhint %}

## Tweet モデルの作成

Tweet モデルとそれに関連する

* `マイグレーションファイル` ... モデルに対応するテーブル作成に使用
* `コントローラ` ... Tweet データの CRUD 処理に使用するメソッドを記述 を作成する。 コマンドにオプション（`-rm`）付加することで，これらを一括で生成する事ができる．

Laravel ではファイル名含めて命名規則が多く規則に従ってファイル名を作成することで実装も容易となる。 _コマンドでまとめて作成すると自動的に規則に従ってくれるので便利だしおすすめ_

以下コマンドを`cms`階層で実行する

`$ php artisan make:model Tweet -rm`

以下のようなlogが吐き出されて、`Model`, `migrationsファイル`、`Controller`が作成されればok

```bash
// cms階層にいることを確認
$ pwd
/home/ec2-user/environment/cms

$ php artisan make:model Tweet -rm

   INFO  Model [app/Models/Tweet.php] created successfully.  

   INFO  Migration [database/migrations/2024_07_23_122117_create_tweets_table.php] created successfully.  

   INFO  Controller [app/Http/Controllers/TweetController.php] created successfully.  
```

### マイグレーションファイルの編集

生成されたマイグレーションファイルに，`tweet` カラムと `user_id` カラムを追加する。&#x20;

※tweetsテーブルを直接操作しない。マイグレーションファイルを用いてテーブルを操作するのだ。

これにより、テキスト共有データの格納と各Tweet がどのユーザに属するかを識別が可能になる。

* 今回は `User` と `Tweet` の関係が `1 対 多`となるため，`tweets` テーブルに `user_id` カラムを追加する。
* 他のテーブルと relation させるためには，カラム名を「モデル名小文字\_id」とする必要がある。

{% hint style="info" %}
マイグレーションファイルを作成する時点で，「`1 対 多`」「`多 対 多`」などデータの構成を考慮しておく．
{% endhint %}

```php
// database/migrations/xxxx_xx_xx_xxxxxx_create_tweets_table.php

// 省略

public function up(): void
{
  Schema::create('tweets', function (Blueprint $table) {
    $table->id();
    
    // 🔽 2カラム追加
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('tweet');

    $table->timestamps();
  });
}

// 省略
```

* `foreignId('user_id')->constrained()` ... userテーブルのidを参照する外部キー制約を設定する。
* `cascadeOnDelete()` ... とあるusersテーブルのレコードが削除されたら、関連するtweetsテーブルのレコードも自動的に削除する制約を設定する。
* `string('tweet')` ... `string`型の`tweet`カラムを作成する。
* `timestamps();` ... 自動で、`created_at`カラムと、`updated_at`カラムを作成してくれる

マイグレーションファイルに記述して保存できたら、マイグレートを実行

```bash
$ php artisan migrate
```

```bash
voclabs:~/environment/cms $ php artisan migrate

   INFO  Running migrations.  

  2024_07_23_122117_create_tweets_table ................ 111ms DONE

voclabs:~/environment/cms $ 
```



phpMyAdminを確認して、テーブルのカラムを確認しよう。 以下のようなルールになっていればok

```bash
MariaDB [c9]> DESC tweets;
+------------+---------------------+------+-----+---------+----------------+
| Field      | Type                | Null | Key | Default | Extra          |
+------------+---------------------+------+-----+---------+----------------+
| id         | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| user_id    | bigint(20) unsigned | NO   | MUL | NULL    |                |
| tweet      | varchar(255)        | NO   |     | NULL    |                |
| created_at | timestamp           | YES  |     | NULL    |                |
| updated_at | timestamp           | YES  |     | NULL    |                |
+------------+---------------------+------+-----+---------+----------------+
```

### モデルファイルの設定

モデルファイルには関連するデータとの連携を定義する。&#x20;

ここに連携を記述しておくことで、連携先のデータを容易に操作できるようになる。 今回は `User` モデルと `Tweet` モデルが `1 対 多`で連携する。

`app/Models/User.php`にて`User` モデルに `Tweet` モデルとの関連を追記する。 `User` モデルから見ると，`Tweet` モデルとの関係は `1 対 多`となるため`tweets()`を作成する。

```php
// app/Models/User.php

// 省略

class User extends Authenticatable
{

  // 省略

  protected $casts = [
      'email_verified_at' => 'datetime',
      'password' => 'hashed',
  ];
  
  // 一番下に以下のメソッドを追加する。
  public function tweets()
  {
    return $this->hasMany(Tweet::class);
  }
}

```

同様に `Tweet` モデルにも関係を定義する。

`app/Models/Tweet.php` ファイルを開き`user` メソッドを追加。

`Tweet` と `User` の間に `多 対 1`の関係が定義される。

また，`$fillable` に `tweet` を追加する。

`$fillable` にはユーザからの入力を受け付けるカラムを指定する．

```php
// app/Models/Tweet.php

// 省略

class Tweet extends Model
{
  use HasFactory;

  // ↓1行追加
  protected $fillable = ['tweet'];

  // 以下userメソッド追加
  public function user()
  {
    return $this->belongsTo(User::class);
  }
}

```

{% hint style="info" %}
モデルを作成した段階で、別モデルとの連携を記述しておくことで，連携先のデータを容易に操作できるようになる
{% endhint %}

{% hint style="info" %}
`$fillable`はアプリケーション側から変更できるカラムを指定する（ホワイトリスト）。

&#x20;対して`$guarded`はアプリケーション側から変更できないカラムを指定する（ブラックリスト）

どちらを使用しても良いがどちらかを使用する必要がある。

自分でどちらを使うかルールを決めておこう。
{% endhint %}

### ルーティングの設定

`routes/web.php`ファイルに，`Tweet`に関するルートを設定する。 コードとしては、2行追加。

今回はモデル作成時に `-r` オプション（`--resource`）を指定しており`Tweet` に関する `CRUD` 処理のルートが自動的に追加されている。

```php
// routes/web.php

<?php

use App\Http\Controllers\ProfileController;

// ⭐️1行追加⭐️
use App\Http\Controllers\TweetController;

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
  return view('welcome');
});

Route::get('/dashboard', function () {
  return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
  Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
  Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
  Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
  
  // ⭐️ 追加 ⭐️
  Route::resource('tweets', TweetController::class);
});

require __DIR__ . '/auth.php';

```

### ルーティングの確認

ルーティングは下記のコマンドで確認可能。 `resource` を用いることで `Tweet` に関する `CRUD` 処理のルートが自動的に追加されていることが確認できる。

```bash
voclabs:~/environment/cms $ php artisan route:list --path=tweets

  GET|HEAD        tweets ...................... tweets.index  › TweetController@index
  POST            tweets ...................... tweets.store  › TweetController@store
  GET|HEAD        tweets/create ............. tweets.create   › TweetController@create
  GET|HEAD        tweets/{tweet} ................ tweets.show › TweetController@show
  PUT|PATCH       tweets/{tweet} ............ tweets.update   › TweetController@update
  DELETE          tweets/{tweet} .......... tweets.destroy    › TweetController@destroy
  GET|HEAD        tweets/{tweet}/edit ........... tweets.edit › TweetController@edit
                                                                                               Showing [7] routes
```
