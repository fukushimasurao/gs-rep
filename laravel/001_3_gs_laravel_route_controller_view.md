
# 001\_3\_Laravelの基本: Route-Controller-Viewとデータの受け渡し

この資料は、Laravelの最も基本的なデータフローである **「Route → Controller → View」** と、**「ControllerからViewへデータを渡す」** 流れを理解するための最小限のチュートリアルです。

本格的な機能開発に入る前に、この流れを体験することで、Laravelアプリケーションがどのように動作するかの基礎を固めます。

### このチュートリアルでやること

1.  新しい **Route** (URL) を1つ定義します。
2.  そのRouteに対応する **Controller** を1つ作成します。
3.  Controllerの中で簡単な **データ** (文字列) を用意します。
4.  そのデータを **View** ファイルに渡して表示します。
5.  ブラウザで指定のURLにアクセスすると、Controllerから渡されたデータが表示されることを確認します。

***

### 前提条件

*   `laratter` プロジェクトのセットアップが完了していること。
*   Dockerコンテナが起動していること (`./vendor/bin/sail up -d`)。

---

## Step 1: ルーティングの追加 (Route)

ユーザーが特定のURLにアクセスしたときに、どのプログラムを動かすかを定義するのがルーティングの役割です。

`routes/web.php` ファイルに、新しいURL `/hello` のためのルートを追加します。

```php
// routes/web.php

<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\TweetController;
// 🔽 1. HelloControllerを読み込む use文を追加
use App\Http\Controllers\HelloController;
use Illuminate\Support\Facades\Route;

/* ... 省略 ... */

Route::get('/', function () {
    return view('welcome');
});

// 🔽 2. 新しいルートをここに追加
Route::get('/hello', [HelloController::class, 'index'])->name('hello.index');


Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

/* ... 省略 ... */
```

---

## Step 2: コントローラの作成 (Controller)

次に、先ほどルートに指定した `HelloController` を作成します。コントローラは、リクエストを処理する司令塔の役割を果たします。

ターミナルで以下のコマンドを実行してください。

```bash
./vendor/bin/sail artisan make:controller HelloController
```

実行すると、`app/Http/Controllers/HelloController.php` というファイルが生成されます。

---

## Step 3: コントローラの編集

生成された `HelloController.php` を開き、`index` メソッドを追加します。このメソッドの中で **Viewに渡すデータを作成** し、`compact()` を使って渡します。

```php
// app/Http/Controllers/HelloController.php

<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HelloController extends Controller
{
    public function index()
    {
        // 🔽 1. Viewに渡すためのデータを用意
        $message = "これはコントローラから渡されたメッセージです。";
        $description = "このように、Controllerで処理した結果やデータベースから取得した値をViewに渡すことができます。";

        // 🔽 2. compact() を使ってデータをビューに渡す
        return view('hello.index', compact('message', 'description'));
    }
}
```

{% hint style="info" %}
**コード解説:**
`compact('message', 'description')` は、`['message' => $message, 'description' => $description]` と書くのと同じ意味です。変数が多くなってもコードを短く保つことができます。
{% endhint %}

---

## Step 4: ビューの作成 (View)

次に、画面に表示されるHTML部分であるビューを作成します。

まず、`resources/views` の中に `hello` という名前のディレクトリを作成します。
次に、`hello` ディレクトリの中に `index.blade.php` というファイルを作成します。

```bash
# 1. ディレクトリを作成
mkdir -p resources/views/hello

# 2. ファイルを作成
touch resources/views/hello/index.blade.php
```

---

## Step 5: ビューの編集

作成した `resources/views/hello/index.blade.php` に、表示したい内容を記述します。
Controllerから渡された変数を `{{ }}` (Blade記法) を使って表示します。

```php
<!-- resources/views/hello/index.blade.php -->

<x-app-layout>
  <x-slot name="header">
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
      {{ __('Hello Laravel!') }}
    </h2>
  </x-slot>

  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-6 text-gray-900 dark:text-gray-100">
          
          <h3 class="text-lg font-bold mb-4">コントローラからのメッセージ:</h3>
          
          {{-- 🔽 Controllerから渡された $message を表示 --}}
          <p class="mb-4 p-4 bg-green-100 text-green-800 rounded">
            {{ $message }}
          </p>

          {{-- 🔽 Controllerから渡された $description を表示 --}}
          <p class="text-sm text-gray-600">
            {{ $description }}
          </p>

        </div>
      </div>
    </div>
  </div>
</x-app-layout>
```

---

## 動作確認

すべてのファイルの準備ができました。

ブラウザで **http://localhost/hello** にアクセスしてください。

レイアウトの中に、「Hello Laravel!」というタイトルと共に、**Controllerで定義した2つのメッセージが表示されていれば成功です。**

---

## 次のステップ: Modelの役割

今回のチュートリアルでは、コントローラ内で直接データ（文字列）を作成しました。

しかし、実際のアプリケーションでは、ユーザー情報や投稿データなどは**データベース(DB)**に保存されています。

この**データベースと対話する役割を担うのが `Model`** です。

{% hint style="success" %}
**Modelとは？**

*   データベースの **テーブル** と1対1で対応するファイルです。
*   例えば、`users` テーブルのデータを操作したい場合は、`app/Models/User.php` という **Userモデル** を通じて行います。
*   同様に、`tweets` テーブルを扱う場合は `Tweet` モデル、`comments` テーブルを扱う場合は `Comment` モデルを使用します。

**今後のチュートリアル (`002`や`003`以降) では、このModelを使ってデータベースからデータを取得し、それをControllerがViewに渡す、というより実践的な流れを学びます。**
{% endhint %}

### まとめ：リクエストとデータの流れ

今回の一連の操作で、以下の流れが実現されました。

1.  **ブラウザ**が `http://localhost/hello` をリクエストする。
2.  **Route** (`routes/web.php`) が `/hello` のリクエストを受け取り、`HelloController` の `index` メソッドを呼び出すよう指示する。
3.  **Controller** (`HelloController.php`) の `index` メソッドが実行され、`$message` と `$description` というデータを作成し、`hello.index` ビューに渡す。
4.  **View** (`hello/index.blade.php`) が、渡されたデータを `{{ $message }}` のようにしてHTMLに埋め込み、ブラウザに送信して画面に表示する。

この **Route → Controller → (データ生成) → View** の流れが、動的なWebアプリケーションを構築する上での基本となります。
