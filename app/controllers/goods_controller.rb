class GoodsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  respond_to :html#, :json
  respond_to :js, only: [:new,:create]
  #respond_to :json,only: :search
  actions :all,except: [:edit,:update,:destroy]
  #belongs_to :breads, optional: true

  #caches_page :index,:show
  #cache_sweeper :good_sweeper
  
  def show
    show! do
      add_crumb(I18n.t("controller.goods"), goods_path)
      add_crumb(@good, good_path(@good))
    end
  end

  def create
     @good = current_user.goods.new(params[:good])
     create!
  end

  #def search
    #@goods = Good.where('name like ?' , '%' + params[:name_q] + '%').list.page(params[:page])
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
    @taggables  = Good.tagged_with(params[:id]).page(params[:page])
  end

  protected
  def collection
    if parent?
      add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      add_crumb(parent.name, polymorphic_path(parent))
    end
    add_crumb(I18n.t("controller.goods"), goods_path)

    @goods ||= end_of_association_chain.page(params[:page])
  end
end
