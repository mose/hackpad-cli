require 'oauth'
require 'net/http'
require 'json'
require 'reverse_markdown'

require_relative '../../reverse_markdown/converters/head'

module Hackpad
  module Cli

    class ApiException < StandardError
    end

    module Api
      module_function

      def prepare(workspace)
        @hackpad ||= OAuth::Consumer.new(workspace.client_id, workspace.secret, site: workspace.site)
        @version = File.read(File.expand_path('../../../../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
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
        get "/api/1.0/pad/#{id}/content/latest.#{realext}", false, (ext == 'md')
      end

      def get(url, json = true, to_md = false)
        res = @hackpad.request :get, url
        if res.is_a? Net::HTTPOK
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
        back.gsub!(/\n-\s*\n/m, "\n") # empty list items
        back.gsub!(/\n\\\*\s*\n/m, "\n") # images are shown as \*
        back.gsub!(/-([^\n]+)\n\n  -/m, "-\\1\n  -") # avoid extra blank lines in lists
        back.gsub!(/\n(  )*-([^\n]+)\n?\n(  )*-([^\n]+)\n?\n/m, "\n\\1-\\2\n\\3-\\4\n") # another more generalist for lists
        back.gsub(/\n\n?\*\*([^\*]+)\*\*\n\n?/, "\n\n### \\1\n\n") # transform isolated titles from bold to h3
      end

    end
  end
end
