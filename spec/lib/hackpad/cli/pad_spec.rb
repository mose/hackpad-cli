# encoding: utf-8

require 'spec_helper'
require "hackpad/cli"
require "hackpad/cli/pad"
require "hackpad/cli/api"
require "hackpad/cli/store"

describe Hackpad::Cli::Pad do

  let(:pad) { Hackpad::Cli::Pad.new "123" }

  describe ".new" do
    it { expect(pad.id).to eq "123" }
  end

  context "when the pad has no data," do
    describe ".title" do
      it { expect(pad.title).to eq nil }
    end
    describe ".chars" do
      it { expect(pad.chars).to eq nil }
    end
    describe ".lines" do
      it { expect(pad.lines).to eq nil }
    end
  end

  context "when the pad has only a content," do
    before { pad.instance_variable_set(:@content, "This\nis\nInformation!") }
    describe ".title" do
      it { expect(pad.title).to eq "This" }
    end
    describe ".chars" do
      it { expect(pad.chars).to eq 20 }
    end
    describe ".lines" do
      it { expect(pad.lines).to eq 3 }
    end
  end

  context "when a pad is cached," do
    before { Hackpad::Cli::Store.stub(:exists?).and_return true }
    context "when we don't want a refresh," do
      describe ".load" do
        context "when unknown format is asked," do
          it { expect { pad.load 'xxx'}.to raise_error(Hackpad::Cli::UnknownFormat) }
        end
        context "when pad has no id," do
          before { pad.remove_instance_variable(:@id) }
          it { expect { pad.load 'txt'}.to raise_error(Hackpad::Cli::UndefinedPad) }
        end
        context "when all is ok," do
          before { pad.stub(:load_from_cache) }
          it { expect{ pad.load 'txt' }.not_to raise_error }
        end
      end
      describe ".load_from_cache" do
        let(:meta) { { 'options' => { 'guestPolicy' => 'open', 'isModerated' => false }, 'cached_at' => 'some time' } }
        before { Hackpad::Cli::Store.stub(:read).with("123", 'txt').and_return("This\nis\nInformation!") }
        before { Hackpad::Cli::Store.stub(:read_options).with("123").and_return(meta) }
        before { pad.load_from_cache 'txt' }
        it { expect(pad.content).to eq "This\nis\nInformation!" }
        it { expect(pad.guest_policy).to eq "open" }
        it { expect(pad.moderated).to be_false }
        it { expect(pad.cached_at).to eq "some time" }
      end
    end
  end

end
