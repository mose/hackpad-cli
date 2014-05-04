require 'json'

module Hackpad
  module Cli
    module Store
      extend self

      def prepare(config)
        @dir = File.join(config['configdir'], config['workspace'])
        @pads_dir = File.join(@dir, 'pads')
        @list_cache = File.join(@dir, 'pads.list')
        FileUtils.mkdir_p @dir unless Dir.exists?(@dir)
        (Hackpad::Cli::FORMATS + ['meta']).each { |f| FileUtils.mkdir_p File.join(@pads_dir, f) }
      end

      def exists?(id, ext)
        File.exists? File.join(@pads_dir, ext, id)
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

      def read(id, ext)
        file = File.join(@pads_dir, ext, id)
        File.read(file)
      end

      def read_meta(id)
        file = File.join(@pads_dir, 'meta', id)
        JSON.parse File.read(file)
      end

    end
  end
end
