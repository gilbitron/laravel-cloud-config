# Laravel cloud-config

A cloud-config file for local Laravel development. Designed to be used with [Ubuntu Multipass](https://multipass.run). The config sets up a `laravel.test` site with:

* Nginx
* PHP 7.4
* MySQL
* Redis
* Composer
* Cron

## Usage

Download the [cloud-config.yml](cloud-config.yml) file. Then, launch a Multipass VM using the cloud-config file:

```
curl -O https://raw.githubusercontent.com/gilbitron/laravel-cloud-config/master/cloud-config.yml
multipass launch 18.04 --name laravel --cloud-init cloud-config.yml
```

Next, mount your Laravel project to the VM:

```
multipass mount /path/to/laravel laravel:/sites/laravel.test/files
```

Finally, use `multipass info laravel` to find the VM IP and add it to your `/etc/hosts` file to point `laravel.test` to your VM.

```
192.168.64.2 laravel.test
```

## Database

The default MySQL database is:

* Database: `laravel`
* Username: `laravel`
* Password: `secret`

## Credits

Laravel cloud-config was created by [Gilbert Pellegrom](https://gilbitron.me) from [Dev7studios](https://dev7studios.co). Released under the MIT license.
