# N + 1 問題

### N + 1 ?????

**この問題は `hasMany` や `belongsTo` を用いた連携をしている場合に発生する。**

例えば下記のようにユーザが投稿した tweet の一覧を取得する場合を考える

```php
// コードその①
$tweets = Tweet::query()->where('user_id', auth()->id())->get();
```

ビューファイルでは投稿したユーザ名を取得するため下記のコードが実行されていることとする．

```php
@foreach($tweets as $tweet)
  ...
  // コードその②
  {{$tweet->user->name}}
  ...
@endforeach
```

この場合ざっくりいうと

* `コードその①`の部分でtweet の一覧を取得する SQL 文が 1 回実行
* `コードその②`の部分で、各tweet のユーザ情報を取得するための SQL 文が tweet の個数分実行される。

つまりtweet が 1000 件存在したら`コードその②で`1001 回の SQL 文が実行されることとなる。



### 解決法

解決には「Eager ロード」を利用しよう。

`with` メソッドを使用して予めリレーションしているデータを一括して取得することができる。

こうすることで tweet の個数分 SQL を実行しなくてよくなる．

```php
$tweets = Tweet::query()
  ->where('user_id', auth()->id())
  ->with(['user'])
  ->get();
```

ちなみに`show` メソッドなどで Tweet のデータが直接渡されている場合は `load` メソッドを使用する．

```php
$tweet->load(['user']);
```

### 起きているのか起きていないのかわからん

下記の方法で調査可能！`AppServiceProvider.php`に以下のようにコードを追加するだけ

```php
// app/Providers/AppServiceProvider.php

<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
// 🔽 追加
use Illuminate\Database\Eloquent\Model;

class AppServiceProvider extends ServiceProvider
{
  public function register()
  {
    //
  }

  public function boot()
  {
    // 🔽 追加
    Model::preventLazyLoading(!$this->app->isProduction());
  }
}


```

あとはアプリケーションを動かすと，問題のある箇所で以下のようなエラーが表示される．

```
Attempted to lazy load [hoge] on model [App\Models\Hoge] but lazy loading is disabled.
```

コードの中で発生している部分も表示してくれるため、

`with` メソッドなどで修正 → 動作確認してエラーが表示されなくなれば解消されている！！！\
