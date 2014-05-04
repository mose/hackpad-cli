require 'reverse_markdown'
require 'colorize'

require_relative 'config'
require_relative 'api'
require_relative 'store'
require_relative 'pad'
require_relative 'padlist'

module Hackpad
  module Cli
    class Client

      def initialize(options)
        @options = options
        Store.prepare @options
        @config = Config.load @options
        Api.prepare @config
        if @options[:plain]
          load File.expand_path('../plain_colors.rb', __FILE__)
        end
      end

      # GET /api/1.0/pads/all
      def search(term,start=0)
        payload = Api.search(term,start)
        payload.each do |a|
          puts "#{(@config['site'] + '/') if @options['urls']}#{a['id'].bold} - #{unescape(a['title']).yellow}"
          puts "   #{extract a['snippet']}"
        end
      end

      def list
        padlist = Padlist.new @options['refresh']
        puts padlist.all.map { |pad|
          "#{(@config['site'] + '/') if @options['urls']}#{pad.id} - #{pad.title}"
        }
      end

      def info(id)
        pad = Pad.new id
        pad.load 'txt'
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
        pad = Pad.new id
        pad.load ext
        if format == 'md'
          puts ReverseMarkdown.convert(pad.content, github_flavored: true)
        else
          puts pad.content
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
