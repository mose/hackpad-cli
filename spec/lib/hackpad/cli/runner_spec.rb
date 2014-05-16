# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/runner"
require "hackpad/cli/client"

describe Hackpad::Cli::Runner do

  let(:cli) { Hackpad::Cli::Runner.new }

  before :each do
    Hackpad::Cli::Client.stub(:new, {}).and_return(Object)
  end

  it "calls the stats method in client class" do
    Object.stub(:stats)
    cli.shell.mute do
      cli.stats
    end
  end

  it "calls the search method in client class" do
    Object.stub(:search)
    cli.shell.mute do
      cli.search "xxx"
    end
  end

  it "calls the list method in client class" do
    Object.stub(:list)
    cli.shell.mute do
      cli.list
    end
  end

  it "calls the list method in client class" do
    Object.stub(:list)
    cli.shell.mute do
      cli.list
    end
  end

  it "calls the check method in client class" do
    Object.stub(:check)
    cli.shell.mute do
      cli.check
    end
  end

  it "calls the version method in client class" do
    STDOUT.stub(:puts).with(Hackpad::Cli::VERSION)
    cli.shell.mute do
      cli.version
    end
  end

  it "calls the info method in client class" do
    Object.stub(:info)
    cli.shell.mute do
      cli.info 'pad'
    end
  end

  it "calls the show method in client class" do
    Object.stub(:show)
    cli.shell.mute do
      cli.show 'pad', 'md'
    end
  end

  it "calls the colors method in client class" do
    String.stub(:color_matrix).with(' xoxo ')
    cli.shell.mute do
      cli.colors
    end
  end

end
