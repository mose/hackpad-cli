require 'oauth'
require 'net/http'
require 'json'
require 'cgi'
require 'reverse_markdown'

require_relative 'config'

module Hackpad
  class Client

    def initialize(options)
      @config = Config.load options
      site = URI.parse @config['site']
      consumer = OAuth::Consumer.new(
        @config['client_id'],
        @config['secret'],
        site: @config['site']
      )
      @token = OAuth::AccessToken.new consumer
    end

    # GET /api/1.0/pads/all
    def search(term,start=0)
      res = @token.get "/api/1.0/search?q=#{CGI.escape term}&start=#{start}&limit=100"
      if res.is_a? Net::HTTPSuccess
        all = JSON.parse res.body
        all.each do |a|
          puts "#{a['id'].bold} - #{unescape(a['title']).colorize(:yellow)}\n   #{extract a['snippet']}"
        end

      else
        puts "#{res.inspect}".colorize :red
        puts "#{res.body}".colorize :red
        return back
      end
    end

    def listall
      res = @token.get "/api/1.0/pads/all"
      if res.is_a? Net::HTTPSuccess
        all = JSON.parse res.body
        all.each do |a|
          getinfo(a)
        end
      else
        puts "#{res.inspect}".colorize :red
        puts "#{res.body}".colorize :red
        return back
      end
    end

    def getinfo(pad)
      res = @token.get "/api/1.0/pad/#{pad}/content.txt"
      if res.is_a? Net::HTTPSuccess
        printf "%-20s %s\n", "Id", "#{pad}".bold
        printf "%-20s %s\n", "Title", "#{res.body.lines.first.chomp}".colorize(:yellow)
        printf "%-20s %s\n", "URI", "#{@config['site']}/#{pad}"
        printf "%-20s %s\n", "Size", "#{res.body.length} chars"
      else
        puts "#{pad} failed".colorize :red
      end
      res = @token.get "/api/1.0/pad/#{pad}/options"
      if res.is_a? Net::HTTPSuccess
        a = JSON.parse res.body
        printf "%-20s %s\n", "Guest Policy", "#{a['options']['guestPolicy']}"
        printf "%-20s %s\n", "Moderated", "#{a['options']['isModerated'] || "No"}"
      else
        puts "#{pad} failed".colorize :red
      end
    end

    def show(pad,format)
      ext = (format == 'md') ? 'html' : format
      res = @token.get "/api/1.0/pad/#{pad}/content.#{ext}"
      if res.is_a? Net::HTTPSuccess
        puts "#{@config['site']}/#{pad}"
        puts
        if format == 'md'
          puts ReverseMarkdown.convert(res.body, github_flavored: true)
        else
          puts res.body
        end
      else
        puts "#{pad} failed".colorize :red
      end
    end

  private

    def unescape(s)
      CGI.unescapeHTML s
    end

    def extract(s)
      unescape(s).gsub(/<b class="hit">([^<]*)<\/b>/) { |e| $1.colorize(:cyan).bold }
    end

  end
end
