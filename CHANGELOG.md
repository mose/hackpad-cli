Hackpad-cli changelog
=====================

v0.1.4 - wip
-------------------
- update dependencies with new version of reverse_markdown

v0.1.3 - 2015-07-24
-------------------
- fix a 500 case in get api calls
- add command `add` for adding a new workspace
- refactor config management and move code to the configstruct gem

v0.1.2 - 2014-05-27
-------------------
- improve markdown cleanup:
  - transform isolated bold in h3
  - remove parasite lines in list that are left by non-displayed comments
- add a visual indication of currently used workspace in the `workspaces` command

v0.1.1 - 2014-05-25
-------------------
- add a `default` command to switch workspaces
- renamed `check` into `getnew` to make it clearer what it does
- switch from colorize to paint gems (monkey patch of colorize was itchy)
- switch the prompt code to another gem called cliprompt
- add a command `workspaces` to list workspaces
- move config file from ~/.hackpad-cli/default.yml to ~/.hackpad-cli/default/config.yml

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
