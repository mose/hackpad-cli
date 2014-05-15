require 'ostruct'
require_relative "store"
require_relative "api"
require_relative "pad"

module Hackpad
  module Cli
    module Padlist
      extend self

      def get_list(refresh=false)
        all = []
        if refresh or !Store.exists? "padlist"
          print "Refreshing "
          list = Api.list
          list.each do |a|
            print "."
            pad = Pad.new a
            pad.load 'txt', refresh
            all << OpenStruct.new( id: a, title: pad.title )
          end
          puts " all done."
          Store.save_list all
        else
          all = Store.read_list
        end
        all
      end

      def check_list(refresh=false)
        all = []
        list = Api.list
        list.each do |a|
          pad = Pad.new a
          if !pad.is_cached?
            pad.load 'txt', refresh
            all << OpenStruct.new( id: a, title: pad.title )
          end
        end
        all
      end

    end
  end
end

