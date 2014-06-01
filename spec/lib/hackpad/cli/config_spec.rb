# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/config'

describe Hackpad::Cli::Config do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:configfile) { File.join(configdir, 'config.yml') }
  let(:options) { { basedir: configdir, workspace: 'default' } }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  before { FileUtils.mkdir_p configdir unless Dir.exist?(configdir) }
  after { FileUtils.rm configfile if File.exist?(configfile) }

  describe '.new' do
    context 'when there is already config files created,' do
      let(:configvars) { { 'use_colors' => true, 'workspace' => 'default' } }
      before { File.open(configfile, 'w') { |f| f.puts YAML.dump(configvars) } }
      let(:config) { Hackpad::Cli::Config.new(options) }
      it {
        expect(config.workspace).to eq 'default'
      }
    end
    context 'when there is no config files created,' do
      before { input.stub(:gets).and_return('y', 'default') }
      let(:config) { Hackpad::Cli::Config.new(options, input, output) }
      it {
        expect(config.workspace).to eq 'default'
      }
    end
  end

  describe '.patch_1' do
    let(:oldconfigfile) { File.join(configdir, 'default.yml') }
    let(:workspacefile) { File.join(configdir, 'default', 'config.yml') }
    let(:oldconfigvars) { { 'client_id' => '123', 'secret' => 'toto', 'site' => 'http://example.com' } }
    before { File.open(oldconfigfile, 'w') { |f| f.puts YAML.dump(oldconfigvars) } }
    before { input.stub(:gets).and_return('y', 'default') }
    after { FileUtils.rm oldconfigfile if File.exist?(oldconfigfile) }
    after { FileUtils.rm workspacefile if File.exist?(workspacefile) }
    it do
      Hackpad::Cli::Config.new(options, input, output)
      expect(File.exist? oldconfigfile).to be_false
      expect(File.exist? workspacefile).to be_true
    end
  end

end
