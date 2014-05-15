# encoding: utf-8

require 'spec_helper'
require 'webmock/rspec'
require "hackpad/cli/api"

describe Hackpad::Cli::Api do

  pending ".prepare"

  describe ".search" do
    let(:config) { { 'site' => 'http://x.hackpad.com', 'client_id' => '123', 'secret' => 'aaa' } }
    before { Hackpad::Cli::Api.prepare config }
    context "when just a simple term is provided," do
      it "returns expected json" do
        stub_request(:get, "http://x.hackpad.com/api/1.0/search?limit=100&q=term&start=0").
          to_return(body: '[{"title":"API 1.0 Docs","id":"C0E68BD495E9","snippet":"example"}]', status: 200)
        expect(subject.search('term')).to eq([{ "title" => "API 1.0 Docs", "id" => "C0E68BD495E9", "snippet" => "example" }])
      end
    end
  end

  describe ".list" do
    let(:config) { { 'site' => 'http://x.hackpad.com', 'client_id' => '123', 'secret' => 'aaa' } }
    before { Hackpad::Cli::Api.prepare config }
    context "when just a simple term is provided," do
      it "returns expected json" do
        stub_request(:get, "http://x.hackpad.com/api/1.0/pads/all").
          to_return(body: '["aaa","bbb"]', status: 200)
        expect(subject.list).to eq(["aaa","bbb"])
      end
    end
  end

  pending ".read_options"

  describe ".read" do
    let(:config) { { 'site' => 'http://x.hackpad.com', 'client_id' => '123', 'secret' => 'aaa' } }
    before { Hackpad::Cli::Api.prepare config }
    context "when just a simple term is provided," do
      it "returns expected json" do
        stub_request(:get, "http://x.hackpad.com/api/1.0/pad/aaa/content.html").
          to_return(body: '<b>blah</b>', status: 200)
        expect(subject.read("aaa","html")).to eq("<b>blah</b>")
      end
    end
  end

  describe ".get" do
    let(:config) { { 'site' => 'http://x.hackpad.com', 'client_id' => '123', 'secret' => 'aaa' } }
    before { Hackpad::Cli::Api.prepare config }
    context "when proper crendential are provided" do
      it "all goes well" do
        stub_request(:get, "http://x.hackpad.com/api/1.0/xxx").
          with( :headers => {
            'Accept'=>'*/*',
            'Authorization'=> /OAuth oauth_consumer_key="123"/,
            'User-Agent'=> /hackpad-cli v#{Hackpad::Cli::VERSION}/
          }).
          to_return(status: 200, body: '{"some": "result"}')
        expect(Hackpad::Cli::Api.get("/api/1.0/xxx")).to eq({ 'some' => 'result' })
      end
    end
    context "when api endpoint is not found" do
      it "throws an exception" do
        stub_request(:get, "http://x.hackpad.com/api/1.0/xxx").
          with( :headers => {
            'Accept'=>'*/*',
            'Authorization'=> /OAuth oauth_consumer_key="123"/,
            'User-Agent'=> /hackpad-cli v#{Hackpad::Cli::VERSION}/
          }).
          to_return(status: 404, body: '{"some": "result"}')
        expect{ Hackpad::Cli::Api.get("/api/1.0/xxx")}.to raise_error(Hackpad::Cli::ApiException, "HTTP error, code 404")
      end

    end

  end

end
