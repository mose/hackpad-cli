require 'cliprompt'
require 'configstruct'

module Hackpad
  module Cli
    class Config < ConfigStruct

      include Cliprompt

      def set_defaults
        super
        self.refresh ||= false
        self.urls ||= false
        self.workspace ||= 'default'
        setio @input, @output
        patch_1
      end

      def setup
        values = {}
        output.puts Paint['Create a new hackpad-cli configuration:', :blue]
        values['use_colors'] = guess 'HPCLI_COLORS', 'Do you want a colored output?', 'Yn'
        values['workspace'] = guess 'HPCLI_WORKSPACE', 'What is the name of the default workspace?', 'default'
        write values
      end

      def workspaces
        w = Dir.glob(File.join(self.basedir, '*', 'config.yml')).reduce([]) do |a, path|
          a << OpenStruct.new(name: File.basename(File.dirname(path)), site: YAML.load_file(path)['site'])
          a
        end
        w.sort_by { |s| s.name }
      end

      def change_default
        values = {}
        values['use_colors'] = use_colors
        values['workspace'] = ask 'What workspace do you want to use as default from now on?',
          choices: workspaces.map(&:name),
          default: workspace,
          aslist: true
        write values
      end

      def patch_1
        if File.exist? File.join(basedir, "#{workspace}.yml")
          FileUtils.mv File.join(basedir, "#{workspace}.yml"), File.join(basedir, workspace, 'config.yml')
        end
      end

    end
  end
end
