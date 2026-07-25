# 007\_更新処理と削除処理の実装

## 今回やること

1. Tweet の更新（編集機能）
2. Tweet の削除

## 事前準備

### Dockerコンテナが起動していることを確認

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

```bash
cd laratter
```

## 実装の流れ確認

どちらの機能も、詳細画面（`tweets/{tweet}`）から開始します。viewは`tweets.show`、controllerは`TweetController@show`です。

### (1) Tweet更新について

* 詳細画面`tweets.show`内に`href="{{ route('tweets.edit', $tweet) }}"`が記載されています
* routeを確認すると`TweetController@edit`メソッドが呼び出されます。つまり、更新ボタンを押した後の処理は`edit` メソッドを編集するということです。

### (2) Tweet削除について

* 詳細画面内に`<form action="{{ route('tweets.destroy', $tweet) }}"`が記載されています
* routeを確認すると`TweetController@destroy`メソッドが呼び出されます。つまり削除ボタンを押した後の処理は、`destroy` メソッドを編集するということです。

{% hint style="info" %}
**権限チェック** 前章で実装した通り、編集・削除ボタンは投稿者本人にのみ表示されます。
{% endhint %}

## Tweet更新処理の実装

### editメソッドの実装

TweetController の `edit` メソッドを編集します。\
`edit` メソッドは，Tweet の編集画面を表示するためのものです。編集対象のツイートデータをビューに渡すだけのシンプルな処理です。

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  public function edit(Tweet $tweet)
  {
    return view('tweets.edit', compact('tweet'));
  }
}
```

### 編集画面の作成

`TweetController`の`edit`メソッドは、`tweets.edit`ビューを表示します。\
`resources/views/tweets/edit.blade.php` ファイルを開き、Tweet の編集画面を表示するためのコードを追加します。

作成画面と同様に`@error`を用いてエラーメッセージを表示します。\
また、`@method('PUT')` ディレクティブを使用してフォームから送信される `HTTP メソッド`を `PUT` に変更します。

{% hint style="info" %}
**@method('PUT')について** HTMLフォームは`GET`と`POST`しかサポートしていませんが、RESTfulなルーティングでは`PUT`や`DELETE`も使用します。Laravelの`@method`ディレクティブを使用することで、これらのHTTPメソッドをエミュレートできます。
{% endhint %}

```php
<!-- resources/views/tweets/edit.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('Tweet編集') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <a href="{{ route('tweets.show', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">詳細に戻る</a>
          <form method="POST" action="{{ route('tweets.update', $tweet) }}">
            @csrf
            @method('PUT')
            <div class="mb-4">
              <label for="tweet" class="block text-gray-700 dark:text-gray-300 text-sm font-bold mb-2">Edit Tweet</label>
              <input type="text" name="tweet" id="tweet" value="{{ $tweet->tweet }}" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 dark:text-gray-300 dark:bg-gray-700 leading-tight focus:outline-none focus:shadow-outline">
              @error('tweet')
                <span class="text-red-500 text-xs italic">{{ $message }}</span>
              @enderror
            </div>
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">Update</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>
```

### updateメソッドの実装

編集画面のフォームは`method="POST" action="{{ route('tweets.update', $tweet) }}"`として送信されます。\
Tweet の更新処理を実装するために`TweetController` の`update` メソッドを編集します。

このメソッドはツイートの更新処理を行います。\
該当するツイートのデータを受け取り`update` メソッドを用いて新しいデータで上書きします。

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略
  
  public function update(Request $request, Tweet $tweet)
  {
    // バリデーション実行
    $request->validate([
      'tweet' => 'required|max:255',
    ]);

    // ツイート内容を更新
    $tweet->update($request->only('tweet'));

    // 詳細画面にリダイレクト
    return redirect()->route('tweets.show', $tweet);
  }
}
```

{% hint style="info" %}
**updateメソッドについて**

* `$tweet->update()`: 指定されたデータでモデルを更新
* `$request->only('tweet')`: リクエストから`tweet`フィールドのみ取得
  * `store`の時のように`$validate`を入れてもいいですが、`only`の使い方を知るためあえてこの書き方。
* セキュリティのため、`only`で更新可能なフィールドを限定しています
{% endhint %}

### 動作確認

詳細画面から編集画面に移動しtweet を編集できることを確認しよう。\
編集した tweet が詳細画面に反映されることを確認しよう。

### Tweet削除処理の実装

削除処理（`destroy`メソッド）を実装します。

```php
// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略
  
  public function destroy(Tweet $tweet)
  {
    // ツイートを削除
    $tweet->delete();

    // 一覧画面にリダイレクト
    return redirect()->route('tweets.index');
  }
}
```

{% hint style="info" %}
**destroyメソッドについて**

* `$tweet->delete()`: モデルインスタンスを削除
* 削除後は一覧画面にリダイレクトしてユーザーにフィードバック
* Route Model Bindingにより、URLパラメータから自動的にモデルが取得されます
{% endhint %}

### Tailwind CSSの適用

画面を変更したため、CSS更新のためにビルドを実行します。

```bash
./vendor/bin/sail npm run build
```

{% hint style="info" %}
**Tailwind CSSのビルドについて**

* HTMLテンプレートを変更した際は、使用されているCSSクラスを検出するためビルドが必要
* 本番環境では未使用のCSSクラスは自動的に除去されます
{% endhint %}

### 動作確認

詳細画面から削除ボタンを押しtweet を削除できることを確認してください。\
削除したtweetが一覧画面から消えていることを確認してください。
