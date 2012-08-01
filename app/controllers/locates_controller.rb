class LocatesController < ApplicationController
  layout 'home'
  def index
  end

  # 类似搜索
  def show  
    @name = params[:id]
    if @name.strip!
      redirect_to locate_path(@name)
    elsif City.where(:name => @name).first
      redirect_to city_path(@name)
    else
      @locate = Locate.where(:name => @name).first
      @locate = Locate.create(:name => @name)

      @value = @locate.lat,@locate.lon
      render 'cities/show'
    end
  end

  def new
  end

  def create
    @geo = City.where(:name => params[:id]).first
    get_city_name @geo
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
