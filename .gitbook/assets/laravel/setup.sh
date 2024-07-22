#!/bin/sh

echo "\n 001.setup.shを利用するためにexpectのインストールを開始します\n"
sudo yum install -y expect

echo  "\n 002.Apache, MariaDBの起動しました\n "
sudo systemctl start mariadb

echo  "\n 003.MariaDBの初期設定を自動で行なっています\n "

expect -c '
    set timeout 10;
    spawn sudo mysql_secure_installation
    expect "Enter current password for root (enter for none):";
    send "\n";
    expect "Switch to unix_socket authentication";
    send "y\n";
    expect "Set root password?";
    send "y\n";
    expect "New password:";
    send "root\n";
    expect "Re-enter new password:";
    send "root\n";
    expect "Remove anonymous users?";
    send "y\n";
    expect "Disallow root login remotely?";
    send "y\n";
    expect "Remove test database and access to it?";
    send "y\n";
    expect "Reload privilege tables now?";
    send "y\n";
    interact;'


echo  "\n 004.MaridaDBの自動起動を有効化しました\n "
sudo systemctl enable mariadb
sudo systemctl is-enabled mariadb

echo  "\n 005. Composerインストール（バージョン指定）しました\n "
curl -sS https://getcomposer.org/installer | php

echo  "\n 006. Composerのパスを通しました\n "
sudo mv composer.phar /usr/bin/composer

echo  "\n 007. Composerインストールできたかチェックしました\n "
composer

echo  "\n 008. Laravelプロジェクトをバージョン10指定で作成します\n "
composer create-project "laravel/laravel=10.*" cms

echo  "\n 009. コンポーザーをアップデートしました\n "
yes | sudo composer update

echo  "\n 010. phpMyAdminを作成する為にディレクトリ移動\n "
cd cms

echo  "\n 011. phpMyAdminを作成する為にディレクトリ移動\n "
cd public

echo  "\n 012. phpMyAdminをダウンロード\n "
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.2/phpMyAdmin-5.1.2-all-languages.zip

echo  "\n 013. phpMyAdminを解凍\n "
unzip phpMyAdmin-5.1.2-all-languages.zip

echo  "\n 014. phpMyAdminのファイル名変更\n "
mv phpMyAdmin-5.1.2-all-languages phpMyAdmin

echo  "\n 015. cms階層に戻る\n "
cd ..

echo  "\n 016. 親階層に戻る\n "
cd ..

echo  "\n 017. セットアップファイルの削除\n "
rm setup.sh
