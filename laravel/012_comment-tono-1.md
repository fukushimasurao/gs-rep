# 012\_Comment更新処理と削除処理の実装

### ここでやりたいこと <a href="#kokodeyaritaikoto" id="kokodeyaritaikoto"></a>

* Comment編集画面を作成
* Comment更新処理を実装
* Comment削除処理を実装

{% hint style="info" %}
**事前確認**

CommentControllerの先頭に必要なuse文が記述されていることを確認してください：

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Tweet;  // ← 必要
use Illuminate\Http\Request;
```

これらが不足していると、型ヒント（`Tweet $tweet, Comment $comment`）が正しく動作しません。
{% endhint %}

### 編集と削除の実装 <a href="#tono" id="tono"></a>

まずCommentの編集画面を表示します。 編集画面にはTweetとCommentを表示するのでそれぞれデータを渡します。

```php
// app/Http/Controllers/CommentController.php

public function edit(Tweet $tweet, Comment $comment)
{
  // コメント投稿者のみ編集可能
  if (auth()->id() !== $comment->user_id) {
    abort(403, 'このコメントを編集する権限がありません');
  }
  
  return view('tweets.comments.edit', compact('tweet', 'comment'));
}
```

編集画面のビューは下記のように記述しましょう。 書き換えた後、UpdateボタンをクリックするとCommentの更新処理が実行されます。

```blade
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
              <label for="comment" class="block text-gray-700 dark:text-gray-300 text-sm font-bold mb-2">コメント編集</label>
              <input type="text" name="comment" id="comment" value="{{ $comment->comment }}" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 dark:text-gray-300 dark:bg-gray-700 leading-tight focus:outline-none focus:shadow-outline">
              @error('comment')
              <span class="text-red-500 text-xs italic">{{ $message }}</span>
              @enderror
            </div>
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">更新</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</x-app-layout>

```

### 更新処理 <a href="#geng-xin-chu-li" id="geng-xin-chu-li"></a>

データを受け取って更新処理を行います。 （更新後はComment詳細画面に遷移） ルーティングで2つのパラメータを設定する必要があるので配列を渡しましょう。

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

{% hint style="info" %}
**更新処理の詳細説明**

**1. バリデーション：**
- `required`: 必須入力
- `string`: 文字列であること
- `max:255`: 最大255文字

**2. `$request->only('comment')` について：**
```php
// これは以下と同じ意味
$comment->update([
  'comment' => $request->comment
]);

// only()を使うメリット：
// - 必要なフィールドだけを指定できる
// - セキュリティの向上（意図しないフィールドの更新を防ぐ）
// - コードの簡潔性
```

**3. リダイレクト先：**
- 更新後はコメント詳細画面に戻る
- 更新されたコメントがすぐに確認できる

**4. セキュリティ考慮：**
本来は権限チェックも追加すべきです：
```php
public function update(Request $request, Tweet $tweet, Comment $comment)
{
  // 権限チェック
  if (auth()->id() !== $comment->user_id) {
    abort(403);
  }
  
  // 以下、更新処理...
}
```
{% endhint %}



### 削除処理 <a href="#xiao-chu-chu-li" id="xiao-chu-chu-li"></a>

削除処理を実装します。削除後はツイート詳細画面に戻ります。

```php
// app/Http/Controllers/CommentController.php

public function destroy(Tweet $tweet, Comment $comment)
{
  $comment->delete();

  return redirect()->route('tweets.show', $tweet);
}
```

{% hint style="info" %}
**削除処理の詳細説明**

**1. シンプルな削除：**
- `$comment->delete()` でデータベースから削除
- Eloquentの論理削除（SoftDelete）は使用していない

**2. リダイレクト先：**
- 削除後はツイート詳細画面に戻る
- 削除されたコメントが表示されなくなることを確認できる

**3. セキュリティ考慮：**
本来は削除権限のチェックも必要です：
```php
public function destroy(Tweet $tweet, Comment $comment)
{
  // 権限チェック（コメント投稿者のみ削除可能）
  if (auth()->id() !== $comment->user_id) {
    abort(403, 'このコメントを削除する権限がありません');
  }
  
  $comment->delete();
  return redirect()->route('tweets.show', $tweet)->with('success', 'コメントを削除しました');
}
```

**4. 外部キー制約：**
- マイグレーションで `cascadeOnDelete()` を設定済み
- ツイートが削除されると、関連するコメントも自動削除される

**5. 確認ダイアログ：**
- ビュー側で `onsubmit="return confirm('本当に削除しますか？');"` を設定済み
- 誤操作を防ぐためのユーザビリティ向上
{% endhint %}

```

### 動作確認 <a href="#dong-zuo-que-ren" id="dong-zuo-que-ren"></a>

**基本的な動作：**
* Comment詳細画面:「編集」クリックで Comment 編集画面に遷移
* Comment編集画面でコメントを編集して「更新」クリックで Comment更新処理が実行
* Comment更新処理が完了するとComment詳細画面に遷移
* Comment詳細画面で「削除」クリックでComment削除処理が実行
* Comment削除処理が完了するとTweet詳細画面に遷移

**確認すべきポイント：**
* **権限チェック**: 自分のコメントのみ編集・削除ボタンが表示される
* **バリデーション**: 空のコメントや255文字を超える入力でエラーが表示される
* **確認ダイアログ**: 削除時に確認ダイアログが表示される
* **リダイレクト**: 更新後はコメント詳細、削除後はツイート詳細に遷移
* **データ整合性**: 更新・削除後にデータベースが正しく変更されている

**セキュリティテスト：**
* **URL直接アクセス**: 他人のコメント編集URLに直接アクセスした場合のエラー処理
* **CSRF保護**: フォーム送信時のCSRFトークンが正しく機能している
* **SQLインジェクション**: 特殊文字を含むコメントの処理が適切

**発展課題：**
* **権限チェック**: コントローラー側での権限チェック実装
* **フラッシュメッセージ**: 更新・削除完了時のメッセージ表示
* **Ajax対応**: ページ遷移なしでの更新・削除機能
* **履歴管理**: コメント編集履歴の保存機能
