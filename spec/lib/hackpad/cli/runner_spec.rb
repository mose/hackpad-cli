# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/runner'
require 'hackpad/cli/client'

describe Hackpad::Cli::Runner do

  let(:cli) { Hackpad::Cli::Runner.new }

  before :each do
    Hackpad::Cli::Client.stub(:new, {}).and_return(Object)
  end

  it 'calls the stats method in client class' do
    Object.stub(:stats)
    cli.shell.mute do
      cli.stats
    end
  end

  it 'calls the search method in client class' do
    Object.stub(:search)
    cli.shell.mute do
      cli.search 'xxx'
    end
  end

  it 'calls the add method in client class' do
    Object.stub(:add)
    cli.shell.mute do
      cli.add
    end
  end

  it 'calls the workspaces method in client class' do
    Object.stub(:workspaces)
    cli.shell.mute do
      cli.workspaces
    end
  end

  it 'calls the default method in client class' do
    Object.stub(:default)
    cli.shell.mute do
      cli.default
    end
  end

  it 'calls the list method in client class' do
    Object.stub(:list)
    cli.shell.mute do
      cli.list
    end
  end

  it 'calls the getnew method in client class' do
    Object.stub(:getnew)
    cli.shell.mute do
      cli.getnew
    end
  end

  it 'calls the version method in client class' do
    version = File.read(File.expand_path('../../../../../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
    STDOUT.stub(:puts).with(version)
    cli.shell.mute do
      cli.version
    end
  end

  it 'calls the info method in client class' do
    Object.stub(:info)
    cli.shell.mute do
      cli.info 'pad'
    end
  end

  it 'calls the show method in client class' do
    Object.stub(:show)
    cli.shell.mute do
      cli.show 'pad', 'md'
    end
  end

end
