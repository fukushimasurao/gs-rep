# 新しいLaravelプロジェクトの作成方法

## 基本的なプロジェクト作成

### Laravel Sailを使用した作成（推奨）
```bash
curl -s "https://laravel.build/プロジェクト名" | bash
```

例：
```bash
# 新しいプロジェクト「blog」を作成
curl -s "https://laravel.build/blog" | bash

# 新しいプロジェクト「todo-app」を作成
curl -s "https://laravel.build/todo-app" | bash
```

## プロジェクト作成後の初期設定

### 1. プロジェクトディレクトリに移動
```bash
cd プロジェクト名
```

### 2. Sailコンテナの起動
```bash
./vendor/bin/sail up -d
```

## .envファイルの編集方法

### .envファイルとは
- Laravelアプリケーションの環境変数を設定するファイル
- データベース接続情報、アプリケーション設定などを管理
- `.env.example`をコピーして`.env`ファイルが作成される

### 主要な設定項目

#### データベース設定
```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel  # デフォルトは「laravel」、必要に応じて変更
DB_USERNAME=sail
DB_PASSWORD=password
```

**注意：** `DB_DATABASE`は作成したプロジェクト名と合わせることが推奨されます。
- プロジェクト名が「blog」なら → `DB_DATABASE=blog`
- プロジェクト名が「todo-app」なら → `DB_DATABASE=todo_app`（ハイフンをアンダースコアに変更）

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
   - `DB_DATABASE`：データベース名を変更
   - その他必要に応じて設定

3. **変更例**
   ```env
   APP_NAME="My Blog App"
   APP_URL=http://localhost:8080
   
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
curl -s "https://laravel.build/my-blog?with=mysql" | bash

# 2. ディレクトリ移動
cd my-blog

# 3. .envファイル編集
code .env
# APP_NAME="My Blog"
# DB_DATABASE=blog_database

# 4. コンテナ起動
./vendor/bin/sail up -d

# 5. マイグレーション実行
./vendor/bin/sail artisan migrate

# 6. ブラウザでアクセス
# http://localhost
```

## トラブルシューティング

### よくあるエラーと解決方法

1. **ポートが使用されている場合**
   ```bash
   # ポートを変更
   ./vendor/bin/sail up -d --port 8080
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
