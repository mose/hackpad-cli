module Hackpad
  class Pad

    attr_reader :id, :content, :guest_policy, :moderated

    def initialize(id, content, options)
      @id = id
      @content = content || Nullpad.content
      @guest_policy = options['guestPolicy']
      @moderated = !!options['isModerated']
    end

    def title
      @content.lines.first.strip if @content
    end

    def chars
      @content.length
    end

    def lines
      @content.lines.count
    end

  end

  module Nullpad
    extend self

    def content
      "Empty"
    end
  end

end

