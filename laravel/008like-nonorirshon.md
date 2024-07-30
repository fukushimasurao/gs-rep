# 🥹 008\_Like 機能の実装（多対多のリレーション）

### やること

* User と Tweet の関係が多対多となる Like 機能を実装する。
* 多対多の場合，中間テーブルを作成 → モデルに多対多の連携を定義，の流れで実装できる。

### Like 機能実装の流れ

本項目では 1 を実施する。

1. 中間テーブルの作成と各モデルの連携
2. コントローラに Like 機能の実装
3. ビューファイルに like ボタンを設置

### 中間テーブルの作成と各モデルの連携

下記のコマンドを実行して中間テーブルを作成しよう。

```
$ php artisan make:migration create_tweet_user_table --create=tweet_user
```

このテーブルには「`どの Tweet に`」「`どの User` 」がlike したのか、という情報が入る。

今回はモデルを作成しないため直接マイグレーションファイルを作成しましょう。

テーブル名は `tweet_user` 。

命名のルールは「**アルファベット順に並べたテーブル名の単数形をアンダースコアでつなげる**」

今回は 2 つのテーブルをリレーションできればよいためモデルは作成**しません。**

### マイグレーションファイルの記述と実行

マイグレーションファイルを開き下記のように編集しよう。

中間テーブルとなるためカラムは id 以外に tweet\_id と user\_id を追加。



```php
// database/migrations/xxxx_xx_xx_000000_create_tweet_user_table.php

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateTweetUserTable extends Migration
{
  /**
   * Run the migrations.
   */
  public function up(): void
  {
    Schema::create('tweet_user', function (Blueprint $table) {
      $table->id();
      
      // 🔽 3行追加 🔽
      $table->foreignId('tweet_id')->constrained()->cascadeOnDelete();
      $table->foreignId('user_id')->constrained()->cascadeOnDelete();
      $table->unique(['tweet_id', 'user_id']);
      
      $table->timestamps();
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('tweet_user');
  }
}
```

記述したらマイグレーションを実行!!!!!

```
$ php artisan migrate
```

### モデルの編集

中間テーブルの作成が完了したら各モデルに中間テーブルとの関連を定義。

今回の場合は、`User` モデルと `Tweet` モデルの両方に関連を定義する必要があり。

多対多の場合は `belongsToMany` を使用しましょう。

```php
// app/Models/User.php

<?php

// ...

class User extends Authenticatable
{

  // ...

  // 🔽 追加 🔽 
  public function likes()
  {
      return $this->belongsToMany(Tweet::class)->withTimestamps();
  }
}
```

```php
// app/Models/Tweet.php

<?php

// ...

class Tweet extends Model
{

  // ...

  // 🔽 追加 🔽 
  public function liked()
  {
      return $this->belongsToMany(User::class)->withTimestamps();
  }
}
```

{% hint style="info" %}
**Point**

【テーブル名とカラム名の命名規則】

データをリレーションさせる場合のテーブル名及びカラム名には命名規則が存在します。

* 1 対多のカラム名は「単数形のテーブル名の末尾に \_id をつける」
* 多対多の中間テーブル名は「アルファベット順に並べたテーブル名の単数形をアンダースコアでつなげる」

命名規則を守らなくてもモデルの設定でカスタマイズできますが、命名規則に従っておくと，モデルの設定を省略できます。

Laravel では**可能な限り命名規則に従うことを強く推奨します。**
{% endhint %}
