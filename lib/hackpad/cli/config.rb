require 'ostruct'
require 'cliprompt'

module Hackpad
  module Cli
    class Config < OpenStruct

      include Cliprompt

      def initialize(options = nil, input = STDIN, output = STDOUT)
        super(options)
        self['configdir'] ||= File.join(ENV['HOME'], '.hackpad-cli')
        self['workspace'] ||= 'default'
        self['refresh'] ||= false
        self['urls'] ||= false
        self['output'] = output
        self['workspacedir'] = File.join(configdir, workspace)
        setio input, output
        patch_1
        addvalues 'config'
        addvalues 'workspace'
      end

      def addvalues(type)
        dir = self["#{type}dir"]
        file = File.join(dir, 'config.yml')
        FileUtils.mkdir_p dir unless Dir.exist? dir
        send("setup_#{type}".to_sym, file) unless File.exist? file
        YAML.load_file(file).each do |k, v|
          self[k] = v
        end
      end

      def workspaces
        Dir.glob(File.join(configdir, '*', 'config.yml')).reduce([]) do |a, path|
          a << OpenStruct.new(name: File.basename(File.dirname(path)), site: YAML.load_file(path)['site'])
          a
        end
      end

      def setup_config(file)
        values = {}
        output.puts Paint['Create a new hackpad-cli configuration:', :blue]
        values['use_colors'] = guess 'HPCLI_COLORS', 'Do you want a colored output?', 'Yn'
        values['workspace'] = guess 'HPCLI_WORKSPACE', 'What is the name of the default workspace?', 'default'
        File.open(file, 'w') do |f|
          f.write YAML.dump(values)
        end
      end

      def setup_workspace(file)
        values = {}
        output.puts Paint['Workspace configuration.', :blue]
        output.puts Paint['Gather your information from https://<workspace>.hackpad.com/ep/account/settings/', :bold]
        values['client_id'] = guess 'HPCLI_CLIENTID', 'What is your Client ID?'
        values['secret'] = guess 'HPCLI_SECRET', 'What is your Secret Key?'
        values['site'] = guess('HPCLI_URL', 'What is the URI of your workspace? (ex. https://xxx.hackapd.com)').gsub(/\/$/, '')
        File.open(file, 'w') do |f|
          f.write YAML.dump(values)
        end
      end

      def patch_1
        if File.exist? File.join(configdir, "#{workspace}.yml")
          FileUtils.mv File.join(configdir, "#{workspace}.yml"), File.join(configdir, workspace, 'config.yml')
        end
      end

    end
  end
end
