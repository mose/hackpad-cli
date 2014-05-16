# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/client"

describe Hackpad::Cli::Client do
  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:options) { { configdir: configdir, workspace: 'default' } }
  let(:format) { "%-20s %s\n" }

  describe ".new" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load) }

    context "when default options are passed," do
      let(:client) { Hackpad::Cli::Client.new options }
      it { expect(client).to be_a Hackpad::Cli::Client }
      context "when colorization is expected," do
        it { expect("x".blue).to eq "\e[0;34;49mx\e[0m" }
      end
    end

    context "when plain text is required," do
      context "when colorization is not expected," do
        before { Hackpad::Cli::Client.new options.merge({plain: true}) }
        after { load "colorize.rb" }
        it { expect("x".blue).to eq "x" }
      end
    end
  end

  describe ".stats" do
    let(:timestamp) { Time.new(2013, 10, 2) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    before { Hackpad::Cli::Store.stub(:count_pads).and_return(12) }
    before { Hackpad::Cli::Store.stub(:last_refresh).and_return(timestamp) }
    let(:client) { Hackpad::Cli::Client.new options }
    it {
      expect(STDOUT).to receive(:printf).with(format, "Site", "\e[0;34;49mhttp://test.dev\e[0m")
      expect(STDOUT).to receive(:printf).with(format, "Cached Pads", 12)
      expect(STDOUT).to receive(:printf).with(format, "Last Refresh", timestamp)
      client.stats
    }
  end

  describe ".search" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    before {
      Hackpad::Cli::Api.stub(:search).with("xxx",0).and_return(
        [ {
          "title" => "xtitle",
          "id" => "xxxxxx",
          "snippet" => "context <b class=\"hit\">x</b> context"
        } ]
      )
    }
    context "when default options are used," do
      let(:client) { Hackpad::Cli::Client.new options }
      it {
        expect(STDOUT).to receive(:puts).with("\e[1;39;49mxxxxxx\e[0m - \e[0;33;49mxtitle\e[0m")
        expect(STDOUT).to receive(:puts).with("   context \e[1;36;49mx\e[0m context")
        client.search "xxx"
      }
    end
    context "when options sets urls to true," do
      let(:client) { Hackpad::Cli::Client.new options.merge({urls: true}) }
      it {
        expect(STDOUT).to receive(:puts).with("http://test.dev/\e[1;39;49mxxxxxx\e[0m - \e[0;33;49mxtitle\e[0m")
        expect(STDOUT).to receive(:puts).with("   context \e[1;36;49mx\e[0m context")
        client.search "xxx"
      }
    end
  end

  describe ".list" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    before { Hackpad::Cli::Padlist.stub(:get_list).and_return( [ OpenStruct.new( id: 'xxxxxx', title: 'xtitle' ) ] ) }
    context "when default options are used," do
      let(:client) { Hackpad::Cli::Client.new options }
      it {
        expect(STDOUT).to receive(:puts).with(["xxxxxx - xtitle"])
        client.list
      }
    end
    context "when options sets urls to true," do
      let(:client) { Hackpad::Cli::Client.new options.merge({urls: true}) }
      it {
        expect(STDOUT).to receive(:puts).with(["http://test.dev/xxxxxx - xtitle"])
        client.list
      }
    end
  end

  describe ".check" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }

    context "when there is a new pad," do
      before { Hackpad::Cli::Padlist.stub(:check_list).and_return( [ OpenStruct.new( id: 'xxxxxx', title: 'xtitle' ) ] ) }
      context "when default options are used," do
        let(:client) { Hackpad::Cli::Client.new options }
        it {
          expect(STDOUT).to receive(:puts).with("New pads:")
          expect(STDOUT).to receive(:puts).with(["xxxxxx - xtitle"])
          client.check
        }
      end
      context "when options sets urls to true," do
        let(:client) { Hackpad::Cli::Client.new options.merge({urls: true}) }
        it {
          expect(STDOUT).to receive(:puts).with("New pads:")
          expect(STDOUT).to receive(:puts).with(["http://test.dev/xxxxxx - xtitle"])
          client.check
        }
      end
    end
    context "when there is no new pad," do
      before { Hackpad::Cli::Padlist.stub(:check_list).and_return( [] ) }
      let(:client) { Hackpad::Cli::Client.new options }
      it {
        expect(STDOUT).to receive(:puts).with("New pads:")
        expect(STDOUT).to receive(:puts).with("There is no new pad.")
        client.check
      }
    end
  end

  describe ".info" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    let(:client) { Hackpad::Cli::Client.new options }
    let(:pad) { double Hackpad::Cli::Pad }
    before { Hackpad::Cli::Pad.stub(:new).with("123").and_return pad }

    context "when unknown id is given," do
      before { pad.stub(:load).and_raise Hackpad::Cli::UndefinedPad }
      it { expect{client.info("123")}.to raise_error(Hackpad::Cli::UndefinedPad) }
    end

    context "when id is an existing pad," do
      before { pad.stub(:load) }
      before { pad.stub(:title).and_return("title1") }
      before { pad.stub(:chars).and_return(20) }
      before { pad.stub(:lines).and_return(2) }
      before { pad.stub(:guest_policy).and_return("open") }
      before { pad.stub(:moderated).and_return("false") }
      before { pad.stub(:cached_at).and_return() }
      it {
        expect(STDOUT).to receive(:printf).with(format, "Id", "\e[1;39;49m123\e[0m")
        expect(STDOUT).to receive(:printf).with(format, "Title", "\e[0;33;49mtitle1\e[0m")
        expect(STDOUT).to receive(:printf).with(format, "URI", "http://test.dev/123")
        expect(STDOUT).to receive(:printf).with(format, "Chars", "20")
        expect(STDOUT).to receive(:printf).with(format, "Lines", "2")
        expect(STDOUT).to receive(:printf).with(format, "Guest Policy", "open")
        expect(STDOUT).to receive(:printf).with(format, "Moderated", "false")
        expect(STDOUT).to receive(:printf).with(format, "Cached", "unknown")
        client.info "123"
      }
    end

  end

  describe ".show" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    let(:client) { Hackpad::Cli::Client.new options }
    let(:pad) { double Hackpad::Cli::Pad }
    before { Hackpad::Cli::Pad.stub(:new).with("123").and_return pad }
    before { pad.stub(:load) }

    context "when a txt version is asked," do
      before { pad.stub(:content).and_return("this is content") }
      it {
        expect(STDOUT).to receive(:puts).with("this is content")
        client.show "123", "txt"
      }
    end

    context "when a html version is asked," do
      before { pad.stub(:content).and_return("<ul><li>this is content</li></ul>") }
      it {
        expect(STDOUT).to receive(:puts).with("<ul><li>this is content</li></ul>")
        client.show "123", "html"
      }
    end

    context "when a markdown version is asked," do
      before { pad.stub(:content).and_return("<ul><li>this is content</li></ul>") }
      before {
        ReverseMarkdown.stub(:convert).
          with("<ul><li>this is content</li></ul>", github_flavored: true).
          and_return("- this is content") }
      it {
        expect(STDOUT).to receive(:puts).with("- this is content")
        client.show "123", "md"
      }
    end

  end

end
