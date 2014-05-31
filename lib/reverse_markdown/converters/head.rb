module ReverseMarkdown
  module Converters
    class Head < Base

      def convert(node)
        ''
      end

    end
    register :head, Head.new
  end
end
