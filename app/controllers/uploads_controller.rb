class UploadsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  actions :all,except: [:edit,:update,:destroy]
  belongs_to :good, optional: true

  #caches_page :index,:show
  #cache_sweeper :upload_sweeper

  def show
    show! do
      add_crumb(I18n.t("controller.uploads"), uploads_path)
      add_crumb(@upload.to_s, upload_path(@upload))
    end
  end

  def create
    create!{@upload.uploadable ? @upload.uploadable : @upload}
  end
  
  protected
  def collection
    if parent?
      add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      add_crumb(parent.name, polymorphic_path(parent))
    end
    add_crumb(I18n.t("controller.uploads"), uploads_path)
    @uploads ||= end_of_association_chain.page(params[:page])
  end
end
