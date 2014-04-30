Hackpad-Cli
===================

This is a command-line utility to check and manipulate hackpad documents.
It uses Hackpad REST API 1.0 https://hackpad.com/fQD2DRz22Wf and was tested with ruby 1.9.3 and 2.1.1.

Initially this tool was created to overcome the frustration of the md export of pads,
because we need to copy them to other places sometimes. Proper markdown would be appreciated.

So for now, it does that, by transforming the html in markdown with the https://github.com/xijo/reverse_markdown gem.

Installation
------------------

    gem install hackpad-cli

or

    git clone https://github.com/mose/hackpad-cli.git
    cd hackpad-cli
    bundle install

Usage
---------------

(use `bundle exec` if you need, mostly in clone mode when not using rvm)

    hpcli                 # will show help
    hpcli list            # gets a list of pads you have access to
    hpcli get <pad_id> md # will spit out the content in nice markdown
    # and you can use alternate config
    hpcli list -w alt

At first launch it will create your config dir (default ~/.hackpad-cli/), and will ask you questions to create the config file (default is .. default.yml). If you pass the `-w whatever` option at the end, it will ask questions again to write whatever.yml config file.


Roadmap and todoz
---------------------

Check the [Changelog](CHANGELOG.md) for past evolutions.

* cache the pads list in a local storage
* refresh cache according to last cached date
* add commands for creating a new pad, linked to $EDITOR
* add admin commands for managing users
* nag hackpad for they add REST endpoints to query collections
* write proper tests
* add freaking cool badges on the readme
* add a gateway to github so a pad could be copied over a wiki page directly or in a repo somehow
* implement pretty much all what the hackpad API v1 offers

Contributing
------------------

1. Fork it ( http://github.com/<my-github-username>/hackpad-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright
----------

(c) Copy is right, 2014 - mose - this code is distributed under MIT license

