require "thor"
require "colorize"
require "yaml"
require_relative "config"

module Hackpad

  class Cli < Thor
    include Thor::Actions

    default_task :help

    class_option :configdir,
      aliases: "-c",
      banner: "PATH",
      default: File.join(ENV["HOME"], ".hackpad-cli/"),
      desc: "Path to the hackpad-cli directory to use"


    desc "collections", "Lists available collections."
    def collections
      config = Hackpad::Config.load options[:configdir]
    end

    desc "list [collection]", "Lists available pads (in collection if collection argument is provided)."
    def list
      config = Hackpad::Config.load options[:configdir]
      puts config.inspect.colorize(:blue)
    end

  end

end
