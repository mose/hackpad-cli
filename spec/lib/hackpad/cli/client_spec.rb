# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/client'
require 'pp'

describe Hackpad::Cli::Client do
  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:configfile) { File.join(configdir, 'config.yml') }
  let(:workspacedir) { File.join(configdir, 'default') }
  let(:workspacefile) { File.join(workspacedir, 'config.yml') }
  let(:configvars) { { 'use_colors' => true, 'workspace' => 'default' } }
  let(:workspacevars) { { 'client_id' => '123', 'secret' => 'toto', 'site' => 'http://example.com' } }
  let(:options) { { basedir: configdir, workspace: 'default' } }
  let(:format) { "%-20s %s\n" }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  before { FileUtils.mkdir_p configdir }
  before { FileUtils.mkdir_p workspacedir }
  before { File.open(configfile, 'w') { |f| f.puts YAML.dump(configvars) } }
  before { File.open(workspacefile, 'w') { |f| f.puts YAML.dump(workspacevars) } }
  after  { FileUtils.rm configfile if File.exist?(configfile) }
  after  { FileUtils.rm workspacefile if File.exist?(workspacefile) }

  describe '.new' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }

    context 'when default options are passed,' do
      let(:client) { Hackpad::Cli::Client.new options }
      it { expect(client).to be_a Hackpad::Cli::Client }
    end

    context 'when plain text is required,' do
      context 'when colorization is not expected,' do
        before { Hackpad::Cli::Client.new options.merge(plain: true) }
        it { expect(Paint.mode).to eq 0 }
      end
    end
  end

  describe '.workspaces' do
    let(:client) { Hackpad::Cli::Client.new(options, input, output) }
    let(:workspacedir2) { File.join(configdir, 'default2') }
    let(:workspacefile2) { File.join(workspacedir2, 'config.yml') }
    let(:workspacevars2) { { 'client_id' => '321', 'secret' => 'otot', 'site' => 'http://2.example.com' } }
    before { FileUtils.mkdir_p workspacedir2 }
    before { File.open(workspacefile2, 'w') { |f| f.puts YAML.dump(workspacevars2) } }
    after  { FileUtils.rm workspacefile2 if File.exist?(workspacefile2) }

    it do
      client.workspaces
      expect(output.string).to eq "> default            http://example.com\ndefault2             http://2.example.com\n"
    end
  end

  describe '.default' do
    let(:client) { Hackpad::Cli::Client.new(options, input, output) }
    let(:workspacedir2) { File.join(configdir, 'default2') }
    let(:workspacefile2) { File.join(workspacedir2, 'config.yml') }
    let(:workspacevars2) { { 'client_id' => '321', 'secret' => 'otot', 'site' => 'http://2.example.com' } }
    before { input.stub(:gets).and_return('1') }
    before { FileUtils.mkdir_p workspacedir2 }
    before { File.open(workspacefile2, 'w') { |f| f.puts YAML.dump(workspacevars2) } }
    after  { FileUtils.rm workspacefile2 if File.exist?(workspacefile2) }

    it do
      client.default
      expect(output.string).to eq "What workspace do you want to use as default from now on? \n> 0   default\n  1   default2\nChoose a number: [0] "
      expect(YAML.load_file(configfile)['workspace']).to eq 'default2'
    end
  end

  describe '.stats' do
    let(:timestamp) { Time.new(2013, 10, 2) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:count_pads).and_return(12) }
    before { Hackpad::Cli::Store.stub(:last_refresh).and_return(timestamp) }
    let(:client) { Hackpad::Cli::Client.new(options, input, output) }
    it do
      client.stats
      expect(output.string).to eq "Site                 #{Paint[workspacevars['site'], :blue]}\nCached Pads          12\nLast Refresh         #{timestamp}\n"
    end
  end

  describe '.search' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before do
      Hackpad::Cli::Api.stub(:search)
        .with('xxx', 0)
        .and_return(
          [{
            'title' => 'xtitle',
            'id' => 'xxxxxx',
            'snippet' => 'context <b class="hit">x</b> context'
          }]
        )
    end
    context 'when default options are used,' do
      let(:client) { Hackpad::Cli::Client.new(options, input, output) }
      it do
        expect(output).to receive(:puts).with("#{Paint['xxxxxx', :bold]} - #{Paint['xtitle', :yellow]}")
        expect(output).to receive(:puts).with("   context #{Paint['x', :cyan, :bold]} context")
        client.search 'xxx'
      end
    end
    context 'when options sets urls to true,' do
      let(:client) { Hackpad::Cli::Client.new(options.merge(urls: true), input, output) }
      it do
        client.search 'xxx'
        expect(output.string).to eq "#{workspacevars['site']}/#{Paint['xxxxxx', :bold]} - #{Paint['xtitle', :yellow]}\n   context #{Paint['x', :cyan, :bold]} context\n"
      end
    end
  end

  describe '.list' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before do
      Hackpad::Cli::Padlist.stub(:get_list)
        .and_return([OpenStruct.new(id: 'xxxxxx', title: 'xtitle')])
    end
    context 'when default options are used,' do
      let(:client) { Hackpad::Cli::Client.new(options, input, output) }
      it do
        expect(output).to receive(:puts).with(['xxxxxx - xtitle'])
        client.list
      end
    end
    context 'when options sets urls to true,' do
      let(:client) { Hackpad::Cli::Client.new(options.merge(urls: true), input, output) }
      it do
        expect(output).to receive(:puts).with(["#{workspacevars['site']}/xxxxxx - xtitle"])
        client.list
      end
    end
  end

  describe '.getnew' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }

    context 'when there is a new pad,' do
      before do
        Hackpad::Cli::Padlist.stub(:get_new)
          .and_return([OpenStruct.new(id: 'xxxxxx', title: 'xtitle')])
      end
      context 'when default options are used,' do
        let(:client) { Hackpad::Cli::Client.new(options, input, output) }
        it do
          expect(output).to receive(:puts).with('New pads:')
          expect(output).to receive(:puts).with(['xxxxxx - xtitle'])
          client.getnew
        end
      end
      context 'when options sets urls to true,' do
        let(:client) { Hackpad::Cli::Client.new(options.merge(urls: true), input, output) }
        it do
          expect(output).to receive(:puts).with('New pads:')
          expect(output).to receive(:puts).with(["#{workspacevars['site']}/xxxxxx - xtitle"])
          client.getnew
        end
      end
    end
    context 'when there is no new pad,' do
      before { Hackpad::Cli::Padlist.stub(:get_new).and_return([]) }
      let(:client) { Hackpad::Cli::Client.new(options, input, output) }
      it do
        expect(output).to receive(:puts).with('New pads:')
        expect(output).to receive(:puts).with('There is no new pad.')
        client.getnew
      end
    end
  end

  describe '.info' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    let(:client) { Hackpad::Cli::Client.new(options, input, output) }
    let(:pad) { double Hackpad::Cli::Pad }
    before { Hackpad::Cli::Pad.stub(:new).with('123').and_return pad }

    context 'when unknown id is given,' do
      before { pad.stub(:load).and_raise Hackpad::Cli::UndefinedPad }
      it { expect { client.info('123') }.to raise_error(Hackpad::Cli::UndefinedPad) }
    end

    context 'when id is an existing pad,' do
      before { pad.stub(:load) }
      before { pad.stub(:title).and_return('title1') }
      before { pad.stub(:chars).and_return(20) }
      before { pad.stub(:lines).and_return(2) }
      before { pad.stub(:guest_policy).and_return('open') }
      before { pad.stub(:moderated).and_return('false') }
      before { pad.stub(:cached_at).and_return }
      it do
        expect(output).to receive(:printf).with(format, 'Id', Paint["123", :bold])
        expect(output).to receive(:printf).with(format, 'Title', Paint['title1', :yellow])
        expect(output).to receive(:printf).with(format, 'URI', "#{workspacevars['site']}/123")
        expect(output).to receive(:printf).with(format, 'Chars', '20')
        expect(output).to receive(:printf).with(format, 'Lines', '2')
        expect(output).to receive(:printf).with(format, 'Guest Policy', 'open')
        expect(output).to receive(:printf).with(format, 'Moderated', 'false')
        expect(output).to receive(:printf).with(format, 'Cached', 'unknown')
        client.info '123'

      end
    end

  end

  describe '.show' do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    let(:client) { Hackpad::Cli::Client.new(options, input, output) }
    let(:pad) { double Hackpad::Cli::Pad }
    before { Hackpad::Cli::Pad.stub(:new).with('123').and_return pad }
    before { pad.stub(:load) }

    context 'when a txt version is asked,' do
      before { pad.stub(:content).and_return('this is content') }
      it do
        expect(output).to receive(:puts).with('this is content')
        client.show '123', 'txt'
      end
    end

    context 'when a html version is asked,' do
      before { pad.stub(:content).and_return('<ul><li>this is content</li></ul>') }
      it do
        expect(output).to receive(:puts).with('<ul><li>this is content</li></ul>')
        client.show '123', 'html'
      end
    end

    context 'when a markdown version is asked,' do
      before { pad.stub(:content).and_return('- this is content') }
      it do
        expect(output).to receive(:puts).with('- this is content')
        client.show '123', 'md'
      end
    end

  end

end
