# 006\_作成処理と詳細画面の実装

## 今回やること

1. Tweet の作成処理（tweet作成画面からpostしてテーブルへのデータ作成）を実装する。
2. Tweet 一件の詳細画面を作成する。

### 前提確認

* (1)について
  * 作成画面の場所を確認。urlを見ると場所は `http://localhost/tweets/create`
  * `/tweets/create`で描写されている画面について確認
    * routeから`tweets/create`は`TweetController@create`が利用されていることを確認しよう。
    * `TweetController@create`のreturnから`view('tweets.create')`のviewを描写しているいうことを確認しよう。
  * `view('tweets.create')`は`resources/views/tweets/create.blade.php`を指している。見てみよう。
    * 中の`form`を見ると、`action`は`'tweets.store'`ということを確認しよう。
    * routeから`'tweets.store'`へのpostは`TweetController@store` メソッドを利用するということを確認しよう。
* (2)について
  * ※前提 : ツイートを数件作成しておいてください。
  * Tweet一覧ページ http://localhost/tweets に各ツイートの詳細へのリンクがあり。
  * Tweet一覧ページ`view('tweets.index')`の中のコードに`<a href="{{ route('tweets.show', $tweet) }}"` の記載を確認しよう。 \*`route('tweets.show'`を`route`で見ると`TweetController@show` なので、`TweetController`の`show`メソッドを記入していく。
    * なお、`route('tweets.show', $tweet)` は自動で`$tweetの主キー`を渡す。`$tweet->id`と書かなくてもok。

## Tweet 作成処理の実装

Tweet の作成処理は`TweetController` の `store` メソッドに記載していきましょう！

フォームのPOSTを受け取るときの基本的な流れは、

* フォームを受け取る
* バリデーションチェックする
* バリデーションに問題なければ、処理をする という流れになります。

なお、`フォーム`から送信されてきたデータは `$request`に格納されています。 この`$request`に対して`validate` を用いてデータのバリデーションを行っていきます。

ここでのバリデーションルールは、

* `tweet が空でないこと`
* `長さが 255 以内であること` を確認します。

バリデーションをクリアしない場合（=tweetが空だったり255以上あったり）は処理をせずに自動的に作成ページ（とエラーメッセージ）に戻されます。

バリデーションをクリアしたら Tweet のデータを作成します。

{% hint style="info" %}
```
$requestには、formから送られてきた中身が入っています。
`dd($request->all());`
と書けば簡単に中身を確認できるぞ。
```
{% endhint %}

{% hint style="info" %}
以下コードの詳細はLaravel Tipsのレコード作成のパターンも参照。 `https://nu0640042.gitbook.io/gs_php/laravel/laravel-tips/rekdonopatn`
{% endhint %}

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  // ⭐️以下store内を全部記入
  public function store(Request $request)
  {
    $request->validate([
       // tweet必須 + 最高で255文字までの制限
      'tweet' => 'required|max:255',
    ]);

    $request->user()->tweets()->create($request->all());
    // リクエストからユーザの情報を取得し、「ユーザidが指定済みのtweetsテーブル」を用意してデータを作成する
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
