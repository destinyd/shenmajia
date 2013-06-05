class CommentsController < InheritedResources::Base
  actions :index, :create
  respond_to :js
  #before_filter :find_commentable
  belongs_to :good, optional: true
  belongs_to :cost, optional: true
  before_filter :authenticate_user!,except: [:index]

  def create
    create! do |format|
      @comment.user = current_user
      @comment.save
      @commentable = parent
      @comments = parent.comments.recent.page(params[:comments_page])
    end
  end

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    @comments ||= end_of_association_chain.recent.page params[:page]
  end
end
