# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/workspace'

describe Hackpad::Cli::Workspace do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:workspacedir) { File.join(configdir, 'default') }
  let(:workspacedir) { File.join(configdir, 'default') }
  let(:workspacefile) { File.join(workspacedir, 'config.yml') }
  let(:options) { { basedir: workspacedir, basefile: workspacefile } }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  before { FileUtils.mkdir_p configdir unless Dir.exist?(configdir) }
  before { FileUtils.mkdir_p workspacedir unless Dir.exist?(workspacedir) }

  after { FileUtils.rm workspacefile if File.exist?(workspacefile) }

  describe '.new' do
    context 'when there is already config files created,' do
      let(:workspacevars) { { 'client_id' => '123', 'secret' => 'toto', 'site' => 'http://example.com' } }
      before { File.open(workspacefile, 'w') { |f| f.puts YAML.dump(workspacevars) } }
      let(:workspace) { Hackpad::Cli::Workspace.new(options) }
      it {
        expect(workspace.secret).to eq 'toto'
        expect(workspace.site).to eq 'http://example.com'
      }
    end
    context 'when there is no config files created,' do
      before { input.stub(:gets).and_return('123', 'toto', 'http://example.com') }
      let(:workspace) { Hackpad::Cli::Workspace.new(options, input, output) }
      it {
        expect(workspace.secret).to eq 'toto'
        expect(workspace.site).to eq 'http://example.com'
      }
    end
  end

end
