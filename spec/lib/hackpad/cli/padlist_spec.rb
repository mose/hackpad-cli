# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/padlist'

describe Hackpad::Cli::Padlist do

  describe '.get_list' do
    let(:output) { StringIO.new }

    context 'when no refresh is asked and cache exists,' do
      before { Hackpad::Cli::Store.stub(:exist?).and_return(true) }
      before { Hackpad::Cli::Store.stub(:read_list).and_return(Array.new) }
      it { expect(subject.get_list).to be_an(Array) }
    end

    context "when no refresh is asked and cache don't exist," do
      let(:pad1) { OpenStruct.new(id: '123', title: 'title1') }
      let(:pad2) { OpenStruct.new(id: '456', title: 'title2') }
      before { Hackpad::Cli::Api.stub(:list).and_return(%w(123 456)) }
      before { Hackpad::Cli::Store.stub(:exist?).and_return(false, false) }
      before { Hackpad::Cli::Padlist.stub(:get_pad).and_return(pad1, pad2) }
      before { Hackpad::Cli::Store.stub(:save_list) }
      it { expect(subject.get_list(false, output)).to be_an(Array) }
      it { expect(subject.get_list(false, output).count).to be 2 }
      it { expect(subject.get_list(false, output)[1].title).to eq 'title2' }
    end

  end

  describe '.get_pad' do
    context 'when no refresh is asked,' do
      let(:pad1) { OpenStruct.new(id: '123', title: 'title1') }
      let(:pad) { double Hackpad::Cli::Pad }
      before { Hackpad::Cli::Pad.stub(:new).and_return pad }
      before { pad.stub(:load) }
      before { pad.stub(:title).and_return('title1') }
      it { expect(subject.get_pad('123')).to eq pad1 }
    end
  end

  describe '.check_list' do
    before { Hackpad::Cli::Api.stub(:list).and_return(%w(123 456)) }
    let(:pad) { double Hackpad::Cli::Pad }
    before { Hackpad::Cli::Pad.stub(:new).and_return(pad, pad) }

    context 'when there is no new pad,' do
      before { pad.stub(:cached?).and_return(true, true) }
      it { expect(subject.check_list).to eq [] }
    end

    context 'when there is no one new pad,' do
      let(:pad2) { OpenStruct.new(id: '456', title: 'title2') }
      before { pad.stub(:cached?).and_return(true, false) }
      before { pad.stub(:load) }
      before { pad.stub(:title).and_return('title2') }
      it { expect(subject.check_list).to eq [pad2] }
    end

    context 'when there is no 2 new pads,' do
      let(:pad1) { OpenStruct.new(id: '123', title: 'title1') }
      let(:pad2) { OpenStruct.new(id: '456', title: 'title2') }
      before { pad.stub(:cached?).and_return(false, false) }
      before { pad.stub(:load).and_return(nil, nil) }
      before { pad.stub(:title).and_return('title1', 'title2') }
      it { expect(subject.check_list).to eq [pad1, pad2] }
    end
  end

end
