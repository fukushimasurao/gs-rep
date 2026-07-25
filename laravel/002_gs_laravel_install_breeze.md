# 002\_認証の仕組み(Livewire Starter Kit + Fortify)

`todo-app` は、プロジェクト作成時点（001の手順）で、すでに認証機能（ログイン・会員登録・パスワードリセットなど）が組み込まれています。

以前のBreezeでは「パッケージを後からインストールして認証機能を追加する」という流れでしたが、今回使用する **Livewire Starter Kit** は `laravel new todo-app --livewire` を実行した時点で認証まわりのファイルが一式生成済みです。このページでは「何を追加でインストールするか」ではなく、**すでに用意されているものが何なのか**を確認していきます。

## 事前準備

### Dockerコンテナが起動していることを確認

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

```bash
cd todo-app
```

{% hint style="info" %}
**現在のディレクトリの確認方法**
- Mac/Linux: `pwd` コマンドで現在のディレクトリを確認できます
- 表示されるパスの最後が `/todo-app` になっていればOKです
{% endhint %}

## Livewire Starter Kit と Fortify の役割分担

{% hint style="info" %}
**Laravel Fortify とは？**
ログイン・会員登録・パスワードリセット・メール確認・2要素認証などの**バックエンド処理（ルート・コントローラー相当の処理）**を提供するパッケージです。画面（View）は持っていません。
{% endhint %}

{% hint style="info" %}
**Livewire Starter Kit とは？**
Fortifyの処理につなぎこむ**画面（View）側**を提供するスターターキットです。ログイン画面・会員登録画面・ダッシュボード・ナビゲーションなどが、Livewire/Flux UIコンポーネントを使ったBladeファイルとしてあらかじめ用意されています。
{% endhint %}

つまり「Fortifyが裏側の処理を担当し、Livewire Starter Kitがその画面を提供する」という役割分担になっています。

## 生成されたファイルを確認しよう

### 1. ルート定義

`routes/web.php` を開いてください：

```php
<?php

use Illuminate\Support\Facades\Route;

Route::view('/', 'welcome')->name('home');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::view('dashboard', 'dashboard')->name('dashboard');
});

require __DIR__.'/settings.php';
```

{% hint style="info" %}
**Breeze版との違い**
Breezeでは `require __DIR__.'/auth.php'` のように、ログイン・会員登録用のルートを別ファイルで読み込んでいました。Fortifyではログイン・会員登録などのルート（`/login`, `/register` など）は**Fortify自身が内部で自動登録**するため、`routes/web.php` には出てきません。
{% endhint %}

`routes/settings.php` には、ログイン後のプロフィール設定・パスワード変更などのルートが定義されています。

### 2. Fortifyの設定ファイル

`app/Providers/FortifyServiceProvider.php` を開いてください。ここで「Fortifyのどの処理に、どの画面（View）を表示するか」が紐付けられています：

```php
private function configureViews(): void
{
    Fortify::loginView(fn () => view('pages::auth.login'));
    Fortify::registerView(fn () => view('pages::auth.register'));
    Fortify::verifyEmailView(fn () => view('pages::auth.verify-email'));
    // ...
}
```

{% hint style="info" %}
**このコマンドの意味**
例えば `/login` にGETアクセスがあった場合、Fortifyは `resources/views/pages/auth/login.blade.php` を表示します。ログインフォームが送信された（POST）場合の処理はFortify内部で行われます。
{% endhint %}

### 3. 認証画面のView

`resources/views/pages/auth/` フォルダの中に、ログイン・会員登録などの画面がBladeファイルとして用意されています：

```
resources/views/pages/auth/
├── login.blade.php
├── register.blade.php
├── forgot-password.blade.php
├── reset-password.blade.php
├── confirm-password.blade.php
├── two-factor-challenge.blade.php
└── verify-email.blade.php
```

`login.blade.php` の中身を見ると、通常のBladeフォームで `route('login.store')` にPOSTしているだけのシンプルな構造です（`flux:input` など、Flux UIというコンポーネント集を使って見た目を整えています）：

```blade
<form method="POST" action="{{ route('login.store') }}" class="flex flex-col gap-6">
    @csrf
    <flux:input name="email" :label="__('Email address')" type="email" required autofocus />
    <flux:input name="password" :label="__('Password')" type="password" required />
    <flux:button variant="primary" type="submit" class="w-full">
        {{ __('Log in') }}
    </flux:button>
</form>
```

### 4. ナビゲーション

`resources/views/layouts/app/header.blade.php` に、ログイン後のヘッダー・ナビゲーションが `flux:header` / `flux:navbar` / `flux:sidebar` コンポーネントで組まれています。詳しくは次のレッスン（004）で扱います。

## 動作確認

### ユーザー登録のテスト

1. ブラウザで http://localhost にアクセス
2. 「Register」をクリック
3. 以下の情報で2〜3人のテストユーザーを作成してください：
   - **Name**: 任意の名前
   - **Email**: テスト用のメールアドレス（例：test1@example.com）
   - **Password**: 8文字以上のパスワード
   - **Confirm Password**: 上記と同じパスワード

{% hint style="success" %}
**登録成功の確認**
ユーザー登録が成功すると、自動的にログインされ、ダッシュボード画面に遷移します。
{% endhint %}

{% hint style="warning" %}
**「SQLSTATE...」エラーが出た場合**
テーブルがまだ作成されていない可能性があります。001のレッスンで案内した通り、`./vendor/bin/sail artisan migrate` を実行してください。
{% endhint %}

## 便利機能：ローカルメールサーバー（Mailpit）

{% hint style="info" %}
**Mailpit（メールサーバー）**
http://localhost:8025 にアクセスすると、開発用のメールサーバーにアクセスできます。

**用途:**
- パスワードリセットメールの確認
- ユーザー登録確認メールの確認
- 外部ネットワークに接続せずにメール機能をテスト可能

このメールサーバーは開発環境専用で、実際のメールは送信されません。001の `sail:install --with=mysql,mailpit` で自動的にセットアップ済みです。
{% endhint %}

---

## なぜBreezeではなくLivewire Starter Kit + Fortifyにしたのか

{% hint style="warning" %}
**Laravel BreezeはLaravel 12以降、公式推奨から外れています**

Laravel 12で新しいアプリケーションスターターキット（React / Vue / Livewire）が導入されたことに伴い、Laravel BreezeとLaravel Jetstreamは追加アップデートを受けられなくなりました。今後の学習・開発では、公式が現在も更新を続けているLivewire Starter Kit（内部でFortifyを使用）を採用しています。
{% endhint %}
