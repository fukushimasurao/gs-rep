# about Class Detail(仮)

## 　クラスとは

* クラスの最小定義
* インスタンス化

```php
class Person {}

$p = new Person();
```

## プロパティ

```php
class Person {
    public $firstName;
    public $lastName = 'hayato';
}

$p = new Person();
$p->firstName = '山田';
$p->lastName = '太郎';
echo "$p->firstName $p->lastName"
```

## メソッド

```php
class Person {
    public $firstName;
    public $lastName = 'hayato';

    public function show() {
        echo "$this->firstName $this->lastName";
    }
}

$p = new Person();
$p->firstName = '山田';
$p->lastName = '太郎';
$p->show();
```

## コンストラクタ

```php
class Person {
    public $firstName;
    public $lastName = 'hayato';

    public function __construct(string $firstName, string $lastName) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
    }

    public function show() {
        echo "$this->firstName $this->lastName";
    }
}

$p = new Person('山田','太郎');
$p->show();
```

## 静的メソッド

* インスタンスを作成せず、直接メソッドにアクセスする。
* インスタンスがないので、`$this`は利用できない。

```php
class Area {
    public static function circle(float $radius): float {
        return pow($radius, 2) * 3.14;
    }
}

echo Area::circle(10);
```

## 静的インスタンス

```php
class Area {
    public static $pi= 3.14;

    public static function circle(float $radius): float {
        return pow($radius, 2) * self::$pi;
    }
}

echo '円周率は' . Area::$pi;
echo Area::circle(10);
```

## カプセル化

利用者にとって不要な部分を見せない・編集できないようにする。 そのためにアクセス修飾子を利用する。

| 修飾子       | 概要                     |
| --------- | ---------------------- |
| public    | どこでもアクセス可能             |
| protected | 現在のクラスと、サブクラスからアクセス可能。 |
| private   | 現在のクラスだけ               |

```php
/**
 * ゲッターセッターを用意したクラス。
 * プロパティは、private（外からアクセスできない）なので、セッターゲッターが必要
 * これで、マイナスなどの変な数字が入ってきても防げる
 */
class TriangleFigure
{
    private $base;
    private $height;

    public function __construct()
    {
        $this->setBase(1);
        $this->setHeight(1);
    }

    // ゲッター
    public function getBase(): float
    {
        return $this->base;
    }

    // セッター
    public function setBase(float $base)
    {
        if ($base > 0) {
            $this->base = $base;
        }
    }


    // ゲッター
    public function getHeight(): float
    {
        return $this->height;
    }

    // セッター
    public function setHeight(float $height)
    {
        if ($height > 0) {
            $this->height = $height;
        }
    }

   public function getArea()
   {
       return $this->getBase() * $this->getHeight() / 2;
   }
}

$tri = new TriangleFigure();

$tri->setBase(-10);
$tri->setHeight(-10);
echo $tri->getArea();
```

## 継承(inheritance)

* 継承元 = スーパークラス、親クラスと呼ぶ
* 継承先 = サブクラス、小クラス

似たクラスを作る場合、継承を利用すれば最初から作る必要がない。 親クラスの機能を引き継いで、子クラスを利用してもいい。

```php
class Person
{
    public string $firstName;
    public string $lastName;

    public function __construct(string $firstName, string $lastName)
    {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
    }

    public function show(): void
    {
        print "<p>ボクの名前は{$this->lastName}{$this->firstName}です。</p>";
    }
}


class BusinessPerson extends Person
{
    public function work()
    {
        echo "<p> {$this->lastName} {$this->firstName}は働いています。";
    }
}

$bp = new BusinessPerson('名字', '太郎');

// BusinessPersonのメソッドを利用
$bp->work();

// 継承元のメソッドも利用
$bp->show();
```

* _**なお、PHPでは、以下のような多重継承はできない**_

```php
class BusinessPerson extends Person, Animal {}
```

* _**サブクラスが、親クラスに全て含まれる関係(is-aの関係)になっている。**_

## 継承(inheritance)　メソッドのオーバーライド

```php
class EliteBusinessPerson extends BusinessPerson
{
    // BusinessPersonと同じ名前のメソッド work()
    public function work(): void
    {
        echo "<p>{$this->lastName} {$this->firstName} はエリートです</p>";
    }
    
    public function parentWork(): void
    {
        // parent::メソッドで、継承元を呼び出せる。
        parent::work();
        echo "ぼちぼち,,";
    }
}

$ebp = new EliteBusinessPerson('エリート', '太郎');
// work()はオーバーライド（継承先が使われている）されたメソッド
$ebp->work().PHP_EOL;

// show()は１番の継承元のPersonから継承されている。
$ebp->show().PHP_EOL;

// parentWorkは、parent::work();なので、継承元のwork()が呼び出されている。
$ebp->parentWork().PHP_EOL;
```

* \***parentで、継承元のメソッドを利用することができるが、constructにもparentが利用可能。**

## 継承先でのオーバーライド禁止 (final修飾子)

継承元のメソッドや、クラスに、`final`をつけるとオーバーライドができなくなる。

```php
// BusinessPerson
public final function work() {
}
```

```php
final class BusinessPerson extends Person{}
```

* 継承元のメソッドに、追記する例

```php

class MyClass2
{
    protected $date;
    public function __construct(string $data)
    {
        $this->data = $data;
    }

    public function getData(): string
    {
        return $this->data;
    }
}

class inheritMyClass extends MyClass2
{
    public function echoName()
    {
        echo "~~~~~~~~~~~~~~~" . PHP_EOL;
        echo parent::getData() . PHP_EOL;;
        echo "~~~~~~~~~~~~~~~" . PHP_EOL;
    }
}

$imc = new inheritMyClass('でーた');
$imc->echoName();
```

## ポリモーフィズム

* 複数のクラスで同じ名前のメソッドを定義する。これがポリモーフィズム
* ポリモーフィズムのメリットは、同じ目的の機能を呼び出すために異なる名前（命令）を覚えなくてもよいという点
* Triangleクラスでは面積を求めるのはgetAreaメソッドなのに、SquareクラスではcalculateAreaメソッドである、となるとクラスを使う側からすれば面倒。
* また、名前は一緒でも継承先での振る舞い・動作が異なる。

```php
class Figure
{
    protected float $width;
    protected float $height;

    public function __construct(float $width, float $height)
    {
        $this->width = $width;
        $this->height = $height;
    }

    // オーバーライドしてもらうため、中身はダミー
    public function getArea(): float
    {
        return 0;
    }
}


class Triangle extends Figure
{
    public function getArea(): float
    {
        return $this->width * $this->height / 2;
    }
}

class Square extends Figure
{
    public function getArea(): float
    {
        return $this->width * $this->height;
    }
}


$tri = new Triangle(5, 10);
$squ = new Square(5, 10);

// 同じgetArea()という名前で呼び出している。
// 利用者としては、同じ名前でわかりやすい。
print "三角形の面積：{$tri->getArea()} <br />";
print "四角形の面積：{$squ->getArea()}";
```

## 抽象クラス、抽象メソッド

* 上記のコード例だと、例えばサブクラスで違う名前のメソッド例を作成される可能性がある。よって、強制させる。
* `抽象メソッド` : サブクラスでオーバーライドされることを強制されたメソッド（使わないとエラーになる。
* `抽象クラス` : 抽象メソッドを含んだクラス
* _**抽象クラスを継承した場合、サブクラスはすべての抽象メソッドをオーバライドしなければならない義務を負う**_
* これらを利用すると、ポリモーフィズムを実現できる。

```php
// abstractがついているので、抽象メソッドになる。
abstract class Figure {
  protected float $width;
  protected float $height;

  public function __construct(float $width, float $height) {
    $this->width = $width;
    $this->height = $height;
  }

    // これもabstractがついているので、抽象メソッドになる。
    protected abstract function getArea(): float;
}
```

## インターフェース

例えば、以下のような例があるとする。

```
abstract class X {
    abstract Aメソッド
    abstract Bメソッド
    abstract Cメソッド
}
```

その時に、

* `class Y`では、`Aメソッド`、`Bメソッド`を利用したい。(Cメソッドはいらない)
* `class Z`では、`Bメソッド`、`Cメソッド`を利用したい。(Aメソッドはいらない) とすると、YにもZにも A,B,Cメソッドをとりあえずオーバーライドする必要がある。

そこで**クラスではなくインターフェース**を利用する。 イメージは、配下メソッドが全て**抽象メソッド** ( = オーバーライドされることが強制される)になる感じ。

```php
interface IFigure {
    function getArea(): froat;
}
```

インターフェースのルール

* Classとは違う。
* _**多重継承可能**_
* 中身のあるメソッド / プロパティは定義できない。
* 抽象メソッドが自明なので、 `abstract`の記述不要
* アクセス修飾子も不要
* インターフェース機能を受け継ぐことを「**実装する**」と表現する(継承じゃない)
* インターフェースを実装したクラスを「**実装クラス**」と呼ぶ。
* クラスでは、`extends`と記載したが、インターフェースでは`implements`を利用する。

```php
interface IFigure {
    function getArea(): float;
}

class Triangle implements IFigure {
    private $width;
    private $height;

    public function __construct(float $width, float $height) {
        $this->width = $width;
        $this->height= $height;
    }

    public function getArea(): float {
        return $this->width * $this->height / 2;
    }
}

```
