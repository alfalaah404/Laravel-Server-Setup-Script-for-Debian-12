#!/bin/bash
set -e

echo "=== Update dan install dependensi dasar ==="
apt update && apt upgrade -y
apt install -y curl wget gnupg2 lsb-release ca-certificates apt-transport-https software-properties-common unzip

echo "=== Tambahkan repositori PHP 8.3 ==="
wget -qO /etc/apt/trusted.gpg.d/sury.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt update

echo "=== Install Apache ==="
apt install -y apache2
a2enmod rewrite
systemctl enable apache2
systemctl start apache2

echo "=== Install PHP 8.3 dan ekstensi yang dibutuhkan Laravel ==="
apt install -y php8.3 php8.3-cli php8.3-common php8.3-mbstring php8.3-xml php8.3-curl php8.3-pgsql php8.3-bcmath php8.3-tokenizer php8.3-mysql php8.3-zip php8.3-gd php8.3-readline libapache2-mod-php8.3

echo "=== Konfigurasi PHP Apache (php.ini) ==="
PHPINI="/etc/php/8.3/apache2/php.ini"
sed -i 's/^memory_limit = .*/memory_limit = 512M/' $PHPINI
sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 64M/' $PHPINI
sed -i 's/^post_max_size = .*/post_max_size = 64M/' $PHPINI

echo "=== Restart Apache ==="
systemctl restart apache2

echo "=== Install Composer ==="
export COMPOSER_ALLOW_SUPERUSER=1
cd /tmp
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH_EXPECTED="$(curl -s https://composer.github.io/installer.sig)"
HASH_ACTUAL="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$HASH_EXPECTED" != "$HASH_ACTUAL" ]; then
  echo "❌ ERROR: Invalid Composer installer hash"
  exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php
composer --version

echo "=== Install PostgreSQL ==="
apt install -y postgresql postgresql-contrib
systemctl enable postgresql
systemctl start postgresql

echo "=== Install pgAdmin 4 (Web version) ==="
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/pgadmin.gpg
sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
apt update
apt install -y pgadmin4-web

echo "=== Konfigurasi pgAdmin 4 ==="
/usr/pgadmin4/bin/setup-web.sh --yes
systemctl enable apache2

echo "=== Permissions direktori Laravel (jika nanti di-clone) ==="
mkdir -p /var/www/laravel
chown -R www-data:www-data /var/www/laravel
chmod -R 755 /var/www/laravel

echo "=== SETUP SELESAI ==="
echo "Silakan clone project Laravel ke /var/www/laravel dan sesuaikan konfigurasi VirtualHost Apache-nya."
