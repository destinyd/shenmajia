require 'spec_helper'

describe SidebarCell do

  context "cell instance" do
    subject { cell(:sidebar) }

    it { should respond_to(:tuijian) }
    it { should respond_to(:near) }
    it { should respond_to(:cheap) }
  end

  context "cell rendering" do
    context "rendering tuijian" do
      subject { render_cell(:sidebar, :tuijian) }

      it { should have_selector("h1", :content => "Sidebar#tuijian") }
      it { should have_selector("p", :content => "Find me in app/cells/sidebar/tuijian.html") }
    end

    context "rendering near" do
      subject { render_cell(:sidebar, :near) }

      it { should have_selector("h1", :content => "Sidebar#near") }
      it { should have_selector("p", :content => "Find me in app/cells/sidebar/near.html") }
    end

    context "rendering cheap" do
      subject { render_cell(:sidebar, :cheap) }

      it { should have_selector("h1", :content => "Sidebar#cheap") }
      it { should have_selector("p", :content => "Find me in app/cells/sidebar/cheap.html") }
    end
  end

end
