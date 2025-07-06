<?php
$CONFIG = array(
  // Maintenance window configuration - starts at 2 AM UTC
  'maintenance_window_start' => 2,
  
  // Security settings
  'trusted_domains' => array(
    0 => getenv('DOMAIN') ?: 'localhost',
  ),
  
  // Force HTTPS
  'overwriteprotocol' => 'https',
  'overwritehost' => getenv('DOMAIN') ?: 'localhost',
  'overwrite.cli.url' => 'https://' . (getenv('DOMAIN') ?: 'localhost'),
  
  // Trusted proxies for reverse proxy setup
  'trusted_proxies' => array(
    0 => '172.16.0.0/12',
    1 => '172.17.0.0/16',
    2 => '172.18.0.0/16',
    3 => '172.19.0.0/16',
    4 => '172.20.0.0/16',
    5 => '172.21.0.0/16',
    6 => '172.22.0.0/16',
    7 => '172.23.0.0/16',
    8 => '172.24.0.0/16',
    9 => '172.25.0.0/16',
    10 => '172.26.0.0/16',
    11 => '172.27.0.0/16',
    12 => '172.28.0.0/16',
    13 => '172.29.0.0/16',
    14 => '172.30.0.0/16',
    15 => '172.31.0.0/16',
  ),
  
  // Redis configuration for caching and session storage
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => array(
    'host' => 'redis',
    'port' => 6379,
    'password' => getenv('REDIS_PASSWORD') ?: 'redis_secure_password',
    'timeout' => 0.0,
  ),
  
  // Database configuration optimizations
  'dbtype' => 'mysql',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  
  // Performance optimizations
  'default_phone_region' => 'BD',
  'uploadbuffer_size' => 16777216, // 16MB
  'max_chunk_size' => 1073741824, // 1GB
  'filesystem_check_changes' => 0,
  'part_file_in_storage' => false,
  
  // Security headers
  'htaccess.RewriteBase' => '/',
  'htaccess.IgnoreFrontController' => false,
  
  // Background jobs
  'backgroundjobs_mode' => 'cron',
  'cron_log' => true,
  'log_rotate_size' => 104857600, // 100MB
  
  // File locking
  'filelocking.enabled' => true,
  'filelocking.ttl' => 3600,
  
  // App settings
  'app_install_overwrite' => array(
    'richdocuments',
    'onlyoffice',
  ),
  
  // Email settings (configure for your SMTP server)
  'mail_smtpmode' => 'smtp',
  'mail_smtpsecure' => 'tls',
  'mail_smtpauth' => true,
  'mail_smtphost' => 'smtp.gmail.com',
  'mail_smtpport' => 587,
  'mail_smtpname' => getenv('SMTP_USERNAME'),
  'mail_smtppassword' => getenv('SMTP_PASSWORD'),
  'mail_from_address' => 'nextcloud',
  'mail_domain' => getenv('DOMAIN') ?: 'localhost',
  
  // Logging
  'log_type' => 'file',
  'logfile' => 'nextcloud.log',
  'loglevel' => 2, // 0=Debug, 1=Info, 2=Warning, 3=Error, 4=Fatal
  
  // Security
  'auth.bruteforce.protection.enabled' => true,
  'trashbin_retention_obligation' => 'auto, 30',
  'versions_retention_obligation' => 'auto, 365',
  
  // Preview settings
  'preview_max_x' => 2048,
  'preview_max_y' => 2048,
  'preview_max_filesize_image' => 50,
  'preview_max_memory' => 128,
  
  // Maintenance mode
  'maintenance' => false,
);
