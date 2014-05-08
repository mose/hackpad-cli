# encoding: utf-8

require 'spec_helper'
require "hackpad/cli/config"

describe Hackpad::Cli::Config do

  before :each do
    @configdir = File.expand_path('../../../../files', __FILE__)
    @configfile = File.join(@configdir, 'default.yml')
    @options = {
      configdir: @configdir,
      workspace: 'default'
    }
  end

  after :each do
    FileUtils.rm @configfile if File.exists? @configfile
  end

  describe ".load" do
    let(:config) { {'xx' => 'oo'} }

    context "when there is no config file" do
      it "calls for setup" do
        subject.stub(:setup).with(@configfile)
        File.open(@configfile, "w") do |f|
          f.write YAML::dump(config)
        end
        expect(subject.load @options).to eq config
      end
    end

  end

  describe ".setup" do
    context "when normal input is provided" do
      module Kernel; def puts(x); end; def print(x); end;end
      it "handles setup interactively" do
        STDIN.stub(:gets).and_return("client_id","secret","site")
        subject.send :setup, @configfile
        expect(File.read @configfile).to eq "---\nclient_id: client_id\nsecret: secret\nsite: site\n"
      end
    end
  end

end
