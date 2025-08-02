# 006\_作成処理と詳細画面の実装

## 今回やること

1. Tweet の作成処理（tweet作成画面からpostしてテーブルへのデータ作成）を実装する。
2. Tweet 一件の詳細画面を作成する。

## 事前準備

### Dockerコンテナが起動していることを確認

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

```bash
cd laratter
```

### テストデータの準備

{% hint style="info" %}
**事前にツイートデータを数件作成しておいてください**
前回の章でSQLを使用してテストデータを作成したか、フォーム機能が実装済みの場合は画面から作成してください。
{% endhint %}

## 実装の流れ確認

### (1) Tweet作成処理について

* 作成画面の場所: `http://localhost/tweets/create`
* `/tweets/create`で表示されている画面について確認
  * routeから`tweets/create`は`TweetController@create`が利用されています
  * `TweetController@create`のreturnから`view('tweets.create')`のviewを表示しています
* `view('tweets.create')`は`resources/views/tweets/create.blade.php`を指しています
  * 中の`form`を見ると、`action`は`tweets.store`になっています
  * routeから`tweets.store`へのpostは`TweetController@store`メソッドを利用します

### (2) Tweet詳細画面について

* Tweet一覧ページ `http://localhost/tweets` に各ツイートの詳細へのリンクがあります
* Tweet一覧ページ`view('tweets.index')`の中のコードに`<a href="{{ route('tweets.show', $tweet) }}"`の記載があります
* `route('tweets.show')`を確認すると`TweetController@show`なので、`TweetController`の`show`メソッドを実装していきます

{% hint style="info" %}
**ルートパラメータについて**
`route('tweets.show', $tweet)`は自動で`$tweet`の主キー（ID）を渡します。`$tweet->id`と書く必要はありません。
{% endhint %}

## Tweet作成処理の実装

Tweet の作成処理は`TweetController` の `store` メソッドに記載していきます。

### フォーム処理の基本的な流れ

フォームのPOSTを受け取るときの基本的な流れは以下の通りです：

1. **フォームデータを受け取る**
2. **バリデーションチェックする**
3. **バリデーションに問題なければ、処理をする**

### バリデーションルール

今回設定するバリデーションルールは以下の通りです：

* `tweet`が空でないこと（required）
* 長さが255文字以内であること（max:255）

{% hint style="warning" %}
**バリデーション失敗時の動作**
バリデーションをクリアしない場合（tweetが空だったり255文字以上だったり）は処理をせずに自動的に作成ページ（とエラーメッセージ）に戻されます。
{% endhint %}

### $requestについて

`フォーム`から送信されてきたデータは `$request`に格納されています。この`$request`に対して`validate`を用いてデータのバリデーションを行います。

{% hint style="info" %}
**$requestの中身を確認する方法**
`$request`には、formから送られてきた中身が入っています。
`dd($request->all());`と書けば簡単に中身を確認できます。
{% endhint %}

{% hint style="info" %}
以下コードの詳細はLaravel Tipsのレコード作成のパターンも参照。 `https://nu0640042.gitbook.io/gs_php/laravel/laravel-tips/rekdonopatn`
{% endhint %}

### storeメソッドの実装

以下のコードを`TweetController`の`store`メソッドに記述してください：

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  public function store(Request $request)
  {
    // バリデーション実行
    $request->validate([
      'tweet' => 'required|max:255', // tweet必須 + 最大255文字までの制限
    ]);

    // ログインユーザーのツイートとして作成
    $request->user()->tweets()->create($request->all());
    // リクエストからユーザーの情報を取得し、そのユーザーのツイートとしてデータを作成

    // 一覧画面にリダイレクト
    return redirect()->route('tweets.index');
  }
}
```

{% hint style="info" %}
**コードの詳細説明**
- `$request->user()`: 現在ログインしているユーザーを取得
- `->tweets()`: そのユーザーのツイートリレーションを取得
- `->create($request->all())`: フォームのデータを使ってツイートを作成
- `$request->only('tweet')`でも同様の処理が可能です
{% endhint %}

## 動作確認

作成画面に移動してツイートが投稿できることを確認してください。

投稿したツイートが一覧画面に表示されることを確認してください。

## Tweet詳細画面の実装

TweetController の `show` メソッドを編集します。\
`show` メソッドは，Tweet の詳細画面を表示するためのものです。

### ルートモデルバインディング

一覧画面のリンク（`<a href="{{ route('tweets.show', $tweet) }}">`部分）で Tweet 1件のデータが渡されているため、`$tweet`に該当するTweetのデータが自動で渡されます。\
`show`メソッドが受け取ったデータをそのままビューファイルに渡せばOKです。

{% hint style="info" %}
**ルートモデルバインディングとは？**
Laravelの機能で、ルートパラメータ（この場合はツイートのID）を自動でモデルインスタンスに変換してくれます。手動でデータベースから取得する必要がありません。
{% endhint %}

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

`resources/views/tweets/show.blade.php` ファイルを開き、Tweet の詳細画面を表示するためのコードを追加しましょう。

ここでは，ツイートの投稿者のみが編集・削除できるようにするため、ツイートの投稿者とログインユーザーが一致するかを確認した上で編集ボタンと削除ボタンを表示します。

{% hint style="info" %}
**認証チェックについて**
`auth()->id() === $tweet->user_id`で、現在ログインしているユーザーとツイートの投稿者が同じかどうかを確認しています。
{% endhint %}

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
          <!--ログインしているユーザーとツイート投稿者が同じ場合のみ表示-->
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

## 動作確認

一覧画面から詳細画面に移動してツイートの詳細が表示されることを確認してください。

{% hint style="warning" %}
**注意**
編集と削除ボタンはまだ動作しません。画面の表示が確認できればOKです。次の章で実装します。
{% endhint %}

## 【補足】認証ユーザー情報の取得

auth() ヘルパ関数を使用すると，現在認証されているユーザーを取得できます。

```php
// 現在認証しているユーザーを取得
$user = auth()->user();

// 現在認証しているユーザーのIDを取得
$id = auth()->id();
```

{% hint style="info" %}
**auth()ヘルパーの活用**
- `auth()->check()`: ユーザーがログインしているかを確認
- `auth()->guest()`: ゲスト（未ログイン）かを確認
- `auth()->id()`: ログインユーザーのIDを取得
- `auth()->user()`: ログインユーザーのモデルインスタンスを取得
{% endhint %}
