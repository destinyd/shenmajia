module Api::V1
  class BillsController < ApiController
    doorkeeper_for :all

    def index
      @bills = respond_with current_resource_owner.bills.paginate page: params[:page]
      respond_with @bills
    end

    def show
      @bill = current_resource_owner.bills.find params[:id]
      respond_with @bill
    end

    def create
      @bill = current_resource_owner.bills.create params[:bill]
      respond_with @bill
    end

    def destroy
      @bill = current_resource_owner.bills.find(params[:id])
      @bill.destroy
      format.json  { render :json => 'destroy success', :status => :ok }
    end
  end
end
