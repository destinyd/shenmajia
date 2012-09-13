class Userhome::ShopsController < UserhomeController
  actions :all, only: [:index,:new,:create]
end

