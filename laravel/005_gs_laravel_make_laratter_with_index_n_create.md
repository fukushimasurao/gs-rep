# 005\_一覧画面と作成画面の実装

## 今回やること

* Tweet の一覧画面(index)を作成する。
* Tweet の作成画面(create)を作成する。

## 事前準備

### Dockerコンテナが起動していることを確認

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

```bash
cd laratter
```

## コントローラのメソッド

`TweetController` の `index` メソッドと `create` メソッドを編集していきます。 それぞれ、

* `index` メソッドはTweet の一覧を表示するためのもの
* `create` メソッドは，Tweet の作成画面を表示するためのもの

です。

それぞれブラウザで tweetsにアクセスしたときindexメソッドが、 tweets/createにアクセスしたときcreateメソッドが 呼ばれます。

```bash
./vendor/bin/sail artisan route:list --path=tweets
  // 省略
  GET|HEAD        tweets ........  tweets.index › TweetController@index
  GET|HEAD        tweets/create .. tweets.create › TweetController@create
  // 省略
```

`index` メソッドではTweet全件を`新しい順`に取得するために `latest` メソッドを使用します。\
`Tweet`に関連するユーザ情報を取得するために `with` メソッドを使用します。

{% hint style="info" %}
**重要な概念**
- `Tweet::with('user')の 'user'`は、前回Tweetモデルに追加した`user()`リレーションメソッドのことです
- `user()`メソッドを定義していないと、`with('user')`は使用できません
- `latest()`は`created_at`の降順（新しい順）でデータを取得します
- `with('user')`により、N+1問題を回避してユーザー情報を効率的に取得できます
{% endhint %}

{% hint style="warning" %}
**N+1問題とは？**
ユーザー情報なしでTweetを取得し、その後各Tweetに対してユーザー情報を個別に取得すると、データベースへのクエリが大量に発生します。`with('user')`を使うことで、1回のクエリでまとめて取得できます。
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
    // ⭐️追加↓ 全ツイート(Tweet)を、それぞれの投稿者情報も含めて(with('user'))、新しい順で取得(latest()->get())
    $tweets = Tweet::with('user')->latest()->get();

    // ⭐️追加↓
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

## 一覧画面の作成

`resources/views/tweets/index.blade.php` ファイルを開きTweet の一覧を表示するためのコードを追加しましょう。\
`@foreach` ディレクティブを使用してTweetの一覧を表示します。\
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
**Bladeレイアウトについて**
`<x-app-layout></x-app-layout>`で囲って記載すると、`resources/views/layouts/app.blade.php`内の`{{ $slot }}`という箇所に、この囲ったコードがすべて埋め込まれます。

これにより、ヘッダーやナビゲーションなどの共通部分を自動で含めることができます。
{% endhint %}

## 作成画面の作成

`resources/views/tweets/create.blade.php` ファイルを開きTweet の作成画面を表示するためのコードを追加する。

### CSRFトークンについて

`@csrf` ディレクティブを使用して`CSRF（Cross-Site Request Forgery）トークン`を生成する。

{% hint style="warning" %}
**CSRFトークンとは？**
CSRF攻撃を防ぐためのセキュリティ機能です。悪意のあるサイトが、ユーザーの知らない間に別のサイトに不正な要求を送信することを防ぎます。

**重要**: フォームを用いてデータを送信する場合には**必ず**`@csrf`を設定してください。忘れると419エラーが発生します。
{% endhint %}

{% hint style="info" %}
**CSRFの詳細**
- CSRFについて詳しく: https://www.ipa.go.jp/security/vuln/websecurity/csrf.html
- Laravelでpostのformに`@csrf`を書き忘れると、フォーム送信時に`419 Page Expired`エラーが発生します
- `@csrf`は送信フォーム内に隠しフィールドとしてトークンを生成します
{% endhint %}

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

## Tailwind CSS の適用

ビューファイルを変更した後は、Tailwind CSSを再ビルドする必要があります。

{% hint style="warning" %}
**重要**: ビューファイル（.blade.php）を変更した場合は必ず以下のコマンドを実行してください。
{% endhint %}

{% hint style="info" %}
**なぜ再ビルドが必要？**
Tailwind CSSは使用されているクラスのみを含む最適化されたCSSファイルを生成します。新しいクラスを追加した場合、それらを含めるために再ビルドが必要です。
{% endhint %}

```bash
./vendor/bin/sail npm run build
```

## 動作確認

一覧画面に移動しエラーが発生しないことを確認しましょう。\
作成画面に移動し入力フォームが表示されていることを確認する。※まだ登録できないよ。

## 【補足】エラーメッセージの表示

この画面では入力したデータに不備があった場合（未入力や文字列が長すぎるなど）にエラーメッセージを表示します。\
エラーメッセージは`@error` ディレクティブを使用して表示できます。\
`@error`ディレクティブは指定した項目にエラーがある場合にのみ表示されます。

{% hint style="info" %}
**テストデータの登録**
この時点ではまだフォームからのTweet登録機能は実装していませんが、SQLを使って直接データベースに登録することができます。

以下のSQLでテストデータを登録してみましょう！

**注意**: `user_id`は実際にuserテーブルに存在するIDを指定してください。多くの場合、最初に登録したユーザーのIDは1です。
{% endhint %}

```sql
insert into
  tweets (id, user_id, tweet, created_at, updated_at)
  values (null, 1, 'test', now(), now());
```
