class CartsController < ApplicationController
  def index
  end

  def update
  	session[:cart] ||= {}
  	session[:cart][:items] ||= {}
    unless session[:cart][:items][params[:id]].blank?
    	session[:cart][:items][params[:id]].merge!(amount: params[:amount].to_f) unless params[:amount].blank?
      session[:cart][:items][params[:id]].merge!(price: params[:price].to_f) unless params[:price].blank?
    end
  end

  def create
  	session[:cart] ||= {}
  	session[:cart][:items] ||= {}  	
  	unless params[:good_id].blank?
  		@good = Good.find(params[:good_id])
  		session[:cart][:items][params[:good_id]] = {name: @good.name, amount: 1, price: 0} if session[:cart][:items][params[:good_id]].blank?
  	end
    render :update
  end

  def destroy
  	session[:cart] ||= {}
  	session[:cart][:items].delete params[:id]
  	render :update
  end
end
