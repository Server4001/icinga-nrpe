# icinga-nrpe

## Playing around with alerting/monitoring using Icinga and NRPE in a Vagrant environment.

### Setup

* `vagrant up`
* `vagrant ssh icinga`
* `sudo -s`
* Run: `icingacli setup token create`
* Copy token that is output from above command.
* Hit `http://dev.icinga.loc/setup` in your browser.
* Put token into text-box on web page.

### Credentials/Information

* MySQL root user:
    * Username: `root`
    * Password: `password`
* MySQL Icinga user:
    * Username: `icinga`
    * Password: `icinga`
* MySQL Icinga database:
    * Name: `icinga`
    * Character set: `utf8`
* MySQL Icinga Web database:
    * Name: `icingaweb`
    * Character set: `utf8`

### TODO

* Finish settings up Icinga Web 2.
* Install NRPE.
* Add monitoring plugins on web servers.

### Useful links

* [Icinga 2 Getting Started](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/getting-started)
* [Icinga Web 2 Installation](https://github.com/Icinga/icingaweb2/blob/master/doc/02-Installation.md)
* [Icinga 2 Addons](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/chapter/addons#addons)

