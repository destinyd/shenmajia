class Userhome::ShopsController < UserhomeController
  actions :all, only: [:index,:new,:create]
  def places_search

  end
end

