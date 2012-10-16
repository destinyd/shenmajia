class Shop::HomesController < ApplicationController
  layout 'userhome'
  before_filter :authenticate_user!,except: [:index,:show]
  def index
    @shop = current_shop
  end

  def edit
    @shop = current_shop
  end

  #def costs
    #@costs=current_user.prices.where(type_id: [0,1])
    #@cost_months = @costs.group_by{|a| a.created_at.beginning_of_month}
  #end


  def integrals
    @integrals=current_user.integrals
    @integrals_count = @integrals.sum(:point)
  end
end
