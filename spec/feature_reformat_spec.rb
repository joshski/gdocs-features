require File.dirname(__FILE__) + '/spec_helper'

$reformatted = %{Feature: Washing up

  In order to reduce infection
  As a user of kitchenware
  I want to wash up after use

    Scenario: Wash dishes

      Given there is a dish
      And it is dirty
      Then I should wash it up

    Scenario: Dishwasher

      Given there are lots of dirty dishes
      When I put them into the dishwasher
      And I turn it on
      Then it should wash the dishes}

require 'feature'

describe Feature, "reformat" do
  
  class StubFeature < Feature
    def body
      $reformatted.map { |line| line.strip }.reject { |l| l == "" }
    end
    
    def version
      123
    end
  end
  
  it "should reformat feature body" do
    StubFeature.new.reformat.should == $reformatted
  end
  
end