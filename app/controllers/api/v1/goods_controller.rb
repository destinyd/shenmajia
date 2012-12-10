module Api::V1
  class GoodsController < ApiController
    doorkeeper_for :all

    def index
      if !params[:place_id].blank?
        @goods = Place.find(params[:place_id]).goods.list.paginate(page: params[:page])
      else
        @goods = Good.list.paginate(page: params[:page])
      end
      respond_with @goods
    end

    def show
      @good = Good.find(params[:id])
      respond_with @good
    end

    def create
      @good = current_resource_owner.goods.create params[:good]
      render json: @good
    end

    def search
      @goods = Good.search(params[:q]).list.paginate(page: params[:page])
      render json: @goods
    end
  end
end
