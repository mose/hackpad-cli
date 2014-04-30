require 'oauth'
require 'net/http'
require 'json'
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
        puts "#{@config['site']}/#{pad} - #{pad} - #{res.body.lines.first.chomp}"
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

  end
end
