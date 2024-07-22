# day5内容

## 全体的にやること

- 画像表示
- テーブルの結合

## 画像表示

- 前と同じ

## テーブルの結合
- 前提
- テーブル名を変更する
- gs_an_table -> users
- gs_user_table -> admin_users

### 案1 contentsテーブルの作成

- gs_an_tableの修正
  - テーブルは名前複数系で中身を表せられるもの。現状はuser名情報とcontentの情報が合わさっている。
  - gs_an_tableと、contentsテーブルに分ける。

- contentsテーブルの作成
- 以下の内容でcontentsテーブル作成
  - id int AI pk
  - user_id	int
  - content varchar(256)
  - created_at datetime
  - updated_at datetime nullable

- (内容は↓にてこちらで用意したinsertで入れる)
- phpmyadminにてgs_an_tableとcontentsをjoinで表示させる。



### 案2 usersの部署テーブルの作成
- ただしこれは多対多になるのでちょっとレベル高い
