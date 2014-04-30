Hackpad-Cli
===================

This is a command-line utility to check and manipulate hackpad documents.
It uses Hackpad REST API 1.0 https://hackpad.com/fQD2DRz22Wf

Initially this tool was created to overcome the frustration of the md export of pads, becasue we need to copy them to other places sometimes where proper markdown would be appreciated.

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

    hpcli # will show help
    hpcli get <pad_id> md # will spit out the content in nice markdown


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

