require "spec_helper"

describe Userhome::OrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/userhome_orders").should route_to("userhome_orders#index")
    end

    it "routes to #new" do
      get("/userhome_orders/new").should route_to("userhome_orders#new")
    end

    it "routes to #show" do
      get("/userhome_orders/1").should route_to("userhome_orders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/userhome_orders/1/edit").should route_to("userhome_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/userhome_orders").should route_to("userhome_orders#create")
    end

    it "routes to #update" do
      put("/userhome_orders/1").should route_to("userhome_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/userhome_orders/1").should route_to("userhome_orders#destroy", :id => "1")
    end

  end
end
