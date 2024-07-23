# 🐷【laravel】004\_画面の用意


## 今回やること


- アプリケーションで使用する「Tweet 作成画面」「Tweet 一覧画面」「Tweet 詳細画面」「Tweet 編集画面」のファイルを作成する．
- 各画面へスムーズに移動できるよう，ナビゲーションバーにリンクを追加する．

## ビューファイルの作成

Laravel では，画面を作成する際に Blade テンプレートを使用します。
Blade テンプレートは HTML のタグを書きながらコントローラから受け取ったデータを埋め込むことができます。
htmlとphp足して２で割った感じのものです。
また`@if` や `@foreach` などの制御構文も使用できるため、簡単に条件分岐や繰り返しで表示非表示などを制御できます。

今回は、Bladeテンプレートを作成して`tailwindcss`でスタイリングします。


まずはcms階層で以下のコマンドを順番に実行しましょう。

```bash
$ php artisan make:view tweets.index
$ php artisan make:view tweets.create
$ php artisan make:view tweets.show
$ php artisan make:view tweets.edit
```

上記を実行すると`resources/views`内に`tweets`フォルダが作成されて、以下 4 つのファイルが作成されます。

- Tweet の作成画面 (`tweets/create.blade.php`)
- Tweet の一覧画面 (`tweets/index.blade.php`)
- Tweet の詳細画面 (`tweets/show.blade.php`)
- Tweet の編集画面 (`tweets/edit.blade.php`)

結果、以下のようなファイル構成になりますので、確認しましょう。

```bash
[views]
│
├── dashboard.blade.php
├── layouts
│   ├── app.blade.php
│   ├── guest.blade.php
│   └── navigation.blade.php
├── tweets
│   ├── create.blade.php [← ⭐️NEW⭐️]
│   ├── edit.blade.php　[← ⭐️NEW⭐️]
│   ├── index.blade.php　[← ⭐️NEW⭐️]
│   └── show.blade.php　[← ⭐️NEW⭐️]
└── welcome.blade.php

```

### 各画面へのリンク追加
まず、各画面へ簡単に移動できるようにナビゲーションバーにリンクを追加。
ナビゲーションバーは`layouts/navigation.blade.php`に記述されています。
初期状態では`Dashboard`のリンクが追加されているため、同様の形式で一覧画面と作成画面へのリンクを作成します。
※このファイルでは `PC 画面`と`モバイル画面`で表示する内容を変えているため、それぞれ`2箇所`にリンクのコードを追加する必要があります。


```php
<!-- resources/views/layouts/navigation.blade.php -->

<nav x-data="{ open: false }" class="bg-white dark:bg-gray-800 border-b border-gray-100 dark:border-gray-700">
  <!-- Primary Navigation Menu -->
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between h-16">
      <div class="flex">
        <!-- Logo -->
        <div class="shrink-0 flex items-center">
          <a href="{{ route('dashboard') }}">
            <x-application-logo class="block h-9 w-auto fill-current text-gray-800 dark:text-gray-200" />
          </a>
        </div>

        <!-- Navigation Links -->
        <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
          <x-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
            {{ __('Dashboard') }}
          </x-nav-link>

          <!-- ⭐️ 2項目追加↓↓↓ ⭐️ -->
          <x-nav-link :href="route('tweets.index')" :active="request()->routeIs('tweets.index')">
            {{ __('Tweet一覧') }}
          </x-nav-link>
          <x-nav-link :href="route('tweets.create')" :active="request()->routeIs('tweets.create')">
            {{ __('Tweet作成') }}
          </x-nav-link>
          <!-- ⭐️ 2項目追加↑↑↑↑ ⭐️ -->

        </div>
      </div>

      <!-- Settings Dropdown -->
      <div class="hidden sm:flex sm:items-center sm:ms-6">
        <x-dropdown align="right" width="48">
          <x-slot name="trigger">
            <button class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-gray-500 dark:text-gray-400 bg-white dark:bg-gray-800 hover:text-gray-700 dark:hover:text-gray-300 focus:outline-none transition ease-in-out duration-150">
              <div>{{ Auth::user()->name }}</div>

              <div class="ms-1">
                <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </div>
            </button>
          </x-slot>

          <x-slot name="content">
            <x-dropdown-link :href="route('profile.edit')">
              {{ __('Profile') }}
            </x-dropdown-link>

            <!-- Authentication -->
            <form method="POST" action="{{ route('logout') }}">
              @csrf

              <x-dropdown-link :href="route('logout')" onclick="event.preventDefault();
                                                this.closest('form').submit();">
                {{ __('Log Out') }}
              </x-dropdown-link>
            </form>
          </x-slot>
        </x-dropdown>
      </div>

      <!-- Hamburger -->
      <div class="-me-2 flex items-center sm:hidden">
        <button @click="open = ! open" class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 dark:text-gray-500 hover:text-gray-500 dark:hover:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-900 focus:outline-none focus:bg-gray-100 dark:focus:bg-gray-900 focus:text-gray-500 dark:focus:text-gray-400 transition duration-150 ease-in-out">
          <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
            <path :class="{'hidden': open, 'inline-flex': ! open }" class="inline-flex" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            <path :class="{'hidden': ! open, 'inline-flex': open }" class="hidden" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  </div>

  <!-- Responsive Navigation Menu -->
  <div :class="{'block': open, 'hidden': ! open}" class="hidden sm:hidden">
    <div class="pt-2 pb-3 space-y-1">
      <x-responsive-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
        {{ __('Dashboard') }}
      </x-responsive-nav-link>
      
      <!-- ⭐️ 2項目追加↓↓↓ ⭐️ -->
      <x-responsive-nav-link :href="route('tweets.index')" :active="request()->routeIs('tweets.index')">
        {{ __('Tweet一覧') }}
      </x-responsive-nav-link>
      <x-responsive-nav-link :href="route('tweets.create')" :active="request()->routeIs('tweets.create')">
        {{ __('Tweet作成') }}
      </x-responsive-nav-link>
      <!-- ⭐️ 2項目追加↑↑↑↑ ⭐️ -->

    </div>

    <!-- Responsive Settings Options -->
    <div class="pt-4 pb-1 border-t border-gray-200 dark:border-gray-600">
      <div class="px-4">
        <div class="font-medium text-base text-gray-800 dark:text-gray-200">{{ Auth::user()->name }}</div>
        <div class="font-medium text-sm text-gray-500">{{ Auth::user()->email }}</div>
      </div>

      <div class="mt-3 space-y-1">
        <x-responsive-nav-link :href="route('profile.edit')">
          {{ __('Profile') }}
        </x-responsive-nav-link>

        <!-- Authentication -->
        <form method="POST" action="{{ route('logout') }}">
          @csrf

          <x-responsive-nav-link :href="route('logout')" onclick="event.preventDefault();
                                        this.closest('form').submit();">
            {{ __('Log Out') }}
          </x-responsive-nav-link>
        </form>
      </div>
    </div>
  </div>
</nav>

```


{% hint style="info" %}
bladeの中に記述されている`<x-...>`というタグは、コンポーネントという部品のようなものです。
実体は、`views/components`の中にあります。
例えば`<x-dropdown align="right" width="48">`は、`views/components/dropdown-link.blade.php`に記載があります。
同じような部品はコンポーネントに用意して複数のページで使いまわしましょう。
{% endhint %}

### 動作確認

画面上部にナビゲーションバーが表示されていることを確認する。
※リンク先のファイルは未実装のため動作しない状態で OK
