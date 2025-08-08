# 011\_Comment作成処理と詳細画面の実装

### ここでやりたいこと <a href="#kokodeyaritaikoto" id="kokodeyaritaikoto"></a>

* Tweet 詳細画面に Comment の一覧を表示する。
* Comment の作成画面を作成する。
* Comment の作成処理を実装する。
* Comment の詳細画面を作成する。

### Tweet 詳細画面に Comment を一覧表示する <a href="#tweet-ni-comment-wosuru" id="tweet-ni-comment-wosuru"></a>

Tweet の詳細取得時に、Comment の一覧も合わせて取得する。

一対多の関係なので`load`メソッドを使用することで子データも合わせて取得できる。

{% hint style="info" %}
**`load`メソッドについて**

`load`メソッドは**Eager Loading（積極的読み込み）** の一種で、既に取得したモデルに対してリレーションデータを後から追加で読み込む際に使用します。

**使用例：**
```php
$tweet = Tweet::find(1);        // ツイートのみ取得
$tweet->load('comments');       // 後からコメントも読み込み
$tweet->load('comments.user');  // コメントとコメント投稿者も読み込み
```

**メリット：**
- N+1問題の回避（1回のクエリでまとめて取得）
- 必要な時だけリレーションを読み込める
- パフォーマンスの向上

**`with`メソッドとの違い：**
- `with`: 最初のクエリ時にリレーションも同時取得
- `load`: モデル取得後にリレーションを追加読み込み

**どちらを使うべき？使い分けのポイント：**

**✅ `with`を使うべき場面：**
```php
// 最初からコメントが必要だと分かっている場合
$tweet = Tweet::with('comments')->find(1);
$tweets = Tweet::with('comments', 'user')->paginate(10); // 一覧でも使える
```
- 最初からリレーションが必要だと分かっている
- パフォーマンス重視（1回のクエリで全て取得）
- 一覧表示でN+1問題を回避したい

**✅ `load`を使うべき場面：**
```php
// 条件によってコメントが必要な場合
$tweet = Tweet::find(1);
if ($user->canViewComments()) {
    $tweet->load('comments');
}
```
- 条件によってリレーションが必要かどうか変わる
- 既に取得済みのモデルに後から追加したい
- 複雑な条件分岐がある

**パフォーマンス比較：**
```php
// ❌ N+1問題が発生（避けるべき）
$tweets = Tweet::all();
foreach ($tweets as $tweet) {
    echo $tweet->comments->count(); // 各ツイートごとにクエリ実行
}

// ✅ withで解決
$tweets = Tweet::with('comments')->get();
foreach ($tweets as $tweet) {
    echo $tweet->comments->count(); // 既に読み込み済み
}

// ✅ loadでも解決可能
$tweets = Tweet::all();
$tweets->load('comments'); // コレクション全体に対してまとめて読み込み
```

**今回のケースでは？**
Tweet詳細画面では常にコメントを表示するので、`with`の方が適切です：
```php
// より良い書き方
public function show(Tweet $tweet)
{
    $tweet = Tweet::with('comments.user')->find($tweet->id);
    return view('tweets.show', compact('tweet'));
}
```

今回の場合、`$tweet->comments` でコメント一覧にアクセスできるようになります。
{% endhint %}

```php
// app/Http/Controllers/TweetController.php

public function show(Tweet $tweet)
{
  $tweet->load('comments');
  return view('tweets.show', compact('tweet'));
}

```

Tweet 詳細画面を下記のように編集しましょう。(まだコメントは表示されないです）

「コメントする」リンクをクリックするとコメント作成画面に遷移します。

```blade
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
          <div class="flex mt-4">
            @if ($tweet->likedByUsers->contains(auth()->id()))
            <form action="{{ route('tweets.dislike', $tweet) }}" method="POST">
              @csrf
              @method('DELETE')
              <button type="submit" class="text-red-500 hover:text-red-700">💔 {{$tweet->likedByUsers->count()}}</button>
            </form>
            @else
            <form action="{{ route('tweets.like', $tweet) }}" method="POST">
              @csrf
              <button type="submit" class="text-blue-500 hover:text-blue-700">❤️ {{$tweet->likedByUsers->count()}}</button>
            </form>
            @endif
          </div>

          <!-- 🔽 追加 -->
          <div class="mt-4">
            <p class="text-gray-600 dark:text-gray-400 ml-4">comment {{ $tweet->comments->count() }}</p>
            <a href="{{ route('tweets.comments.create', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">コメントする</a>
          </div>

          <div class="mt-4">
            @foreach ($tweet->comments as $comment)
            <p>{{ $comment->comment }} <span class="text-gray-600 dark:text-gray-400 text-sm">{{ $comment->user->name }} {{ $comment->created_at->format('Y-m-d H:i') }}</span></p>
            @endforeach
          </div>
          <!-- ⬆️ ここまで追加 -->

        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### コメント作成画面の作成 <a href="#komentono" id="komentono"></a>

コントローラの create メソッドを編集します。 ルーティングで下記のように設定されているため、引数にTweetを渡す。 このタイプのルーティングを使用する場合、子モデルに関するコントローラ（今回は CommentController）の各メソッドに引数として親モデル（今回は Tweet）を渡します。

```
tweets/{tweet}/comments/create
```

```php
// app/Http/Controllers/CommentController.php

// 🔽 Tweetモデルを読み込む
use App\Models\Tweet;

// 省略

// 🔽 引数に Tweet を入力する
public function create(Tweet $tweet)
{
  return view('tweets.comments.create', compact('tweet'));
}

```

コメント作成画面を編集します。 `form`部分で`Comment`を送信する際に、どの`Tweet`に対する`Comment`かを指定するために引数に`Tweet`を渡しています。

```blade
<!-- resources/views/tweets/comments/create.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('コメント作成') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <a href="{{ route('tweets.show', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">Tweetに戻る</a>
          <form method="POST" action="{{ route('tweets.comments.store', $tweet) }}">
            @csrf
            <div class="mb-4">
              <label for="comment" class="block text-gray-700 dark:text-gray-300 text-sm font-bold mb-2">コメント</label>
              <input type="text" name="comment" id="comment" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 dark:text-gray-300 dark:bg-gray-700 leading-tight focus:outline-none focus:shadow-outline">
              @error('comment')
              <span class="text-red-500 text-xs italic">{{ $message }}</span>
              @enderror
            </div>
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">コメントする</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### Comment 作成処理 <a href="#comment-zuo-cheng-chu-li" id="comment-zuo-cheng-chu-li"></a>

作成画面から送信されるデータを受け取りCommentを作成します。 form 内容以外に Tweet を受け取るためstoreメソッドの引数に Tweet を追加しています。

```php
// app/Http/Controllers/CommentController.php

// 🔽 引数に Tweet を追加する
public function store(Request $request, Tweet $tweet)
{
  $request->validate([
    'comment' => 'required|string|max:255',
  ]);

  $tweet->comments()->create([
    'comment' => $request->comment,
    'user_id' => auth()->id(),
  ]);

  return redirect()->route('tweets.show', $tweet);
}
```

{% hint style="info" %}
**`$tweet->comments()->create()` について**

この書き方により、以下のことが自動的に行われます：

**1. リレーションを通じた作成：**
```php
// これは以下と同じ意味
Comment::create([
  'comment' => $request->comment,
  'user_id' => auth()->id(),
  'tweet_id' => $tweet->id,  // ← 自動的に設定される
]);
```

**2. 外部キーの自動設定：**
- `$tweet->comments()->create()` を使うことで
- `tweet_id` が自動的に `$tweet->id` に設定される
- わざわざ `'tweet_id' => $tweet->id` を書く必要がない

**3. バリデーション：**
- `$fillable` に設定したカラムのみ保存される
- 今回は `['comment', 'tweet_id', 'user_id']` が設定済み

**4. リダイレクト：**
- 作成完了後は元のツイート詳細画面に戻る
- 新しく作成されたコメントがすぐに表示される
{% endhint %}

### Comment の詳細画面 <a href="#comment-no" id="comment-no"></a>

Tweet詳細画面のComment をクリックでComment詳細画面に遷移します。 Comment詳細画面にて、編集や削除ができるようにします。

最初に、Tweet詳細画面にComment詳細画面へのリンクを追加します。 詳細画面ではTweetとCommentの2つのパラメータを渡したいので、配列で設定しています。

```
tweets/{tweet}/comments/{comment}
```

```blade
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
          <div class="flex mt-4">
            @if ($tweet->likedByUsers->contains(auth()->id()))
            <form action="{{ route('tweets.dislike', $tweet) }}" method="POST">
              @csrf
              @method('DELETE')
              <button type="submit" class="text-red-500 hover:text-red-700">💔 {{$tweet->likedByUsers->count()}}</button>
            </form>
            @else
            <form action="{{ route('tweets.like', $tweet) }}" method="POST">
              @csrf
              <button type="submit" class="text-blue-500 hover:text-blue-700">❤️ {{$tweet->likedByUsers->count()}}</button>
            </form>
            @endif
          </div>
          <div class="mt-4">
            <p class="text-gray-600 dark:text-gray-400 ml-4">comment {{ $tweet->comments->count() }}</p>
            <a href="{{ route('tweets.comments.create', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">コメントする</a>
          </div>
          <div class="mt-4">
            @foreach ($tweet->comments as $comment)
            <!-- 🔽 リンク追加 -->
            <a href="{{ route('tweets.comments.show', [$tweet, $comment]) }}">
              <div class="border-b border-gray-200 dark:border-gray-700 pb-2 mb-2 hover:bg-gray-50 dark:hover:bg-gray-700 p-2 rounded">
                <p class="text-gray-800 dark:text-gray-300">{{ $comment->comment }}</p>
                <p class="text-gray-600 dark:text-gray-400 text-sm">{{ $comment->user->name }} • {{ $comment->created_at->format('Y-m-d H:i') }}</p>
              </div>
            </a>
            @endforeach
          </div>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>
```

{% hint style="info" %}
ルーティングで 2 つのパラメータを設定する場合は配列で設定する．

```php
例（パラメータが一つの場合）
tweets/{tweet}
route('tweets.show', $tweet)
```

```php
例（パラメータが二つの場合
tweets/{tweet}/comments/{comment}
route('tweets.comments.show', [$tweet, $comment])
```
{% endhint %}

詳細画面コントローラにてTweetとCommentのパラメータを受け取理ます。

```php
// app/Http/Controllers/CommentController.php

public function show(Tweet $tweet, Comment $comment)
{
  return view('tweets.comments.show', compact('tweet', 'comment'));
}
```

{% hint style="info" %}
**ルートモデル結合（Route Model Binding）**

`public function show(Tweet $tweet, Comment $comment)` のように書くことで、**ルートモデル結合**が自動的に行われます。

**どういうこと？**
- URL: `/tweets/5/comments/3`
- `$tweet` → 自動的に `Tweet::find(5)` が実行される
- `$comment` → 自動的に `Comment::find(3)` が実行される

**従来の書き方との比較：**
```php
// ❌ 従来の書き方
public function show($tweetId, $commentId)
{
  $tweet = Tweet::findOrFail($tweetId);
  $comment = Comment::findOrFail($commentId);
  return view('tweets.comments.show', compact('tweet', 'comment'));
}

// ✅ ルートモデル結合
public function show(Tweet $tweet, Comment $comment)
{
  // $tweet と $comment は既にモデルインスタンス
  return view('tweets.comments.show', compact('tweet', 'comment'));
}
```

**メリット：**
- コードが簡潔になる
- 存在しないIDの場合、自動的に404エラーになる
- 型安全性が向上する
{% endhint %}

コメント詳細画面に下記を記述します。 詳細画面リンクと同様に、更新と削除のルーティング部分もTweetとCommentの2つのパラメータを渡すため配列で設定します。

```blade
<!-- resources/views/tweets/comments/show.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('コメント詳細') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <a href="{{ route('tweets.show', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">Tweetに戻る</a>
          <p class="text-gray-600 dark:text-gray-400 text-sm">{{ $tweet->tweet }}: {{ $tweet->user->name }}</p>
          <p class="text-gray-800 dark:text-gray-300 text-lg">{{ $comment->comment }}</p>
          <p class="text-gray-600 dark:text-gray-400 text-sm">{{ $comment->user->name }}</p>
          <div class="text-gray-6000 dark:text-gray-400 text-sm">
            <p>コメント作成日時: {{ $comment->created_at->format('Y-m-d H:i') }}</p>
            <p>コメント更新日時: {{ $comment->updated_at->format('Y-m-d H:i') }}</p>
          </div>
          @if (auth()->id() === $comment->user_id)
          <div class="flex mt-4">
            <a href="{{ route('tweets.comments.edit', [$tweet, $comment]) }}" class="text-blue-500 hover:text-blue-700 mr-2">編集</a>
            <form action="{{ route('tweets.comments.destroy', [$tweet, $comment]) }}" method="POST" onsubmit="return confirm('本当に削除しますか？');">
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

**基本的な動作：**
* Tweet 詳細画面の「コメントする」クリックで Comment 作成画面に遷移
* Comment 作成画面でコメントを入力して「コメントする」クリックで Comment が保存される
* Comment 作成処理が完了すると Tweet 詳細画面に遷移する
* Tweet 詳細画面に Comment 詳細画面へのリンクが追加される
* Comment 詳細画面では Comment 作成者のみ編集削除が表示される（動作はまだ）

**追加で確認すべきポイント：**
* コメント数が正しく表示される
* コメントが新しい順に表示される（`orderBy('created_at', 'desc')`の効果）
* ログインユーザーのみコメント作成ができる
* 他人のコメントには編集・削除ボタンが表示されない
* コメント投稿者の名前が正しく表示される

**発展課題：**
* できる人は一覧画面にもコメント数を表示してみよう
* コメントの文字数制限やバリデーションエラーの表示を確認してみよう
* コメントにもページネーションを追加してみよう（コメントが多い場合）
