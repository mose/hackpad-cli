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

      def initialize(options, output = STDOUT)
        @output = output
        @options = options
        Store.prepare @options
        @config = Config.load @options
        Api.prepare @config
        if @options[:plain]
          load File.expand_path('../plain_colors.rb', __FILE__)
        end
      end

      def stats
        table 'Site', @config['site'].blue
        table 'Cached Pads', Store.count_pads
        table 'Last Refresh', Store.last_refresh || 'not refreshed yet'
      end

      def search(term, start = 0)
        payload = Api.search(term, start)
        payload.each do |a|
          @output.puts "#{id_or_url a['id']} - #{unescape(a['title']).yellow}"
          @output.puts "   #{extract a['snippet']}"
        end
      end

      def list
        @output.puts Padlist.get_list(@options['refresh']).map { |pad|
          padline pad
        }
      end

      def check
        @output.puts 'New pads:'
        padlist = Padlist.check_list(@options['refresh']).map
        if padlist.count == 0
          @output.puts 'There is no new pad.'
        else
          @output.puts padlist.map { |pad|
            padline pad
          }
        end
      end

      def info(id)
        pad = Pad.new id
        pad.load 'txt'
        table 'Id', "#{id}".bold
        table 'Title', "#{pad.title}".yellow
        table 'URI', "#{@config['site']}/#{id}"
        table 'Chars', "#{pad.chars}"
        table 'Lines', "#{pad.lines}"
        table 'Guest Policy', "#{pad.guest_policy}"
        table 'Moderated', "#{pad.moderated}"
        table 'Cached', "#{pad.cached_at || 'unknown'}"
      end

      def show(id, format)
        ext = (format == 'md') ? 'html' : format
        pad = Pad.new id
        pad.load ext
        if format == 'md'
          @output.puts ReverseMarkdown.convert(pad.content, github_flavored: true)
        else
          @output.puts pad.content
        end
      end

      private

      def padline(pad)
        "#{(@config['site'] + '/') if @options[:urls]}#{pad.id} - #{pad.title}"
      end

      def unescape(s)
        CGI.unescapeHTML s
      end

      def extract(s)
        unescape(s).gsub(/<b class="hit">([^<]*)<\/b>/) { Regexp.last_match[1].cyan.bold }
      end

      def table(key, value)
        @output.printf "%-20s %s\n", key, value
      end

      def id_or_url(id)
        "#{(@config['site'] + '/') if @options[:urls]}#{id.bold}"
      end

    end
  end
end
