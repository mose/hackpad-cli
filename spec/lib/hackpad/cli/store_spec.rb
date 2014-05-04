# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/store"

describe Hackpad::Cli::Store do

  before :each do
    options = {
      "configdir" => File.expand_path('../../../files', __FILE__),
      "workspace" => 'default'
    }
    Hackpad::Cli::Store.prepare options
  end

  it "reads pads list from file" do
    File.stub(:read).and_return("gy23ui first one\ngy3u4 second one\n23489g third")
    list = Hackpad::Cli::Store.read_list
    expect(list).to be_an Array
    expect(list[0]).to be_an OpenStruct
    expect(list[0].id).to eq "gy23ui"
    expect(list[0].title).to eq "first one"
    expect(list[2].id).to eq "23489g"
    expect(list[2].title).to eq "third"
  end

end