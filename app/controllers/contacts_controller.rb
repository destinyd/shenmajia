class ContactsController < InheritedResources::Base
  before_filter :authenticate_user!
  actions :all, except: [:edit,:update]
  def set_default
  	@contact = current_user.contacts.find(params[:id])
  	@contact.update_attribute  :is_default, true
  	redirect_to contacts_path
  end

  def create
    create!(notice: "success.") { contacts_url }
  end

  protected
	def begin_of_association_chain
	  current_user
	end

  # def collection
  #   @contacts = end_of_association_chain.
  # end    
end
