require 'spec_helper'

describe "inventories/index" do
  before(:each) do
    assign(:inventories, [
      stub_model(Inventory),
      stub_model(Inventory)
    ])
  end

  it "renders a list of inventories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
