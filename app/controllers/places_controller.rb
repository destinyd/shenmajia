# coding: utf-8
class PlacesController < InheritedResources::Base
  before_filter :authenticate_user!,:only => [:new,:create]
  actions :all, :except => [:edit,:update,:destroy]
  #belongs_to :city,:finder => :find_by_name!, :optional => true
  #belongs_to :place, :optional => true
  respond_to :html
  caches_page :index,:show
  #caches_action :search, :expires_in => 1.day
  #caches_action :show,
    #:expires_in => 1.month
  cache_sweeper :place_sweeper

  def new
    Place.new params[:place]
    super
  end

  def show
    @place = Place.find(params[:id])
    @place.update_jiepang
    super
  end

  def search
    @where_name = params[:q]
    if @where_name.blank?
      redirect_to places_path
      return
    end
    @where = request.url
    @page = params[:page] ? params[:page].to_i : 1
    args = {:q => params[:q],:page => @page.to_s,:lat => cookies["lat"],:lon => cookies["lon"]}
    args.merge! :city => cookies['city'] if !cookies['city'].blank? and cookies['city'].scan(/自治/).blank?
    @places = Place.search(args).paginate :page => params[:page]

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
