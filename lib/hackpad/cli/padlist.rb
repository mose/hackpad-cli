require 'ostruct'
require_relative 'store'
require_relative 'api'
require_relative 'pad'

module Hackpad
  module Cli
    module Padlist
      module_function

      def get_list(refresh = false, output = STDOUT)
        all = []
        if refresh || !Store.exist?('padlist')
          output.print 'Refreshing '
          list = Api.list
          list.each do |a|
            output.print '.'
            all << get_pad(a, refresh)
          end
          output.puts ' all done.'
          Store.save_list all
        else
          all = Store.read_list
        end
        all
      end

      def get_pad(id, refresh = false)
        pad = Pad.new id
        pad.load 'txt', refresh
        OpenStruct.new(id: id, title: pad.title)
      end

      def check_list
        all = []
        list = Api.list
        list.each do |a|
          pad = Pad.new a
          unless pad.cached?
            pad.load 'txt'
            all << OpenStruct.new(id: a, title: pad.title)
          end
        end
        all
      end

    end
  end
end
