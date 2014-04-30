module Hackpad
  module Config
    extend self

    def load(dir = nil)
      if !Dir.exists?(conf_dir dir) || !File.exists?(conf_file)
        setup conf_dir dir
      end
      YAML::load_file conf_file
    end

  private

    def setup(dir)
      config = {}
      FileUtils.mkdir_p dir
      puts "We need first to initialize your hackpad-cli configuration.".colorize(:blue)
      puts "Please gather your information from https://<subdomain>.hackpad.com/ep/account/settings/"
      print "What is your Client ID?  "
      STDOUT.flush
      config['client_id'] = STDIN.gets.chomp
      print "What is your Secret Key? "
      STDOUT.flush
      config['secret'] = STDIN.gets.chomp
      print "What is the URI of your pad? "
      STDOUT.flush
      config['site'] = STDIN.gets.chomp
      File.open(conf_file, "w") do |f|
        f.write YAML::dump(config)
      end
    end

    def conf_file
      File.join(conf_dir, 'config.yml')
    end

    def conf_dir(dir = "#{ENV["HOME"]}/.hackpad-cli/")
      dir
    end

  end
end
