class Userhome::BillsController < UserhomeController
  actions :all, only: [:index,:destroy]
  #protected
  #def begin_of_association_chain
    #current_shop
  #end
end
