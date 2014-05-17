require 'reverse_markdown'

require_relative 'store'
require_relative 'api'

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

      def load(ext, refresh = false)
        fail UnknownFormat unless FORMATS.include? ext
        fail UndefinedPad unless @id
        if refresh || !Store.exist?(ext, @id)
          load_from_provider Api, ext
          Store.save(self, ext)
          Store.save_options(@id, @options)
        else
          load_from_provider Store, ext
        end
      end

      def load_from_provider(klass, ext)
        @content = klass.read @id, ext
        @options = klass.read_options(@id)
        load_options @options
      end

      def load_options(options)
        @guest_policy = options['options']['guestPolicy']
        @moderated = options['options']['isModerated']
        options['cached_at'] ||= Time.now
        @cached_at = options['cached_at']
      end

      def cached?
        Store.exist? 'meta', @id
      end


    end
  end
end
