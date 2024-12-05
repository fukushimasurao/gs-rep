# 🌲 007\_更新処理と削除処理の実装

## 今回やること

1. Tweet の更新処理（テーブルのデータ更新）を実装する．
2. Tweet の削除処理（テーブルのデータ削除）を実装する．

### 前提

* (1)について。
* `tweets/{tweet}`のページ。`route`で見ると、`TweetController@show`、`viewは'tweets.show'`。view内に`href="{{ route('tweets.edit', $tweet) }}"`があり、routeで確認すると`TweetController@edit`とわかる。



* (2)について。
* `tweets/{tweet}`のページ。`route`で見ると、`TweetController@show`、`viewは'tweets.show'`。view内に`href="{{ route('tweets.edit', $tweet) }}"`があり、routeで確認すると`TweetController@edit`とわかる。



## Tweet 作成処理の実装

TweetController の `edit` メソッドを編集する。 `edit` メソッドは，Tweet の編集画面を表示するためのものです。

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

`resources/views/tweets/edit.blade.php` ファイルを開きTweet の編集画面を表示するためのコードを追加。 作成画面と同様に`@error`を用いてエラーメッセージを表示する。 また、`@method('PUT')` ディレクティブを使用してフォームから送信される `HTTP メソッド`を `PUT` に変更する。 これはルーティングで `PUT` メソッドが使用されている一方で、フォームから送信される HTTP メソッドは `GET` と `POST` のみであることに起因する。

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

### 更新処理の実装

Tweet の更新処理を実装するために`TweetController` の`update` メソッドを編集しよう。 このメソッドはTweet の更新処理を行う。 該当する Tweet のデータを受け取り、`update` メソッドを用いて新しいデータ（`$request の tweet 項目`）で上書きする。

<pre class="language-php"><code class="lang-php">// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

<strong>  public function update(Request $request, Tweet $tweet)
</strong>  {
    $request->validate([
      'tweet' => 'required|max:255',
    ]);

    $tweet->update($request->only('tweet'));

    return redirect()->route('tweets.show', $tweet);
  }
}
</code></pre>

### 動作確認

詳細画面から編集画面に移動しtweet を編集できることを確認しよう。 編集した tweet が詳細画面に反映されることを確認しよう。

### Tweet 削除処理の実装

Tweet の削除処理を実装するために`TweetController` の `destroy` メソッドを編集。 このメソッドはTweet の削除処理を行う。 該当する Tweet のデータを受け取り、`delete` メソッドを用いて削除する。

```php

// app/Http/Controllers/TweetController.php

// 省略

class TweetController extends Controller
{
  // 省略

  public function destroy(Tweet $tweet)
  {
    $tweet->delete();

    return redirect()->route('tweets.index');
  }
}
```

※ deleteは処理だけして、何かを映す画面は無いので不要。

### Tailwind CSS の適用

画面いじったので、`Tailwind CSS` を適用

```bash
$ npm run build
```

### 動作確認

詳細画面から削除ボタンを押しtweet を削除できることを確認。 削除した tweet が一覧画面から消えていることを確認。
