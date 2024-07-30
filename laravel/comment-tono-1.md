# 🐖 Comment 更新処理と削除処理の実装

### ここでやりたいこと <a href="#kokodeyaritaikoto" id="kokodeyaritaikoto"></a>

* Comment の編集画面を作成する．
* Comment の更新処理を実装する．
* Comment の削除処理を実装する．

### 編集と削除の実装 <a href="#tono" id="tono"></a>

まずComment の編集画面を表示するようにする。

編集画面には Tweet と Comment を表示するので各データを渡す。

<pre class="language-php"><code class="lang-php">// app/Http/Controllers/CommentController.php

<strong>public function edit(Tweet $tweet, Comment $comment)
</strong>{
  return view('tweets.comments.edit', compact('tweet', 'comment'));
}

</code></pre>

編集画面のビューは下記のように記述する。

書き換えて Update ボタンをクリックすると Comment の更新処理が実行される

```php
<!-- resources/views/tweets/comments/edit.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('コメント編集') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          <a href="{{ route('tweets.comments.show', [$tweet, $comment]) }}" class="text-blue-500 hover:text-blue-700 mr-2">詳細に戻る</a>
          <form method="POST" action="{{ route('tweets.comments.update', [$tweet, $comment]) }}">
            @csrf
            @method('PUT')
            <div class="mb-4">
              <label for="comment" class="block text-gray-700 dark:text-gray-300 text-sm font-bold mb-2">Edit Comment</label>
              <input type="text" name="comment" id="comment" value="{{ $comment->comment }}" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 dark:text-gray-300 dark:bg-gray-700 leading-tight focus:outline-none focus:shadow-outline">
              @error('comment')
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

### 更新処理 <a href="#geng-xin-chu-li" id="geng-xin-chu-li"></a>

データを受け取って更新処理を実行する。

更新後は Comment 詳細画面に遷移する。

ルーティングで 2 つのパラメータを設定する必要がある場合は配列で設定する（詳細画面のリンクなどと同様）．

```
tweets/{tweet}/comments/{comment}
```

```php
// app/Http/Controllers/CommentController.php

public function update(Request $request, Tweet $tweet, Comment $comment)
{
  $request->validate([
    'comment' => 'required|string|max:255',
  ]);

  $comment->update($request->only('comment'));

  return redirect()->route('tweets.comments.show', [$tweet, $comment]);
}

```

### 削除処理 <a href="#xiao-chu-chu-li" id="xiao-chu-chu-li"></a>

削除するだけ。

```php
// app/Http/Controllers/CommentController.php

public function destroy(Tweet $tweet, Comment $comment)
{
  $comment->delete();

  return redirect()->route('tweets.show', $tweet);
}

```

### 動作確認 <a href="#dong-zuo-que-ren" id="dong-zuo-que-ren"></a>

* Comment 詳細画面で「編集」クリックで Comment 編集画面に遷移する．
* Comment 編集画面でコメントを編集して「更新」クリックで Comment 更新処理が実行される．
* Comment 更新処理が完了すると Tweet 詳細画面に遷移する．
* Comment 詳細画面で「削除」クリックで Comment 削除処理が実行される．
* Comment 削除処理が完了すると Tweet 詳細画面に遷移する．
