# icinga-nrpe

## Playing around with alerting/monitoring using Icinga and NRPE in a Vagrant environment.

### Setup

* Add the following to your local machine's `/etc/hosts` file:

        192.168.38.10 dev.icinga.loc
        192.168.38.11 dev.icinga-web1.loc
        192.168.38.12 dev.icinga-web2.loc
        192.168.38.13 dev.icinga-web2.loc
        192.168.38.14 dev.icinga-elb.loc

* `vagrant up`
* `vagrant ssh icinga`
* `sudo -s`
* `icingacli setup token create`
* Copy token that is output from above command.
* Hit `http://dev.icinga.loc/setup` in your browser.
* Put token into "Setup Token" text-box on web page and click "Next" button.
* Complete the setup process.
    * Authentication Type: Database
    * Database Resource:
        * Resource Name: `icingaweb_db`
        * Database Type: `MySQL`
        * Host: `localhost`
        * Port: `3306`
        * Database Name: `icingaweb`
        * Username: `icinga`
        * Password: `icinga`
        * Character Set: `utf8`
        * Persistent: No
        * Use SSL: No
    * Authentication Backend:
        * Backend Name: `icingaweb2`
    * Administration:
        * Username: `someusername`
        * Password: `password`
    * Application Configuration:
        * Show Stacktraces: Yes
        * User Preference Storage Type: `Database`
        * Logging Type: `Syslog`
        * Logging Level: `Error`
        * Application Prefix: `icingaweb2`
        * Facility: user
    * Monitoring Backend:
        * Backend Name: `icinga`
        * Backend Type: `IDO`
    * Monitoring IDO Resource:
        * Resource Name: `icinga_ido`
        * Database Type: `MySQL`
        * Host: `localhost`
        * Port: `3306`
        * Database Name: `icinga`
        * Username: `icinga`
        * Password: `icinga`
        * Character Set: `utf8`
        * Persistent: No
        * Use SSL: No
    * Command Transport:
        * Transport Name: `icinga2`
        * Transport Type: `Local Command File`
        * Command File: `/var/run/icinga2/cmd/icinga2.cmd`
    * Monitoring Security:
        * Protected Custom Variables: `*pw*,*pass*,community`
* Login at: `http://dev.icinga.loc/authentication/login`
    * Username: `someusername`
    * Password: `password`

### Credentials/Information

* MySQL root user:
    * Username: `root`
    * Password: `password`
* MySQL Icinga user:
    * Username: `icinga`
    * Password: `icinga`

### Useful links

* [Icinga 2 Getting Started](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/getting-started)
* [Icinga Web 2 Installation](https://github.com/Icinga/icingaweb2/blob/master/doc/02-Installation.md)
* [Icinga 2 Addons](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/chapter/addons#addons)

