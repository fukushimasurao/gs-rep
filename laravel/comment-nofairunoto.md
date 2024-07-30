# 🎇 Comment 機能の実装（ファイルの準備と設定）

ここでやりたいこと

* 各 tweet に対してコメントを投稿できるようにする
* tweet とコメントは一対多の関係
* コメントは tweet 詳細画面からコメント投稿画面に移動して投稿する
* コメントは tweet 詳細画面に一覧表示される
* 各コメントをクリックするとコメント詳細画面に移動でき，編集や削除ができる．

### [必要なファイルの作成](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E5%BF%85%E8%A6%81%E3%81%AA%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E4%BD%9C%E6%88%90) <a href="#nafairuno" id="nafairuno"></a>

モデル、リソースコントローラ、マイグレーションファイルを作成する。

Tweet に関するファイルを作成するときと同様の流れ。

```bash
./vendor/bin/sail php artisan make:model Comment -rm
```

下記のファイルが作成される．

* `app/Models/Comment.php`
* `database/migrations/xxxx_xx_xx_xxxxxx_create_comments_table.php`
* `app/Http/Controllers/CommentController.php`

### [マイグレーションファイルの編集](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E3%83%9E%E3%82%A4%E3%82%B0%E3%83%AC%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E7%B7%A8%E9%9B%86) <a href="#maigurshonfairuno" id="maigurshonfairuno"></a>

comments テーブルを作成するためのマイグレーションファイルを記述する．

`comment` カラムに加えて `tweet_id` と `user_id` を設定する．「どの Tweet に対する」「どのユーザの」という情報を保存する．

* Tweet と Comment の関係は `1 対多`
* User と Comment の関係は `1 対多`

```php
// database/migrations/xxxx_xx_xx_xxxxxx_create_comments_table.php

// 省略

public function up(): void
{
  Schema::create('comments', function (Blueprint $table) {
    $table->id();
    // 🔽 3カラム追加
    $table->foreignId('tweet_id')->constrained()->cascadeOnDelete();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('comment');
    $table->timestamps();
  });
}

// 省略

```

作成したら下記コマンドを実行してマイグレーションを実行する．

```bash
./vendor/bin/sail php artisan migrate
```

phpmyadmin で確認すると，下記の構造で comments テーブルが作成されている．

```txt
+-------------+-----------------+------+-----+---------+----------------+
| Field       | Type            | Null | Key | Default | Extra          |
+-------------+-----------------+------+-----+---------+----------------+
| id          | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| tweet_id    | bigint unsigned | NO   | MUL | NULL    |                |
| user_id     | bigint unsigned | NO   | MUL | NULL    |                |
| comment     | varchar(255)    | NO   |     | NULL    |                |
| created_at  | timestamp       | YES  |     | NULL    |                |
| updated_at  | timestamp       | YES  |     | NULL    |                |
+-------------+-----------------+------+-----+---------+----------------+
```

### [モデルファイルの設定](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E3%83%A2%E3%83%87%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E8%A8%AD%E5%AE%9A) <a href="#moderufairuno" id="moderufairuno"></a>

モデルファイルには，テーブルとの関連を定義する．今回は下記のとおり．

* Tweet と Comment が 1 対多．
* User と Comment が 1 対多．

`app/Models/Comment.php`，`app/Models/Tweet.php` ， `app/Models/User.php` それぞれに連携を設定する．`Comment.php` に対しては `$fillable` も設定しておく．

```php
// app/Models/Comment.php

// 省略

class Comment extends Model
{
  use HasFactory;

  // 🔽 設定できるカラムを追加
  protected $fillable = ['comment', 'tweet_id', 'user_id'];

  // 🔽 多対1の関係
  public function tweet()
  {
    return $this->belongsTo(Tweet::class);
  }

  // 🔽 多対1の関係
  public function user()
  {
    return $this->belongsTo(User::class);
  }
}

```

```php
// app/Models/User.php

// 省略

class User extends Authenticatable
{

  // 省略

  // 🔽 1対多の関係
  public function comments()
  {
    return $this->hasMany(Comment::class);
  }
}

```

```php
// app/Models/Tweet.php

// 省略

class Tweet extends Model
{
  use HasFactory;

  protected $fillable = ['tweet'];

  // 🔽 1対多の関係
  public function comments()
  {
    return $this->hasMany(Comment::class)->orderBy('created_at', 'desc');
  }
}

```

### [ビューファイルの作成](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E3%83%93%E3%83%A5%E3%83%BC%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E4%BD%9C%E6%88%90) <a href="#byfairuno" id="byfairuno"></a>

コメント機能で使用するビューファイルを作成する．Tweet の CRUD 処理と同様だが，コメント一覧は `tweets.show` に追加するため `index.blade.php` は作成しなくて OK．

```bash
$ php artisan make:view tweets.comments.create
$ php artisan make:view tweets.comments.show
$ php artisan make:view tweets.comments.edit
```

### [ルーティングの設定](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%81%AE%E8%A8%AD%E5%AE%9A) <a href="#rtinguno" id="rtinguno"></a>

リソースコントローラを使用しているのでルーティングは 1 行書くだけでok

ただし、Comment は Tweet に従うためルーティングは `tweet.comment` となる。

このような記述を行う理由として、Comment に対する処理（表示，編集，削除）を行う場合に Comment の元の Tweet の情報が必要となることが挙げられる。

ルーティングを上記のように記述すると Tweet の情報も合わせて得ることができる（後述）。

```php
// routes/web.php

<?php

// 🔽 追加
use App\Http\Controllers\CommentController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\TweetController;
use App\Http\Controllers\TweetLikeController;
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
  Route::resource('tweets', TweetController::class);
  Route::post('/tweets/{tweet}/like', [TweetLikeController::class, 'store'])->name('tweets.like');
  Route::delete('/tweets/{tweet}/like', [TweetLikeController::class, 'destroy'])->name('tweets.dislike');
  // 🔽 追加
  Route::resource('tweets.comments', CommentController::class);
});

require __DIR__ . '/auth.php';
```

### [ルーティングの確認](https://gs-lab-202406.deno.dev/laravel/tweet-comment-setting.html#%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%81%AE%E7%A2%BA%E8%AA%8D) <a href="#rtinguno" id="rtinguno"></a>

Comment に関する CRUD 処理のルートが自動的に追加されていることが確認できる

```bash
php artisan route:list --path=comments

# 実行結果（ユーザ操作などのルーティングは省略）
+--------+-----------+------------------------------------------+-------------------------+-------------------------------------------------------+-----------------+
| Domain | Method    | URI                                      | Name                    | Action                                                | Middleware      |
+--------+-----------+------------------------------------------+-------------------------+-------------------------------------------------------+-----------------+
|        | GET|HEAD  | tweets/{tweet}/comments                  | tweets.comments.index   | App\Http\Controllers\CommentController@index          | web             |
|        | POST      | tweets/{tweet}/comments                  | tweets.comments.store   | App\Http\Controllers\CommentController@store          | web             |
|        | GET|HEAD  | tweets/{tweet}/comments/create           | tweets.comments.create  | App\Http\Controllers\CommentController@create         | web             |
|        | GET|HEAD  | tweets/{tweet}/comments/{comment}        | tweets.comments.show    | App\Http\Controllers\CommentController@show           | web             |
|        | PUT|PATCH | tweets/{tweet}/comments/{comment}        | tweets.comments.update  | App\Http\Controllers\CommentController@update         | web             |
|        | DELETE    | tweets/{tweet}/comments/{comment}        | tweets.comments.destroy | App\Http\Controllers\CommentController@destroy        | web             |
|        | GET|HEAD  | tweets/{tweet}/comments/{comment}/edit   | tweets.comments.edit    | App\Http\Controllers\CommentController@edit           | web             |
+--------+-----------+------------------------------------------+-------------------------+-------------------------------------------------------+-----------------+
```

\
