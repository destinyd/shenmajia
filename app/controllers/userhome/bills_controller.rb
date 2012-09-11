class Userhome::BillsController < UserhomeController
  actions :all, except: [:edit,:update]
  #protected
  #def begin_of_association_chain
    #current_shop
  #end
end
