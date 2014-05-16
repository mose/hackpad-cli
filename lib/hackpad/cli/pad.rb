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

      def load(ext, refresh=false, save=true)
        raise UnknownFormat unless FORMATS.include? ext
        raise UndefinedPad unless @id
        if refresh or !Store.exists? ext, @id
          load_from_api ext, save
        else
          load_from_cache ext
        end
      end

      def load_from_api(ext, save=true)
        @content = Api.read @id, ext
        if save
          Store.save self, ext
        end
        options = Api.read_options @id
        @guest_policy = options['options']['guestPolicy']
        @moderated = !!options['options']['isModerated']
        options['cached_at'] = Time.now
        @cached_at = options['cached_at']
        if save
          Store.save_options @id, options
        end
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

