class CostsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create]
  actions :all, except: [:edit,:update,:destroy]
  #belongs_to :city,finder: :find_by_name!, optional: true
  #belongs_to :place, optional: true
  #belongs_to :good, optional: true
  #belongs_to :place, optional: true
  belongs_to :bill, optional: true
  respond_to :html

  respond_to :js, only: [:index, :new]

  #caches_page :index,:show
  #cache_sweeper :cost_sweeper

  def show
    show! do
      add_crumb(I18n.t("controller.costs"), costs_path)
      add_crumb(@cost, cost_path(@cost))
    end
  end

  def create
    @cost = resource = current_user.costs.new params[:cost]
    create! do |format|
      format.html
    end
  end

  protected
  def collection
    if parent?
      add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      add_crumb(parent.name, polymorphic_path(parent))
    end
    add_crumb(I18n.t("controller.costs"), costs_path)

    @costs ||= end_of_association_chain.recent.page(params[:page])
  end
end
