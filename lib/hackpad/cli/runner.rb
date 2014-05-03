require "thor"
require "yaml"
require_relative "client"
require_relative "version"

module Hackpad
  module Cli
    class Runner < Thor

      class_option :configdir,
        aliases: "-c",
        default: File.join(ENV["HOME"], ".hackpad-cli/"),
        desc: "Path to the hackpad-cli directory to use."

      class_option :workspace,
        aliases: "-w",
        default: "default",
        desc: "Name of the workspace to use."

      class_option :plain,
        aliases: "-p",
        type: 'boolean',
        default: false,
        desc: "Add this if you don't want colors."

      default_task :help

      desc "search [term]", "Lists available pads matching [term]."
      def search(term)
        Hackpad::Cli::Client.new(options).search term
      end

      desc "list", "Lists available pads."
      def list
        Hackpad::Cli::Client.new(options).list
      end

      desc "info [pad_id]", "gets info for the pad <pad_id>."
      def info(pad)
        Hackpad::Cli::Client.new(options).info pad
      end

      desc "show [pad_id] [format]", "shows pad <pad_id> in format [html,txt,md] (default txt)."
      def show(pad,format='txt')
        Hackpad::Cli::Client.new(options).show pad, format
      end

      desc "version", "Displays the hackpad-cli version."
      def version
        puts Hackpad::Cli::VERSION
      end


      desc "colors", "displays colorize color matrix.", hide: true
      def colors
        require 'colorize'
        String.color_matrix ' xoxo '
      end

    end
  end
end
