# 001\_2\_Docker導入\_Mac

**WINDOWS向けの記事です！** **Macは次のページへ！**

### 注意

もしxamppやmampを起動している場合は、それらを終了させてから以下行ってください。

***

laravelを導入するにあたり、今回はDockerというものを使います。

phpを学ぶときに、仮のサーバーとしてxammp(or mamp)を利用しましたよね？

laravelも同じように大きな器を用意してその中で環境構築をします。

その器がdockerです。

{% hint style="info" %}
dockerの説明はここでは割愛します。 詳しくは自分の目で確かめるのだ！
{% endhint %}

docker導入はこちらの記事参考にしてください。 すでに私のmacにdocker入っている手前、新しくdockerを入れ直すのが少し手間でして。

以下のURLの **8.インストール初回** まで完了すればokです。

9はやらなくていいです。

https://minegishirei.hatenablog.com/entry/2023/05/04/124946

***

### 注意

動画内に映るスクリプトと以下スクリプトの内容が若干異なりますが、 **以下のスクリプトを正**としてください。 （もしくは動画内の字幕を正としてください。）

動画では出てないですが、初めて`./vendor/bin/sail up -d`した際に以下のようなエラーが出ることがあります。

<figure><img src="../.gitbook/assets/スクリーンショット 2025-01-18 14.11.12.png" alt=""><figcaption></figcaption></figure>

その際は、

```
./vendor/bin/sail artisan migrate
```

を実行してください。

参考 windowsの動画([https://www.youtube.com/watch?v=jlLolZ-ZfBk](https://www.youtube.com/watch?v=jlLolZ-ZfBk))の3:50あたりを参考にしてください。

動画内で利用しているスクリプトはこちら

```bash
curl -s "https://laravel.build/laratter" | bash

cd example-app

./vendor/bin/sail up -d

./vendor/bin/sail down
```

```bash
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

```bash
platform: linux/amd64
```

動画 https://youtu.be/qHF9JU629QM
