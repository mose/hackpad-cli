# encoding: utf-8

require 'spec_helper'
require 'hackpad/cli/store'
require 'hackpad/cli/pad'

describe Hackpad::Cli::Store do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:options) { { configdir: configdir, workspace: 'default' } }

  before :each do
    subject.prepare options
  end

  describe '.read_list' do
    before { File.stub(:read).and_return("gy23ui first one\ngy3u4 second one\n23489g [some time] third") }
    let(:list) { subject.read_list }
    it { expect(list).to be_an Array }
    it { expect(list[0]).to be_an OpenStruct }
    it { expect(list[0].id).to eq 'gy23ui' }
    it { expect(list[0].title).to eq 'first one' }
    it { expect(list[2].id).to eq '23489g' }
    it { expect(list[2].title).to eq 'third' }
    it { expect(list[2].cached_at).to eq 'some time' }
  end

  describe '.exists?' do

    context 'when refresh option is set,' do
      let(:options) { { configdir: configdir, workspace: 'default', refresh: true } }
      before do
        subject.prepare options
        FileUtils.touch File.join(configdir, 'default', 'pads', 'txt', 'xxx')
      end
      after { FileUtils.rm File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
      it { expect(subject.exists? 'txt', 'xxx').to be false }
    end

    context 'when refresh option is not set,' do
      context "when config file don't exist," do
        it { expect(subject.exists? 'txt', 'xxx').to be false }
      end

      context 'when configfile exists,' do
        before { FileUtils.touch File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
        after { FileUtils.rm File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
        it { expect(subject.exists? 'txt', 'xxx').to be true }
      end
    end

  end

  describe '.save' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
    let(:content) { "This is content\n" }
    before { subject.prepare options }
    let(:pad) { double Hackpad::Cli::Pad }
    before { pad.stub(:id).and_return 'xxx' }
    before { pad.stub(:content).and_return content }
    after { FileUtils.rm padfile }
    it do
      subject.save pad, 'txt'
      expect(File.read(padfile)).to eq content
    end
  end

  describe '.save_options' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'meta', 'xxx') }
    let(:content) { { thing: '123', other: 'option' } }
    before { subject.prepare options }
    after { FileUtils.rm padfile }
    it do
      subject.save_options 'xxx', content
      expect(File.read(padfile)).to eq "{\n  \"thing\": \"123\",\n  \"other\": \"option\"\n}\n"
    end
  end

  describe '.save_list' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'padlist') }
    let(:pads) { [OpenStruct.new(id: '123', cached_at: 'some time', title: 'title1')] }
    before { subject.prepare options }
    after { FileUtils.rm padfile }
    it do
      subject.save_list pads
      expect(File.read(padfile)).to eq "123 [some time] title1\n"
    end
  end

  describe '.read' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
    let(:content) { "This is content\n" }
    before { subject.prepare options }
    let(:pad) { double Hackpad::Cli::Pad }
    before { pad.stub(:id).and_return 'xxx' }
    before { pad.stub(:content).and_return content }
    before { subject.save pad, 'txt' }
    after { FileUtils.rm padfile }

    it { expect(subject.read 'xxx', 'txt').to eq content }
  end

  describe '.read_option' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'meta', 'xxx') }
    let(:content) { { 'thing' => '123', 'other' => 'option' } }
    before { subject.prepare options }
    before { subject.save_options 'xxx', content }
    after { FileUtils.rm padfile }
    it { expect(subject.read_options 'xxx').to eq content }
  end

  describe '.count_pads' do
    let(:padfile) { File.join(configdir, 'default', 'pads', 'meta', 'xxx') }
    let(:content) { { 'thing' => '123', 'other' => 'option' } }
    before { subject.prepare options }
    before { subject.save_options 'xxx', content }
    after { FileUtils.rm padfile }
    it { expect(subject.count_pads).to be 1 }
  end

  describe '.last_refresh' do
    let(:timestamp) { Time.new(2012, 10, 31) }
    let(:padlist) { File.join(configdir, 'default', 'pads', 'padlist') }
    let(:pads) { [OpenStruct.new(id: '123', cached_at: 'some time', title: 'title1')] }
    before { subject.prepare options }
    before do
      subject.save_list pads
      FileUtils.touch padlist, mtime: timestamp
    end
    after { FileUtils.rm padlist }
    it { expect(subject.last_refresh).to eq timestamp }
  end

end
