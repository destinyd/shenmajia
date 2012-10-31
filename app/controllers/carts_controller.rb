class CartsController < ApplicationController
  layout 'no_sidebar'
  before_filter :find_place,except: :index
  def index
    if params[:place_id].blank?
      @places = Place.find session[:b].keys unless session[:b].blank?
    else
      find_place
    end
  end

  def update
    session[:b] ||= {}
    session[:b][@place.id.to_s] ||= {}
    unless session[:b][@place.id.to_s][params[:id]].blank?
      session[:b][@place.id.to_s][params[:id]].merge!(amount: params[:amount].to_f) unless params[:amount].blank?
      session[:b][@place.id.to_s][params[:id]].merge!(price: params[:price].to_f) unless params[:price].blank?
      session[:b][@place.id.to_s][params[:id]].merge!(price_id: params[:price_id].to_i) unless params[:price_id].blank?
    end
    respond_to do |format|
      format.html{redirect_to place_carts_path(@place)}
      format.js
    end
  end

  def create
    session[:b] ||= {}
    session[:b][@place.id.to_s] ||= {}
    unless params[:price_id].blank?
      @price = Price.find(params[:price_id])
      session[:b][@place.id.to_s][@price.good_id.to_s] = {amount: 1, price: @price.price,price_id:@price.id} if session[:b][@place.id.to_s][params[:price_id]].blank?
    end
    unless params[:good_id].blank?
      @good = Good.find(params[:good_id])
      session[:b][@place.id.to_s][params[:good_id]] = {amount: 1, price: 0.0} if session[:b][@place.id.to_s][params[:good_id]].blank?
    end
    respond_to do |format|
      format.html{redirect_to place_carts_path(@place)}
      format.js{render :update}
    end
  end

  def destroy
    session[:b] ||= {}
    unless session[:b][@place.id.to_s].blank?
      session[:b][@place.id.to_s].delete params[:id]
      session[:b][@place.id.to_s] = nil if session[:b][@place.id.to_s].blank?
    end
    respond_to do |format|
      format.html{redirect_to place_carts_path(@place)}
      format.js{render :update}
    end
  end

  protected
  def find_place
    @place = Place.find(params[:place_id])
  end
end
