# ð gs\_php\_day2

### ææ¥­è³æ <a href="#shou-ye-zi-liao" id="shou-ye-zi-liao"></a>

{% embed url="https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/PHP02_haifu.zip" %}

## ååã®ãããã

* ä»ã¾ã§ã®å­¦ç¿ã¯ã¯ã©ã¤ã¢ã³ããµã¤ãã®å­¦ç¿
  * HTML : ã©ã®ãããªæå­ãªã©ãåºãããæç¤ºãã
  * CSS : ã©ã®ãªã¬ã¤ã¢ã¦ãã«ããããæç¤ºãã
  * JS : ã©ã®ãããªåããããããæç¤ºãã
* ãµã¼ãã¼ãµã¤ã
  * ã¯ã©ã¤ã¢ã³ãããæå ±ãåãåãããã®åå®¹ããã¨ã«å¦çãããã

## DBã«ç»é²ãã

ã¯ã©ã¤ã¢ã³ãããåãåã£ãæå ±ãDB(= ãã¼ã¿ãã¼ã¹)ã«ç»é²ãã¦ããã¾ãã

### ãã¼ã¿ãã¼ã¹ï¼ï¼ï¼

#### â»ããã§ã¯ã ãªã¬ã¼ã·ã§ãã«ãã¼ã¿ãã¼ã¹ã®ãã¨ããã¼ã¿ãã¼ã¹ã¨ãã¾ã

#### ä»¥ä¸ããã¼ã¿ãã¼ã¹ãDBã¨ç¥ãã¦è¡¨è¨ãã¾ã

* æå ±ãè¨é²ãããã®ã
  * DBã¨
  * ãã¼ãã«ã§æ§æãããã
  * ãã®ä¸­ã«ãè¡¨å½¢å¼ã§è¨é²ãã¦ããã

ã¹ãã¬ããã·ã¼ãã§ããã¨ã

* ãã¡ã¤ã«ãã®ãã®(XXXX.xlsx)ãDB
* ã·ã¼ãããã¼ãã«

ã®ã¤ã¡ã¼ã¸ã

![ãã¨ã¯ã»ã«ã§è¨ãã¨ããã®ãã¡ã¤ã«ããã¼ã¿ãã¼ã¹](<.gitbook/assets/ã¹ã¯ãªã¼ã³ã·ã§ãã 2022-01-16 11.19.57.png>)

![](<.gitbook/assets/ã¹ã¯ãªã¼ã³ã·ã§ãã 2022-01-16 12.18.33.png>)

ã¹ãã¬ããã·ã¼ãã ã¨ãç»é¢è¦ãªããæä½ã§ãã DBã¯ãéå¸¸CLIï¼ã³ãã³ãã©ã¤ã³ã¤ã³ã¿ã¼ãã§ã¼ã¹ï¼ = é»ãç»é¢ã«æå­ã§æä½ããã

ããã ã¨ã¨ã£ã¤ãã«ããã®ã§ãCGIã§æä½ã§ãã`phpMyAdmin`ã¨ããã½ãããå©ç¨ããã

## phpMyAdmin

1. `MAMP`ãèµ·åã
2. `WebStartãã¿ã³`ã§welcomeç»é¢(èµ·åæã«åæã«ãã©ã¦ã¶ã«è¡¨ç¤ºãããç»é¢)
3. welcomeç»é¢å·¦ä¸ã®ã¡ãã¥ã¼ãããphpMyAdminãã¯ãªãã¯ éãæ¹ã¯ç»é¢åç§ã

![](<.gitbook/assets/ã¹ã¯ãªã¼ã³ã·ã§ãã 2022-01-16 11.21.17.png>)

ãã©ã¦ã¶ã®URLããã¯ãå¤å `http://localhost/phpMyAdmin5/`ã§è¡ããã

## DBä½æ

### æ°è¦DBä½æ

1. å·¦ã¡ãã¥ã¼ãã\[æ°è¦ä½æ]
2. ãã¼ã¿ãã¼ã¹åã¯ `gs_db`
3. ç§åé åºã¯`utf8_unicode_ci`
4. ä½æã¯ãªãã¯ã
5. ç¹ã«ã¨ã©ã¼ã®æè¨ãåºãªããã°ok

![](<.gitbook/assets/ã¹ã¯ãªã¼ã³ã·ã§ãã 2022-01-16 11.29.50.png>)

### æ°è¦ãã¼ãã«ä½æ

1. ãã¼ãã«åï¼`gs_an_table`
2. ã«ã©ã æ°ï¼5

### ã«ã©ã ãä½æ

```
`id`:    int(12) AUTO_INCREMENT PRIMARY KEY
`name`:  var_char(64)
`email`:  var_char(128)
`content`: text
`date`: datetime
```

è¨å¥ãããä¿å­

![](<.gitbook/assets/ã¹ã¯ãªã¼ã³ã·ã§ãã 2022-01-16 11.37.20.png>)

{% hint style="info" %}
varcharã¨textéã âã¡ã¢ãªå®¹é

varcharåã®æå­åã¯ãã¼ã¿ãã¼ã¹ã«ç´æ¥ä¿å­ããã¾ãã

textåã®æå­åã¯ãã¼ã¿ãã¼ã¹ã¨ã¯å¥ã«ä¿å­ããã¼ã¿ãã¼ã¹ã«ã¯ãã®ãã¤ã³ã¿ã¼ã®ã¿ä¿å­ããã¾ãã

ãã®ãããç­ãæå­åã§ããã°varcharãä½¿ã£ãæ¹ãå¹çè¯ãå¦çã§ãã¾ãã
{% endhint %}

{% hint style="info" %}
ãã©ã¤ããªã­ã¼

ãã¼ã¿ãä¸æã«è­å¥ããããã«ä½¿ãããé ç® âä»ã®é ç®(ååã¨ãå¹´é½¢ã¨ã)ã¯éè¤ããå ´åãããã

â»ãã¼ã¿ã¯å¿ãå¥åããªããã°ãªããªããï¼NULL)ã«ã¯ãªããªãã
{% endhint %}

{% hint style="info" %}
ãªã¼ãã¤ã³ã¯ãªã¡ã³ã

é£ç¶ããæ°å¤ãèªåã§å¥ãã¦ãããã
{% endhint %}

*

### SQL

ã¨ã¯ã»ã«ã«è¨å¥ããå ´åã¯ç»é¢è¦ãªããæä½ã DBã«ç»é²ãç·¨éåé¤ç­ããå ´å`SQL`ã¨ããè¨èªãå©ç¨ãã¾ãã

ãã®ç« ã§ã¯ãã¼ã¿ã«å¯¾ãã¦

* ç»é² : `INSERT`
* åå¾è¡¨ç¤º : `SELECT` ã®å¦çãè¡ãã¾ãã

### INSERT

ãã¼ã¿ãè¨é²ããéã«ç¨ããã

åºæ¬çãªæ¸ãæ¹ã¯ `INSERT INTO ãã¼ãã«å(ã«ã©ã 1,ã«ã©ã 2,ã«ã©ã 3ã»ã»ã») VALUES (å¤1,å¤2,å¤3ã»ã»ã»);`

â» åºæ¬çã«å¤§æå­(å°æå­ã§ãåä½ãã¾ããæ£ç¿çã«ã) åºæ¬çã«è¡ã®æå¾ã¯`;`ãã¤ãã¦ããã¦ãã ããã

ä¾æ

```sql
INSERT INTO gs_an_table(id,name,email,content,date) VALUES (NULL,'ç¦å³¶ã¯ãã¨','test@test.jp','åå®¹',sysdate());
```

{% hint style="success" %}
**ååãã¡ã«ã¢ããå¤ãã¦3ã¤ä»¥ä¸ç»é²ãã¦ãã ãã**
{% endhint %}

### SELECT

ãã¼ã¿ãåå¾è¡¨ç¤ºããéã«ç¨ããã

1. æ¸å¼ `SELECT è¡¨ç¤ºããã«ã©ã  FROM ãã¼ãã«å;`
2. ãã¼ã¿åå¾ã®åºæ¬ããªã¨ã¼ã·ã§ã³

```sql
SELECT * FROM gs_an_table; --å¨ã«ã©ã æå®åå¾
SELECT name FROM gs_an_table; --åä¸ã«ã©ã æå®åå¾
SELECT name,email FROM gs_an_table; --è¤æ°ã«ã©ã æå®åå¾
SELECT * FROM gs_an_table WHERE name='ãã¹ãå¤ªé'; --WHEREãä½¿ã£ãç¹å®ãã¼ã¿ã®åå¾
```

1. æ¡ä»¶ä»ãæ¤ç´¢åå¾

```sql
--æ¼ç®å­ãä½¿ã£ãæ¤ç´¢
SELECT * FROM ãã¼ãã«å WHERE id = 1;
SELECT * FROM ãã¼ãã«å WHERE id >= 3;

--AND,ORã§æ¤ç´¢æ¡ä»¶ãè¤æ°æå®
SELECT * FROM ãã¼ãã«å WHERE id = 1 OR id = 2;
SELECT * FROM ãã¼ãã«å WHERE id = 1 AND id = 2;

--ææ§æ¤ç´¢
SELECT * FROM ãã¼ãã«å WHERE date LIKE '2021-06%';
SELECT * FROM ãã¼ãã«å WHERE email LIKE '%@gmail.com';
SELECT * FROM ãã¼ãã«å WHERE email LIKE '%@%';
```

1. ã½ã¼ãåå¾ã¨å¶éåå¾

```sql
--ã½ã¼ã
SELECT * FROM ãã¼ãã«å ORDER BY ã½ã¼ãå¯¾è±¡ã«ã©ã  ã½ã¼ãã«ã¼ã«;
SELECT * FROM ãã¼ãã«å ORDER BY id DESC; --éé 
SELECT * FROM ãã¼ãã«å ORDER BY id ASC; --æ
--åå¾æ°å¶é
æ¸å¼ï¼SELECT * FROM ãã¼ãã«å LIMIT ***;

SELECT * FROM ãã¼ãã«å LIMIT 5; --æå¤§5ä»¶åå¾ 
SELECT * FROM ãã¼ãã«å LIMIT 3,5; --3çªç®ã®ãã¼ã¿ããæå¤§5ä»¶åå¾ 
```

## PHPããMySQLãæä½

DBã¨ãããã®ã¨ãBDãæä½ããããã®`SQL`ãå­¦ã³ã¾ããã æ¬¡ã«PHPåã§ã`SQL`ãæ¸ãã¦`MySQL`ãæä½ãã¦ããã¾ãã

### formãä½æ

`index.php`ã®formãä¿®æ­£ããã

```
methodï¼POST
actionï¼insert.php
```

### åãåã/ç»é²å¦çãä½æ(INSERT)

`insert.php`ãä»¥ä¸ã®ããã«è¨è¿°

```php
<?php
//1. POSTãã¼ã¿åå¾
$name = $_POST['name'];
$email = $_POST['email'];
$content = $_POST['content'];

//2. DBæ¥ç¶
try {
    //Password:MAMP='root',XAMPP=''
    $pdo = new PDO('mysql:dbname=gs_db; charset=utf8; host=localhost', 'root', 'root');
} catch (PDOException $e) {
    exit('DBConnectError:' . $e->getMessage());
}

//ï¼ï¼ãã¼ã¿ç»é²SQLä½æ
$stmt = $pdo->prepare("INSERT INTO gs_an_table(id, name, email, content, date)
                        VALUES(NULL, :name, :email, :content, sysdate())");
$stmt->bindValue(':name', $name, PDO::PARAM_STR);  //Integerï¼æ°å¤ã®å ´å PDO::PARAM_INT)
$stmt->bindValue(':email', $email, PDO::PARAM_STR);  //Integerï¼æ°å¤ã®å ´å PDO::PARAM_INT)
$stmt->bindValue(':content', $content, PDO::PARAM_STR);  //Integerï¼æ°å¤ã®å ´å PDO::PARAM_INT)
$status = $stmt->execute();

//ï¼ï¼ãã¼ã¿ç»é²å¦çå¾
if ($status === false) {
    //SQLå®è¡æã«ã¨ã©ã¼ãããå ´åï¼ã¨ã©ã¼ãªãã¸ã§ã¯ãåå¾ãã¦è¡¨ç¤ºï¼
    $error = $stmt->errorInfo();
    exit("ErrorMessage:" . print_r($error, true));
} else {
    header('Location: index.php');
}
```

{% hint style="info" %}
try-catch

ã¾ãtryã®ä¸­èº«ãå¦ç.

ããã¨ã©ã¼(ä¾å¤å¦ç)ãã­ã£ãããããã`catch`ã®ä¸­èº«ãå®è¡ãããã
{% endhint %}

{% hint style="info" %}
prepare, bindValue

SQLã¤ã³ã¸ã§ã¯ã·ã§ã³ãé²ãã

[https://blog.senseshare.jp/placeholder.html](https://blog.senseshare.jp/placeholder.html)
{% endhint %}

### ãã¼ã¿ã®åå¾ã¨è¡¨ç¤º(SELECT)

#### `selsect.php` - 1

```php
<?php

//1.  DBæ¥ç¶
try {
    //Password:MAMP='root',XAMPP=''
    $pdo = new PDO('mysql:dbname=gs_db;charset=utf8;host=localhost', 'root', 'root');
} catch (PDOException $e) {
    exit('DBConnectError' . $e->getMessage());
}

//ï¼ï¼ãã¼ã¿åå¾SQLä½æ
$stmt = $pdo->prepare("SELECT * FROM gs_an_table");
$status = $stmt->execute();

//ï¼ï¼ãã¼ã¿è¡¨ç¤º
$view = '';
if ($status === false) {
    //executeï¼SQLå®è¡æã«ã¨ã©ã¼ãããå ´åï¼
    $error = $stmt->errorInfo();
    exit('ErrorQuery:' . $error[2]);
} else {
    // Selectãã¼ã¿ã®æ°ã ãèªåã§ã«ã¼ããã¦ããã
    // FETCH_ASSOC = http://php.net/manual/ja/pdostatement.fetch.php
    while ($result = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $view .= '<p>';
        $view .= $result['date'] . ':' . $result['name'] . ' ' . $result['content'] . ' ' . $result['email'];
        $view .= '</p>';
    }
}
?>
```

#### `selsect.php` - 2

* ãã­ã³ãè¡¨ç¤ºé¨å

```php
    <!-- Main[Start] -->
    <div>
        <div class="container jumbotron"><?= $view ?></div>
    </div>
```

### ã»ã­ã¥ãªãã£å¯¾ç­ XSS -1

`select.php`ã«`funcs.php`ãèª­ã¿è¾¼ãã§ä½æããé¢æ°ãä½¿ã

```php
<?php
//select.phpã®ä¸çªä¸ã«1è¡è¿½è¨
require_once('funcs.php');
```

### ã»ã­ã¥ãªãã£å¯¾ç­ XSS - 2

\`funcs.php\`

```php
<?php
//å±éã«ä½¿ãé¢æ°ãè¨è¿°
//XSSå¯¾å¿ï¼ echoããå ´æã§ä½¿ç¨ï¼ããä»¥å¤ã¯NG ï¼
function h($str)
{
    return htmlspecialchars($str, ENT_QUOTES);
}

```

`selsect.php` ã® `$view`å¦çé¨åã«`XSSå¯¾ç­`ãããã

```php
$view .= '<p>';
$view .= h($result['date']).':'.h($result['name']).' '.h($result['content']).' '.h($result['email']);
$view .= '</p>';
```

#### ãèª²é¡ã ããã¯ãã¼ã¯ã¢ããª

1. ã¾ããä»¥ä¸ã®éãDBã¨ãã¼ãã«ãä½æ

* DBå:èªç±
* tableå:`gs_bm_table`
* é ç®ï¼ã«ã©ã ï¼å
  1. ã¦ãã¼ã¯å¤ (int 12 , PRIMARY, AutoIncrement)
  2. 2.æ¸ç±å (varChar 64)
  3. æ¸ç±URL (text)
  4. æ¸ç±ã³ã¡ã³ã(text)
  5. ç»é²æ¥æ (datetime)

2. ææ¥­ã§ãã£ãããã«ã

* ç»é²ç»é¢
* ç»é²å¦çç»é¢
* ç»é²åå®¹ç¢ºèªç»é¢

ãä½æãã¦ãã ããã

3. èª²é¡ãæåºããã¨ãã¯ãå¿ãsqlãã¡ã¤ã«ãæåºã
ãã¡ã¤ã«ã®ç¨æã®ä»æ¹ã¯[ãããåç§](https://gitlab.com/gs_hayato/gs-php-01/-/blob/master/%E3%81%9D%E3%81%AE%E4%BB%96/howToExportSql.md)
