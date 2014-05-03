require 'reverse_markdown'
require 'colorize'

require_relative 'config'
require_relative 'requester'
require_relative '../pad'

module Hackpad
  module Cli
    class Client

      def initialize(options)
        @config = Config.load options
        @requester = Requester.new @config
        if options[:plain]
          load File.expand_path('../plain_colors.rb', __FILE__)
        end
      end

      # GET /api/1.0/pads/all
      def search(term,start=0)
        payload = @requester.search(term,start)
        payload.each do |a|
          puts "#{a['id'].bold} - #{unescape(a['title']).yellow}\n   #{extract a['snippet']}"
        end
      end

      def list
        all = @requester.list
        all.each do |id|
          puts "#{@config['site']}/#{id} - #{@requester.title id}"
        end
      end

      def info(id)
        padinfo = @requester.show id, 'txt'
        padoptions = @requester.options id
        puts padoptions.inspect if ENV['DEBUG']
        pad = Pad.new id, padinfo, padoptions['options']
        table "Id", "#{id}".bold
        table "Title", "#{pad.title}".yellow
        table "URI", "#{@config['site']}/#{id}"
        table "Chars", "#{pad.chars}"
        table "Lines", "#{pad.lines}"
        table "Guest Policy", "#{pad.guest_policy}"
        table "Moderated", "#{pad.moderated}"
      end

      def show(id,format)
        ext = (format == 'md') ? 'html' : format
        payload = @requester.show id, ext
        if format == 'md'
          puts ReverseMarkdown.convert(payload, github_flavored: true)
        else
          puts payload
        end
      end

    private

      def unescape(s)
        CGI.unescapeHTML s
      end

      def extract(s)
        unescape(s).gsub(/<b class="hit">([^<]*)<\/b>/) { |e| $1.cyan.bold }
      end

      def table(key,value)
        printf "%-20s %s\n", key, value
      end

    end
  end
end
