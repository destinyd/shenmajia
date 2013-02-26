require 'spec_helper'

describe UserCell do

  context "cell instance" do
    subject { cell(:users) }

    it { should respond_to(:login) }
    it { should respond_to(:where) }
  end

  context "cell rendering" do
    context "rendering login" do
      subject { render_cell(:users, :login) }

      it { should have_selector("h1", :content => "Users#login") }
      it { should have_selector("p", :content => "Find me in app/cells/users/login.html") }
    end

    context "rendering where" do
      subject { render_cell(:users, :where) }

      it { should have_selector("h1", :content => "Users#where") }
      it { should have_selector("p", :content => "Find me in app/cells/users/where.html") }
    end
  end

end
