# 008_Like機能の実装（多対多のリレーション）

## 事前準備

以下の環境が整っていることを確認してください：
- Laravel Sailが起動していること（`./vendor/bin/sail up -d`）
- 前回までのTweetアプリケーションが動作していること

## やること

UserとTweetの関係が**多対多**となる`Like機能`の実装。

<figure><img src="../.gitbook/assets/like_many-many.jpg" alt=""><figcaption></figcaption></figure>

多対多の場合は以下の流れが基本です：

1. 中間テーブルを作成
2. モデルに多対多の連携を定義

## 多対多リレーションの概念

多対多の場合は、中間テーブルを作成する必要があります。

中間テーブルに必要な情報：
- id
- tweet_id（どのツイートに）
- user_id（どのユーザーが）
- 日付（created_at, updated_at）

テーブル構造のイメージ：

| id | tweet\_id | user\_id | created\_at | updated\_at |
| -- | --------- | -------- | ----------- | ----------- |
| 1  | 1         | 1        | ...         | ...         |
| 2  | 2         | 1        | ...         | ...         |
| 3  | 1         | 2        | ...         | ...         |

{% hint style="warning" %}
**重要：重複防止**
同じユーザーが同じツイートに複数回いいねすることを防ぐため、以下のような重複レコードは登録できないようにします。

| id | tweet\_id | user\_id | created\_at | updated\_at |
| -- | --------- | -------- | ----------- | ----------- |
| 1  | 1         | 1        | ...         | ...         |
| 2  | 1         | 1        | ...         | ...         |
{% endhint %}

## Like機能実装の流れ

この章では以下の手順でLike機能を実装します：

1. **中間テーブルの作成と各モデルの連携** ← 今回実装
2. コントローラにLike機能の実装
3. ビューファイルにlikeボタンを設置

## 中間テーブルの作成と各モデルの連携

### マイグレーションファイルの作成

下記のコマンドを実行して中間テーブルを作成します。

```bash
./vendor/bin/sail artisan make:migration create_tweet_user_table --create=tweet_user
```

{% hint style="info" %}
**中間テーブルの命名規則**
- テーブル名：`tweet_user`
- 命名ルール：「**アルファベット順に並べたテーブル名の単数形をアンダースコアでつなげる**」
- 今回は2つのテーブルをリレーションできればよいため、専用のモデルは作成しません
{% endhint %}

### マイグレーションファイルの編集

マイグレーションファイルを開き、以下のように編集します。

中間テーブルとなるため、カラムはid以外に`tweet_id`と`user_id`を追加します。

```php
// database/migrations/xxxx_xx_xx_000000_create_tweet_user_table.php

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

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

{% hint style="info" %}
**外部キー制約の説明**
- `$table->foreignId('tweet_id')->constrained()->cascadeOnDelete();`  
  tweetsテーブルからレコードが削除されると、そのtweet_idを持つtweet_userテーブルのすべてのレコードが自動的に削除

- `$table->foreignId('user_id')->constrained()->cascadeOnDelete();`  
  usersテーブルからレコードが削除されると、そのuser_idを持つtweet_userテーブルのすべてのレコードが自動的に削除

- `$table->unique(['tweet_id', 'user_id']);`  
  tweet_userテーブルのtweet_idカラムとuser_idカラムの組み合わせを一意にして重複を防止
{% endhint %}

{% hint style="info" %}
**参考：constrainedを使わない書き方**
`constrained()`メソッドを使わない場合は以下のように記述します（より冗長になります）：

`$table->foreignId('user_id')->references('id')->on('users')->onDelete('cascade');`
{% endhint %}

### マイグレーションの実行

記述したらマイグレーションを実行します：

```bash
./vendor/bin/sail artisan migrate
```

## モデルの編集

中間テーブルの作成が完了したら、各モデルに中間テーブルとの関連を定義します。

今回の場合は、`User`モデルと`Tweet`モデルの両方に関連を定義する必要があります。

多対多の場合は`belongsToMany`を使用します。

### Userモデルの編集

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

### Tweetモデルの編集

```php
// app/Models/Tweet.php

<?php

// ...

class Tweet extends Model
{
    // 省略

    // 🔽 追加 🔽 
    public function likedByUsers()
    {
        return $this->belongsToMany(User::class)->withTimestamps();
    }
}
```

{% hint style="info" %}
**withTimestamps()について**
- 中間テーブルに`created_at`と`updated_at`を記録する場合に必要
- いいねした日時を記録できるため、分析やソート機能で活用可能
{% endhint %}

{% hint style="warning" %}
**Point**

【テーブル名とカラム名の命名規則】

データをリレーションさせる場合のテーブル名及びカラム名には命名規則が存在します。

* 1 対多のカラム名は「単数形のテーブル名の末尾に \_id をつける」
* 多対多の中間テーブル名は「アルファベット順に並べたテーブル名の単数形をアンダースコアでつなげる」

命名規則を守らなくてもモデルの設定でカスタマイズできますが、命名規則に従っておくと，モデルの設定を省略できます。

Laravel では**可能な限り命名規則に従うことを強く推奨します。**
{% endhint %}
