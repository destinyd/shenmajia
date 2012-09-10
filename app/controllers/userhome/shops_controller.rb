class Userhome::ShopsController < UserhomeController
  actions :all, except: [:new,:create,:destroy]
end

