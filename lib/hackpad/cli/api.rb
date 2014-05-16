require 'oauth'
require 'net/http'
require 'json'

module Hackpad
  module Cli

    class ApiException < StandardError
    end

    module Api
      module_function

      def prepare(config)
        consumer = OAuth::Consumer.new(
          config['client_id'],
          config['secret'],
          site: config['site']
        )
        @token = OAuth::AccessToken.new consumer
      end

      def search(term, start = 0)
        get "/api/1.0/search?q=#{CGI.escape term}&start=#{start}&limit=100"
      end

      def list
        get '/api/1.0/pads/all'
      end

      def read_options(id)
        get "/api/1.0/pad/#{id}/options"
      end

      def read(id, ext)
        get "/api/1.0/pad/#{id}/content.#{ext}", false
      end

      def get(url, json = true)
        res = @token.get url, 'User-Agent' => "hackpad-cli v#{Hackpad::Cli::VERSION}"
        if res.is_a? Net::HTTPSuccess
          json ? JSON.parse(res.body) : res.body
        else
          fail ApiException, "HTTP error, code #{res.code}"
        end
      end

    end
  end
end
