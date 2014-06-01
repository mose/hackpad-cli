require 'cliprompt'
require 'configstruct'

module Hackpad
  module Cli
    class Workspace < ConfigStruct

      include Cliprompt

      def set_defaults
        super
        self.name ||= 'default'
        self.url ||= 'http://hackpad.com'
        setio @input, @output
      end

      def setup
        values = {}
        puts Paint['Workspace configuration.', :blue]
        puts Paint['Gather your information from https://<workspace>.hackpad.com/ep/account/settings/', :bold]
        values['client_id'] = guess 'HPCLI_CLIENTID', 'What is your Client ID?'
        values['secret'] = guess 'HPCLI_SECRET', 'What is your Secret Key?'
        values['site'] = guess('HPCLI_URL', 'What is the URI of your workspace? (ex. https://xxx.hackapd.com)').gsub(/\/$/, '')
        write values
      end

    end
  end
end
