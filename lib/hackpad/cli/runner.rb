require 'thor'
require 'yaml'
require_relative 'client'

module Hackpad
  module Cli
    class Runner < Thor

      refresh_option = [
        :refresh, {
          aliases: '-r',
          type:    'boolean',
          default: false,
          desc:    'Add this if you want refresh the cache.'
        }
      ]

      url_option = [
        :urls, {
          aliases: '-u',
          type:    'boolean',
          default: false,
          desc:    'Displays urls rather than pad ids.'
        }
      ]

      class_option :basedir,
        aliases: '-c',
        default: File.join(ENV['HOME'], '.hackpad-cli/'),
        desc:    'Path to the hackpad-cli directory to use.'

      class_option :workspace,
        aliases: '-w',
        default: 'default',
        desc:    'Name of the workspace to use.'

      class_option :plain,
        aliases: '-p',
        type:    'boolean',
        default: false,
        desc:    "Add this if you don't want colors."

      default_task :help

      desc 'workspaces', 'Lists configurated hackpad workspaces.'
      def workspaces
        Hackpad::Cli::Client.new(options).workspaces
      end

      desc 'add', 'Add a new workspace.'
      def add
        Hackpad::Cli::Client.new(options).add
      end

      desc 'default', 'change the default workspace.'
      def default
        Hackpad::Cli::Client.new(options).default
      end

      desc 'stats', 'Lists configuration values.'
      def stats
        Hackpad::Cli::Client.new(options).stats
      end

      desc 'search [term]', 'Lists available pads matching [term] (options: -u to show urls)'
      method_option(*url_option)
      def search(term)
        Hackpad::Cli::Client.new(options).search term
      end

      desc 'list', 'Lists available pads (options: -u to show urls, -r to refresh).'
      method_option(*refresh_option)
      method_option(*url_option)
      def list
        Hackpad::Cli::Client.new(options).list
      end

      desc 'getnew', 'Downloads the new pads the are not cached yet (options: -u to show urls).'
      method_option(*url_option)
      def getnew
        Hackpad::Cli::Client.new(options).getnew
      end

      desc 'info [pad_id]', 'gets info for the pad <pad_id>.'
      def info(pad)
        Hackpad::Cli::Client.new(options).info pad
      end

      desc 'show [pad_id] [format]', 'shows pad <pad_id> in format [html,txt,md], default txt (options: -r to refresh).'
      method_option(*refresh_option)
      def show(pad, format = 'txt')
        Hackpad::Cli::Client.new(options).show pad, format
      end

      desc 'version', 'Displays the hackpad-cli version.'
      def version
        puts File.read(File.expand_path('../../../../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
      end

    end
  end
end
