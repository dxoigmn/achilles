Achilles
========

Achilles is a web-based Nessus client with the added ability to prioritize vulnerabilities by severity. Achilles was built because we needed the ability to prioritize vulnerabilities by location. For example, a vulnerability found on a host in the administrative network might be prioritized much higher than a vulnerability found on a host in the residential network. Achilles allows you to customize this prioritization via several techniques.

In Achilles, a vulnerability inherits almost all of its characteristics from a Nessus plugin. For example, if you were to modify a plugin's severity at a specific location it will be reflected in all vulnerabilities associated with that plugin. However, depending on your setup Nessus could be utilizing several thousand plugins at any given time. It would be a time consuming task to modify the severity in every location for all plugins. Thus, Achilles abstracts this to what we call the severity matrix. The severity matrix is simply a mapping from plugin classifications and location to a severity.

The ability to classify plugins is also a unique ability of Achilles. Because every Nessus plugin must specify a risk and family, Achilles allows you to map these to classifications. For example, a plugin that specifies a "high" risk and as a "backdoor" family you might classify as "compromised." This mapping is entirely your choice and should be chosen carefully.

In general, vulnerability severities are inherited in the following order:

  1. A severity specified on the vulnerability itself
  2. A severity specified on the vulnerability's plugin
  3. A severity specified on the severities matrix.

A minimal Achilles installation should specify locations, plugin classifications, and the severity matrix. Achilles will run with these being empty, but will be unable to prioritize vulnerabilities.

Installation
------------

Installing Achilles is similar to any other Rails-based application. You can play around with Achilles locally using a sqlite3 database but is recommended to use MySQL in production.

To play around with Achilles you must first edit the `config/config.yml` file. There are several things you will want to change:

  1. The nmap executable path, `nmap_path`.
  2. Where results from nmap should be stored, `nmap_results_path`.
  4. The nessus executable path, `nessus_path`.
  5. Where nessus results should be stored, `nessus_results_path` and `nessus_plugins_path`.

You might also want to change the secret that Rails uses to encrypt session cookies:

    rake secret

The following commands will create, migrate, and populate the a SQLite3 database and start the HTTP server:

    rake db:schema:load
    rake db:populate
    ./script/server

Once the server is running, you can open your web browser to <http://0.0.0.0:3000>.

Scheduling Nessus Scans
-----------------------

Achilles can schedule nessus scans. In order for this to work, it is advisable to setup a cronjob that executes the following:

    ./script/runner Scan.run!

This will run exactly 1 scan.

Dependencies
------------

Achilles has been developed on Rails 2.0.2. It is recommended you run Achilles on this version as future version might not be backwards compatible.

Achilles is also dependent on the follow ruby gems:

  * chronic
  * netaddr
  * haml
  * libxml-ruby


The following command should install the gem dependencies:

    rake gems:install

License
-------

Copyright (c) 2007-2008, The Trustees of Dartmouth College.

Achilles is released as open source under a BSD license. See LICENSE for details.

The several plugins (`./vendor/plugins/`) included in Achilles are copyright their respective authors.
