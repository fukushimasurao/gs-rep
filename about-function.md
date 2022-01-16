---
description: 関数について、ざっくり説明します。
---

# 😇 about function 途中まで

### 関数が無い場合

例えば、以下のような内容を考えます。

```php
// 以下の３行を１０回繰り返す。
echo 'hello';
echo 'world';
echo "I'm from japan";
```

この場合、

1. この３行をコピペして、
2. １０回貼り付ける

という方法が考えられます。 ただし、ちょっとめんどくさいです。

```php
// イメージ
echo 'hello';
echo 'world';
echo "I'm from japan";

echo 'hello';
echo 'world';
echo "I'm from japan";

echo 'hello';
echo 'world';
echo "I'm from japan";

// ...以下省略
```

こういった、`複数行の処理`を、何かしらの理由で`複数回記述する必要が有る`場合、関数が便利です。

### 関数の基本

まず、関数は以下の順番で処理をします。

1. 関数を用意する。
2. 関数を実行する。

時々、関数を用意しただけで関数を実行した気になってしまう方がいますが、ちゃんと「用意→実行」が関数の基本です。

#### 関数の書き方

基本フォーマットは以下のとおりです。 `func_test`という名前の関数を用意してみます。

そしてそれを実行します。

```php
// (1)まずは関数を用意。
function func_test() {
    // 処理を書く
}

// (2)用意した関数を実行する。
// 実行するときは、関数名とカッコを付ける。
func_test();
```

![](<.gitbook/assets/名称未設定のノート-6 2.jpg>)

#### 関数の書き方(具体例)

それでは、例題で具体的にやってみましょう。

1. 関数の作成
   * 関数名の命名
   * 処理を記述
2. 関数の実行

の順番で対応します。

今回の関数は、`greeting`という名前にしましょう

```php
// (1)まずは関数を用意。
function greeting() {
    // 処理を書く
    echo 'hello';
    echo 'world';
    echo "I'm from japan";
}

// (2)用意した関数を実行する。
greeting();
```

これで、`greeting()`と書くたびに、処理の中身３行が実行されます。

```php
function greeting() {
    echo 'hello';
    echo 'world';
    echo "I'm from japan";
}
greeting();
greeting();
greeting();
greeting();
greeting();
greeting();
greeting();
greeting();
greeting();
greeting();
```

関数を利用すると行数をぐっと減らすことができます。 実際、１５行になりました。

#### 余談

単純に連続するだけなら、あまり恩恵を感じ取りづらいかもしれませんが、 離れたところで同じ処理をする場合に関数はとても便利です。

```php
function greeting() {
    echo 'hello';
    echo 'world';
    echo "I'm from japan";
}
// ここに100行くらいコードが有ると思ってください
greeting();
// ここに100行くらいコードが有ると思ってください
greeting();
// ここに100行くらいコードが有ると思ってください
greeting();
```

こんな感じで、離れたところで複数回処理をする場合、 関数が有るともっと便利です。 しかも、自分がつけた名前から、この関数がどのような処理をするかがなんとなくわかるのです。 ※よって、命名する際の名前は超重要になってきます。

### 関数の基本(引数編)

同じ処理をする場合「似た処理なんだけど若干違う処理」をしたい場合があります。

例えば、以下の処理を考えて見ましょう。

* ３つ有る三角形の面積を求めましょう。どの三角形も底辺は5cmで、高さがそれぞれ2cm,4cm, 6cmです。

さて、ご存知の通り三角形は、 `底辺 * 高さ / 2`で求めることが可能です。

今回は底辺は一緒ですが、高さだけが異なります。

さて、まずは上記で学んだとおり、それぞれの面積を求める関数を作って見ましょう。

```php
//１つ目
function getTriangleArea1() {
    echo (5 * 2 / 2);
}

//2つ目
function getTriangleArea2() {
    echo (5 * 4 / 2);
}

//3つ目
function getTriangleArea3() {
    echo (5 * 6 / 2);
}

getTriangleArea1();
getTriangleArea2();
getTriangleArea3();
```

さて、上記で気づくことは「どの関数も内容がめちゃくちゃ似てる」ということです。

* 関数名
* 掛け算の部分 以外は同じです。

少し抽象化すると以下のように表せると思います。

![](.gitbook/assets/getTriangleArea.jpg)

```php
function getTriangleArea() {
    echo (5 * 高さ / 2);
}
```

このように、高さの部分だけを変えれば３つの三角形の面積がわかります。 その際に役立つのが`引数`です。

上記例でいうと、高さの部分に入れたい数字を()の中に入れてあげます。

1. まず漢字で書くとこうです。

```php
function getTriangleArea(高さ) {
    echo (5 * 高さ / 2);
}
```

1. 漢字のままだとエラーになるので、関数定義の引数は変数に変更します。

```php
function getTriangleArea($hight) {
    echo (5 * $hight / 2);
}
```

※変数名はなんでもいいです。 `$hight`じゃなくて、`$h`とか`$aaaa`とかでも良いです。 ただし、何を表すのかわかりやすいように変数名を書いてください。 今回は三角形の「高さ」なのでhightとしました。

1. 実行するときは、高さを書いて実行してあげてください。

```php
// ↓例えば、下の場合は高さを50にした場合です。
getTriangleArea(10);
```

結果として、`25`という値が表示されます。

![](.gitbook/assets/引数.jpg)

例えば、以下のようにしたらどのような数字が出てくるでしょうか？

```php
function num($num) {
    echo (5 * $num * $num * $num / 2);
}

num(10);
```

こうすると、`$num`の部分は10に置き換わるので、
`5 * 10 * 10 * 10 / 2`という計算がされます。
