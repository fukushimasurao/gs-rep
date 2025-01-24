# 🐔 005\_一覧画面と作成画面の実装

今回やること

* Tweet の一覧画面(index)を作成する。
* Tweet の作成画面(create)を作成する。

### コントローラのメソッド

`TweetController` の `index` メソッドと `create` メソッドを編集していきます。 それぞれ、

* `index` メソッドはTweet の一覧を表示するためのもの
* `create` メソッドは，Tweet の作成画面を表示するためのもの

です。

それぞれブラウザで
tweetsにアクセスしたときindexメソッドが、
tweets/createにアクセスしたときcreateメソッドが
呼ばれます。

```bash
$ sail artisan route:list --path=tweets
  // 省略
  GET|HEAD        tweets ........  tweets.index › TweetController@index
  GET|HEAD        tweets/create .. tweets.create › TweetController@create
  // 省略
```
                                    



`index` メソッドではTweet全件を`新しい順`に取得するために `latest` メソッドを使用します。
<br>
`Tweet`に関連するユーザ情報を取得するために `with` メソッドを使用します。

{% hint style="info" %}
```
Tweet::with('user')の 'user'は、さっきTweetモデルに追加した`user()`のことです。
`user()`を定義していないと、`with('user')`と書けないよ。
```
{% endhint %}

```php
// app/Http/Controllers/TweetController.php

<?php

namespace App\Http\Controllers;

use App\Models\Tweet;
use Illuminate\Http\Request;

class TweetController extends Controller
{
  public function index()
  {
    // ⭐️追加
    $tweets = Tweet::with('user')->latest()->get();

    // $tweetsを'tweets.index'に渡す
    // このtweets.indexとは、resources/views配下のtweetsの中のindex.blade.phpを指すよ。
    return view('tweets.index', compact('tweets'));
  }

  public function create()
  {
    // ⭐️追加
    return view('tweets.create');
  }

  // 省略

}

```

#### 一覧画面の作成

`resources/views/tweets/index.blade.php` ファイルを開きTweet の一覧を表示するためのコードを追加しましょう。
<br>
`@foreach` ディレクティブを使用してTweetの一覧を表示します。
<br>
モデルで`Tweet` と `User` を連携しているため，`$tweet->user->name` で Tweet に関連するユーザの名前を取得できる．

```php
<!-- resources/views/tweets/index.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('Tweet一覧') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          @foreach ($tweets as $tweet)
          <div class="mb-4 p-4 bg-gray-100 dark:bg-gray-700 rounded-lg">
            <p class="text-gray-800 dark:text-gray-300">{{ $tweet->tweet }}</p>
            <p class="text-gray-600 dark:text-gray-400 text-sm">投稿者: {{ $tweet->user->name }}</p>
            <a href="{{ route('tweets.show', $tweet) }}" class="text-blue-500 hover:text-blue-700">詳細を見る</a>
          </div>
          @endforeach
        </div>
      </div>
    </div>
  </div>

</x-app-layout>



```

{% hint style="info" %}
`<x-app-layout></x-app-layout>`で囲って記載すると、`views/layouts/app.blade.php`内の`{{ $slot }}`という箇所に、 この囲ったコードがすべて埋め込まれます。
{% endhint %}

#### 作成画面の作成

`resources/views/tweets/create.blade.php` ファイルを開きTweet の作成画面を表示するためのコードを追加する。&#x20;

`@csrf` ディレクティブを使用して`CSRF（Cross-Site Request Forgery）トークン`を生成する。

👹`@csrf`はフォームを用いてデータを送信する場合には必ず設定すること👹

```php
<!-- resources/views/tweets/create.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('Tweet作成') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <form method="POST" action="{{ route('tweets.store') }}">
            @csrf
            <div class="mb-4">
              <label for="tweet" class="block text-gray-700 dark:text-gray-300 text-sm font-bold mb-2">Tweet</label>
              <input type="text" name="tweet" id="tweet" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 dark:text-gray-300 dark:bg-gray-700 leading-tight focus:outline-none focus:shadow-outline">
              @error('tweet')
              <span class="text-red-500 text-xs italic">{{ $message }}</span>
              @enderror
            </div>
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">Tweet</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

#### Tailwind CSS の適用

一部 CSS が適用されない部分があるため下記コマンドで Tailwind CSS を適用しましょう。
<br>
👹ビューファイルを変更した場合は必ず実行するようにしましょう。👹

```bash
$ sail npm run build
```

#### 動作確認

一覧画面に移動しエラーが発生しないことを確認しましょう。
<br>
作成画面に移動し入力フォームが表示されていることを確認する。※まだ登録できないよ。

## 【補足】エラーメッセージの表示

この画面では入力したデータに不備があった場合（未入力や文字列が長すぎるなど）にエラーメッセージを表示しましょう。
<br>
エラーメッセージは`@error` ディレクティブを使用して表示できます。
<br>
なお `@error`ディレクティブは指定した項目にエラーがある場合にのみ表示される。

{% hint style="info" %}
この時点ではまだtweetの登録できないが、sqlから登録することが可能です。
いくつか登録してみましょう！

insert into tweets (id, user\_id, tweet, created\_at, updated\_at) values (null, 1, 'test', now(), now());
{% endhint %}

&#x20;
