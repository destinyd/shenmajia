module Api::V1
  class CredentialsController < ApiController
    doorkeeper_for :all

    def me
      respond_with current_resource_owner
    end

    def dashboard
      render :json => {
        bills_count: current_resource_owner.bills.count,
        costs_sum: current_resource_owner.costs.sum(&:money)
      }, :status => :ok
    end
  end
end
