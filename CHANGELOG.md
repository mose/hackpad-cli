Hackpad-cli changelog
=====================

v0.1.1 - wip
-------------------

- add a command `sites` to list workspaces
- move config file from ~/.hackpad-cli/default.yml to ~/.hackpad-cli/default/config.ymlz

v0.1.0 - 2014-05-17
-------------------

- add a `stats` command to show how much pads are cached, and when it was last refreshed
- move `-r` (refresh) and `-u` (urls) options to specific method options
- add a User-Agent so that hackpad knows what is poking them
- completed test coverage
- prevent trailing slash on site config param to fuck up urls
- useless but satisfying rubocop green flag

v0.0.7 - 2014-05-15
-------------------

- add a `cached_at` value in metadata, visible in the `show` command
- fix `info` to display guest policy properly
- add a `check` command to check if there are new pads and decide to refresh or not
- whole lot of more tests

v0.0.6 - 2014-05-04
-------------------

- fix compat with 1.9.3 (require ostruct)

v0.0.5 - 2014-05-04
-------------------

- add a dot-timer for when padlist refreshes so one knows that something is happening
- add an option `-u` to display urls rather than pad id
- add an option `-r` to force the refresh of the cache
- add storage of cache for pad and pad lists
- add some tests
- add a flag for removing colors `-p`

v0.0.4 - 2014-05-01
-------------------

- add options in pad info for `hpcli info [pad_id]`
- implement a search command `hpcli search [term]`

v0.0.3 - 2014-05-01
-------------------

- add a better way to manage alternative configuration file
- fix alternate config dir setup
- verify compat with ruby 1.9.3
- better readme

v0.0.2 - 2014-05-01
-------------------

- damn, forgot to remove awesome_print. huhu

v0.0.1 - 2014-05-01
-------------------

- initial release of a draft
