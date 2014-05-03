require 'oauth'
require 'net/http'
require 'json'

module Hackpad
  module Cli

    class ApiException < StandardError
    end

    class Requester

      def initialize(config)
        site = URI.parse config['site']
        consumer = OAuth::Consumer.new(
          config['client_id'],
          config['secret'],
          site: config['site']
        )
        @token = OAuth::AccessToken.new consumer
      end

      def search(term, start=0)
        get "/api/1.0/search?q=#{CGI.escape term}&start=#{start}&limit=100"
      end

      def list
        get "/api/1.0/pads/all"
      end

      def title(id)
        show(id, 'txt').lines.first
      end

      def options(id)
        get "/api/1.0/pad/#{id}/options"
      end

      def show(id, ext)
        get "/api/1.0/pad/#{id}/content.#{ext}", false
      end

      def get(url, json=true)
        res = @token.get url
        if res.is_a? Net::HTTPSuccess
          puts res.body.inspect if ENV['DEBUG']
          if json
            JSON.parse res.body
          else
            res.body
          end
        else
          raise ApiException, "HTTP error, code #{res.code}"
        end
      end

    end
  end
end
