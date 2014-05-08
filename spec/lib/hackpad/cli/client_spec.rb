# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/client"

describe Hackpad::Cli::Client do
  let(:configdir) { File.expand_path('../../../../files', __FILE__) }

  describe ".new" do
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load) }

    context "when default options are passed," do
      let(:options) { {
        configdir: configdir,
        workspace: 'default'
      } }
      let(:client) { Hackpad::Cli::Client.new options }
      it { expect(client).to be_a Hackpad::Cli::Client }
      context "when colorization is expected," do
        it { expect("x".blue).to eq "\e[0;34;49mx\e[0m" }
      end
    end

    context "when plain text is required," do
      let(:options) { {
        configdir: configdir,
        workspace: 'default',
        plain: true
      } }
      context "when colorization is not expected," do
        before { Hackpad::Cli::Client.new options }
        it { expect("x".blue).to eq "x" }
      end
    end
  end

  describe ".search" do
    let(:options) { {
      configdir: configdir,
      workspace: 'default'
    } }
    before { Hackpad::Cli::Api.stub(:prepare) }
    before { Hackpad::Cli::Store.stub(:prepare) }
    before { Hackpad::Cli::Config.stub(:load).and_return({'site' => 'http://test.dev'}) }
    before {
      Hackpad::Cli::Api.stub(:search).with("xxx",0).and_return(
        [ {
          "title" => "xtitle",
          "id" => "xxxxxx",
          "snippet" => "context <b>x</b> context"
        } ]
      )
    }
    context "when default options are used," do
      let(:client) { Hackpad::Cli::Client.new options }
      it {
        expect(STDOUT).to receive(:puts).with("xxxxxx - xtitle")
        expect(STDOUT).to receive(:puts).with("   context <b>x</b> context")
        client.search "xxx"
      }
    end
    context "when options sets urls to true," do
      let(:options) { {
        configdir: configdir,
        workspace: 'default',
        urls: true
      } }
      let(:client) { Hackpad::Cli::Client.new options }
      it {
        expect(STDOUT).to receive(:puts).with("http://test.dev/xxxxxx - xtitle")
        expect(STDOUT).to receive(:puts).with("   context <b>x</b> context")
        client.search "xxx"
      }
    end
  end

  pending "Hackpad::Cli::Client.search"
  pending "Hackpad::Cli::Client.list"
  pending "Hackpad::Cli::Client.info"
  pending "Hackpad::Cli::Client.show"

end
