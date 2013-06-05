module Api::V1
  class CostsController < ApiController
    doorkeeper_for :all

    def index
      @costs = respond_with current_resource_owner.costs.recent.page params[:page]
    end

    def show
      @cost = respond_with current_resource_owner.costs.find(params[:id])
    end

    def create
      @cost = current_resource_owner.costs.create params[:cost]
      respond_with @cost
    end

  end
end
