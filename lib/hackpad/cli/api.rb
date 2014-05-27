require 'oauth'
require 'net/http'
require 'json'
require 'reverse_markdown'

module Hackpad
  module Cli

    class ApiException < StandardError
    end

    module Api
      module_function

      def prepare(config)
        consumer = OAuth::Consumer.new(
          config.client_id,
          config.secret,
          site: config.site
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
        realext = (ext == 'md') ? 'html' : ext
        get "/api/1.0/pad/#{id}/content.#{realext}", false, (ext == 'md')
      end

      def get(url, json = true, to_md = false)
        res = @token.get url, 'User-Agent' => "hackpad-cli v#{Hackpad::Cli::VERSION}"
        if res.is_a? Net::HTTPSuccess
          if json
            JSON.parse(res.body)
          else
            if to_md
              cleanup_md(res.body)
            else
              res.body
            end
          end
        else
          fail ApiException, "HTTP error, code #{res.code}"
        end
      end

      def cleanup_md(text)
        back = ReverseMarkdown.convert(text, github_flavored: true).strip
        back.sub!(/<head>.*<\/head>\n/m, '')
        back.gsub!(/-([^\n]+)\n\n  -/m, "-\\1\n  -")
        back.gsub!(/\n(  )*-([^\n]+)\n?\n(  )*-([^\n]+)\n?\n/m, "\n\\1-\\2\n\\3-\\4\n")
        back.gsub(/\n\n\*\*([^\*]+)\*\*\n\n/, "\n\n### \\1\n\n")
      end

    end
  end
end
