# ルートモデル結合

ルートモデル結合（Route Model Binding）は Laravel が提供する強力な機能の一つで、

ウェブルート（URL）のパラメータを自動的にモデルのインスタンス（今回は Tweet のデータ）に変換する仕組みである！

例えば、ルーティングに以下のように設定されている場合、通常`{tweet}` パラメータは投稿の ID を表す。

ルートモデル結合を使用するとTweetController の show メソッドには、ID に基づいてデータベースから検索された Tweet モデルのインスタンスが直接渡される。

```php
// web.php

🔽 パラメータに {tweet} （← モデル名小文字）を指定
Route::get('/tweets/{tweet}',  [TweetController::class, 'show']);
```

```php
// TweetController.php

// 🔽 引数に直接 Tweet モデルを指定できる
public function show(Tweet $tweet)
{
    return view('tweets.show', compact('tweet'));
}
```

なお，今回はコントローラ作成時に `--resource` オプションを指定しているため、ルートモデル結合が自動的に設定されている．

ルートモデル結合は必ず使用しなければならないわけではないが下記の利点がある．

* コードの簡素化: モデルの検索ロジックをルートやコントローラーから取り除き、コードを簡潔に保つことができます．
* 自動的な 404 エラー応答: モデルが見つからない場合、Laravel は自動的に 404 エラー応答を返す．これにより，手動でモデルが存在するかどうかをチェックする必要がなくなる。

[\
](https://gs-lab-202406.deno.dev/laravel/n-plus-1.html)
