# 👯‍♀️ XAMPP再インストール方法

バックアップXAMPP再インストールの流れ

* 授業やご自身で作成したphpファイルのバックアップ
* DBのバックアップ
* XAMPPのアンインストールしてからインストール
* 退避していたバックアップを再インストールしたXAMPPに移行する。

## 授業やご自身で作成したphpファイルのバックアップ

`htdocs`内のファイルをコピーし、任意の場所に移動 or コピペしてください。

<figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 18.10.32.png" alt=""><figcaption><p>バックアップ例</p></figcaption></figure>

## 授業やご自身で作成したDBのバックアップ

1. `phpMyAdmin`を開く
2. バックアップしたいDBをクリックし、headerメニューからエクスポートをクリック
3.

    <figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 17.15.52.png" alt=""><figcaption></figcaption></figure>
4. 特に何もいじらずそのままページ下部のエクスポートボタンを押下すると、`SQLファイル`が勝手にダウンロードされます。このダウンロードしたファイルは後で使います。

<figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 17.16.08.png" alt=""><figcaption></figcaption></figure>

## XAMPPの再インストール

1. 既存のXAMPPをアンインストールし、再度インストールします。

## 作成したバックアップを新しいXAMPPに移行する。（PHPファイル）

1. バックアップしたphpファイルを`htdocs`に格納してください。（上書きしてしまって大丈夫かと思います。）

<figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 18.15.26.png" alt=""><figcaption></figcaption></figure>

## 作成したバックアップを新しいXAMPPに移行する。（DB/SQLファイル）

1. phpMyAdminを開く
2. `gs_db`と言うDBを作成する。
3.

    <figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 18.17.37.png" alt=""><figcaption></figcaption></figure>
4. 左メニューから、今作成した`gs_db`をクリック。headerメニューから、インポートをクリック
5. インポートするファイルにて、先ほどバックアップした`SQLファイル`を選択
6.

    <figure><img src=".gitbook/assets/スクリーンショット 2022-12-11 18.19.07.png" alt=""><figcaption></figcaption></figure>
7. そのまま一番下までスクロールして、インポートをクリック
