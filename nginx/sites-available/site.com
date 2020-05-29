server {
	# Ports to listen on, uncomment one.
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	# Server name to listen for
	server_name site.com;

	# Path to document root
	root /sites/site.com/files/public;

	# Paths to certificate files.
	ssl_certificate /etc/letsencrypt/live/site.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/site.com/privkey.pem;

	# File to be used as index
	index index.php;

	# Overrides logs defined in nginx.conf, allows per site logs.
	access_log /sites/site.com/logs/access.log;
	error_log /sites/site.com/logs/error.log;

	# Default server block rules
	include global/server/defaults.conf;

	# SSL rules
	include global/server/ssl.conf;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ \.php$ {
		try_files $uri =404;
		include global/fastcgi-params.conf;

		# Use the php pool defined in the upstream variable.
		# See global/php-pool.conf for definition.
		fastcgi_pass   $upstream;
	}
}

# Redirect http to https
server {
	listen 80;
	listen [::]:80;
	server_name site.com www.site.com;

	return 301 https://site.com$request_uri;
}

# Redirect www to non-www
server {
	listen 443;
	listen [::]:443;
	server_name www.site.com;

	return 301 https://site.com$request_uri;
}
