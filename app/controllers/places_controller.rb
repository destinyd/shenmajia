class PlacesController < InheritedResources::Base
  before_filter :authenticate_user!,:only => [:new,:create]
  actions :all, :except => [:edit,:update,:destroy]
  #belongs_to :city,:finder => :find_by_name!, :optional => true
  #belongs_to :place, :optional => true
  respond_to :html

  def show
    @place = Place.find(params[:id])
    @jiepang = Jiepang.new
    @j = @jiepang.locations_show @place.guid
    @photos = @jiepang.locations_photos @place.guid
    super
  end

  def search
    require 'jiepang'
    @page = params[:page] ? params[:page].to_i : 1
    @where_name = params[:q]
    @where = request.url
    args = {:q => params[:q],:page => params[:page],:lat => cookies["lat"],:lon => cookies["lon"]}
    @jiepang = Jiepang.new
    result = @jiepang.search args
    @places = result["places"]
    @has_more = result["has_more"]
    respond_to do |format|
      format.html { render :index } # index.html.erb
      format.json { render json: @places }
    end
  end


  protected
  def collection
    @places = collection ||= end_of_association_chain.paginate(:page => params[:page])
  end
end
