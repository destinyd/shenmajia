module Api::V1
  class GoodsController < ApiController
    doorkeeper_for :all

    def index
      @goods = respond_with Good.list.paginate(page: params[:page])
    end

    def show
      @good = respond_with Good.find(params[:id])
    end

    def create
      @good = current_resource_owner.goods.create params[:good]
      render json: @good
    end

    def search
      @goods = Good.search(params[:q]).list.paginate(page: params[:page])
      respond_with @goods
    end
  end
end
