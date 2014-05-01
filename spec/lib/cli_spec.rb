# encoding: utf-8

require 'spec_helper'
require "hackpad/cli"
require "hackpad/client"

describe Hackpad::Cli do

  before :each do
    @cli = Hackpad::Cli.new
  end

  it "calls the search method in client class" do
    Hackpad::Client.stub(:new, {}).and_return(Object)
    Object.stub(:search)
    @cli.shell.mute do
      @cli.search "xxx"
    end
  end

  it "calls the list method in client class" do
    Hackpad::Client.stub(:new, {}).and_return(Object)
    Object.stub(:list)
    @cli.shell.mute do
      @cli.list
    end
  end

  it "calls the list method in client class" do
    Hackpad::Client.stub(:new, {}).and_return(Object)
    Object.stub(:list)
    @cli.shell.mute do
      @cli.list
    end
  end

  it "calls the info method in client class" do
    Hackpad::Client.stub(:new, {}).and_return(Object)
    Object.stub(:info)
    @cli.shell.mute do
      @cli.info 'pad'
    end
  end

  it "calls the show method in client class" do
    Hackpad::Client.stub(:new, {}).and_return(Object)
    Object.stub(:show)
    @cli.shell.mute do
      @cli.show 'pad', 'md'
    end
  end

end
