require 'spec_helper'

describe "menus/index" do
  before(:each) do
    assign(:menus, [
      stub_model(Menu,
        :image => "Image",
        :page => 1
      ),
      stub_model(Menu,
        :image => "Image",
        :page => 1
      )
    ])
  end

  it "renders a list of menus" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
