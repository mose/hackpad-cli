# encoding: utf-8

require 'spec_helper'
require "hackpad/cli"
require "hackpad/cli/pad"
require "hackpad/cli/api"
require "hackpad/cli/store"

describe Hackpad::Cli::Pad do

  before :each do
    Hackpad::Cli::Api.stub(:read).with('123', 'txt').and_return("content\nand body")
    Hackpad::Cli::Api.stub(:read_options).with('123').and_return({"success" => "true"})
    options = {
      "configdir" => File.expand_path('../../../files', __FILE__),
      "workspace" => 'default'
    }
    Hackpad::Cli::Store.prepare options
    @pad = Hackpad::Cli::Pad.new "123"
    @pad.load 'txt'
  end

  after :each do
    FileUtils.rm_rf File.expand_path('../../../files/default', __FILE__)
  end

  it "creates a new pad object" do
    expect(@pad.id).to eq "123"
  end

  it "Can extract the title" do
    expect(@pad.title).to eq "content"
  end
  it "Can count chars from content" do
    expect(@pad.chars).to be 16
  end
  it "Can count lines from content" do
    expect(@pad.lines).to be 2
  end

end
