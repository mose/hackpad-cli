Hackpad-Cli
===================

[![Gem Version](https://badge.fury.io/rb/hackpad-cli.png)](http://rubygems.org/gems/hackpad-cli)
[![Build Status](https://travis-ci.org/mose/hackpad-cli.png?branch=master)](https://travis-ci.org/mose/hackpad-cli)
[![Coverage Status](https://coveralls.io/repos/mose/hackpad-cli/badge.png)](https://coveralls.io/r/mose/hackpad-cli)
[![Dependency Status](https://gemnasium.com/mose/hackpad-cli.svg)](https://gemnasium.com/mose/hackpad-cli)
[![Code Climate](https://codeclimate.com/github/mose/hackpad-cli.png)](https://codeclimate.com/github/mose/hackpad-cli)

----

This is a command-line utility to check and manipulate hackpad documents.
It uses Hackpad REST API 1.0 https://hackpad.com/fQD2DRz22Wf and was tested with ruby 1.9.3 and 2.1.1.

Initially this tool was created to overcome the frustration of the md export of pads,
because we need to copy them to other places sometimes. Proper markdown would be appreciated. It does that by transforming the html in markdown with the https://github.com/xijo/reverse_markdown gem.

Offline hackpad reading
-----------------------

It felt right to cache the pads content and list because then we can browse and search in the whole workspace very fast. So by default the `list`, `show` and `info` are cached unless you pass the `-r` option at the end of the commandline. Note that the longest is the `list` because the API don't provide pads titles, so `hpcli list` actually downloads the whole list of the pads in txt format. But it makes the `info` and the `show` very fast after that.

The side effect is that it provides the ability to just refresh the list of pads with `hpcli list`, and it will cache the text version of each pad locally. Then you can `hpcli show <xxx>` without hitting the api.

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

```
Commands:
  hpcli check                   # Checks differences between local cache and remote list.
  hpcli help [COMMAND]          # Describe available commands or one specific command
  hpcli info [pad_id]           # gets info for the pad <pad_id>.
  hpcli list                    # Lists available pads.
  hpcli search [term]           # Lists available pads matching [term].
  hpcli show [pad_id] [format]  # shows pad <pad_id> in format [html,txt,md] (default txt).
  hpcli version                 # Displays the hackpad-cli version.

Options:
  -c, [--configdir=CONFIGDIR]      # Path to the hackpad-cli directory to use.
                                   # Default: /home/mose/.hackpad-cli/
  -w, [--workspace=WORKSPACE]      # Name of the workspace to use.
                                   # Default: default
  -r, [--refresh], [--no-refresh]  # Add this if you want refresh the cache.
  -u, [--urls], [--no-urls]        # Displays urls rather than pad ids.
  -p, [--plain], [--no-plain]      # Add this if you don't want colors.
```

At first launch it will create your config dir (default ~/.hackpad-cli/), and will ask you questions to create the config file (default is .. default.yml). If you pass the `-w whatever` option at the end, it will ask questions again to write whatever.yml config file.


Roadmap and todoz
---------------------

Check the [Changelog](CHANGELOG.md) for past evolutions.

- for v0.1.0
  - <s>add freaking cool badges on the readme</s>
  - <s>cache the pads list in a local storage</s>
  - <s>have a choice to refresh cache</s>
  - display cached date in output
  - write proper tests
- for v0.2.0
  - add commands for creating a new pad, linked to $EDITOR
  - add a gateway to github so a pad could be copied over a wiki page directly or in a repo somehow
- for v0.3.0
  - add admin commands for managing users
  - implement pretty much all what the hackpad API v1 offers
  - nag hackpad for they add REST endpoints to query collections

Contributing
------------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright
----------

(c) Copy is right, 2014 - mose - this code is distributed under MIT license

