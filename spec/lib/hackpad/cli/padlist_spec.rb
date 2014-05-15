# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/padlist"

describe Hackpad::Cli::Padlist do

  describe ".get_list" do

    context "when no refresh is asked and cache exists" do
      before { Hackpad::Cli::Store.stub(:exists?).and_return(true) }
      before { Hackpad::Cli::Store.stub(:read_list).and_return(Array.new) }
      it { expect(subject.get_list).to be_an(Array) }
    end

    context "when no refresh is asked and cache don't exist" do
      let(:pad1) { OpenStruct.new( id: "123", title: "title1" ) }
      let(:pad2) { OpenStruct.new( id: "456", title: "title2" ) }
      let(:output) { StringIO.new }
      before { Hackpad::Cli::Api.stub(:list).and_return(["123","456"]) }
      before { Hackpad::Cli::Store.stub(:exists?).and_return(false, false) }
      before { Hackpad::Cli::Padlist.stub(:get_pad).and_return(pad1, pad2) }
      before { Hackpad::Cli::Store.stub(:save_list) }
      it { expect(subject.get_list(false,output)).to be_an(Array) }
      it { expect(subject.get_list(false,output).count).to be 2 }
      it { expect(subject.get_list(false,output)[1].title).to eq "title2" }
    end

  end

  describe ".check_list" do
  end

end
