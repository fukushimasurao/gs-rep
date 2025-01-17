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


docker導入はこちらの記事参考にしてください。
すでに私のmacにdocker入っている手前、新しくdockerを入れ直すのが少し手間でして。

以下のURLの
**8.インストール初回**
まで完了すればokです。

9はやらなくていいです。

https://minegishirei.hatenablog.com/entry/2023/05/04/124946

----

```bash
$ curl -s "https://laravel.build/test-project" | bash
$ cd test-project
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