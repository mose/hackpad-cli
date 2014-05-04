require 'json'
require 'ostruct'
require_relative '../cli'

module Hackpad
  module Cli
    module Store
      extend self

      def prepare(config)
        @refresh = config['refresh']
        @dir = File.join(config['configdir'], config['workspace'])
        @pads_dir = File.join(@dir, 'pads')
        @list_cache = File.join(@dir, 'pads.list')
        FileUtils.mkdir_p @dir unless Dir.exists?(@dir)
        (Hackpad::Cli::FORMATS + ['meta']).each { |f| FileUtils.mkdir_p File.join(@pads_dir, f) }
      end

      def exists?(*path)
        !@refresh && File.exists?(File.join(@pads_dir, *path))
      end

      def save(pad, ext)
        File.open(File.join(@pads_dir, ext, pad.id), 'w') do |f|
          f.puts pad.content
        end
      end

      def save_meta(id, options)
        File.open(File.join(@pads_dir, 'meta', id), 'w') do |f|
          f.puts JSON.pretty_generate(options)
        end
      end

      def save_list(pads)
        File.open(File.join(@pads_dir, 'padlist'), 'w') do |f|
          pads.each do |p|
            f.puts "#{p.id} #{p.title}"
          end
        end
      end

      def read(id, ext)
        file = File.join(@pads_dir, ext, id)
        File.read(file)
      end

      def read_options(id)
        file = File.join(@pads_dir, 'meta', id)
        JSON.parse File.read(file)
      end

      def read_list
        File.read(File.join(@pads_dir, 'padlist')).lines.reduce([]) { |a,line|
          /(?<id>[a-zA-Z0-9]*) (?<title>.*)/ =~ line
          a << OpenStruct.new( id: id, title: title )
          a
        }
      end

    end
  end
end
