class CartsController < ApplicationController
  before_filter :find_place,except: :index
  def index
  end

  def update
    session[:b] ||= {}
    unless session[:b][params[:id]].blank?
      session[:b][params[:id]].merge!(amount: params[:amount].to_f) unless params[:amount].blank?
      session[:b][params[:id]].merge!(price: params[:price].to_f) unless params[:price].blank?
      session[:b][params[:id]].merge!(price_id: params[:price_id].to_i) unless params[:price_id].blank?
    end
  end

  def create
    session[:b] ||= {}
    unless params[:price_id].blank?
      @price = Price.find(params[:price_id])
      session[:b][@price.good_id.to_s] = {amount: 1, price: @price.price,price_id:@price.id} if session[:b][params[:price_id]].blank?
    end
    unless params[:good_id].blank?
      @good = Good.find(params[:good_id])
      session[:b][params[:good_id]] = {amount: 1, price: 0.0} if session[:b][params[:good_id]].blank?
    end
    render :update
  end

  def destroy
    session[:b] ||= {}
    session[:b].delete params[:id]
    render :update
  end

  protected
  def find_place
    @place = Place.find(params[:place_id])
  end
end
