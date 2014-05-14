require_relative "store"
require_relative "api"

module Hackpad
  module Cli
    class UndefinedPad < StandardError
    end
    class UnknownFormat < StandardError
    end

    class Pad

      attr_reader :id, :content, :guest_policy, :moderated, :cached_at

      def initialize(id)
        @id = id
      end

      def title
        @title ||= (@content.lines.first.strip if @content)
      end

      def chars
        @content.length if @content
      end

      def lines
        @content.lines.count if @content
      end

      def load(ext, refresh=false)
        raise UnknownFormat unless FORMATS.include? ext
        raise UndefinedPad unless @id
        if refresh or !Store.exists? ext, @id
          load_from_api ext
        else
          load_from_cache ext
        end
      end

      def load_from_api(ext)
        @content = Api.read @id, ext
        Store.save self, ext
        options = Api.read_options @id
        @guest_policy = options['options']['guestPolicy']
        @moderated = !!options['options']['isModerated']
        options['cached_at'] = Time.now
        @cached_at = options['cached_at']
        Store.save_meta @id, options
      end

      def load_from_cache(ext)
        @content = Store.read @id, ext
        options = Store.read_options @id
        @guest_policy = options['options']['guestPolicy']
        @moderated = !!options['options']['isModerated']
        @cached_at = options['cached_at']
      end

      def is_cached?
        Store.exists? 'meta', @id
      end

    end
  end
end

