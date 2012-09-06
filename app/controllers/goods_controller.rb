class GoodsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  respond_to :html#, :json
  #respond_to :json,only: :search
  actions :all,except: [:edit,:update,:destroy]
  #belongs_to :breads, optional: true
  belongs_to :shop, optional: true

  caches_page :index,:show
  cache_sweeper :good_sweeper
  
  def create
     @good = current_user.goods.new(params[:good])
     create!
  end

  #def search
    #@goods = Good.where('name like ?' , '%' + params[:name_q] + '%').list.paginate(page: params[:page])
    #respond_to do |f|
      ##f.json{render json: @goods.to_json}
      #f.html{render :index}
    #end
  #end

  def tags
    @tags = Good.tag_counts.includes(:taggings)
  end

  def tag
    @tagname = params[:id]
    @taggables  = Good.tagged_with(params[:id]).paginate(page: params[:page])
  end

  protected
  def collection
    @goods ||= end_of_association_chain.list.paginate(page: params[:page])
  end
end
