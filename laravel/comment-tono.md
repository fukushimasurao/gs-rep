# 👞 Comment 作成処理と詳細画面の実装

### [ここでやりたいこと](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#%E3%81%93%E3%81%93%E3%81%A7%E3%82%84%E3%82%8A%E3%81%9F%E3%81%84%E3%81%93%E3%81%A8) <a href="#kokodeyaritaikoto" id="kokodeyaritaikoto"></a>

* Tweet 詳細画面に Comment の一覧を表示する．
* Comment の作成画面を作成する．
* Comment の作成処理を実装する．
* Comment の詳細画面を作成する．

### [Tweet 詳細画面に Comment を一覧表示する](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#tweet-%E8%A9%B3%E7%B4%B0%E7%94%BB%E9%9D%A2%E3%81%AB-comment-%E3%82%92%E4%B8%80%E8%A6%A7%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B) <a href="#tweet-ni-comment-wosuru" id="tweet-ni-comment-wosuru"></a>

Tweet の詳細取得時に，Comment の一覧も合わせて取得する．一対多の関係なので，`load`メソッドを使用することで子データも合わせて取得できる．

```php
// app/Http/Controllers/TweetController.php

public function show(Tweet $tweet)
{
  $tweet->load('comments');
  return view('tweets.show', compact('tweet'));
}

```

Tweet 詳細画面を下記のように編集する．まだコメントは表示されない．「コメントする」リンクをクリックするとコメント作成画面に遷移する．

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
          <!-- 🔽 追加 -->
          <div class="mt-4">
            <p class="text-gray-600 dark:text-gray-400 ml-4">comment {{ $tweet->comments->count() }}</p>
            <a href="{{ route('tweets.comments.create', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">コメントする</a>
          </div>
          <!-- 🔽 追加 -->
          <div class="mt-4">
            @foreach ($tweet->comments as $comment)
            <p>{{ $comment->comment }} <span class="text-gray-600 dark:text-gray-400 text-sm">{{ $comment->user->name }} {{ $comment->created_at->format('Y-m-d H:i') }}</span></p>
            @endforeach
          </div>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### [コメント作成画面の作成](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E4%BD%9C%E6%88%90%E7%94%BB%E9%9D%A2%E3%81%AE%E4%BD%9C%E6%88%90) <a href="#komentono" id="komentono"></a>

コントローラの create メソッドを編集する．ルーティングで下記のように設定されているため，引数に Tweet を渡す．このタイプのルーティングを使用する場合，子モデルに関するコントローラ（今回は CommentController）の各メソッドに引数として親モデル（今回は Tweet）を渡す必要がある．

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

コメント作成画面を下記のように編集する．form 部分で Comment を送信する際に，どの Tweet に対する Comment かを指定するために，引数に Tweet を渡す．

```php
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

### [Comment 作成処理](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#comment-%E4%BD%9C%E6%88%90%E5%87%A6%E7%90%86) <a href="#comment-zuo-cheng-chu-li" id="comment-zuo-cheng-chu-li"></a>

作成画面から送信されるデータを受け取り，Comment を作成する．form 内容以外に Tweet を受け取るため，store メソッドの引数に Tweet を追加している．

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

### [Comment の詳細画面](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#comment-%E3%81%AE%E8%A9%B3%E7%B4%B0%E7%94%BB%E9%9D%A2) <a href="#comment-no" id="comment-no"></a>

Tweet 詳細画面の Comment をクリックすると，Comment の詳細画面に遷移する．Comment 詳細画面では編集や削除ができるようにする．

まず Tweet 詳細画面に Comment 詳細画面へのリンクを追加する．

詳細画面では Tweet と Comment の 2 つのパラメータを渡すため，配列で設定する．

```
tweets/{tweet}/comments/{comment}
```

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
          <div class="mt-4">
            <p class="text-gray-600 dark:text-gray-400 ml-4">comment {{ $tweet->comments->count() }}</p>
            <a href="{{ route('tweets.comments.create', $tweet) }}" class="text-blue-500 hover:text-blue-700 mr-2">コメントする</a>
          </div>
          <div class="mt-4">
            @foreach ($tweet->comments as $comment)
            <!-- 🔽 リンク追加 -->
            <a href="{{ route('tweets.comments.show', [$tweet, $comment]) }}">
              <p>{{ $comment->comment }} <span class="text-gray-600 dark:text-gray-400 text-sm">{{ $comment->user->name }} {{ $comment->created_at->format('Y-m-d H:i') }}</span></p>
            </a>
            @endforeach
          </div>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

> **💡 Point**
>
> ルーティングで 2 つのパラメータを設定する場合は配列で設定する．
>
> 例（パラメータが一つの場合）
>
> ```
> tweets/{tweet}
> ```
>
> ```php
> route('tweets.show', $tweet)
> ```
>
> 例（パラメータが二つの場合）
>
> ```
> tweets/{tweet}/comments/{comment}
> ```
>
> ```php
> route('tweets.comments.show', [$tweet, $comment])
> ```

詳細画面のコントローラでも Tweet と Comment の 2 つのパラメータを受け取る．

```php
// app/Http/Controllers/CommentController.php

public function show(Tweet $tweet, Comment $comment)
{
  return view('tweets.comments.show', compact('tweet', 'comment'));
}
```

コメント詳細画面に下記を記述する．詳細画面リンクと同様に，更新と削除のルーティング部分も Tweet と Comment の 2 つのパラメータを渡すため，配列で設定する．

```php
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

### [動作確認](https://gs-lab-202406.deno.dev/laravel/tweet-comment-create-and-store.html#%E5%8B%95%E4%BD%9C%E7%A2%BA%E8%AA%8D) <a href="#dong-zuo-que-ren" id="dong-zuo-que-ren"></a>

* Tweet 詳細画面の「コメントする」クリックで Comment 作成画面に遷移する．
* Comment 作成画面でコメントを入力して「コメントする」クリックで Comment が保存される．
* Comment 作成処理が完了すると Tweet 詳細画面に遷移する．
* Tweet 詳細画面に Comment 詳細画面へのリンクが追加される．
* Comment 詳細画面では Comment 作成者のみ編集削除が表示される（動作はまだ）．
* できる人は一覧画面にもコメント数を表示してみよう．
