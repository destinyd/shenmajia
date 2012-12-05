module Api::V1
  class BillsController < ApiController
    doorkeeper_for :all

    def index
      @bills = respond_with current_resource_owner.bills.paginate page: params[:page]
      respond_with @bills
    end

    def show
      @bill = respond_with current_resource_owner.bills.find(params[:id])
      respond_with @bill
    end

    def create
      @bill = current_resource_owner.bills.new params[:bill],on: :api
      @bill.locatable = @place = Place.find(params[:place_id])
      unless params[:bill_prices].blank?
        params[:bill_prices].each do |key,item|
          bp = @bill.bill_prices.new
          bp.amount = item[:amount]
          unless item[:image].blank?
            bp.image = params[:image][key]
            @bill.picture_count +=1 unless params[:image][key].blank?
          end
          if item[:price_id]
            bp.price_id = item[:price_id]
          else
            bp.price = Price.where(
              locatable_type: 'Place',
              locatable_id: params[:place_id],
              good_id: key,
              price: item[:price],
              lat: @bill.locatable.lat,
              lon: @bill.locatable.lon,
              city_id: @bill.locatable.city_id
            ).first_or_create({type_id: 0,user_id: @bill.user_id}, on: :bill)
          end
        end
      end
      @bill.save!
      respond_with @bill
    end

  end
end
