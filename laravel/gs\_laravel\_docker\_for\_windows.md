# 🪟 001\_Docker導入_WINDOWS

**WINDOWS向けの記事です！**
**Macは次のページへ！**


laravelを導入するにあたり、今回はDockerというものを使います。

phpを学ぶときに、仮のサーバーとしてxammp(or mamp)を利用しましたよね？

laravelも同じように大きな器を用意してその中で環境構築をします。

その器がdockerです。

{% hint style="info" %}
dockerの説明はここでは割愛します。
詳しくは自分の目で確かめるのだ！
{% endhint %}


### 注意
動画内と以下スクリプトの内容が若干異なりますが、
**以下のスクリプトを正**としてください。

動画内のスクリプトはこちら
```bash
$ curl -s "https://laravel.build/example-app" | bash
$ cd example-app
$ ./vendor/bin/sail up -d
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



動画はこちら
https://youtu.be/jlLolZ-ZfBk
