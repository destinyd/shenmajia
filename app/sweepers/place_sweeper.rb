class PlaceSweeper < ActionController::Caching::Sweeper
  observe Place

  def after_create(place)
    expire_cache_for(place) if place.id % 10 == 0
  end
 
  # If our sweeper detects that a place was updated call this
  #def after_update(place)
    #expire_cache_for(place)
    #expire_cache_for_single(place)
  #end
 
  # If our sweeper detects that a place was deleted call this
  #def after_destroy(place)
    #expire_cache_for(place)
    #expire_cache_for_single(place)
  #end
  private
  def expire_cache_for_single(place)
    expire_page(:controller => 'places', :action => 'show')
  end
  
  def expire_cache_for(place)
    expire_page(:controller => 'places', :action => 'index')
    expire_page '/places/index.html'
    
    # manually remove pages(1.html, 2.html, etc)
    if File.exist?("#{Rails.root}/public/places/page") # check to make sure directory exists
      Dir.foreach("#{Rails.root}/public/places/page") do |entry|
        unless entry == "." || entry == ".." || entry == ".gitignore" # ignore dot files
          File.delete("#{Rails.root}/public/places/page/#{entry}")
        end
      end
    end
  end
end
