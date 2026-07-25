# 新しいLaravelプロジェクトの作成方法

## 基本的なプロジェクト作成

### Docker（Sail公式イメージ）を使用した作成（推奨）

PCにPHPやComposerをインストールしていなくても、Dockerさえあればこの方法でLaravelプロジェクトを作成できます。**Livewire Starter Kit（認証にFortifyを使用）・MySQL・Pest**構成で作成する例です：

```bash
docker run --rm --pull=always \
  -v "$(pwd)":/opt \
  -w /opt \
  laravelsail/php84-composer:latest \
  bash -lc "composer global require laravel/installer --quiet && export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\" && laravel new プロジェクト名 --livewire --database=mysql --pest --no-node --no-interaction && cd プロジェクト名 && php artisan sail:install --with=mysql,mailpit"

sudo chown -R $USER: プロジェクト名
```

例：

```bash
# 新しいプロジェクト「blog」を作成
docker run --rm --pull=always \
  -v "$(pwd)":/opt -w /opt \
  laravelsail/php84-composer:latest \
  bash -lc "composer global require laravel/installer --quiet && export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\" && laravel new blog --livewire --database=mysql --pest --no-node --no-interaction && cd blog && php artisan sail:install --with=mysql,mailpit"
sudo chown -R $USER: blog

# 新しいプロジェクト「todo-app」を作成
docker run --rm --pull=always \
  -v "$(pwd)":/opt -w /opt \
  laravelsail/php84-composer:latest \
  bash -lc "composer global require laravel/installer --quiet && export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\" && laravel new todo-app --livewire --database=mysql --pest --no-node --no-interaction && cd todo-app && php artisan sail:install --with=mysql,mailpit"
sudo chown -R $USER: todo-app
```

{% hint style="info" %}
**各オプションの意味**
- `composer global require laravel/installer`：`laravelsail/php84-composer`イメージに入っているLaravelインストーラーが古い場合があるため、最新版に更新（`--livewire`などの新しいオプションを使うために必要）
- `--livewire`：Livewire Starter Kit（Fortifyベースの認証込み）を使用
- `--database=mysql`：DBはMySQLを使用
- `--pest`：テストフレームワークはPestを使用
- `--no-node`：この段階ではnpmビルドを行わない（あとでSailコンテナ内から`sail npm install && sail npm run dev`を実行する）
- `--no-interaction`：対話プロンプトをスキップ
- `php artisan sail:install --with=mysql,mailpit`：SailのDocker設定（`compose.yaml`）を、MySQLとメール確認用のMailpitを含む構成で生成
- `sudo chown -R $USER: プロジェクト名`：コンテナ内（root権限）で作成されたファイルの所有者を自分に戻す
{% endhint %}

{% hint style="warning" %}
**旧来の`curl -s https://laravel.build/...`方式について**
以前は `curl -s "https://laravel.build/プロジェクト名" | bash` でも作成できましたが、この方式は生成されるスターターキットのバージョンをコントロールしづらいため、現在は上記のdockerコマンドを推奨しています。
{% endhint %}

## プロジェクト作成後の初期設定

### 1. プロジェクトディレクトリに移動

```bash
cd プロジェクト名
```

### 2. Sailコンテナの起動とセットアップ

```bash
./vendor/bin/sail up -d
./vendor/bin/sail artisan migrate
./vendor/bin/sail npm install
./vendor/bin/sail npm run dev
```

## .envファイルの編集方法

### .envファイルとは

- Laravelアプリケーションの環境変数を設定するファイル
- データベース接続情報、アプリケーション設定などを管理
- プロジェクト作成時に自動的に `.env` ファイルが生成される

### 主要な設定項目

#### データベース設定

```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel  # プロジェクト名に応じて変更（下記参照）
DB_USERNAME=sail
DB_PASSWORD=password
```

**注意：** `DB_DATABASE`は作成したプロジェクト名と合わせることが推奨されます。
- プロジェクト名が「blog」なら → `DB_DATABASE=blog`
- プロジェクト名が「todo-app」なら → `DB_DATABASE=todo_app`（ハイフンをアンダースコアに変更）

#### アプリケーションURL

```env
APP_URL=http://localhost
```

{% hint style="warning" %}
**APP_URLの初期値に注意**
Laravelインストーラーは`APP_URL=http://localhost:8000`をデフォルトで設定しますが、Sailの`compose.yaml`は`80`番ポートを使う設定になっています。**ポート番号なしの`http://localhost`に修正しないと**、メール内のリンクなど一部の機能で意図しないURLが生成されるので注意してください。
{% endhint %}

### .envファイルの編集手順

1. **ファイルを開く**
   ```bash
   # VS Codeで開く場合
   code .env
   
   # viで開く場合
   vi .env
   ```

2. **必要な項目を編集**
   - `APP_NAME`：アプリケーション名を変更
   - `APP_URL`：`http://localhost`になっているか確認
   - `DB_DATABASE`：データベース名を変更
   - その他必要に応じて設定

3. **変更例**
   ```env
   APP_NAME="My Blog App"
   APP_URL=http://localhost
   
   DB_CONNECTION=mysql
   DB_HOST=mysql
   DB_PORT=3306
   DB_DATABASE=blog_db
   DB_USERNAME=sail
   DB_PASSWORD=password
   ```

### 設定変更後の注意点

1. **設定キャッシュのクリア**
   ```bash
   ./vendor/bin/sail artisan config:clear
   ```

2. **コンテナの再起動（データベース設定を変更した場合）**
   ```bash
   ./vendor/bin/sail down
   ./vendor/bin/sail up -d
   ```

3. **マイグレーションの実行**
   ```bash
   ./vendor/bin/sail artisan migrate
   ```

## 実践例：ブログアプリの作成

```bash
# 1. プロジェクト作成
docker run --rm --pull=always \
  -v "$(pwd)":/opt -w /opt \
  laravelsail/php84-composer:latest \
  bash -lc "composer global require laravel/installer --quiet && export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\" && laravel new my-blog --livewire --database=mysql --pest --no-node --no-interaction && cd my-blog && php artisan sail:install --with=mysql,mailpit"
sudo chown -R $USER: my-blog

# 2. ディレクトリ移動
cd my-blog

# 3. .envファイル編集
code .env
# APP_NAME="My Blog"
# APP_URL=http://localhost
# DB_DATABASE=blog_database

# 4. コンテナ起動とセットアップ
./vendor/bin/sail up -d
./vendor/bin/sail artisan migrate
./vendor/bin/sail npm install
./vendor/bin/sail npm run dev

# 5. ブラウザでアクセス
# http://localhost
```

## トラブルシューティング

### よくあるエラーと解決方法

1. **ポートが使用されている場合**
   ```bash
   # .envのAPP_PORTを変更してから
   ./vendor/bin/sail up -d
   ```

2. **データベース接続エラー**
   - `.env`のDB設定を確認
   - コンテナが正常に起動しているか確認：`./vendor/bin/sail ps`

3. **アプリケーションキーエラー**
   ```bash
   ./vendor/bin/sail artisan key:generate
   ```

4. **権限エラー**
   ```bash
   sudo chown -R $USER:$USER プロジェクト名/
   ```

5. **`--livewire`オプションが見つからないエラー**
   - `laravelsail/php84-composer`イメージに入っているLaravelインストーラーが古いことが原因です
   - コマンド内の `composer global require laravel/installer` が実行されているか確認してください
