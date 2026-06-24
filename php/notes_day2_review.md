# Day2 内容レビューメモ

## 良い点

- **Excelとの例え**が直感的でわかりやすい（DB=ファイル、テーブル=シート）
- **SQLインジェクション対策**をサンプルコードで具体的に示している（プレースホルダあり・なしの比較）
- **XSS対策**も `h()` 関数として再利用しやすい形にまとめられている

---

## 気になる点・補足メモ

### 1. DB接続情報がハードコード

`insert.php` と `select.php` の両方に同じ接続情報が書かれている。

```php
$pdo = new PDO('mysql:dbname=gs_db_class; charset=utf8; host=localhost', 'root', '');
```

**学習段階では問題ないが**、実務では接続情報は `.env` ファイルや設定ファイルにまとめて一か所で管理するのが基本。コピペが発生すると修正漏れの原因になる。

---

### 2. DB接続を関数・クラス化すると保守しやすい

学習が進んだら、接続部分を共通関数に切り出すとよい。

```php
// funcs.php に追記するイメージ
function getDbConnection(): PDO
{
    return new PDO('mysql:dbname=gs_db_class;charset=utf8;host=localhost', 'root', '');
}
```

---

### 3. `charset=utf8` より `utf8mb4` が推奨

```php
// 現状
'mysql:dbname=gs_db_class; charset=utf8; host=localhost'

// 推奨
'mysql:dbname=gs_db_class;charset=utf8mb4;host=localhost'
```

`utf8`（MySQL内部）は絵文字などが保存できない。テーブル作成時に `utf8mb4_general_ci` を指定しているのに、接続文字コードが `utf8` になっているのは不一致。  
→ テーブルは `utf8mb4` で作っているので接続も合わせた方が良い。

---

### 4. PDOのエラーモード設定が未指定

現状、`PDOException` をキャッチしているが、SQL実行時のエラー（prepare・execute失敗）は `errorInfo()` で手動確認している。  
PDO属性に `ERRMODE_EXCEPTION` を設定すると、SQL失敗時も例外として統一的に扱える。

```php
$pdo = new PDO('mysql:dbname=gs_db_class;charset=utf8mb4;host=localhost', 'root', '');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
```

---

### 5. `h()` 関数の第2引数に `ENT_HTML5` を追加すると現代的

```php
// 現状
return htmlspecialchars($str, ENT_QUOTES);

// より明示的
return htmlspecialchars($str, ENT_QUOTES | ENT_HTML5, 'UTF-8');
```

第3引数に文字コードを明示するのが安全。

---

## 授業の構成上の気づき

- SQLインジェクション対策のコード例が非常に明快で、**「なぜプレースホルダを使うのか」が直感的に伝わる**良いサンプル
- `_bk.md`（バックアップ）との差分を見ると、XAMPP全体構成の図解やPDO・prepareの説明が**追記・改善されている**のがわかる（ノートが育っている）
- 発展課題（検索・削除・編集・並び替え）がDay3以降の内容への橋渡しになっている
