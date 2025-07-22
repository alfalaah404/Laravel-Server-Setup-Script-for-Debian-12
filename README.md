# Laravel Server Setup Script for Debian 12

This repository contains a Bash script to automatically configure a **production-ready** Laravel server stack on **Debian 12** with the following components:

- Apache 2
- PHP 8.3 (only required Laravel modules)
- Composer (latest version)
- PostgreSQL + pgAdmin 4 (web interface)
- Laravel-ready file permissions

---

## 🛠️ Stack Components

| Component   | Description                     |
|------------|---------------------------------|
| Apache 2   | Web server with `mod_rewrite` enabled |
| PHP 8.3    | With essential Laravel modules only |
| Composer   | PHP dependency manager          |
| PostgreSQL | Relational database system      |
| pgAdmin 4  | Web-based DB admin for PostgreSQL |

---

## 📦 Requirements

- Debian 12 (Bookworm)
- Root access (no `sudo` required)
- Internet connection

---

## 📄 Installation

1. **Clone this repository**:

   ```bash
   git clone https://github.com/alfalaah404/Laravel-Server-Setup-Script-for-Debian-12.git
   cd laravel-server-setup
   ```

2. **Make the script executable**:

   ```bash
   chmod +x setup-laravel-server.sh
   ```

3. **Run the script as root**:

   ```bash
   ./setup-laravel-server.sh
   ```

---

## 📁 Laravel Project Deployment (Manual Step)

After running the script:

1. Clone your Laravel project to `/var/www/laravel`:
   ```bash
   git clone https://github.com/your-org/your-laravel-project.git /var/www/laravel
   ```

2. Set permissions:
   ```bash
   chown -R www-data:www-data /var/www/laravel
   chmod -R 755 /var/www/laravel
   ```

3. Create an Apache virtual host config:

   ```apache
   <VirtualHost *:80>
       ServerName yourdomain.com
       DocumentRoot /var/www/laravel/public

       <Directory /var/www/laravel/public>
           AllowOverride All
           Require all granted
       </Directory>

       ErrorLog ${APACHE_LOG_DIR}/laravel_error.log
       CustomLog ${APACHE_LOG_DIR}/laravel_access.log combined
   </VirtualHost>
   ```

   Enable the site:
   ```bash
   a2ensite laravel
   systemctl reload apache2
   ```

---

## 🔐 pgAdmin 4 Login

After installation, access **pgAdmin** via `http://your-server-ip/pgadmin4`  
Credentials you can specify when running the script.

---

## ⚙️ PHP Settings Tuned for Production

- `memory_limit = 512M`
- `upload_max_filesize = 64M`
- `post_max_size = 64M`

---

## 🧼 What the Script Does **Not** Do

- It does **not** create or initialize Laravel projects.
- It does **not** create PostgreSQL databases or users.
- It does **not** install unnecessary PHP modules (only Laravel-needed ones).

---

## 📜 License

MIT License © 2025 - Ahmad Fajrul Falaah
