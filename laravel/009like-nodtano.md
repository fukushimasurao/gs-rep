# 🎁 009\_Like! 機能の実装（多対多データの操作）

### ここでやりたいこと

* `User` と `Tweet` の関係が`多対多`となる Like 機能を実装しましょう。
* LIKE機能は、
  * `like` したら中間テーブルにレコードが追加
  * `dislike` は中間テーブルからレコードを削除、という動きになります。

### Like 機能実装の流れ

↓ここでは 2 と 3 を実施します↓

1. 中間テーブルの作成と各モデルの連携
2. コントローラに Like 機能の実装
3. ビューファイルに like ボタンを設置

### 前提

イメージは
- viewのいいねが押される
- →routeの確認
- →controllerで処理される
- →modelでデータが保存される。
という感じです。

以下では、コントローラの作成、routeの設定、controller+model記述、view記述の順番で対応していきます。

### コントローラの作成

```
$ php artisan make:controller TweetLikeController --resource
```

{% hint style="info" %}
**Point**

今回は特定のモデルに対するコントローラではないためコントローラの命名に規則はありません。

このような場合は，コントローラが実現する機能を判別できるように命名すれば OK
{% endhint %}

### ルーティングの追加

コントローラのメソッドをルーティングに追加。

今回は`like` と `dislike` の 2 つを追加するため`resource` ではなく個別に記述する．

* like の場合は `store` メソッドを実行します。呼び出しやすいように`tweets.like` という名前をつけましょう。
* dislike の場合は `destroy` メソッドを実行します。呼び出しやすいように `tweets.dislike` という名前をつけましょう。
* like と dislike の操作ではTweetを指定したいため、URLパラメータとしてtweetを指定している．
どちらの場合もターゲットとなる Tweet と指定し、認証中のユーザが `like` または `dislike` するという動きになります。
URLにTweetを特定するためのパラメータとして `{tweet}` を指定しています。(`ルートモデル結合`)

<pre><code>// routes/web.php

&#x3C;?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\TweetController;

// 🔽 追加 🔽
use App\Http\Controllers\TweetLikeController;

use Illuminate\Support\Facades\Route;

// ...

Route::middleware('auth')->group(function () {
  Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
  Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
  Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
  Route::resource('tweets', TweetController::class);

  // 🔽 2行追加  🔽
<strong>  Route::post('/tweets/{tweet}/like', [TweetLikeController::class, 'store'])->name('tweets.like');
</strong>  Route::delete('/tweets/{tweet}/like', [TweetLikeController::class, 'destroy'])->name('tweets.dislike');

});

require __DIR__ . '/auth.php';

</code></pre>

### Like 機能の実装

store メソッドと destroy メソッドを実装しましょうお！！！！

* ルートモデル結合を使用しているため指定した Tweet モデルのインスタンスを受け取ることが可能！
* ユーザの情報は `auth()` ヘルパーを用いて取得します
* 中間テーブルへのデータの追加は `attach` メソッドを用いる．「指定した Tweet（の id）」と「認証ユーザの id」を一緒に中間テーブルに追加する動きをします。
* 同様に中間テーブルのデータ削除には `detach` メソッドを利用！

<pre class="language-php"><code class="lang-php">// app/Http/Controllers/TweetLikeController.php

&#x3C;?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
// 🔽 追加
use App\Models\Tweet;

class TweetLikeController extends Controller
{
  /**
   * Store a newly created resource in storage.
   */
  public function store(Tweet $tweet)
  {
    $tweet->liked()->attach(auth()->id());
    return back();
  }

  /**
   * Remove the specified resource from storage.
   */
<strong>  public function destroy(Tweet $tweet)
</strong>  {
    $tweet->liked()->detach(auth()->id());
    return back();
  }
}
</code></pre>

### like ボタンの設置（ビューファイル編集）

画面から操作できるように`like` ボタンを設置しましょう。一覧画面と詳細画面の両方に設置

* `$tweet->liked` で、該当する Tweet に対して like しているユーザのコレクションを取得できます
* `contains` メソッドを用いて、認証中のユーザが like しているかどうかを判定します。like 済の場合には dislike ボタンを表示、like していない場合には like ボタンを表示します。
* like ボタン（と dislike ボタン）の横にはlike しているユーザの数を表示します。`$tweet->liked->count()` で 該当する Tweet に対して like しているユーザの数を取得します。

### 一覧画面

一覧画面では、まずデータ取得時に like のデータも合わせて取得しておきます。

これは各 Tweet に対して like 数を表示したいためです。

ここでは，Tweet モデルで `liked()` を作成しているため，`with()` 内に記述することで like したユーザのデータを取得できます。

```php
// app/Http/Controllers/TweetController.php

class TweetController extends Controller
{
  // 省略

  public function index()
  {
    // 🔽 liked のデータも合わせて取得するよう修正
    $tweets = Tweet::with(['user', 'liked'])->latest()->get();
    // dd($tweets);
    return view('tweets.index', compact('tweets'));
  }

  // 省略

}


```

{% hint style="info" %}
**Point**

`with()` で複数の項目を取得したい場合は配列の形で指定
{% endhint %}

一覧画面では各 Tweet に対して like ボタンと like 数を表示します。

like ボタンはユーザが like しているかどうかによって like（like するボタン）と dislike（like を取り消すボタン）が切り替わります。

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
            {{-- 🔽 追加 --}}
            <div class="flex">
              @if ($tweet->liked->contains(auth()->id()))
              <form action="{{ route('tweets.dislike', $tweet) }}" method="POST">
                @csrf
                @method('DELETE')
                <button type="submit" class="text-red-500 hover:text-red-700">dislike {{$tweet->liked->count()}}</button>
              </form>
              @else
              <form action="{{ route('tweets.like', $tweet) }}" method="POST">
                @csrf
                <button type="submit" class="text-blue-500 hover:text-blue-700">like {{$tweet->liked->count()}}</button>
              </form>
              @endif
            </div>
            {{-- 🔼 ここまで --}}
          </div>
          @endforeach
        </div>
      </div>
    </div>
  </div>

</x-app-layout>

```

### 詳細画面

詳細画面も一覧画面と同様に，like ボタンと like 数を表示します

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
          @if (auth()->id() == $tweet->user_id)
          <div class="flex mt-4">
            <a href="{{ route('tweets.edit', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">編集</a>
            <form action="{{ route('tweets.destroy', $tweet) }}" method="POST" onsubmit="return confirm('本当に削除しますか？');">
              @csrf
              @method('DELETE')
              <button type="submit" class="text-red-500 hover:text-red-700">削除</button>
            </form>
          </div>
          @endif
          {{-- 🔽 追加 --}}
          <div class="flex mt-4">
            @if ($tweet->liked->contains(auth()->id()))
            <form action="{{ route('tweets.dislike', $tweet) }}" method="POST">
              @csrf
              @method('DELETE')
              <button type="submit" class="text-red-500 hover:text-red-700">dislike {{$tweet->liked->count()}}</button>
            </form>
            @else
            <form action="{{ route('tweets.like', $tweet) }}" method="POST">
              @csrf
              <button type="submit" class="text-blue-500 hover:text-blue-700">like {{$tweet->liked->count()}}</button>
            </form>
            @endif
          </div>
          {{-- 🔼 ここまで --}}
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### 動作確認

下記の動作が確認できれば OK

* 一覧画面で like ボタンを押すと、like が追加される。画面のカウントが増えてtweet\_user テーブルにデータが追加される
* 一覧画面で dislike ボタンを押すと、like が削除される。画面のカウントが減り、tweet\_user テーブルからデータが削除される。
* 詳細画面で like ボタンを押すと、like が追加される。画面のカウントが増え、tweet\_user テーブルにデータが追加される。
* 詳細画面で dislike ボタンを押すと、like が削除される。画面のカウントが減り、tweet\_user テーブルからデータが削除される。
