# 001\_1\_Docker導入\_WINDOWS

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

### 注意

動画内と以下スクリプトの内容が若干異なりますが、 **以下のスクリプトを正**としてください。 （もしくは動画内の字幕を正としてください。）

動画内で利用しているスクリプトはこちら

```bash
curl -s "https://laravel.build/laratter" | bash

cd example-app

./vendor/bin/sail up -d

./vendor/bin/sail down

./vendor/bin/sail artisan migrate

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

動画はこちら https://youtu.be/PBzFkAERXNc
