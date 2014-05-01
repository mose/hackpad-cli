require "thor"
require "colorize"
require "yaml"
require_relative "client"

module Hackpad

  class Cli < Thor

    class_option :configdir,
      aliases: "-c",
      default: File.join(ENV["HOME"], ".hackpad-cli/"),
      desc: "Path to the hackpad-cli directory to use."

    class_option :workspace,
      aliases: "-w",
      default: "default",
      desc: "Name of the workspace to use."

    default_task :help

    desc "search [term]", "Lists available pads matching [term]."
    def search(term)
      Hackpad::Client.new(options).search term
    end

    desc "list", "Lists available pads."
    def list
      Hackpad::Client.new(options).listall
    end

    desc "getinfo [pad_id]", "gets info for the pad <pad_id>."
    def info(pad)
      Hackpad::Client.new(options).getinfo pad
    end

    desc "show [pad_id] [format]", "shows pad <pad_id> in format [html,txt,md] (default txt)."
    def show(pad,format='txt')
      Hackpad::Client.new(options).show pad, format
    end

  end

end
