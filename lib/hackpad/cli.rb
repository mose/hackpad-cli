require "thor"
require "colorize"
require "yaml"
require_relative "client"

module Hackpad

  class Cli < Thor
    include Thor::Actions

    default_task :help

    class_option :configdir,
      aliases: "-c",
      banner: "PATH",
      default: File.join(ENV["HOME"], ".hackpad-cli/"),
      desc: "Path to the hackpad-cli directory to use"

    desc "list", "Lists available pads."
    def list
      Hackpad::Client.new(options[:configdir]).list
    end

    desc "getinfo [pad_id]", "gets info for the pad <pad_id>"
    def getinfo(pad)
      Hackpad::Client.new(options[:configdir]).getinfo pad
    end

    desc "show [pad_id] [format]", "shows pad <pad_id> in format [html,txt,md] (default txt)"
    def show(pad,format='txt')
      Hackpad::Client.new(options[:configdir]).show pad, format
    end

  end

end
