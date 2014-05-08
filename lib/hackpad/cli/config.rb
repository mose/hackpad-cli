require 'colorize'

module Hackpad
  module Cli
    module Config
      extend self

      def load(options, input=STDIN, output=STDOUT)
        @input = input
        @output = output
        configdir = options[:configdir]
        configfile = File.join(configdir, "#{options[:workspace]}.yml")
        # temporary migration path
        if !File.exists?(configfile) && File.exists?(File.join(configdir, "config.yml"))
          FileUtils.mv File.join(configdir, "config.yml"), configfile
        end
        if !Dir.exists?(configdir) || !File.exists?(configfile)
          setup configfile, input, output
        end
        YAML::load_file configfile
      end

    private

      def setup(configfile, input=STDIN, output=STDOUT)
        config = {}
        FileUtils.mkdir_p File.dirname(configfile)
        output.puts "We need first to initialize your hackpad-cli configuration.".blue
        output.puts "Please gather your information from https://<subdomain>.hackpad.com/ep/account/settings/".light_blue
        output.print "What is your Client ID?  "
        config['client_id'] = input.gets.chomp
        output.flush
        output.print "What is your Secret Key? "
        output.flush
        config['secret'] = input.gets.chomp
        output.print "What is the URI of your pad? "
        output.flush
        config['site'] = input.gets.chomp
        File.open(configfile, "w") do |f|
          f.write YAML::dump(config)
        end
      end

    end
  end
end
