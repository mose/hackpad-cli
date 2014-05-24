require 'json'
require 'ostruct'

require_relative '../cli'
require_relative 'config'

module Hackpad
  module Cli
    module Store
      module_function

      def prepare(config)
        @refresh = config.refresh
        @configdir = config.configdir
        @pads_dir = File.join(config.workspacedir, 'pads')
        @list_cache = File.join(@pads_dir, 'padlist')
        prepare_dirs @pads_dir
      end

      def prepare_dirs(base)
        (Hackpad::Cli::FORMATS + ['meta']).each { |f| FileUtils.mkdir_p File.join(base, f) }
      end

      def exist?(*path)
        !@refresh && File.exist?(File.join(@pads_dir, *path))
      end

      def save(pad, ext)
        File.open(File.join(@pads_dir, ext, pad.id), 'w') do |f|
          f.puts pad.content
        end
      end

      def save_options(id, options)
        File.open(File.join(@pads_dir, 'meta', id), 'w') do |f|
          f.puts JSON.pretty_generate(options)
        end
      end

      def save_list(pads)
        File.open(@list_cache, 'w') do |f|
          pads.each do |p|
            f.puts "#{p.id} [#{p.cached_at}] #{p.title}"
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
        File.read(@list_cache).lines.reduce([]) do |a, line|
          /(?<id>[a-zA-Z0-9]*) (\[(?<cached_at>[-a-zA-Z0-9: ]*)\] )?(?<title>.*)/ =~ line
          a << OpenStruct.new(id: id, title: title, cached_at: cached_at)
          a
        end
      end

      def count_pads
        Dir.glob(File.join(@pads_dir, 'meta', '*')).count
      end

      def last_refresh
        File.mtime(@list_cache) if File.exist?(@list_cache)
      end

    end
  end
end
