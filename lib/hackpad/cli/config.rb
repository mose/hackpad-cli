require 'ostruct'
require 'cliprompt'

module Hackpad
  module Cli
    class Config < OpenStruct

      include Cliprompt

      def initialize(options = nil, input = STDIN, output = STDOUT)
        super(options)
        @@input = input
        @@output = output
        self.configdir ||= File.join(ENV['HOME'], '.hackpad-cli')
        self.refresh ||= false
        self.urls ||= false
        self.output = output
        setio input, output
        patch_1
        addvalues 'config'
        self.workspace ||= 'default'
        self.workspacedir = File.join(configdir, workspace)
        addvalues 'workspace'
      end

      def addvalues(type)
        dir = send("#{type}dir".to_sym)
        file = File.join(dir, 'config.yml')
        FileUtils.mkdir_p dir unless Dir.exist? dir
        send("setup_#{type}".to_sym, file) unless File.exist? file
        YAML.load_file(file).each do |k, v|
          new_ostruct_member(k)
          send("#{k}=", v)
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
        write(file, values)
      end

      def setup_workspace(file)
        values = {}
        output.puts Paint['Workspace configuration.', :blue]
        output.puts Paint['Gather your information from https://<workspace>.hackpad.com/ep/account/settings/', :bold]
        values['client_id'] = guess 'HPCLI_CLIENTID', 'What is your Client ID?'
        values['secret'] = guess 'HPCLI_SECRET', 'What is your Secret Key?'
        values['site'] = guess('HPCLI_URL', 'What is the URI of your workspace? (ex. https://xxx.hackapd.com)').gsub(/\/$/, '')
        write(file, values)
      end

      def change_default
        values = {}
        values['use_colors'] = use_colors
        values['workspace'] = ask 'What workspace do you want to use as default from now on?',
          choices: workspaces.map(&:name),
          default: workspace,
          aslist: true
        file = File.join(configdir, 'config.yml')
        write(file, values)
      end

      def patch_1
        if File.exist? File.join(configdir, "#{workspace}.yml")
          FileUtils.mv File.join(configdir, "#{workspace}.yml"), File.join(configdir, workspace, 'config.yml')
        end
      end

      def write(file, values)
        File.open(file, 'w') do |f|
          f.write YAML.dump(values)
        end
      end

    end
  end
end
