# 002\_Breeze導入

Laravel Breeze は、手軽に利用できる認証パッケージです。

パッケージを利用すると非常に簡単にログイン機能等が実装できます！ Laravel Breeze をプロジェクトにインストールしましょう。

## 事前準備

### Dockerコンテナが起動していることを確認

まずは前回作成したDockerコンテナが起動していることを確認してください：

```bash
./vendor/bin/sail up -d
```

### プロジェクトディレクトリにいることを確認

ターミナルで `laratter` プロジェクトフォルダにいることを確認してください：

```bash
cd laratter
```

{% hint style="info" %}
**現在のディレクトリの確認方法**
- Mac/Linux: `pwd` コマンドで現在のディレクトリを確認できます
- 表示されるパスの最後が `/laratter` になっていればOKです
{% endhint %}

## Breezeパッケージの導入

### 手順1: Breezeパッケージのインストール

```bash
./vendor/bin/sail composer require laravel/breeze --dev
```

{% hint style="info" %}
**このコマンドの意味:**
- Breezeパッケージをプロジェクトに追加します
- `--dev` オプションにより開発環境専用として追加されます
- この段階ではまだ利用できません（次の手順で設定を適用する必要があります）
{% endhint %}

### 手順2: Breezeの設定適用

```bash
./vendor/bin/sail artisan breeze:install
```

{% hint style="info" %}
**このコマンドの意味:**
- ログイン・登録・パスワードリセットなどのテンプレートファイルを自動生成
- 認証に必要なルートやコントローラーを自動追加
- CSS/JSファイルの設定も自動で行われます
{% endhint %}

コマンドを実行すると、以下のような選択肢が表示されます。
基本Enter押してれば問題ないですが、
**Which testing framework do you prefer? に関しては、PHPUnitを選択してください。**
**Pestを選択すると、次に進めません**
※もし進めなくなったら、ファイルをすべて削除 → 最初から`curl -s "https://laravel.build/laratter" | bash`からやり直しです。


```bash
 ┌ Which Breeze stack would you like to install? ─┐
 │ Blade with Alpine                              │  ← Enterで選択
 └────────────────────────────────────────────────┘

 ┌ Would you like dark mode support? ─────────────┐
 │ No                                             │  ← Enterで選択
 └────────────────────────────────────────────────┘

 ┌ Which testing framework do you prefer? ────────┐
 │ PHPUnit                                        │  ← キーボードの矢印でPHPUnitを選択してEnter
 └────────────────────────────────────────────────┘
```

{% hint style="warning" %}
**選択について**
各選択肢の詳細は、Laravel上級者になってから学習することをお勧めします。
{% endhint %}

### 手順3: フロントエンドファイルのビルド

```bash
./vendor/bin/sail npm run build
```

{% hint style="info" %}
**このコマンドの意味:**
- CSS、JavaScriptファイルをコンパイル・最適化
- Breezeで追加されたスタイルを反映
- 今後フロントエンドファイル（CSS/JS）を変更した際にも実行が必要
{% endhint %}

{% hint style="warning" %}
**重要**: このコマンドを実行しないと、ログイン画面のスタイルが正しく表示されません。必ず実行してください。
{% endhint %}

## 動作確認

### ブラウザでの確認

ビルドが完了したら、ブラウザで http://localhost にアクセスしてください。

Laravelのトップページの右上に **「Login」「Register」** のリンクが追加されていることを確認できます。

<figure><img src="../.gitbook/assets/laravel/002/laravel_002_010.png" alt=""><figcaption></figcaption></figure>

{% hint style="warning" %}
**まだユーザー登録はできません**
ログイン画面は表示されますが、まだユーザー情報を保存するためのデータベーステーブルが作成されていないため、実際の登録は行えません。次の手順でテーブルを作成します。
{% endhint %}

## データベーステーブルの作成

### 手順4: マイグレーションの実行

{% hint style="info" %}
**マイグレーションとは？**
データベースにテーブルを作成・変更するためのLaravelの仕組みです。ユーザー情報を保存するための `users` テーブルなどを作成します。
{% endhint %}

```bash
./vendor/bin/sail artisan migrate
```

{% hint style="warning" %}
**すでに実行済みの場合**
前回のDocker環境構築時に既にマイグレーションを実行している場合は、「Nothing to migrate.」と表示されます。その場合は次の手順に進んでください。
{% endhint %}

マイグレーションが成功すると、以下のような出力が表示されます：

```bash
   INFO  Preparing database.  

  Creating migration table ................................. 78ms DONE

   INFO  Running migrations.  

  2014_10_12_000000_create_users_table ..................... 25ms DONE
  2014_10_12_100000_create_password_reset_tokens_table ..... 10ms DONE
  2019_08_19_000000_create_failed_jobs_table ............... 24ms DONE
  2019_12_14_000001_create_personal_access_tokens_table .... 32ms DONE
```

{% hint style="success" %}
**成功！**
すべてのテーブルで「DONE」が表示されれば、データベースの準備が完了です。
{% endhint %}

## 動作テスト

### ユーザー登録のテスト

1. ブラウザで http://localhost にアクセス
2. 右上の **「Register」** をクリック
3. 以下の情報で2-3人のテストユーザーを作成してください：
   - **Name**: 任意の名前
   - **Email**: テスト用のメールアドレス（例：test1@example.com）
   - **Password**: 8文字以上のパスワード
   - **Confirm Password**: 上記と同じパスワード

{% hint style="success" %}
**登録成功の確認**
ユーザー登録が成功すると、自動的にログインされ、ダッシュボード画面に遷移します。
{% endhint %}

## 便利機能：ローカルメールサーバー

{% hint style="info" %}
**MailHog（メールサーバー）**
http://localhost:8025 にアクセスすると、開発用のメールサーバーにアクセスできます。

**用途:**
- パスワードリセットメールの確認
- ユーザー登録確認メールの確認
- 外部ネットワークに接続せずにメール機能をテスト可能

このメールサーバーは開発環境専用で、実際のメールは送信されません。
{% endhint %}

---

## ⚠️ 重要：Laravel Breezeの将来性について（2025年現在）

{% hint style="warning" %}
**Laravel 12以降でのBreeze事情**

Laravel 12が最新となった現在、**Laravel Breezeは公式推奨から外れています**。

**現在の状況（2025年）:**
- **Laravel 11まで**: Breezeは公式推奨の認証スターターキット
- **Laravel 12以降**: 非推奨（ただし技術的には利用可能）

**新しいアプリケーションスターターキットの導入**に伴い、Laravel BreezeとLaravel Jetstreamは**追加アップデートを受けられなくなりました**。
{% endhint %}

{% hint style="info" %}
**現在のBreeze利用について**

✅ **技術的に問題なし**: Laravel 12でもBreezeは正常に動作します  
✅ **既存機能は利用可能**: 認証機能はすべて動作します  
⚠️ **セキュリティリスク**: 将来的なセキュリティアップデートが期待できません  
⚠️ **機能追加なし**: 新機能追加や改善は期待できません  

**学習目的**: 現時点では問題なく利用できます  
**本格運用**: 他のスターターキットの検討を推奨
{% endhint %}

{% hint style="success" %}
**将来的な選択肢（中長期的対応）**

**1年以降の本格的な開発**では、以下のような代替手段を検討することをお勧めします：

**推奨代替案:**
- **Laravel Livewire**: モダンなフルスタック開発
- **Laravel Jetstream**: より高機能な認証システム（ただしこちらも同様の状況）
- **カスタム認証実装**: 自分で認証システムを構築
- **外部認証サービス**: Auth0、Firebase Authなど

**学習段階**: Breezeで基本を学んだ後、Livewireなどの学習を推奨
{% endhint %}
