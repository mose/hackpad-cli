# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/store"

describe Hackpad::Cli::Store do

  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:options) { { "configdir" => configdir, "workspace" => 'default' } }

  before :each do
    subject.prepare options
  end

  describe ".read_list" do
    before { File.stub(:read).and_return("gy23ui first one\ngy3u4 second one\n23489g third") }
    let(:list) { subject.read_list }
    it { expect(list).to be_an Array }
    it { expect(list[0]).to be_an OpenStruct }
    it { expect(list[0].id).to eq "gy23ui" }
    it { expect(list[0].title).to eq "first one" }
    it { expect(list[2].id).to eq "23489g" }
    it { expect(list[2].title).to eq "third" }
  end

  describe ".exists?" do

    context "when refresh option is set," do
      let(:options) { { "configdir" => configdir, "workspace" => 'default', 'refresh' => true } }
      before {
        subject.prepare options
        FileUtils.touch File.join(configdir, 'default', 'pads', 'txt', 'xxx')
      }
      after { FileUtils.rm File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
      it { expect(subject.exists? 'txt', 'xxx').to be false }
    end

    context "when refresh option is not set," do
      context "when config file don't exist," do
        it { expect(subject.exists? 'txt', 'xxx').to be false }
      end

      context "when configfile exists," do
        before { FileUtils.touch File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
        after { FileUtils.rm File.join(configdir, 'default', 'pads', 'txt', 'xxx') }
        it { expect(subject.exists? 'txt', 'xxx').to be true }
      end
    end

  end

end
