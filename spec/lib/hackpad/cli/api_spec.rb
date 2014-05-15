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

  pending ".list"
  pending ".read_options"
  pending ".read"

  describe ".get" do
    let(:config) { { 'site' => 'http://x.hackpad.com', 'client_id' => '123', 'secret' => 'aaa' } }
    before { Hackpad::Cli::Api.prepare config }
    context "when proper crendetial are provided" do
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
  end

end
