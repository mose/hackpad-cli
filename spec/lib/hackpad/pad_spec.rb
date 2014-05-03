# encoding: utf-8

require 'spec_helper'
require "hackpad/pad"

describe Hackpad::Pad do

  before :each do
    @pad = Hackpad::Pad.new "123", "content\nand body", { 'guestPolicy' => 'domain', 'isModerated' => nil }
  end

  it "creates a new pad object" do
    expect(@pad.id).to eq "123"
    expect(@pad.content).to eq "content\nand body"
    expect(@pad.guest_policy).to eq "domain"
    expect(@pad.moderated).to be false
  end

  it "Can extract the title" do
    expect(@pad.title).to eq "content"
  end
  it "Can count chars from content" do
    expect(@pad.chars).to be 16
  end
  it "Can count lines from content" do
    expect(@pad.lines).to be 2
  end

end
