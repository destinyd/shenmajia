class LocatesController < ApplicationController
  layout 'home'
  def new
  end

  def create
    @geo = City.where(name: params[:id]).first
    get_city_name @geo
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
