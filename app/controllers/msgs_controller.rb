class MsgsController < InheritedResources::Base
  before_filter :authenticate_user!#, only: [:index,:new,:create,:edit,:update,:destroy]
  actions :all,only: [:index,:new,:create,:destroy]

  #def index
    #@msgs = current_user.got_msgs
    #index!
  #end
  
  def show
    show!{@msg.read}
  end

  def create
    @msg = current_user.sent_msgs.new(params[:msg])
    create!{msgs_path}
  end

  def sents
    @msgs = current_user.sent_msgs
  end

  #def destroy
    #@msg = current_user.got_msgs.find params[:id]
    #destroy!
  #end

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    @msgs ||= end_of_association_chain.page(params[:page])
  end
end
