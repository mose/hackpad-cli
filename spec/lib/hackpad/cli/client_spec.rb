# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/client"

describe Hackpad::Cli::Client do
  let(:configdir) { File.expand_path('../../../../files', __FILE__) }
  let(:options) { { configdir: configdir, workspace: 'default' } }

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

  pending "Hackpad::Cli::Client.info"
  pending "Hackpad::Cli::Client.show"

end
