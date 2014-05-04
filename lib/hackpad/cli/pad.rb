require_relative "store"
require_relative "api"

module Hackpad
  module Cli
    class UndefinedPad < StandardError
    end
    class UnknownFormat < StandardError
    end

    class Pad

      attr_reader :id, :content, :guest_policy, :moderated


      def initialize(id)
        @id = id
      end

      def title
        @content.lines.first.strip if @content
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
        if refresh or !Store.exists? id, ext
          @content = Api.read id, ext
          Store.save self, ext
          options = Api.read_options id
          @guest_policy = options['guestPolicy']
          @moderated = !!options['isModerated']
          Store.save_meta @id, options
        else
          @content = Store.read id, ext
          options = Store.read_options id
          @guest_policy = options['guestPolicy']
          @moderated = !!options['isModerated']
        end
      end

    end
  end
end

