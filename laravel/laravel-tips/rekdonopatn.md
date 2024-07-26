# レコード作成のパターン

基本のレコード作成処理は以下のとおり

* モデルでの `$fillable`（または `$guarded`）プロパティの設定
* コントローラなどでの `create()` メソッドの使用

### 例 1：user\_id のない tweets テーブルのレコード作成

| カラム名        | 型                  | 備考     |
| ----------- | ------------------ | ------ |
| id          | unsignedBigInteger | 主キー    |
| tweet       | string             | ツイート内容 |
| created\_at | timestamp          | 作成日時   |
| updated\_at | timestamp          | 更新日時   |

この場合アプリケーション側から設定できる値を指定してコントローラなどで create() メソッドを使用する。

```php
// app/Models/Tweet.php

$fillable = [
  'tweet',
];
```

```php
// app/Http/Controllers/TweetController.php

public function store(Request $request)
{
  $request->validate([
    'tweet' => 'required|max:255',
  ]);

  Tweet::create($request->only('tweet'));

  return redirect()->route('tweets.index');
}

```

### 例 2：user\_id のある tweets テーブルのレコード作成

| カラム名         | 型                      | 備考       |
| ------------ | ---------------------- | -------- |
| id           | unsignedBigInteger     | 主キー      |
| **user\_id** | **unsignedBigInteger** | **外部キー** |
| tweet        | string                 | ツイート内容   |
| created\_at  | timestamp              | 作成日時     |
| updated\_at  | timestamp              | 更新日時     |

user\_id などの外部キー（他テーブルの id）が含まれる場合には，不正な値で作成されないことが重要。

（※ここが自由に登録できると、**他の人になりすましてtweetが記録できる！**）

もし`controller`の`create()`メソッドを使用してデータを作成する場合、モデルの`$fillable` プロパティに外部キーを追加する必要がある。

**しかし**これではformからリクエスト送信されたデータで外部キーが設定できてしまうため、不正な値で作成される可能性があるっ！！！

そのため、「リクエストからユーザの情報を取得してリレーションを活用してデータを作成する」という流れになっている。

```php
// app/Models/Tweet.php

$fillable = [
  'tweet',
];
```

```php
// app/Http/Controllers/TweetController.php

public function store(Request $request)
{
  $request->validate([
    'tweet' => 'required|max:255',
  ]);

  // リクエストから、ユーザー情報を取得して、そのユーザーのtweetに対してcreateする、という流れ。
  $request->user()->tweets()->create($request->only('tweet'));

  return redirect()->route('tweets.index');
}

```

* `$request->user()` の部分は現在認証されているユーザーのインスタンス（ユーザ情報）を取得できる。
* `tweets()` は User のモデルから`1 対多`の Tweet モデルを呼び出している。このときの Tweet モデルにはすでに user\_id が設定された状態となる。
* `create` は，tweets モデルにデータを作成するためのメソッド

リクエストからユーザの情報を取得し、ユーザ id が指定済みの tweets テーブルを用意してデータを作成する、と考えるとイメージしやすい。

### user\_id のある tweets テーブルのレコード作成（リレーションを使わない場合 2）

```php
// app/Models/Tweet.php

$fillable = [
  'tweet'
];
```

```php
// app/Http/Controllers/TweetController.php

public function store(Request $request)
{
  $request->validate([
    'tweet' => 'required|max:255',
  ]);

  //以下のように記載できる。けど、ちょっとめんどい。
  $tweet = new Tweet();
  $tweet->tweet = $request->tweet;
  $tweet->user_id = $request->user()->id;
  $tweet->save();

  return redirect()->route('tweets.index');
}

```
