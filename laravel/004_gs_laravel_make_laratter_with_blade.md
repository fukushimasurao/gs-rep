# 004\_画面の用意

## 今回やること

* アプリケーションで使用する画面ファイルを作成します：
  * **Tweet作成画面** - 新しいツイートを投稿する画面
  * **Tweet一覧画面** - 投稿されたツイートを表示する画面
  * **Tweet詳細画面** - 個別のツイートを詳しく表示する画面
  * **Tweet編集画面** - 既存のツイートを編集する画面
* 各画面へスムーズに移動できるようナビゲーションバーにリンクを追加します

## 事前準備

### Dockerコンテナが起動していることを確認

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

```bash
cd todo-app
```

## Bladeテンプレートとは？

Laravelでは画面を作成する際に**Bladeテンプレート**を使用します。

{% hint style="info" %}
**Bladeテンプレートの特徴**
- HTMLのタグを書きながらコントローラから受け取ったデータを埋め込むことができます
- HTMLとPHPを組み合わせたような記法で書けます
- `@if`や`@foreach`などの制御構文も使用できるため、簡単に条件分岐や繰り返し処理を書けます
- ファイル拡張子は`.blade.php`になります
{% endhint %}

今回は、Bladeテンプレートを作成して**Tailwind CSS**でスタイリングします。

{% hint style="info" %}
**Tailwind CSSとは？**
CSSフレームワークの一つです。HTMLのclassに直接デザインを指定して書くことができるユーティリティファーストのCSSライブラリです。Livewire Starter Kit（Flux UI）にあらかじめ含まれています。
{% endhint %}

## ビューファイルの作成

### Bladeテンプレートファイルの生成

以下のコマンドを`todo-app`ディレクトリで実行してください：
4行を一気にコピペでもokです。

```bash
./vendor/bin/sail artisan make:view tweets.index
./vendor/bin/sail artisan make:view tweets.create
./vendor/bin/sail artisan make:view tweets.show
./vendor/bin/sail artisan make:view tweets.edit
```

{% hint style="info" %}
**各コマンドの意味:**
- `make:view tweets.index`: Tweet一覧画面のBladeファイルを作成
- `make:view tweets.create`: Tweet作成画面のBladeファイルを作成
- `make:view tweets.show`: Tweet詳細画面のBladeファイルを作成
- `make:view tweets.edit`: Tweet編集画面のBladeファイルを作成
{% endhint %}

上記を実行すると`resources/views`内に`tweets`フォルダが作成されて、以下4つのファイルが作成されます：

* **Tweet作成画面** (`tweets/create.blade.php`)
* **Tweet一覧画面** (`tweets/index.blade.php`)
* **Tweet詳細画面** (`tweets/show.blade.php`)
* **Tweet編集画面** (`tweets/edit.blade.php`)

結果、以下のようなファイル構成になりますので、確認しましょう：

```text
[resources/views]
│
├── dashboard.blade.php
├── layouts
│   ├── app.blade.php
│   └── app
│       ├── header.blade.php
│       └── sidebar.blade.php   ← ナビゲーションはここ
├── tweets
│   ├── create.blade.php [← ⭐️NEW⭐️]
│   ├── edit.blade.php   [← ⭐️NEW⭐️]
│   ├── index.blade.php  [← ⭐️NEW⭐️]
│   └── show.blade.php   [← ⭐️NEW⭐️]
└── welcome.blade.php
```

{% hint style="info" %}
**なぜファイルが2つあるの？**
Livewire Starter Kitは「サイドバー型」（`sidebar.blade.php`）と「ヘッダー型」（`header.blade.php`）の2種類のナビゲーションデザインを用意しています。`resources/views/layouts/app.blade.php` を見ると、実際に使われているのは `x-layouts::app.sidebar`、つまり**サイドバー型**であることが分かります。このレッスンでは `sidebar.blade.php` を編集します。
{% endhint %}

{% hint style="success" %}
**ファイル作成完了！**
4つのBladeテンプレートファイルが正常に作成されました。次の手順でナビゲーションリンクを追加していきます。
{% endhint %}

## ナビゲーションバーの設定

### 各画面へのリンク追加

各画面へ簡単に移動できるようにナビゲーションバーにリンクを追加します。ナビゲーションバーは`resources/views/layouts/app/sidebar.blade.php`に記述されています。

初期状態では`Dashboard`のリンクが追加されているため、同様の形式で一覧画面と作成画面へのリンクを作成します。

{% hint style="success" %}
**Breeze版との違い：編集箇所は1箇所だけ**
Breezeのナビゲーションバーは、PC画面用・モバイル画面用でそれぞれ別のHTMLを書く必要がありました。Livewire Starter Kitの`flux:sidebar`はレスポンシブ対応（`collapsible="mobile"`）が組み込まれているため、**リンクの追加は1箇所だけでOK**です。
{% endhint %}

### sidebar.blade.phpファイルの編集

`resources/views/layouts/app/sidebar.blade.php`ファイルを開き、`<flux:sidebar.group>`の中に`Dashboard`と同じ形式でリンクを追加してください：

{% hint style="info" %}
**編集方法について**
以下は既存の`flux:sidebar.nav`ブロックの一部を抜粋しています。`<!-- ⭐️ 追加 ⭐️ -->`の箇所だけを追記してください。

記載されている`route('tweets.index')`などは、routeで設定されたルート名です。
`./vendor/bin/sail artisan route:list --path=tweets`の出力を思い出してください！
{% endhint %}

```php
<!-- resources/views/layouts/app/sidebar.blade.php（抜粋） -->

<flux:sidebar.nav>
    <flux:sidebar.group :heading="__('Platform')" class="grid">
        <flux:sidebar.item icon="home" :href="route('dashboard')" :current="request()->routeIs('dashboard')" wire:navigate>
            {{ __('Dashboard') }}
        </flux:sidebar.item>

        <!-- ⭐️ 2項目追加↓↓↓ ⭐️ -->
        <flux:sidebar.item icon="list-bullet" :href="route('tweets.index')" :current="request()->routeIs('tweets.index')" wire:navigate>
            {{ __('Tweet一覧') }}
        </flux:sidebar.item>
        <flux:sidebar.item icon="pencil-square" :href="route('tweets.create')" :current="request()->routeIs('tweets.create')" wire:navigate>
            {{ __('Tweet作成') }}
        </flux:sidebar.item>
        <!-- ⭐️ 2項目追加↑↑↑↑ ⭐️ -->
    </flux:sidebar.group>
</flux:sidebar.nav>
```

{% hint style="info" %}
**Fluxコンポーネントについて**
`<flux:...>`というタグは、Livewire Starter Kitに含まれる**Flux UI**というコンポーネント集です。BreezeのBladeコンポーネント（`<x-nav-link>`など）と役割は同じですが、見た目がすでに整ったUIキットとして提供されています。

`icon`属性にはアイコン名（[Heroicons](https://heroicons.com/)ベース）を指定します。`wire:navigate`は、ページ全体を再読み込みせずに高速に画面遷移させるLivewireの機能です。
{% endhint %}

## 動作確認

### ナビゲーションバーの確認

ブラウザで http://localhost にアクセスし、ログイン後に画面上部にナビゲーションバーが表示されていることを確認してください。

新しく追加したリンクが表示されていればOKです：
- **Tweet一覧**
- **Tweet作成**

{% hint style="warning" %}
**動作について**
現時点ではリンク先のファイル（コントローラーやビュー）は未実装のため、リンクをクリックしてもエラーが表示される状態でOKです。次の章で実装していきます。
{% endhint %}

{% hint style="success" %}
**ナビゲーション設定完了！**
画面ファイルの作成とナビゲーションリンクの追加が完了しました。次の章では、これらの画面に実際のコンテンツを実装していきます。
{% endhint %}
