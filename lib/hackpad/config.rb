module Hackpad
  module Config
    extend self

    def load(options)
      configdir = options[:configdir]
      configfile = File.join(configdir, "#{options[:workspace]}.yml")
      # temporary migration path
      if !File.exists?(configfile) && File.exists?(File.join(configdir, "config.yml"))
        FileUtils.mv File.join(configdir, "config.yml"), configfile
      end
      if !Dir.exists?(configdir) || !File.exists?(configfile)
        setup configfile
      end
      YAML::load_file configfile
    end

  private

    def setup(configfile)
      config = {}
      FileUtils.mkdir_p File.dirname(configfile)
      puts "We need first to initialize your hackpad-cli configuration.".blue
      puts "Please gather your information from https://<subdomain>.hackpad.com/ep/account/settings/".light_blue
      print "What is your Client ID?  "
      STDOUT.flush
      config['client_id'] = STDIN.gets.chomp
      print "What is your Secret Key? "
      STDOUT.flush
      config['secret'] = STDIN.gets.chomp
      print "What is the URI of your pad? "
      STDOUT.flush
      config['site'] = STDIN.gets.chomp
      File.open(configfile, "w") do |f|
        f.write YAML::dump(config)
      end
    end

  end
end
