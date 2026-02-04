# 001\_2\_Docker導入\_Mac

**Mac向けの記事です！** **Windowsは前のページへ！**

***

## 📺 **メイン動画**

{% hint style="success" %}
**🎥 この手順は動画で詳しく解説しています！**

**動画を見ながら進めることを強く推奨します。**

▶️ **動画はこちら**: https://youtu.be/qHF9JU629QM

**動画で解説している内容:**

1. Laravel プロジェクトの作成（`curl -s "https://laravel.build/laratter" | bash`）
2. プロジェクトディレクトリへの移動（`cd laratter`）
3. compose.yaml への phpMyAdmin 設定追加
4. `./vendor/bin/sail up -d` でのコンテナ起動

※ 動画内の一部コマンドと下記テキストで差異がある場合は、**下記テキストを正**として進めてください。

※ 動画で使用しているLaravelは少し古いバージョンのため、**現在のLaravelとUIが異なって見える場合があります**が、基本的な操作は同じです。
{% endhint %}

***

## 目次

1. [事前準備](001_2_gs_laravel_docker_for_mac.md#事前準備)
2. [Dockerとは？](001_2_gs_laravel_docker_for_mac.md#dockerとは)
3. [Laravel Sailの導入](001_2_gs_laravel_docker_for_mac.md#laravel-sailの導入)
4. [プロジェクトの起動と確認](001_2_gs_laravel_docker_for_mac.md#プロジェクトの起動と確認)
5. [phpMyAdminの設定](001_2_gs_laravel_docker_for_mac.md#phpmyadminの設定)

***

## 事前準備

{% hint style="info" %}
**Docker Desktop のインストール** Mac版の動画では Docker Desktop のインストール手順は省略されています。 事前に Docker Desktop for Mac をインストールしておいてください。

**参考**: Docker Desktop のインストール方法については、以下の記事の **8.インストール初回** まで完了すればOKです（9は不要）： https://minegishirei.hatenablog.com/entry/2023/05/04/124946
{% endhint %}

### 必要なソフトウェア

1. **Docker Desktop for Mac** のインストール
   * [公式サイト](https://docs.docker.com/desktop/)からダウンロード
   * インストール後、必ず起動させておく
2. **既存サーバーの停止** もしXAMPPやMAMPを起動している場合は、それらを終了させてから以下を行ってください。

{% hint style="warning" %}
**重要**: Docker DesktopがMacにインストールされ、起動していることを確認してください。
{% endhint %}

***

## Dockerとは？

{% hint style="info" %}
**Docker（ドッカー）とは？** アプリケーションを「コンテナ」という仮想環境で動かすためのツールです。

**XAMPPとの違い:**

* **XAMPP**: Macに直接PHP、MySQL、Apacheをインストール
* **Docker**: 仮想的な箱（コンテナ）の中にPHP、MySQL、Apacheを用意

**メリット:**

* 環境の違いによるトラブルが少ない
* 複数のプロジェクトで異なるバージョンを使い分けられる
* 開発チーム全員が同じ環境で作業できる
{% endhint %}

Laravelを導入するにあたり、今回はDockerというものを使います。

PHPを学ぶときに、仮のサーバーとしてXAMPP（or MAMP）を利用しましたよね？

Laravelも同じように大きな器を用意してその中で環境構築をします。

その器がDockerです。

***

## Laravel Sailの導入

{% hint style="info" %}
**Laravel Sail とは？** LaravelがDockerを簡単に使えるようにしてくれるツールです。複雑なDocker設定を自動で行ってくれます。
{% endhint %}

{% hint style="success" %}
**🎥 動画で詳しく解説** この手順は動画で詳しく解説されています。画面を見ながら進めてください。
{% endhint %}

### 手順1: Laravelプロジェクトの作成

ターミナルで以下のコマンドを実行します：

```bash
curl -s "https://laravel.build/laratter" | bash
```

{% hint style="warning" %}
**動画との違いについて** 動画では `curl -s "https://laravel.build/test-project" | bash` としていますが、 `curl -s "https://laravel.build/laratter" | bash` で実行してください。
{% endhint %}

{% hint style="warning" %}
**パスワード入力について** コマンド実行の最後に `Password for XXX:` と表示され、**パソコンのログインパスワード**の入力を求められます。

* **注意**: パスワードを入力しても画面には文字が表示されません（セキュリティのため）
* 見た目は何も入力されていないように見えますが、正しく入力されています
* パスワードを入力後、Enterキーを押してください
{% endhint %}

{% hint style="info" %}
**このコマンドの意味:**

* `laratter` という名前でLaravelプロジェクトを作成
* 必要なDockerファイルも自動生成
* データベース（MySQL）、Redis、メールサーバーなども含まれる
{% endhint %}

### 手順2: プロジェクトディレクトリに移動

ターミナルで以下のコマンドを実行します：

```bash
cd laratter
```

{% hint style="warning" %}
**注意**: プロジェクト名を `laratter` に変更したので、`cd laratter` で移動します。
{% endhint %}

***

## プロジェクトの起動と確認

{% hint style="success" %}
**🎥 動画で詳しく解説** `./vendor/bin/sail up -d` でのコンテナ起動手順を動画で確認できます。
{% endhint %}

### 手順3: Dockerコンテナの起動

ターミナルで以下のコマンドを実行します：

```bash
./vendor/bin/sail up -d
```

{% hint style="info" %}
**このコマンドの意味:**

* `sail up`: Dockerコンテナを起動
* `-d`: バックグラウンドで実行（ターミナルが占有されない）
{% endhint %}

### 手順4: データベースのセットアップ

初回 `./vendor/bin/sail up -d` 実行後、ブラウザで `http://localhost` にアクセスしてみてください。

{% hint style="warning" %}
**SQLSTATEエラーが表示された場合** 🚨もし「SQLSTATE...」というエラー画面が表示された場合は、データベースの初期設定が必要です。 以下のコマンドをターミナルで実行してください。
{% endhint %}

```bash
./vendor/bin/sail artisan migrate
```

{% hint style="info" %}
**このコマンドの意味:**

* Laravelのデータベーステーブルを作成
* ユーザー認証などの基本テーブルが準備される
{% endhint %}

### 手順5: 動作確認

ブラウザで以下のURLにアクセス：

* **Laravel アプリケーション**: http://localhost
* **成功**: Laravelのウェルカムページが表示される

{% hint style="warning" %}
**UIの違いについて** 動画で使用しているLaravelは少し古いバージョンのため、現在のLaravelウェルカムページとはデザインが異なって見える場合があります。しかし、基本的な機能や操作方法は同じです。
{% endhint %}

<figure><img src="../.gitbook/assets/laravel_start (1).png" alt=""><figcaption></figcaption></figure>

### 手順6: 開発終了時（コンテナの停止）

作業を終了する際は以下のコマンドでターミナルで実行してコンテナを停止：

```bash
./vendor/bin/sail down
```

***

## phpMyAdminの設定

{% hint style="success" %}
**🎥 動画で詳しく解説** compose.yaml への phpMyAdmin 設定追加が詳しく説明されています。
{% endhint %}

データベースを視覚的に管理するため、phpMyAdminを追加します。

### compose.yamlファイルの編集

{% hint style="info" %}
**compose.yamlファイルの場所** `compose.yaml` ファイルは、先ほど作成した `laratter` フォルダの中にあります。

**具体的な場所:**

* ターミナルで `cd laratter` を実行した場所
* VS Codeなどのエディタで `laratter` フォルダを開いた時に、フォルダの直下に表示されるファイル
* ファイル名は `compose.yaml`（拡張子は `.yml`）
{% endhint %}

{% hint style="warning" %}
**YAML形式の注意点** `.yml` ファイルは改行やインデント（スペース）が正確でないとエラーになります。

* **インデントはスペースを使用**（タブは使用不可）
* **改行位置や空白に注意**
* 気になる人は、生成AIと相談しながら記述することを推奨します
{% endhint %}

`laratter` フォルダ内の `compose.yaml` ファイルを開き、以下を追加：

{% hint style="warning" %}
**追加する場所に注意！** 以下のコードは、`compose.yaml` ファイルの **`networks:` より上の位置** に追加してください。 具体的には、既存のサービス（`laravel.test`, `mysql`, `redis` など）と同じレベルで追加します。
{% endhint %}

```yaml
phpmyadmin:
    image: phpmyadmin/phpmyadmin
    links:
        - mysql:mysql
    ports:
        - 8080:80
    environment:
        MYSQL_USERNAME: '${DB_USERNAME}'
        MYSQL_ROOT_PASSWORD: '${DB_PASSWORD}'
        PMA_HOST: mysql
    networks:
        - sail
```

{% hint style="info" %}
**設定内容の確認** `compose.yaml` の内容を生成AIに見せて、インデントや改行が正しいか確認してください。YAMLファイルは記述ミスがあると動作しません。
{% endhint %}

{% hint style="info" %}
**M1/M2 Macの場合** Apple Silicon Mac（M1/M2）を使用している場合は、「phpmyadmin The requested image's platform(linux/amd64) does not match the ....」が出る場合があります。その場合は、以下の行も追加してください：

```yaml
platform: linux/amd64
```
{% endhint %}

### phpMyAdminの利用方法

1.  上記設定を追加後、ターミナルで以下を1行ずつ実行してコンテナを再起動(シャットダウン + 起動)：

    ```bash
    ./vendor/bin/sail down
    ./vendor/bin/sail up -d
    ```
2. ブラウザで http://localhost:8080 にアクセス
3. ログイン情報：
   * **ユーザー名**: `sail`
   * **パスワード**: `password`
4. **phpMyAdmin動作確認**：
   * ログイン後、左側に `laratter` データベースが表示されることを確認
   * データベースをクリックして、テーブル一覧が表示されることを確認
   * もしテーブルが表示されない場合は、先ほどの `./vendor/bin/sail artisan migrate` が実行されているか確認

<figure><img src="../.gitbook/assets/phpmyadmin_start (2).png" alt=""><figcaption></figcaption></figure>

{% hint style="success" %}
**完了！** これでLaravel開発環境の準備が完了しました。以下のURLが利用できます：

* **Laravel**: http://localhost
* **phpMyAdmin**: http://localhost:8080
{% endhint %}

***

## トラブルシューティング

{% hint style="success" %}
**🎥 困ったときは動画をチェック！** エラーが発生した場合は、まず動画を確認してください: https://youtu.be/qHF9JU629QM
{% endhint %}

### よくあるエラー

**「Docker is not running」エラー** → Docker Desktopが起動していることを確認

**「Port already in use」エラー** → XAMPP/MAMPが起動していないか確認

**コマンドが認識されない** → プロジェクトディレクトリ（`laratter`フォルダ）内で実行しているか確認

**M1/M2 Mac での動作不具合** → compose.yaml に `platform: linux/amd64` を追加

***

## 📺 **動画で学習しよう！**

{% hint style="success" %}
**🎥 メイン解説動画**

▶️ **https://youtu.be/qHF9JU629QM**

**動画で実際に解説している内容:**

1. **Laravel プロジェクトの作成**
2. **プロジェクトディレクトリへの移動**
3. **compose.yaml への phpMyAdmin 設定追加**
4. **`./vendor/bin/sail up -d` でのコンテナ起動**

**推奨**: テキストと合わせて動画を視聴することで、より確実に環境構築ができます。
{% endhint %}

{% hint style="warning" %}
**重要な注意点:**

* 動画内の一部コマンドとこのテキストで差異がある場合は、**このテキストの内容を正**として進めてください
* **動画で使用しているLaravelは少し古いバージョン**のため、現在のLaravelとUIが異なって見える場合がありますが、基本的な操作は同じです
{% endhint %}
