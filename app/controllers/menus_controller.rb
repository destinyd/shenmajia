class MenusController < InheritedResources::Base
  actions :all#, except: :index
  belongs_to :place,optional: true
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  before_filter admin?, only: [:new,:create,:edit,:update,:destroy]
  def create
    create! do |success,failure|
      success.html{
        redirect_to [@place,@menu]
      }
      failure.html{render :new}
    end
  end
  protected
  #def begin_of_association_chain
    #current_user if ['create','edit','update','destroy'].include? action_name
  #end
end
