# 命名規則に従わない場合の多対多連携

命名規則に従っていない場合は、モデルの設定でカスタマイズする。

例えばユーザのフォロー機能を実装したい場合は下記の流れとなる

* フォロー関係を表す中間テーブル（follows）を作成する
* User モデルに belongsToMany を 2 つ追加する

### 中間テーブルの作成 <a href="#tburuno" id="tburuno"></a>

マイグレーションファイルの例

```php

// ...

public function up()
{
  Schema::create('follows', function (Blueprint $table) {
    $table->id();
    // 🔽 user_id（誰が）カラムとfollowing_id（誰を）を追加する
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->foreignId('following_id')->constrained('users')->cascadeOnDelete();
    $table->unique(['user_id', 'following_id']);
    $table->timestamps();
  });
}

// ...

```

#### ## User モデルの設定 <a href="#user-moderuno" id="user-moderuno"></a>

前項の like 機能と比較すると，カラム名を自分で指定しているため belongsToMany の引数が多い．

`followings()` を呼び出す場合は「follows テーブルの user\_id カラムに呼び出し元のユーザ id を指定し，following\_id カラムに入っているユーザの一覧を取得」する．

`followers()` は上記と逆の関係性となる．

```php
public function followings()
{
  return $this->belongsToMany(self::class, "follows", "user_id", "following_id")->withTimestamps();
}

public function followers()
{
  return $this->belongsToMany(self::class, "follows", "following_id", "user_id")->withTimestamps();
}
```

このように命名規則に従った場合と比較してモデルの設定が複雑になるため，やむを得ない場合以外は命名規則に従うことを強く推奨する．
