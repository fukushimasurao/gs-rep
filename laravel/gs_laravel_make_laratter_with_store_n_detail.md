# 🍄 006\_作成処理と詳細画面の実装

## 今回やること

1. Tweet の作成処理（tweet作成画面からpostしてテーブルへのデータ作成）を実装する。
2. Tweet 一件の詳細画面を作成する。

### 前提確認

* (1)について
  * `/tweets/create` のページ。routeから`tweets/create`は`TweetController@create`を利用し、そこから`view('tweets.create')`のviewを描写しているいうことがわかる。
  * viewの中の`form`を見ると、`action`は`'tweets.store'`ということを確認。routeから、`'tweets.store'`へのpostは`TweetController@store` ということを確認。



## Tweet 作成処理の実装

Tweet の作成処理は`TweetController` に `store` メソッドに記載する。

`フォーム`から送信されてきたデータは `$request`に格納されているため、`validate` を用いてデータのバリデーションを行う。 ここでは，

* `tweet が空でないこと`
* `長さが 255 以内であること` を確認している．

バリデーションをクリアしたら Tweet のデータを作成する。 バリデーションをクリアしない場合は自動的に作成ページ（とエラーメッセージ）が表示される。

{% hint style="info" %}
```
$requestには、formから送られてきた中身が入っている。
ddd($request->all());
と書けば簡単に中身を確認できるぞ。
```
{% endhint %}

{% hint style="info" %}
```
Tweet Modelに、
$fillable = ['tweet'];
とルール設定したので、
```
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
      'tweet' => 'required|max:255',
    ]);

    $request->user()->tweets()->create($request->all());
    // $request->user()->tweets()->create($request->only('tweet')); // ←これでもok

    return redirect()->route('tweets.index');
  }
}
```

### 動作確認

作成画面に移動しtweet が投稿できることを確認。

投稿した tweet が一覧画面に表示されることを確認。

### Tweet 詳細画面の実装

TweetController の `show` メソッドを編集。 `show` メソッドは，Tweet の詳細画面を表示するためのものです。

一覧画面のリンク（ `<a href="{{ route('tweets.show', $tweet) }}">` 部分）で Tweet 1 件のデータが渡されているため、`$tweet` に該当する Tweet のデータが渡される。 `show` メソッドが受け取ったデータをそのままビューファイルに渡せば OK。

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

`resources/views/tweets/show.blade.php` ファイルを開き、Tweet の詳細画面を表示するためのコードを追加しましょう。 ここでは，Tweet の投稿者のみが編集・削除できるようにするため、Tweet の投稿者とログインユーザが一致するかを確認した上で編集ボタンと削除ボタンを表示します。

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
