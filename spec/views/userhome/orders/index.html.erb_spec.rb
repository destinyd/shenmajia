require 'spec_helper'

describe "userhome_orders/index" do
  before(:each) do
    assign(:userhome_orders, [
      stub_model(Userhome::Order),
      stub_model(Userhome::Order)
    ])
  end

  it "renders a list of userhome_orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
