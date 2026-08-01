# 日本語化(i18n)の現状と対処法

Livewire Starter Kitで作った`laratter`は、初期状態だとログイン画面もメールも英語のままです。ここでは日本語化する方法と、その限界について整理します。

## 結論

* Laravelの**組み込み文言**（バリデーションエラー、パスワードリセット/認証メールなど）→ パッケージで解決できる
* Livewire Starter Kit**独自の画面文言**（ログイン画面の見出しなど）→ パッケージの対象外。自分で翻訳ファイルを用意する必要がある

## 1. 組み込み文言の日本語化：`laravel-lang/lang`

Laravel本体・Fortify・Jetstream・Breezeなどの定型文言を128言語分カバーしているパッケージです。Laravel 13・Fortify 1系にも対応しています。

```bash
./vendor/bin/sail composer require --dev laravel-lang/lang
./vendor/bin/sail artisan lang:update
```

{% hint style="info" %}
より手軽に使いたい場合は`laravel-lang/common`という軽量版もあります。こちらは`./vendor/bin/sail artisan lang:add ja`の1コマンドで日本語リソースを追加できます。
{% endhint %}

`.env`を編集して日本語をデフォルトにします：

```env
APP_LOCALE=ja
APP_FALLBACK_LOCALE=ja
```

これで以下が日本語化されます：

* バリデーションエラーメッセージ（「このフィールドは必須です」など）
* パスワードリセットメール・メール認証メールの文言
* ページネーションの表記（「次へ」「前へ」など）

## 2. スターターキット独自の画面文言は対象外

ログイン画面の見出し（例："Log in to your account"）などは、`laravel-lang`パッケージの対象外です。

理由は、これらがLaravel本体の定型文言ではなく、**Livewire Starter Kit独自のBladeビュー**（`resources/views/pages/auth/login.blade.php`など）に直接書かれた英文だからです。

```blade
<x-auth-header :title="__('Log in to your account')" ... />
```

このように`__()`で囲まれてはいるものの、**英文そのものが翻訳キー**になっているため、対応する翻訳が定義されていないと英語のまま表示されます。

{% hint style="warning" %}
**翻訳の質について**
コミュニティの翻訳リソースも、この新しいスターターキット固有の文言についてはまだ整備が薄く、ほぼ未翻訳という状況です（2026年時点の調査より）。
{% endhint %}

## 3. 独自文言の翻訳方法：`lang/ja.json`

Bladeファイルを直接書き換えなくても、プロジェクト直下に`lang/ja.json`を作成し、英文キーと日本語訳を対応づければ翻訳されます。

```json
{
    "Log in to your account": "アカウントにログイン",
    "Enter your email and password below to log in": "メールアドレスとパスワードを入力してログインしてください",
    "Sign in with a passkey": "パスキーでサインイン",
    "Don't have an account?": "アカウントをお持ちでない方は",
    "Sign up": "新規登録"
}
```

{% hint style="info" %}
**やり方**
1. `APP_LOCALE=ja`にした状態でログイン画面などを開く
2. 英語のまま表示されている文言をコピー
3. `lang/ja.json`にその英文をキーとして追加し、値に日本語訳を書く
4. ページをリロードして反映を確認

地道な作業ですが、画面ごとに数個〜十数個程度なので、AIに手伝ってもらいながら進めるのが現実的です。
{% endhint %}

## まとめ

| 対象 | 方法 |
| --- | --- |
| バリデーション・メール文言など | `laravel-lang/lang`（または`common`）を導入 + `APP_LOCALE=ja` |
| ログイン画面などスターターキット独自の文言 | `lang/ja.json`を自作して英文キー→日本語訳を対応づける |
