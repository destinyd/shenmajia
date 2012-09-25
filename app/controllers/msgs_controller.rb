class MsgsController < InheritedResources::Base
  before_filter :authenticate_user!#, only: [:index,:new,:create,:edit,:update,:destroy]
  actions :all,only: [:index,:new,:create,:destroy]

  def index
    @msgs = current_user.got_msgs
    index!
  end
  
  def show
    show!{@msg.read}
  end

  def create
    create!{msgs_path}
  end

  def sents
    @msgs = current_user.msgs
  end

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    @msgs ||= end_of_association_chain.paginate(page: params[:page])
  end
end
