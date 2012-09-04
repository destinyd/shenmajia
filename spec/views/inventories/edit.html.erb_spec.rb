require 'spec_helper'

describe "inventories/edit" do
  before(:each) do
    @inventory = assign(:inventory, stub_model(Inventory))
  end

  it "renders the edit inventory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => inventories_path(@inventory), :method => "post" do
    end
  end
end
