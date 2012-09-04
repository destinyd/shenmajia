require 'spec_helper'

describe "inventories/show" do
  before(:each) do
    @inventory = assign(:inventory, stub_model(Inventory))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
