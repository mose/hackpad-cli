require_relative "store"
require_relative "api"
require_relative "pad"

module Hackpad
  module Cli
    class Padlist

      attr_reader :all

      def initialize(refresh=false)
        if refresh or !Store.exists? "padlist"
          print "Refreshing "
          list = Api.list
          @all = []
          list.each do |a|
            print "."
            pad = Pad.new a
            pad.load 'txt', refresh
            @all << OpenStruct.new( id: a, title: pad.title )
          end
          puts " all done."
          Store.save_list all
        else
          @all = Store.read_list
        end
      end

    end
  end
end

