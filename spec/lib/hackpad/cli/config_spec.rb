# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/config'

describe Hackpad::Cli::Config do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:configfile) { File.join(configdir, 'config.yml') }
  let(:workspacedir) { File.join(configdir, 'default') }
  let(:workspacefile) { File.join(workspacedir, 'config.yml') }
  let(:options) { { configdir: configdir, workspace: 'default' } }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  before { FileUtils.mkdir_p configdir unless Dir.exist?(configdir) }
  before { FileUtils.mkdir_p workspacedir unless Dir.exist?(workspacedir) }

  after { FileUtils.rm configfile if File.exist?(configfile) }
  after { FileUtils.rm workspacefile if File.exist?(workspacefile) }

  describe '.new' do
    context 'when there is already config files created,' do
      let(:configvars) { { 'use_colors' => true, 'workspace' => 'default' } }
      let(:workspacevars) { { 'client_id' => '123', 'secret' => 'toto', 'site' => 'http://example.com' } }
      before { File.open(configfile, 'w') { |f| f.puts YAML.dump(configvars) } }
      before { File.open(workspacefile, 'w') { |f| f.puts YAML.dump(workspacevars) } }
      let(:config) { Hackpad::Cli::Config.new(options) }
      it {
        expect(config.secret).to eq 'toto'
        expect(config.site).to eq 'http://example.com'
      }
    end
    context 'when there is no config files created,' do
      before { input.stub(:gets).and_return('y', 'default', '123', 'toto','http://example.com') }
      let(:config) { Hackpad::Cli::Config.new(options, input, output) }
      it {
        expect(config.secret).to eq 'toto'
        expect(config.site).to eq 'http://example.com'
      }
    end
  end

  describe '.patch_1' do
    let(:oldconfigfile) { File.join(configdir, 'default.yml') }
    let(:oldconfigvars) { { 'client_id' => '123', 'secret' => 'toto', 'site' => 'http://example.com' } }
    before { File.open(oldconfigfile, 'w') { |f| f.puts YAML.dump(oldconfigvars) } }
    before { input.stub(:gets).and_return('y', 'default') }
    after { FileUtils.rm oldconfigfile if File.exist?(oldconfigfile) }
    it do
      Hackpad::Cli::Config.new(options, input, output)
      expect(File.exist? oldconfigfile).to be_false
      expect(File.exist? configfile).to be_true
    end
  end

end
