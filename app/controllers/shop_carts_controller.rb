class ShopCartsController < ApplicationController
  layout 'home'
  #before_filter :authenticate_user!,only: [:new,:create,:update,:edit,:destroy]

  def index
  end

  def update
    session[:shop] ||= {}
    session[:shop][:items] ||= {}
    session[:shop][:items][params[:id]].merge!(amount: params[:amount].to_f) unless session[:shop][:items][params[:id]].blank? or params[:amount].blank?
    @shop = Shop.find(params[:shop_id]) unless params[:shop_id].blank?
  end

  def create
    session[:shop] ||= {}
    session[:shop][:items] ||= {}	
    unless params[:inventory_id].blank?
      @shop = Shop.find(params[:shop_id]) unless params[:shop_id].blank?
            @inventory = Inventory.find(params[:inventory_id])
            session[:shop][:items][params[:inventory_id]] = {
      name: @inventory.name, 
      amount: 1, 
      price: @inventory.price.price
      } if session[:shop][:items][params[:inventory_id]].blank?
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js {
        render :update
      }
    end

      end

  def destroy
  	session[:shop] ||= {}
  	session[:shop][:items].delete params[:id] unless session[:shop][:items].blank?
    @shop = Shop.find(params[:shop_id]) unless params[:shop_id].blank?    
  	render :update
  end
end
