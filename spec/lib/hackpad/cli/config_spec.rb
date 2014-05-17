# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/config'

describe Hackpad::Cli::Config do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:configfile) { File.join(configdir, 'default.yml') }
  let(:options) { { configdir: configdir, workspace: 'default' } }

  before :each do
    FileUtils.mkdir_p configdir unless Dir.exist?(configdir)
  end

  after :each do
    FileUtils.rm configfile if File.exist?(configfile)
  end

  describe '.load' do
    let(:config) { { 'xx' => 'oo' } }

    context 'when there is no config file,' do
      it 'calls for setup' do
        Dir.stub(:exist?).and_return false
        subject.stub(:setup).with(configfile, STDIN, STDOUT)
        File.open(configfile, 'w') do |f|
          f.write YAML.dump(config)
        end
        expect(subject.load options).to eq config
      end
    end
  end

  describe '.setup' do
    context 'when normal input is provided,' do
      let(:input) { StringIO.new }
      let(:output) { StringIO.new }
      it 'handles setup interactively' do
        input.stub(:gets).and_return('client_id', 'secret', 'site')
        subject.send :setup, configfile, input, output
        expect(File.read configfile).to eq "---\nclient_id: client_id\nsecret: secret\nsite: site\n"
      end
    end
  end

end
