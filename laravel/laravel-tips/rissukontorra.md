# リソースコントローラ

### りそこん？

リソースコントローラとは、Laravel で CRUD 処理を行うために使用するコントローラ。

リソースコントローラには、CRUD 処理を行うためのメソッドが用意されている。



### リソースコントローラに用意されているメソッド一覧

下記のようにリソースコントローラには、CRUD 処理を行うためのメソッドが用意されている。

それぞれのメソッドには役割が決められており、この通りに実装することで CRUD 処理を動かすことができる。

Laravel の基本の形となっているため，まずはこの形を作ってしまい必要に応じてメソッドを利用するのが進めるのがおすすめ。

| メソッド    | 役割            |
| ------- | ------------- |
| index   | データの一覧を表示する   |
| create  | データの作成画面を表示する |
| store   | データの作成処理を行う   |
| show    | データの詳細画面を表示する |
| edit    | データの編集画面を表示する |
| update  | データの更新処理を行う   |
| destroy | データの削除処理を行う   |

### リソースコントローラのルーティング

リソースコントローラを使用する場合、下記のルーティングを定義することで CRUD 処理のルーティングがすべて自動的に行われる。めちゃ便利。

```bash
$ Route::resource('tweets', TweetController::class);


```

上記のコードを書くことで動作するようになるルーティング↓

````bash
$ php artisan route:list --path=tweets

# 実行結果（ユーザ操作などのルーティングは省略）
+--------+-----------+-----------------------+----------------+-----------------------------------------------------+-----------------+
| Domain | Method    | URI                   | Name           | Action                                              | Middleware      |
+--------+-----------+-----------------------+----------------+-----------------------------------------------------+-----------------+
|        | GET|HEAD  | tweets                | tweets.index   | App\Http\Controllers\TweetController@index          | web             |
|        | POST      | tweets                | tweets.store   | App\Http\Controllers\TweetController@store          | web             |
|        | GET|HEAD  | tweets/create         | tweets.create  | App\Http\Controllers\TweetController@create         | web             |
|        | GET|HEAD  | tweets/{tweet}        | tweets.show    | App\Http\Controllers\TweetController@show           | web             |
|        | PUT|PATCH | tweets/{tweet}        | tweets.update  | App\Http\Controllers\TweetController@update         | web             |
|        | DELETE    | tweets/{tweet}        | tweets.destroy | App\Http\Controllers\TweetController@destroy        | web             |
|        | GET|HEAD  | tweets/{tweet}/edit   | tweets.edit    | App\Http\Controllers\TweetController@edit           | web             |
+--------+-----------+-----------------------+----------------+-----------------------------------------------------+-----------------+```



````
