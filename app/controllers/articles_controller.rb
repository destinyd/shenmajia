class ArticlesController < InheritedResources::Base
  before_filter :authenticate_admin!, only: [:new,:create,:edit,:update,:destroy]

  def show
    show! do
      add_crumb(I18n.t("controller.articles"), articles_path)
      add_crumb(@article.to_s, article_path(@article))
    end
  end

  protected
  def collection
    if parent?
      add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      add_crumb(parent.name, polymorphic_path(parent))
    end
    add_crumb(I18n.t("controller.articles"), articles_path)
    @articles ||= end_of_association_chain.recent.page(params[:page])
  end
end
