# 🍄 006\_作成処理と詳細画面の実装

## 今回やること

1. Tweet の作成処理（tweet作成画面からpostしてテーブルへのデータ作成）を実装する。
2. Tweet 一件の詳細画面を作成する。

### 前提確認

* (1)について
  * `/tweets/create` のページ。
    * routeから`tweets/create`は`TweetController@create`を利用していること。
    * `TweetController@create`のreturnから`view('tweets.create')`のviewを描写しているいうことがわかる。
  * `view('tweets.create')`の中の`form`を見ると、`action`は`'tweets.store'`ということを確認。
    * routeから`'tweets.store'`へのpostは`TweetController@store` ということを確認。
* (2)について
  * `/tweets`のページに詳細画面へのリンクあり。
  * `route`から`/tweets`は`TweetController@index`を利用し、そこから`view('tweets.index')`に`$tweets`の情報を与えつつ描写していることを確認する。
  * `view('tweets.index')`に`<a href="{{ route('tweets.show', $tweet) }}"` の記載を確認する。`route`で見ると`TweetController@show` なので、`show`メソッドを記入していく。
    * なお、`route('tweets.show', $tweet)` は自動で`$tweetの主キー`を渡す。`$tweet->id`と書かなくてもok。

## Tweet 作成処理の実装

Tweet の作成処理は`TweetController` の `store` メソッドに記載。

`フォーム`から送信されてきたデータは `$request`に格納されているため、`validate` を用いてデータのバリデーションを行っていきます。\


ここでは，

* `tweet が空でないこと`
* `長さが 255 以内であること` を確認しています。

バリデーションをクリアしたら Tweet のデータを作成します。 <>br バリデーションをクリアしない場合（=tweetが空だったり255以上あったり）は自動的に作成ページ（とエラーメッセージ）が表示されます。

{% hint style="info" %}
```
$requestには、formから送られてきた中身が入っています。
`ddd($request->all());`
と書けば簡単に中身を確認できるぞ。
```
{% endhint %}

{% hint style="info" %}
以下コードの詳細は↓

[https://nu0640042.gitbook.io/gs\_php/laravel/laravel-tips/rekdonopatn](broken-reference)
{% endhint %}

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  public function store(Request $request)
  {
    $request->validate([
       // tweet必須 + 最高で255文字までの制限
      'tweet' => 'required|max:255',
    ]);

    $request->user()->tweets()->create($request->all());
    // $request->user()->tweets()->create($request->only('tweet')); // ←これでもok

    return redirect()->route('tweets.index');
  }
}
```

### 動作確認

作成画面に移動しtweetが投稿できることを確認しよう。

投稿したtweetが一覧画面に表示されることを確認しよう。

### Tweet 詳細画面の実装

TweetController の `show` メソッドを編集します。\
`show` メソッドは，Tweet の詳細画面を表示するためのものです。

一覧画面のリンク（ `<a href="{{ route('tweets.show', $tweet) }}">` 部分）で Tweet 1 件のデータが渡されているため、`$tweet` に該当する Tweet のデータが渡されます。\
`show` メソッドが受け取ったデータをそのままビューファイルに渡せば OK。

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  public function show(Tweet $tweet)
  {
    return view('tweets.show', compact('tweet'));
  }
}
```

### 詳細画面の作成

`resources/views/tweets/show.blade.php` ファイルを開き、Tweet の詳細画面を表示するためのコードを追加しましょう。\
ここでは，Tweetの投稿者のみが編集・削除できるようにするため、Tweet の投稿者とログインユーザが一致するかを確認した上で編集ボタンと削除ボタンを表示します。 ※下記補足参照！

```php
<!-- resources/views/tweets/show.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('Tweet詳細') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <a href="{{ route('tweets.index') }}" class="text-blue-500 hover:text-blue-700 mr-2">一覧に戻る</a>
          <p class="text-gray-800 dark:text-gray-300 text-lg">{{ $tweet->tweet }}</p>
          <p class="text-gray-600 dark:text-gray-400 text-sm">投稿者: {{ $tweet->user->name }}</p>
          <div class="text-gray-600 dark:text-gray-400 text-sm">
            <p>作成日時: {{ $tweet->created_at->format('Y-m-d H:i') }}</p>
            <p>更新日時: {{ $tweet->updated_at->format('Y-m-d H:i') }}</p>
          </div>
           <!--もしログインしている人のidとtweetした人のidが一緒の場合-->
          @if (auth()->id() === $tweet->user_id)
          <div class="flex mt-4">
            <a href="{{ route('tweets.edit', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">編集</a>
            <form action="{{ route('tweets.destroy', $tweet) }}" method="POST" onsubmit="return confirm('本当に削除しますか？');">
              @csrf
              @method('DELETE')
              <button type="submit" class="text-red-500 hover:text-red-700">削除</button>
            </form>
          </div>
          @endif

        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### 動作確認

一覧画面から詳細画面に移動しtweet の詳細が表示されることを確認しましょう。 編集と削除はまだ動作しないので画面の表示が確認できれば OKです。

### 【補足】認証ユーザ情報の取得

auth() ヘルパ関数を使用すると，現在認証されているユーザーを取得できます。

```php
// 現在認証しているユーザーを取得
$user = auth()->user();

// 現在認証しているユーザーのIDを取得
$id = auth()->id();
```
